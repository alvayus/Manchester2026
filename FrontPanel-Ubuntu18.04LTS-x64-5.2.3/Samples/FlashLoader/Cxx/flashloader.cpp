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
// Copyright (c) 2005-2012 Opal Kelly Incorporated
// $Rev$ $Date$
//------------------------------------------------------------------------

#include <stdio.h>
#include <string.h>
#include <iostream>
#include <fstream>

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
InitializeFPGA(okCFrontPanel *xem)
{
	if (okCFrontPanel::NoError != xem->OpenBySerial()) {
		printf("Device could not be opened.  Is one connected?\n");
		return(false);
	}

	// The okTDeviceInfo struct contains some information about our System Flash 
	// for USB 3.0 devices.
	xem->GetDeviceInfo(&m_devInfo);

	printf("Found a device: %s\n", m_devInfo.productName);
	if (0 == m_devInfo.flashFPGA.sectorCount) {
		printf("This device does not have an FPGA flash.\n");
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
	if (m_devInfo.configuresFromSystemFlash) {
		return(true);
	}

	// Download the configuration file.
	if (okCFrontPanel::NoError != xem->ConfigureFPGA(std::string(BITFILE_NAME))) {
		printf("FPGA configuration failed.\n");
		return(false);
	}

	// Check for FrontPanel support in the FPGA configuration.
	if (false == xem->IsFrontPanelEnabled()) {
		printf("FrontPanel support is not enabled.\n");
		return(false);
	}

	return(true);
}


void
SetQEBit(okCFrontPanel *xem)
{
	xem->ActivateTriggerIn(0x40, 6); // Send SetQE command
	printf("Quad Enable bit set");
}



void
EraseSectors(okCFrontPanel *xem, int address, int sectors)
{
	int i, sector, lastSector;
  
  if (sectors < 1) {
    return;
  }
  
  // The HDL erases N+1 sectors, so we reduce the argument
  // by one.
  sectors--;

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
			printf("Erased %d sectors starting at address 0x%04X.\n", (sectors+1), address);
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
			printf("Timeout in EraseSectors -- Erasure failed.\n");
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
		printf("Error: Bitfile could not be opened.\n");
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
	if ((OK_PRODUCT_ZEM4310 != info.productID) && (OK_PRODUCT_ZEM5310A4 != info.productID) && 
	    (OK_PRODUCT_ZEM5310A7 != info.productID) && (OK_PRODUCT_ZEM5370A5 != info.productID)) {
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
		i = (lN-1) / m_devInfo.flashSystem.sectorSize + 1;
		for (j=0; j<i; j++) {
			printf("Erasing sector %d\r", (j+m_devInfo.flashSystem.minUserSector));
			fflush(stdout);
			xem->FlashEraseSector((j+m_devInfo.flashSystem.minUserSector) * m_devInfo.flashSystem.sectorSize);
		}
	} else {
		i = (lN + FLASH_SECTOR_SIZE - 1) / FLASH_SECTOR_SIZE;
		printf("File size: %d kB  --  Erasing %d sectors.\n", (int)lN/1024, i);
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
		while (j>0) {
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
		for(i=0; i<lN; i++) {
			printf("Writing to address : 0x%08X\r", j*FLASH_PAGE_SIZE);
			fflush(stdout);
			bit_in.read((char *)buf, MAX_TRANSFER_SIZE);

			// Write
			xem->WriteToPipeIn(0x80, MAX_TRANSFER_SIZE, buf);
			xem->SetWireInValue(0x00, j);	// Send starting address
			xem->SetWireInValue(0x01, (MAX_TRANSFER_SIZE/FLASH_PAGE_SIZE)-1);		// Send the number of pages to program
			xem->UpdateWireIns();							// Update Wire Ins
			xem->UpdateTriggerOuts();						// Makes sure that there are no pending triggers back
			xem->ActivateTriggerIn(0x40, 5);				// Trigger the beginning of the sector erase routine
			j += MAX_TRANSFER_SIZE/FLASH_PAGE_SIZE;

			k = 0;
			do {
				xem->UpdateTriggerOuts();
				if (xem->IsTriggered(0x60, 0x0001))
					break;

				k++;
				if (k > 50) {
					printf("\n** Timeout in WriteBitfile -- Programming failed.\n");
					return(false);
				}
			} while (1);
		}
	}
	printf("\nProgramming complete.\n");

	// For XEM8350, set QE bit to enable Quad SPI I/O
	if (OK_PRODUCT_XEM8350KU060 == m_devInfo.productID || OK_PRODUCT_XEM8350KU085 == m_devInfo.productID || OK_PRODUCT_XEM8350KU115 == m_devInfo.productID) {
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
	printf("Usage: %s bitfile\n", progname);
	printf("   bitfile - Bitfile to write to configuration flash.\n");
}



int
real_main(int argc, char *argv[])
{
	okCFrontPanel *xem;

	printf("---- Opal Kelly ---- Flash Programmer ----\n");
	printf("FrontPanel DLL loaded. Version: %s\n", okFrontPanel_GetAPIVersionString());

	// Initialize the FPGA with our configuration bitfile.
	xem = new okCFrontPanel;
	if (false == InitializeFPGA(xem)) {
		return(-1);
	}

	if (argc == 1) {
		// If no command line arguments are given, we clear the Reset Profile for the devices using system flash.
		if (m_devInfo.configuresFromSystemFlash) {
			printf("Clearing Boot Reset Profile.\n");
			okTFPGAResetProfile profile;
			memset(&profile, 0, sizeof(okTFPGAResetProfile));
			xem->SetFPGAResetProfile(ok_FPGAConfigurationMethod_NVRAM, &profile);
		}
		return(0);
	} else if (argc != 2) {
		printUsage(argv[0]);
		return(-1);
	}

	WriteBitfile(xem, argv[1]);
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
