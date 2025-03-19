//------------------------------------------------------------------------
// flashloader.cpp
//
// A very simple Flash loader for supporting Opal Kelly FPGA modules.
//
// For System Flash devices (USB 3.0):
//   Uses the FlashEraseSector, FlashWrite, and FlashRead APIs to 
//   write an FPGA configuration to the System Flash and sets up a
//   valid BootResetProfile to boot the FPGA on power-up.
//
// For FPGA Flash devices (USB 2.0):
//   Loads a bitfile to the FPGA that contains logic to erase
//   and program the attached SPI Flash.  The program takes a single
//   argument which is the name of a binary file to load to flash.
//
//   If this is a valid Xilinx configuration file, the FPGA will boot
//   to the SPI Flash and load that config file.
//
// In both cases, we trim the bitfile to the start sequence.
//
// This source is provided without guarantee.  You are free to incorporate
// it into your product.  You are also free to include the pre-built 
// bitfile in your product.
//------------------------------------------------------------------------
// Copyright (c) 2005-2024 Opal Kelly Incorporated
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 
//------------------------------------------------------------------------

#include <stdio.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include <stdlib.h>

#include "okFrontPanel.h"

#if defined(_WIN32)
	#include "windows.h"
	#define stricmp _stricmp
	#define sscanf sscanf_s
#elif defined(__linux__) || defined(__APPLE__)
	#include <unistd.h>
	#define Sleep(ms)    usleep(ms*1000)
#endif


#define BITFILE_NAME           "flashloader.bit"
#define MIN(a,b)               ((a)<(b) ? (a) : (b))
#define BUFFER_SIZE            (16*1024)
#define MAX_TRANSFER_SIZE      1024
#define FLASH_PAGE_SIZE        256
#define FLASH_SECTOR_SIZE      (65536)

okTDeviceInfo  m_devInfo;

bool
InitializeFPGA(okCFrontPanel *xem, int argc, char* argv[])
{
	if (okCFrontPanel::NoError != xem->OpenBySerial()) {
		printf("Error: Device could not be opened. Is one connected? If the FrontPanel application is running, close it and try again.\n");
		return(false);
	}

	// The okTDeviceInfo struct contains some information about our System Flash 
	// for USB 3.0 devices.
	xem->GetDeviceInfo(&m_devInfo);

	printf("Found a device: %s\n", m_devInfo.productName);
	if (0 == m_devInfo.flashFPGA.sectorCount) {
		printf("Error: This device does not have an FPGA flash.\n");
		return(false);
	} else {
		printf("Available Flash: %d Mib\n", m_devInfo.flashFPGA.sectorCount * m_devInfo.flashFPGA.sectorSize * 8 / 1024 / 1024);
	}

	xem->LoadDefaultPLLConfiguration();	

	// Get some general information about the XEM.
	printf("Device firmware version: %d.%d\n", m_devInfo.deviceMajorVersion, m_devInfo.deviceMinorVersion);
	printf("Device serial number: %s\n", m_devInfo.serialNumber);
	printf("Device device ID: %d\n", m_devInfo.productID);

	// No configuration file for System Flash devices
	if (m_devInfo.configuresFromSystemFlash && !strcmp(argv[1], "w")) { // don't configure bitfile 
		return(true);									// if writing and boots from system flash
	}

	// Download the configuration file.
	if (okCFrontPanel::NoError != xem->ConfigureFPGA(std::string(BITFILE_NAME))) {
		printf("Error: Flashloader FPGA configuration failed. Is %s present in the working directory?\n", BITFILE_NAME);
		return(false);
	}

	// Check for FrontPanel support in the FPGA configuration.
	if (false == xem->IsFrontPanelEnabled()) {
		printf("Error: FrontPanel support is not enabled. Is the correct %s in the working directory?\n", BITFILE_NAME);
		return(false);
	}

	return(true);
}


void
SetQEBit(okCFrontPanel *xem)
{
	xem->ActivateTriggerIn(0x40, 6); // Send SetQE command
	Sleep(250); // Give flash time to set QE bit
	printf("Quad Enable bit set\n");
}



void
EraseSectors(okCFrontPanel *xem, int address, int sectors)
{
	int i, sector, lastSector;
  
  if (sectors < 1) {
    return;
  }

	xem->SetWireInValue(0x00, address);    // Send starting address
	xem->SetWireInValue(0x01, sectors);    // Send the number of sectors to erase
	xem->UpdateWireIns();
	xem->UpdateTriggerOuts();                      // Makes sure that there are no pending triggers back
	xem->ActivateTriggerIn(0x40, 3);               // Trigger the beginning of the sector erase routine

	sector = lastSector = i = 0;
	do {
		Sleep(200);
		xem->UpdateTriggerOuts();
		if (xem->IsTriggered(0x60, 0x0001)) {
			printf("Erased %d sectors starting at address 0x%04X.\n", (sectors), address);
			break;
		}

		xem->UpdateWireOuts();
		sector = xem->GetWireOutValue(0x20);
		printf("Erasing sector %d\r", sectors-sector);
		fflush(stdout);
		if (lastSector != sector) {
			i = 0;
			lastSector = sector;
		}
		i++;
		if (i > 50) {
			printf("Error: Timeout in EraseSectors -- Erasure failed.\n");
			break;
		}
	} while (1);
}



bool
WriteBitfile(okCFrontPanel *xem, char *filename)
{
	std::ifstream bit_in;
	unsigned char buf[BUFFER_SIZE];
	int i, j, k;
	long lN;

	bit_in.open(filename, std::ios::binary);
	if (false == bit_in.is_open()) {
		printf("Error: Bitfile to write to flash could not be opened: %s\n", filename);
		return(false);
	}

	bit_in.seekg(0, std::ios::end);
	lN = (long)bit_in.tellg();
	bit_in.seekg(0, std::ios::beg);

	// Verify that the file will fit in the available flash.
	if ((UINT32)lN > m_devInfo.flashFPGA.sectorCount * m_devInfo.flashFPGA.sectorSize) {
		printf("Error: File size exceeds available flash memory.\n");
		printf("       Consider enabling bitstream compression when generating a bitfile.\n");
		return(false);
	}
	
	// For Xilinx devices only:
	// Find the sync word first.  Officially the sync section starts at 4 "0xff" bytes. This 
	// includes enough sync data to determine the configuration bus width and then start the
	// sync bytes.
	okTDeviceInfo info;
	xem->GetDeviceInfo(&info);
	if (m_devInfo.fpgaVendor == okFPGAVENDOR_XILINX) {
		bit_in.read((char *)buf, BUFFER_SIZE);
		for (i=0; i<BUFFER_SIZE; i++) {
			if ((buf[i+0] == 0xff) && (buf[i+1] == 0xff) & (buf[i+2] == 0xff) && (buf[i+3] == 0xff)) {
				bit_in.seekg(i-2, std::ios::beg);
				break;
			}
		}
		if (BUFFER_SIZE == i) {
			printf("Error: Sync word not found.\n");
			return(false);
		}
	}

	//
	// Clear out the sectors required for the new bitfile size.
	//
	if (info.configuresFromSystemFlash) {
		// In System Flash, store the bitfile starting at the first user sector.
		i = (lN - 1) / m_devInfo.flashSystem.sectorSize + 1;
		for (j=0; j<i; j++) {
			printf("Erasing sector %d\r", (j + m_devInfo.flashSystem.minUserSector));
			fflush(stdout);
			xem->FlashEraseSector((j + m_devInfo.flashSystem.minUserSector) * m_devInfo.flashSystem.sectorSize);
		}
	} else {
		i = (lN + FLASH_SECTOR_SIZE - 1) / FLASH_SECTOR_SIZE;
		printf("File size: %d kB  --  Erasing %d sectors.\n", (int)lN / 1024, i);
		EraseSectors(xem, 0x0000, i);
	}
	printf("Sector erase operation complete.\n");


	//
	// Now store the bitfile
	//
	if (info.configuresFromSystemFlash) {
		int count;
		j = lN;
		k = m_devInfo.flashSystem.minUserSector * m_devInfo.flashSystem.sectorSize;
		while (j > 0) {
			printf("Writing to address : 0x%08X\r", k);
			fflush(stdout);
			count = MIN(j, (int)m_devInfo.flashSystem.pageSize);
			bit_in.read((char *)buf, count);
			xem->FlashWrite(k, m_devInfo.flashSystem.pageSize, buf);
			k += count;
			j -= count;
		}
	} else {
		printf("Downloading bitfile (%d bytes).\n", (int)lN);
		lN = lN / MAX_TRANSFER_SIZE + 1;
		j = 0;
		for (i=0; i<lN; i++) {
			printf("Writing to address : 0x%08X\r", j * FLASH_PAGE_SIZE);
			fflush(stdout);
			memset(buf, 0xFF, MAX_TRANSFER_SIZE); // clear the buffer in case the file doesn't have 1024 bytes left
			bit_in.read((char*)buf, MAX_TRANSFER_SIZE); // as an erased flash byte is 0xFF

			// Write
			xem->WriteToPipeIn(0x80, MAX_TRANSFER_SIZE, buf);
			xem->SetWireInValue(0x00, j);	// Send starting address
			xem->SetWireInValue(0x01, (MAX_TRANSFER_SIZE / FLASH_PAGE_SIZE) - 1);		// Send the number of pages to program
			xem->UpdateWireIns();							// Update Wire Ins
			xem->UpdateTriggerOuts();						// Makes sure that there are no pending triggers back
			xem->ActivateTriggerIn(0x40, 5);				// Trigger the beginning of the sector erase routine
			j += MAX_TRANSFER_SIZE / FLASH_PAGE_SIZE;

			k = 0;
			do {
				xem->UpdateTriggerOuts();
				if (xem->IsTriggered(0x60, 0x0001))
					break;

				k++;
				if (k > 50) {
					printf("\nError: Timeout in WriteBitfile -- Programming failed.\n");
					return(false);
				}
			} while (1);
		}
	}
	printf("\nProgramming complete.\n");

	// Set QE bit to enable Quad SPI I/O for XEM8310, XEM8320, and XEM8350
	if (m_devInfo.hasQuadConfigFlash) {
		SetQEBit(xem);
	}

	//
	// For the devices using system flash, set the Boot Reset Profile to point to the bitfile
	//
	if (info.configuresFromSystemFlash) {
		printf("Setting up Boot Reset Profile.\n");
		okTFPGAResetProfile profile;
		memset(&profile, 0, sizeof(okTFPGAResetProfile));
		profile.configFileLocation = m_devInfo.flashSystem.minUserSector;
		profile.configFileLength = lN;
		xem->SetFPGAResetProfile(ok_FPGAConfigurationMethod_NVRAM, &profile);
	}
	return(true);
}

bool
ReadBitfile(okCFrontPanel* xem, char* filename, int start, int end)
{
	std::ofstream bit_out;
	unsigned char buf[BUFFER_SIZE];
	int i, j, k;
	
	// Check that start and end sectors are valid

	if (start < 0 || start > end) {
		printf("Error: Start sector must be atleast 0 and less than or equal to end sector.");
		return(false);
	}
	else if (end > m_devInfo.flashFPGA.sectorCount - 1) {
		printf("Error: invalid end sector %i. There are %u sectors available.", end,  m_devInfo.flashFPGA.sectorCount);
		return(false);
	}

	// Accounts for the fact the flash sectors are 0 indexed.
	long lN = (FLASH_SECTOR_SIZE) * ((end + 1) - start); 
	
	bit_out.open(filename, std::ios::binary);
	if (false == bit_out.is_open()) {
		printf("Error: Output file could not be opened.\n");
		return(false);
	}

	//
	// Now read the bitfile
	//
	
	printf("Downloading flash contents (%ld bytes).\n", lN);
	if (m_devInfo.hasQuadConfigFlash) { // Check if flash is receiving commands
		SetQEBit(xem);
	}
	lN = lN / MAX_TRANSFER_SIZE + 1;
	j = ((start) * FLASH_SECTOR_SIZE) / FLASH_PAGE_SIZE;

	for (i=0; i<lN-1; i++) {
		printf("Reading from address : 0x%08X\r", j * FLASH_PAGE_SIZE);
		fflush(stdout);
	
		// read
		xem->SetWireInValue(0x00, j);	// Send starting address

		xem->SetWireInValue(0x01, (MAX_TRANSFER_SIZE / FLASH_PAGE_SIZE) - 1);		// Send the number of pages to read
		xem->UpdateTriggerOuts();						// Makes sure that there are no pending triggers back
		xem->UpdateWireIns();							// Update Wire Ins
		xem->ActivateTriggerIn(0x40, 4);				// Trigger the read command
		
		j += MAX_TRANSFER_SIZE / FLASH_PAGE_SIZE;

		k = 0;
		do {
			xem->UpdateTriggerOuts();
			if (xem->IsTriggered(0x60, 0x0001))
				break;

			k++;
			if (k > 50) {
				printf("\nError:  Timeout in ReadBitfile -- Operation failed.\n");
				return(false);
			}
		} while (1);

		xem->ReadFromPipeOut(0xA0, MAX_TRANSFER_SIZE, buf);
		bit_out.write((char*)buf, MAX_TRANSFER_SIZE); // write to file
	}
	printf("\nDone.\n");
	return(true);
}

void hdlReset(okCFrontPanel *xem)
{
	printf("Reset \n");
	// Assert then deassert RESET.
	xem->SetWireInValue(0x00, 0x0001, 0xffff);
	xem->UpdateWireIns();
	Sleep(1);
	xem->SetWireInValue(0x00, 0x0000, 0xffff);
	xem->UpdateWireIns();
	Sleep(10);
}



static void
printUsage(char *progname)
{
	printf("Usage: %s [h] [r start end | w | c] filename\n", progname);
	printf("   start - Beginning sector in flash to read from.\n");
	printf("   end - Ending sector in flash to read from.\n");
	printf("   filename - Bitfile to write to configuration flash.\n");
	printf("              or text file to dump flash to.\n");
	printf("   Example usage:\n");
	printf("     %s r 0 3 flashdump.txt\n", progname);
	printf("              Dumps sectors 0-3 to flashdump.txt\n");
	printf("     %s w counters.bit\n", progname);
	printf("              Writes counters.bit to flash.\n");
	printf("              Configures the bitstream to load at boot.\n");
	printf("     %s c\n", progname);
	printf("              Clear the boot reset profile\n");
	printf("   Usage Requirements:\n");
	printf("     okFrontPanel.dll present in the working directory\n");
	printf("     flashloader.bit present in the working directory\n");
}



int
real_main(int argc, char *argv[])
{
	okCFrontPanel *xem;

	printf("---- Opal Kelly ---- Flash Programmer ----\n");
	printf("FrontPanel DLL loaded. Version: %s\n", okFrontPanel_GetAPIVersionString());

	if (argc == 2 && !strcmp(argv[1], "c")) {
		// Initialize the FPGA with our configuration bitfile.
		xem = new okCFrontPanel;
		if (false == InitializeFPGA(xem, argc, argv)) {
			return(-1);
		}

		// Clear the Reset Profile for the devices using system flash.
		if (m_devInfo.configuresFromSystemFlash) {
			printf("Clearing Boot Reset Profile.\n");
			okTFPGAResetProfile profile;
			memset(&profile, 0, sizeof(okTFPGAResetProfile));
			xem->SetFPGAResetProfile(ok_FPGAConfigurationMethod_NVRAM, &profile);
		}
		else {
			printf("Error: Device does not support Reset Profiles.\n");
		}
	
	} else if (argc == 3 && !strcmp(argv[1], "w")) {
		// Initialize the FPGA with our configuration bitfile.
		xem = new okCFrontPanel;
		if (false == InitializeFPGA(xem, argc, argv)) {
			return(-1);
		}

		WriteBitfile(xem, argv[2]);

	} else if (argc == 5 && !strcmp(argv[1], "r")) {
		// Initialize the FPGA with our configuration bitfile.
		xem = new okCFrontPanel;
		if (false == InitializeFPGA(xem, argc, argv)) {
			return(-1);
		}

		ReadBitfile(xem, argv[4], atoi(argv[2]), atoi(argv[3]));

	} else {
		printUsage(argv[0]);
		return(-1);
	}
	return(0);
}


int
main(int argc, char *argv[])
{
	try {
		return real_main(argc, argv);
	} catch (std::exception const& e) {
		fprintf(stderr, "Error: %s\n", e.what());
	} catch (...) {
		fprintf(stderr, "Error: caught unknown exception.\n");
	}

	return -1;
}
