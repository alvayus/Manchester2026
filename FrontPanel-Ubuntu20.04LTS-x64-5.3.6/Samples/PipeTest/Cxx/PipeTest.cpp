//------------------------------------------------------------------------
// PipeTest.cpp
//
// This is the C++ source file for the PipeTest Sample.
//
//
// Copyright (c) 2004-2024 Opal Kelly Incorporated
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
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

#include <algorithm>
#include <chrono>
#include <fstream>
#include <iostream>
#include <map>
#include <vector>

#include <float.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "okFrontPanel.h"

#if defined(_WIN32)
	#define sscanf sscanf_s
#elif defined(__linux__) || defined(__APPLE__)
#endif

typedef unsigned int UINT32;

#define MIN(a, b) (((a) < (b)) ? (a) : (b))

#define OK_PATTERN_COUNT    0
#define OK_PATTERN_LFSR     1
#define OK_PATTERN_WALKING1 2
#define OK_PATTERN_WALKING0 3
#define OK_PATTERN_HAMMER   4
#define OK_PATTERN_NEIGHBOR 5
#define OK_PATTERN_FIXED    6

enum pollingTransferType {
	wireIn,
	wireOut,
	triggerIn,
	triggerOut
};

okTDeviceInfo m_devInfo;
bool m_bCheck;
bool m_bInjectError;
int m_ePattern;
UINT32 m_u32FixedPattern;
UINT32 m_u32BlockSize;
UINT32 m_u32SegmentSize;
UINT32 m_u32TransferSize;
UINT32 m_u32ThrottleIn;
UINT32 m_u32ThrottleOut;

struct transferSizes {
	UINT32 transferSize = 0;
	UINT32 segmentSize = 0;
	UINT32 blockSize = 0;

	bool operator<(const transferSizes& other) const
	{
		if (transferSize != other.transferSize) {
			return transferSize < other.transferSize;
		}
		if (segmentSize != other.segmentSize) {
			return segmentSize < other.segmentSize;
		}
		return blockSize < other.blockSize;
	}
};

struct pollingResult {
	pollingTransferType transferType = wireIn;
	UINT32 size = 0;
	double rate = 0;
};

struct pipeResult {
	long double rateSum = 0;
	UINT32 qty = 0;
	long errorCount = 0;
	double min = DBL_MAX;
	double max = 0;
	UINT32 dataErrors = 0;
};

std::map<transferSizes, pipeResult> pipeInResults;
std::map<transferSizes, pipeResult> pipeOutResults;

std::vector<pollingResult> wireInResults;
std::vector<pollingResult> triggerInResults;
std::vector<pollingResult> wireOutResults;
std::vector<pollingResult> triggerOutResults;

std::chrono::steady_clock::time_point m_cStart;
std::chrono::steady_clock::time_point m_cStop;

void
startTimer()
{
	m_cStart = std::chrono::steady_clock::now();
}

void
stopTimer()
{
	m_cStop = std::chrono::steady_clock::now();
}

// Sets the reset state of the pattern generator based on the
// selected pattern.
void
patternReset(UINT32* wordH, UINT32* wordL, UINT32 u32Width)
{
	switch (m_ePattern) {
		case OK_PATTERN_COUNT:
			*wordH = 0x00000001;
			*wordL = 0x00000001;
			break;
		case OK_PATTERN_LFSR:
			*wordH = 0x0D0C0B0A;
			*wordL = 0x04030201;
			break;
		case OK_PATTERN_WALKING1:
			*wordH = 0x00000000;
			*wordL = 0x00000001;
			break;
		case OK_PATTERN_WALKING0:
			*wordH = 0xFFFFFFFF;
			*wordL = 0xFFFFFFFE;
			break;
		case OK_PATTERN_HAMMER:
			*wordH = 0x00000000;
			*wordL = 0x00000000;
			break;
		case OK_PATTERN_NEIGHBOR:
			*wordH = 0x00000000;
			*wordL = 0x00000000;
			break;
		case OK_PATTERN_FIXED:
			*wordH = m_u32FixedPattern;
			*wordL = m_u32FixedPattern;
			break;
	}
}

// Computes the next word in the data pattern based on the
// selected pattern and the output word width (in bits).
void
patternNext(UINT32* wordH, UINT32* wordL, UINT32 u32Width)
{
	static UINT32 neighborH = 0xFFFFFFFF;
	static UINT32 neighborL = 0xFFFFFFFE;
	UINT32 bit, hold;

	switch (m_ePattern) {
		case OK_PATTERN_COUNT:
			*wordH = *wordH + 1;
			*wordL = *wordL + 1;
			break;
		case OK_PATTERN_LFSR:
			bit = ((*wordH >> 31) ^ (*wordH >> 21) ^ (*wordH >> 1)) & 1;
			*wordH = (*wordH << 1) | bit;
			bit = ((*wordL >> 31) ^ (*wordL >> 21) ^ (*wordL >> 1)) & 1;
			*wordL = (*wordL << 1) | bit;
			break;
		case OK_PATTERN_WALKING0:
			if (64 == u32Width) {
				hold = *wordH;
				*wordH = (*wordH << 1) | ((*wordL >> 31) & 0x01);
				*wordL = (*wordL << 1) | ((hold >> 31) & 0x01);
			} else if (32 == u32Width) {
				*wordH = 0xFFFFFFFF;
				*wordL = (*wordL << 1) | ((*wordL >> 31) & 0x01);
			} else if (16 == u32Width) {
				*wordH = 0xFFFFFFFF;
				*wordL = ((*wordL << 1) | ((*wordL >> 15) & 0x01)) & 0xFFFF;
			} else if (8 == u32Width) {
				*wordH = 0xFFFFFFFF;
				*wordL = ((*wordL << 1) | ((*wordL >> 7) & 0x01)) & 0xFF;
			}
			break;
		case OK_PATTERN_WALKING1:
			if (64 == u32Width) {
				hold = *wordH;
				*wordH = (*wordH << 1) | ((*wordL >> 31) & 0x01);
				*wordL = (*wordL << 1) | ((hold >> 31) & 0x01);
			} else if (32 == u32Width) {
				*wordH = 0x00000000;
				*wordL = (*wordL << 1) | ((*wordL >> 31) & 0x01);
			} else if (16 == u32Width) {
				*wordH = 0x00000000;
				*wordL = ((*wordL << 1) | ((*wordL >> 15) & 0x01)) & 0xFFFF;
			} else if (8 == u32Width) {
				*wordH = 0x00000000;
				*wordL = ((*wordL << 1) | ((*wordL >> 7) & 0x01)) & 0xFF;
			}
			break;
		case OK_PATTERN_HAMMER:
			*wordH = ~(*wordH);
			*wordL = ~(*wordL);
			break;
		case OK_PATTERN_NEIGHBOR:
			if (0x0 == *wordH) {
				*wordH = neighborH;
				*wordL = neighborL;
				if (64 == u32Width) {
					hold = neighborH;
					neighborH = (neighborH << 1) | ((neighborL >> 31) & 0x01);
					neighborL = (neighborL << 1) | ((hold >> 31) & 0x01);
				} else if (32 == u32Width) {
					neighborH = 0xFFFFFFFF;
					neighborL = (neighborL << 1) | ((neighborL >> 31) & 0x01);
				} else if (16 == u32Width) {
					neighborH = 0xFFFFFFFF;
					neighborL = ((neighborL << 1) | ((neighborL >> 15) & 0x01)) & 0xFFFF;
				} else if (8 == u32Width) {
					neighborH = 0xFFFFFFFF;
					neighborL = ((neighborL << 1) | ((neighborL >> 7) & 0x01)) & 0xFF;
				}
			} else {
				*wordH = 0x00000000;
				*wordL = 0x00000000;
			}
			break;
		case OK_PATTERN_FIXED:

			break;
	}
}

// Generates a buffer of data following the selected data pattern
// and word width.
void
generateData(unsigned char* pucValid, UINT32 u32ByteCount, UINT32 u32Width)
{
	UINT32 i;
	UINT32 wordH, wordL;

	patternReset(&wordH, &wordL, u32Width);

	if (64 == u32Width) {
		UINT32* pu32Valid = (UINT32*)pucValid;
		for (i = 0; i < u32ByteCount / 8; i++) {
			pu32Valid[i * 2 + 0] = wordL;
			pu32Valid[i * 2 + 1] = wordH;
			patternNext(&wordH, &wordL, u32Width);
		}
	} else if (32 == u32Width) {
		UINT32* pu32Valid = (UINT32*)pucValid;
		for (i = 0; i < u32ByteCount / 4; i++) {
			pu32Valid[i] = wordL;
			patternNext(&wordH, &wordL, u32Width);
		}
	} else if (16 == u32Width) {
		for (i = 0; i < u32ByteCount / 2; i++) {
			pucValid[i * 2 + 0] = (wordL >> 0) & 0xff;
			pucValid[i * 2 + 1] = (wordL >> 8) & 0xff;
			patternNext(&wordH, &wordL, u32Width);
		}
	} else if (8 == u32Width) {
		for (i = 0; i < u32ByteCount; i++) {
			pucValid[i] = wordL & 0xff;
			patternNext(&wordH, &wordL, u32Width);
		}
	}

	// Inject errors (optional)
	if (m_bInjectError)
		pucValid[7] = ~pucValid[7];
}

bool
checkData(unsigned char* pucBuffer, unsigned char* pucValid, UINT32 u32ByteCount)
{
	UINT32 i;
	UINT32* pu32Buffer = (UINT32*)pucBuffer;
	UINT32* pu32Valid = (UINT32*)pucValid;
	for (i = 0; i < u32ByteCount / 4; i++) {
		if (pu32Buffer[i] != pu32Valid[i]) {
			printf("[%d]  %08X  !=  %08X\n", i, pu32Buffer[i], pu32Valid[i]);
			return (false);
		}
	}
	return (true);
}

double
reportRateResults(UINT32 u32CallCount)
{
	std::chrono::duration<double> clkInterval = m_cStop - m_cStart;

	double callsPerSecond = (double)(u32CallCount) / clkInterval.count();

	std::cout << "Duration: " << clkInterval.count() << " seconds -- " << callsPerSecond
			  << " calls/s" << std::endl;

	return callsPerSecond;
}

double
reportBandwidthResults(UINT32 u32TransferCount)
{
	std::chrono::duration<double> clkInterval = (m_cStop - m_cStart) / u32TransferCount;

	double measuredTransferLength = (double)(m_u32TransferSize / 1024 / 1024);
	double measuredTransferRate = measuredTransferLength / clkInterval.count();

	std::cout << "Duration: " << clkInterval.count() << " seconds -- " << measuredTransferRate
			  << " MB/s" << std::endl;

	return measuredTransferRate;
}


// Helper function to update the map with the pipe results given to it
void
UpdatePipeResults(
	std::map<transferSizes, pipeResult>& resultMap,
	transferSizes sizes,
	pipeResult result,
	double rate,
	long err,
	bool dataError
)
{
	auto search = resultMap.find(sizes);
	if (search != resultMap.end()) {
		search->second.qty++;
		if (err < 0) {
			search->second.errorCount++;
		} else {
			search->second.rateSum += rate;
			if (rate > search->second.max) {
				search->second.max = rate;
			}

			if (rate < search->second.min) {
				search->second.min = rate;
			}

			if (dataError) {
				search->second.dataErrors++;
			}
		}
	} else {
		resultMap.insert({sizes, result});
	}
}

// Add pipe results the the appropriate vector for future calculation
void
RecordPipeResults(
	bool write, double rate, UINT32 tSize, UINT32 sSize, UINT32 bSize, long err, bool dataError
)
{
	pipeResult result;
	result.dataErrors = dataError ? 1 : 0;
	result.errorCount = err < 0 ? 1 : 0;
	result.max = rate;
	result.min = rate;
	result.qty = 1;
	result.rateSum = rate;

	transferSizes pipeSize;
	pipeSize.transferSize = tSize;
	pipeSize.segmentSize = sSize;
	pipeSize.blockSize = bSize;

	UpdatePipeResults(
		write ? pipeInResults : pipeOutResults, pipeSize, result, rate, err, dataError
	);
}

// adds wires and trigger results to their respective vector
void
RecordPollingResults(pollingTransferType transferType, double rate)
{
	std::vector<pollingResult>* results = nullptr;

	switch (transferType) {
		case wireIn:
			results = &wireInResults;
			break;
		case wireOut:
			results = &wireOutResults;
			break;
		case triggerIn:
			results = &triggerInResults;
			break;
		case triggerOut:
			results = &triggerOutResults;
			break;
	}

	if (!results) {
		std::cout << "invalid transfer type: " << transferType << std::endl;
		exit(-1);
	}

	pollingResult result;
	result.transferType = transferType;
	result.rate = rate;
	results->push_back(result);
}

void
Transfer(okCFrontPanel* dev, UINT32 u32Count, bool bWrite)
{
	unsigned char* pBuffer;
	unsigned char* pValid;
	UINT32 i;
	UINT32 u32SegmentSize, u32Remaining;
	long ret = 0;
	bool dataError = false;

	pBuffer = new unsigned char[m_u32SegmentSize];
	pValid = new unsigned char[m_u32SegmentSize];

	// Check capability bits for newer patterns
	// Bit 0 - added Fixed pattern
	dev->UpdateWireOuts();
	if (((dev->GetWireOutValue(0x3E) & 0x1) != 0x1) && (m_ePattern == OK_PATTERN_FIXED)) {
		printf("Fixed pattern is not supported by this bitstream. Switching to "
			   "LFSR.\n");
		m_ePattern = OK_PATTERN_LFSR;
	}

	// Only COUNT and LFSR are supported on non-USB3 devices.
	if (OK_INTERFACE_USB3 != m_devInfo.deviceInterface) {
		switch (m_ePattern) {
			case OK_PATTERN_WALKING0:
			case OK_PATTERN_WALKING1:
			case OK_PATTERN_HAMMER:
			case OK_PATTERN_NEIGHBOR:
				printf("Unsupported pattern for device type.  Switching to LFSR.\n");
				m_ePattern = OK_PATTERN_LFSR;
				break;
		}
	}

	if (OK_INTERFACE_USB3 == m_devInfo.deviceInterface) {
		dev->SetWireInValue(0x03, m_u32FixedPattern); // Apply fixed pattern
		dev->SetWireInValue(0x02, m_u32ThrottleIn);   // Pipe In throttle
		dev->SetWireInValue(0x01, m_u32ThrottleOut);  // Pipe Out throttle
		dev->SetWireInValue(
			0x00, (m_ePattern << 2) | 1 << 1 | 1
		); // PATTERN | SET_THROTTLE=1 | RESET=1
		dev->UpdateWireIns();
		dev->SetWireInValue(
			0x00, (m_ePattern << 2) | 0 << 1 | 0
		); // PATTERN | SET_THROTTLE=0 | RESET=0
		dev->UpdateWireIns();
	} else {
		dev->SetWireInValue(0x02, m_u32ThrottleIn);  // Pipe In throttle
		dev->SetWireInValue(0x01, m_u32ThrottleOut); // Pipe Out throttle
		dev->SetWireInValue(
			0x00, 1 << 5 | ((m_ePattern == OK_PATTERN_LFSR ? 1 : 0) << 4) | 1 << 2
		); // SET_THROTTLE=1 | MODE=LFSR | RESET=1
		dev->UpdateWireIns();
		dev->SetWireInValue(
			0x00, 0 << 5 | ((m_ePattern == OK_PATTERN_LFSR ? 1 : 0) << 4) | 0 << 2
		); // SET_THROTTLE=0 | MODE=LFSR | RESET=0
		dev->UpdateWireIns();
	}

	startTimer();
	for (i = 0; i < u32Count; i++) {
		u32Remaining = m_u32TransferSize;
		while (u32Remaining > 0) {
			u32SegmentSize = MIN(m_u32SegmentSize, u32Remaining);
			u32Remaining -= u32SegmentSize;

			// If we're validating data, generate data per segment.
			if (m_bCheck) {
				if (OK_INTERFACE_USB3 == m_devInfo.deviceInterface) {
					dev->SetWireInValue(
						0x00,
						(m_ePattern << 2) | 0 << 1 | 1
					); // PATTERN | SET_THROTTLE=0 | RESET=1
					dev->UpdateWireIns();
					dev->SetWireInValue(
						0x00,
						(m_ePattern << 2) | 0 << 1 | 0
					); // PATTERN | SET_THROTTLE=0 | RESET=0
					dev->UpdateWireIns();
				} else {
					dev->SetWireInValue(
						0x00, 0 << 5 | ((m_ePattern == OK_PATTERN_LFSR ? 1 : 0) << 4) | 1 << 2
					); // SET_THROTTLE=0 | MODE=LFSR | RESET=1
					dev->UpdateWireIns();
					dev->SetWireInValue(
						0x00, 0 << 5 | ((m_ePattern == OK_PATTERN_LFSR ? 1 : 0) << 4) | 0 << 2
					); // SET_THROTTLE=0 | MODE=LFSR | RESET=0
					dev->UpdateWireIns();
				}
				generateData(pValid, u32SegmentSize, m_devInfo.pipeWidth);
			}

			if (bWrite) {
				if (0 == m_u32BlockSize) {
					ret = dev->WriteToPipeIn(0x80, u32SegmentSize, pValid);
				} else {
					ret = dev->WriteToBlockPipeIn(0x80, m_u32BlockSize, u32SegmentSize, pValid);
				}
			} else {
				if (0 == m_u32BlockSize) {
					ret = dev->ReadFromPipeOut(0xA0, u32SegmentSize, pBuffer);
				} else {
					ret = dev->ReadFromBlockPipeOut(0xA0, m_u32BlockSize, u32SegmentSize, pBuffer);
				}
			}

			if (ret < 0) {
				switch (ret) {
					case okCFrontPanel::InvalidBlockSize:
						printf("Block Size Not Supported\n");
						break;
					case okCFrontPanel::UnsupportedFeature:
						printf("Unsupported Feature\n");
						break;
					default:
						printf("Transfer Failed with error: %ld\n", ret);
						break;
				}

				if (dev->IsOpen() == false) {
					printf("Device disconnected\n");
					exit(-1);
				}
				break;
			} else if (m_bCheck) {
				if (false == bWrite) {
					if (false == checkData(pBuffer, pValid, u32SegmentSize)) {
						printf("ERROR: Data check failed!\n");
						dataError = true;
					}
				} else {
					dev->UpdateWireOuts();
					int n = dev->GetWireOutValue(0x21);
					if (0 != n) {
						printf("ERROR: Data check failed!  (%d errors)\n", n);
						dataError = true;
					}
				}
			}
		}
	}
	stopTimer();

	delete[] pValid;
	delete[] pBuffer;
	double benchmark = ret < 0 ? 0 : reportBandwidthResults(u32Count);
	RecordPipeResults(
		bWrite, benchmark, m_u32TransferSize, m_u32SegmentSize, m_u32BlockSize, ret, dataError
	);
}

void
BenchmarkWires(okCFrontPanel* dev)
{
	UINT32 i;

	printf("UpdateWireIns  (1000 calls)  ");
	startTimer();
	for (i = 0; i < 1000; i++)
		dev->UpdateWireIns();
	stopTimer();
	RecordPollingResults(wireIn, reportRateResults(1000));

	printf("UpdateWireOuts (1000 calls)  ");
	startTimer();
	for (i = 0; i < 1000; i++)
		dev->UpdateWireOuts();
	stopTimer();
	reportRateResults(1000);
	RecordPollingResults(wireOut, reportRateResults(1000));
}

void
BenchmarkTriggers(okCFrontPanel* dev)
{
	UINT32 i;

	printf("ActivateTriggerIns  (1000 calls)  ");
	startTimer();
	for (i = 0; i < 1000; i++)
		dev->ActivateTriggerIn(0x40, 0x01);
	stopTimer();
	RecordPollingResults(triggerIn, reportRateResults(1000));

	printf("UpdateTriggerOuts (1000 calls)  ");
	startTimer();
	for (i = 0; i < 1000; i++)
		dev->UpdateTriggerOuts();
	stopTimer();
	RecordPollingResults(triggerOut, reportRateResults(1000));
}

void
StressPipes(okCFrontPanel* dev)
{
	UINT32 i, j;
	bool bWrite;
	UINT32 matrix[][3] = {// SegmentSize,    TransferSize,   Pattern
						  {4 * 1024 * 1024, 64 * 1024 * 1024, OK_PATTERN_COUNT},
						  {4 * 1024 * 1024, 64 * 1024 * 1024, OK_PATTERN_LFSR},
						  {4 * 1024 * 1024, 64 * 1024 * 1024, OK_PATTERN_WALKING1},
						  {4 * 1024 * 1024, 64 * 1024 * 1024, OK_PATTERN_WALKING0},
						  {4 * 1024 * 1024, 64 * 1024 * 1024, OK_PATTERN_HAMMER},
						  {4 * 1024 * 1024, 64 * 1024 * 1024, OK_PATTERN_NEIGHBOR},
						  {0, 0, 0}};

	m_bCheck = true;
	for (j = 0; j < 2; j++) {
		bWrite = (j == 1);
		for (i = 0; matrix[i][0] != 0; i++) {
			m_u32BlockSize = 0;
			m_u32SegmentSize = matrix[i][0];
			m_u32TransferSize = matrix[i][1];
			m_ePattern = matrix[i][2];
			if (0 != m_u32BlockSize) {
				m_u32SegmentSize -=
					(m_u32SegmentSize % m_u32BlockSize
					); // Segment size must be a multiple of block length
				m_u32TransferSize -=
					(m_u32TransferSize % m_u32BlockSize
					); // Segment size must be a multiple of block length
			}
			printf(
				"%s SS:%-10d  TS:%-10d   Pattern:%d   ",
				bWrite ? ("Write") : ("Read "),
				m_u32SegmentSize,
				m_u32TransferSize,
				m_ePattern
			);
			Transfer(dev, 1, bWrite);
		}
	}
}

void
BenchmarkPipes(okCFrontPanel* dev)
{
	UINT32 i, j, u32Count;
	bool bWrite;
	UINT32 matrix[][4] = {// BlockSize, SegmentSize,    TransferSize, Count
						  {0, 4 * 1024 * 1024, 64 * 1024 * 1024, 1},
						  {0, 4 * 1024 * 1024, 32 * 1024 * 1024, 1},
						  {0, 4 * 1024 * 1024, 16 * 1024 * 1024, 2},
						  {0, 4 * 1024 * 1024, 8 * 1024 * 1024, 4},
						  {0, 4 * 1024 * 1024, 4 * 1024 * 1024, 8},
						  {0, 1 * 1024 * 1024, 32 * 1024 * 1024, 1},
						  {0, 256 * 1024, 32 * 1024 * 1024, 1},
						  {0, 64 * 1024, 16 * 1024 * 1024, 1},
						  {0, 16 * 1024, 4 * 1024 * 1024, 1},
						  {0, 4 * 1024, 1 * 1024 * 1024, 1},
						  {0, 1 * 1024, 1 * 1024 * 1024, 1},
						  {1024, 1 * 1024, 1 * 1024 * 1024, 1},
						  {1024, 1 * 1024 * 1024, 32 * 1024 * 1024, 1},
						  {900, 1 * 1024 * 1024, 32 * 1024 * 1024, 1},
						  {800, 1 * 1024 * 1024, 32 * 1024 * 1024, 1},
						  {700, 1 * 1024 * 1024, 32 * 1024 * 1024, 1},
						  {600, 1 * 1024 * 1024, 32 * 1024 * 1024, 1},
						  {512, 1 * 1024 * 1024, 32 * 1024 * 1024, 1},
						  {500, 1 * 1024 * 1024, 32 * 1024 * 1024, 1},
						  {400, 1 * 1024 * 1024, 16 * 1024 * 1024, 1},
						  {300, 1 * 1024 * 1024, 16 * 1024 * 1024, 1},
						  {256, 1 * 1024 * 1024, 16 * 1024 * 1024, 1},
						  {200, 1 * 1024 * 1024, 8 * 1024 * 1024, 1},
						  {128, 1 * 1024 * 1024, 8 * 1024 * 1024, 1},
						  {100, 1 * 1024 * 1024, 8 * 1024 * 1024, 1},
						  {9999, 0, 0, 0}};

	for (j = 0; j < 2; j++) {
		bWrite = (j == 1);
		for (i = 0; matrix[i][0] != 9999; i++) {
			m_u32BlockSize = matrix[i][0];
			m_u32SegmentSize = matrix[i][1];
			m_u32TransferSize = matrix[i][2];
			if (0 != m_u32BlockSize) {
				m_u32SegmentSize -=
					(m_u32SegmentSize % m_u32BlockSize
					); // Segment size must be a multiple of block length
				m_u32TransferSize -=
					(m_u32TransferSize % m_u32BlockSize
					); // Segment size must be a multiple of block length
			}
			u32Count = matrix[i][3];
			printf(
				"%s BS:%-10d  SS:%-10d  TS:%-10d   ",
				bWrite ? ("Write") : ("Read "),
				m_u32BlockSize,
				m_u32SegmentSize,
				m_u32TransferSize
			);
			Transfer(dev, u32Count, bWrite);
		}
	}
}

// Computer min, max, average of the polling result vector and output it to a
// file with the given column name
void
ComputePollingTransferStatistics(
	std::ofstream& fp, const char* columnName, const std::vector<pollingResult>& v
)
{
	double average = 0;
	double sum = 0;
	double max = 0;
	double min = INT_MAX;

	if (!v.empty()) {

		for (const auto& i: v) {
			sum += i.rate;
			if (i.rate > max) {
				max = i.rate;
			}

			if (i.rate < min) {
				min = i.rate;
			}
		}
		average = sum / wireInResults.size();
		fp << columnName << "," << min << "," << max << "," << average << ","
		   << wireInResults.size() * 1000 << "\n";
	}
}

// Helper function to output the Pipe result maps
void
OutputPipeResults(
	const char* transferType, std::map<transferSizes, pipeResult> results, std::ofstream& fout
)
{
	for (const auto& i: results) {
		fout << transferType << "," << i.first.blockSize << "," << i.first.segmentSize << ","
			 << i.first.transferSize << "," << (i.second.rateSum / i.second.qty) << ","
			 << i.second.min << "," << i.second.max << "," << i.second.qty << ","
			 << i.second.errorCount << "," << (i.second.errorCount / i.second.qty) << ","
			 << i.second.dataErrors << "\n";
	}
}

// Create statistics report output it to a csv file
void
CreateStatisticsReport(const char* fileName)
{
	if (fileName == nullptr) {
		std::cout << "No filename provided, using default 'report.csv'\n";
		fileName = "report.csv";
	}

	std::ofstream fout;
	fout.open(fileName);
	if (!fout.good()) {
		std::cout << "file creation failed." << std::endl;
		exit(-1);
	}

	fout << "Transfer type,"
		 << "min/sec,"
		 << "max/sec,"
		 << "average/sec,"
		 << "# of transfers,\n";

	// Computer and print the polling transfer stats
	ComputePollingTransferStatistics(fout, "Wire In", wireInResults);
	ComputePollingTransferStatistics(fout, "Wire Out", wireOutResults);
	ComputePollingTransferStatistics(fout, "Trigger In", triggerInResults);
	ComputePollingTransferStatistics(fout, "Trigger Out", triggerOutResults);

	fout << "\nPipe Results\n";
	fout << "Transfer Type,Block Size (bytes),Segment Size (bytes),Transfer Size "
			"(bytes),Average "
			"Rate (MB/s),Min (MB/s),Max (MB/s),Transfer Count,Error Count,Error "
			"Percentage,Data "
			"Integrity Errors\n";

	OutputPipeResults("Pipe Out", pipeOutResults, fout);
	OutputPipeResults("Pipe In", pipeInResults, fout);

	std::cout << "Wrote report to: " << fileName << std::endl;
}

bool
InitializeFPGA(okCFrontPanel* dev, char* bitfile)
{
	dev->GetDeviceInfo(&m_devInfo);
	printf("Found a device: %s\n", m_devInfo.productName);

	dev->LoadDefaultPLLConfiguration();

	// Get some general information about the XEM.
	printf(
		"Device firmware version: %d.%d\n",
		m_devInfo.deviceMajorVersion,
		m_devInfo.deviceMinorVersion
	);
	printf("Device serial number: %s\n", m_devInfo.serialNumber);
	printf("Device device ID: %d\n", m_devInfo.productID);

	if (strcmp("nobit", bitfile) != 0) {
		// Download the configuration file.
		if (okCFrontPanel::NoError != dev->ConfigureFPGA(bitfile)) {
			printf("FPGA configuration failed.\n");
			return (false);
		}
	} else {
		printf("Skipping FPGA configuration.\n");
	}

	// Check for FrontPanel support in the FPGA configuration.
	if (dev->IsFrontPanelEnabled()) {
		printf("FrontPanel support is enabled.\n");
	} else {
		printf("FrontPanel support is not enabled.\n");
		return (false);
	}

	return (true);
}

static void
printUsage(char* progname)
{
	printf(
		"Usage: %s bitfile [serial S] [repeat N] [pattern "
		"lfsr|sequential|walking1|walking0|hammer|neighbor|fixed F]\n",
		progname
	);
	printf("                  [throttlein T] [throttleout T] [check] [inject]\n");
	printf("                  [blocksize B] [segmentsize S]\n");
	printf("                  [stress] [bench] [read N] [write N]\n\n");
	printf("   serial S       - Optionally specify serial S of device to test.\n");
	printf("   bitfile        - Configuration file to download, alternatively "
		   "specify \"nobit\" to "
		   "skip configuration.\n");
	printf("   repeat N       - Repeats the requested tests for N seconds "
		   "(\"inf\" to run forever).\n");
	printf("   pattern        - Set pattern to one of the supported patterns.\n");
	printf("      lfsr        - [Default] Selects LFSR psuedorandom pattern "
		   "generator.\n");
	printf("      sequential  - Selects Counter pattern generator.\n");
	printf("      walking1    - Selects Walking 1's pattern generator. (USB 3.0 "
		   "only)\n");
	printf("      walking0    - Selects Walking 0's pattern generator. (USB 3.0 "
		   "only)\n");
	printf("      hammer      - Selects Hammer pattern generator. (USB 3.0 only)\n");
	printf("      neighbor    - Selects Neighbor pattern generator. (USB 3.0 "
		   "only)\n");
	printf("      fixed F     - Selects a fixed pattern defined by hex input F. "
		   "(USB 3.0 only)\n");
	printf("   throttlein     - Specifies a 32-bit hex throttle vector (writes).\n");
	printf("   throttleout    - Specifies a 32-bit hex throttle vector (reads).\n");
	printf("   check          - Turns on validity checks.\n");
	printf("   inject         - Injects an error during data generation.\n");
	printf("   blocksize B    - Sets the block size to B (for BTPipes).\n");
	printf("   segmentsize S  - Sets the segment size to S.\n");
	printf("   stress         - Performs a transfer stress test (validity checks "
		   "on).\n");
	printf("   bench          - Runs a preset benchmark script and prints "
		   "results.\n");
	printf("   csv S             - Also output results to a csv file named [S]\n");
	printf("   read N         - Performs a read of N bytes and optionally checks "
		   "for validity.\n");
	printf("   write N        - Performs a write of N bytes and optionally "
		   "checks for validity.\n");
}

int
real_main(int argc, char* argv[])
{
	const char* serial;
	UINT32 i, orig_i;
	std::chrono::steady_clock::time_point current_time, pipetest_start_time;
	int rep_time = 0; // default to zero so that the loop only completes once
	bool run_forever = 0;

	printf("---- Opal Kelly ---- PipeTest Application v2.0 ----\n");
	printf("FrontPanel DLL loaded. Version: %s\n", okFrontPanel_GetAPIVersionString());

	if (argc < 2) {
		printUsage(argv[0]);
		return (-1);
	}

	// Open the device, optionally selecting the one with the specified serial.
	if ((argc >= 3) && (!strcmp(argv[2], "serial"))) {
		serial = argv[3];
		i = 4;
	} else {
		serial = "";
		i = 2;
	}

	OpalKelly::FrontPanelDevices devices;
	OpalKelly::FrontPanelPtr devptr = devices.Open(serial);
	okCFrontPanel* const dev = devptr.get();
	if (!dev) {
		if (!devices.GetCount()) {
			printf("No connected devices detected.\n");
		} else {
			// We do have some device(s), but not with the specified serial.
			printf("Device \"%s\" could not be opened.\n", serial);
		}

		return (1);
	}

	// Initialize the FPGA with our configuration bitfile.
	if (false == InitializeFPGA(dev, argv[1])) {
		printf("FPGA could not be initialized.\n");
		return (2);
	}

	pipetest_start_time = std::chrono::steady_clock::now();

	if ((argc > int(i)) && !strcmp(argv[i], "repeat")) {
		if (!strcmp(argv[++i], "inf")) {
			run_forever = 1;
			printf("Repeating tests indefinitely\n");
		} else {
			sscanf(argv[i], "%d", &rep_time);
			printf("Repeating tests for %d seconds\n", rep_time);
		}

		i++;
	}

	std::chrono::steady_clock::time_point pipetest_run_time =
		std::chrono::seconds(rep_time) + pipetest_start_time;

	const char* fileName = nullptr;
	bool m_bCsv = false;
	m_bCheck = false;
	m_ePattern = OK_PATTERN_LFSR;
	m_u32BlockSize = 0;
	m_u32SegmentSize = 4 * 1024 * 1024;
	m_u32ThrottleIn = 0xffffffff;
	m_u32ThrottleOut = 0xffffffff;
	orig_i = i;

	do {
		for (; i < (UINT32)argc; i++) {
			if (!strcmp(argv[i], "blocksize")) {
				sscanf(argv[++i], "%u", &m_u32BlockSize);
			} else if (!strcmp(argv[i], "segmentsize")) {
				sscanf(argv[++i], "%u", &m_u32SegmentSize);
			} else if (!strcmp(argv[i], "check")) {
				m_bCheck = true;
			} else if (!strcmp(argv[i], "pattern")) {
				if ((UINT32)argc < ++i) {
					printf("Need argument for pattern\n");
				}
				if (!strcmp(argv[i], "lfsr")) {
					m_ePattern = OK_PATTERN_LFSR;
					printf("Data pattern: LFSR\n");
				} else if (!strcmp(argv[i], "sequential")) {
					m_ePattern = OK_PATTERN_COUNT;
					printf("Data pattern: Sequential\n");
				} else if (!strcmp(argv[i], "walking0")) {
					m_ePattern = OK_PATTERN_WALKING0;
					printf("Data pattern: Walking 0's\n");
				} else if (!strcmp(argv[i], "walking1")) {
					m_ePattern = OK_PATTERN_WALKING1;
					printf("Data pattern: Walking 1's\n");
				} else if (!strcmp(argv[i], "hammer")) {
					m_ePattern = OK_PATTERN_HAMMER;
					printf("Data pattern: Hammer\n");
				} else if (!strcmp(argv[i], "neighbor")) {
					m_ePattern = OK_PATTERN_NEIGHBOR;
					printf("Data pattern: Neighbor\n");
				} else if (!strcmp(argv[i], "fixed")) {
					m_ePattern = OK_PATTERN_FIXED;
					m_u32FixedPattern = strtoul(argv[++i], NULL, 16);
					printf("Data pattern: Fixed %08X\n", m_u32FixedPattern);
				} else {
					printf("Pattern: \"%s\" not supported, defaulting to LFSR\n", argv[i]);
				}
			} else if (!strcmp(argv[i], "inject")) {
				m_bInjectError = true;
			} else if (!strcmp(argv[i], "throttlein")) {
				sscanf(argv[++i], "%08x", &m_u32ThrottleIn);
			} else if (!strcmp(argv[i], "throttleout")) {
				sscanf(argv[++i], "%08x", &m_u32ThrottleOut);
			} else if (!strcmp(argv[i], "read")) {
				sscanf(argv[++i], "%d", &m_u32TransferSize);
				Transfer(dev, 1, false);
			} else if (!strcmp(argv[i], "write")) {
				sscanf(argv[++i], "%d", &m_u32TransferSize);
				Transfer(dev, 1, true);
			} else if (!strcmp(argv[i], "bench")) {
				BenchmarkWires(dev);
				BenchmarkTriggers(dev);
				BenchmarkPipes(dev);
			} else if (!strcmp(argv[i], "stress")) {
				StressPipes(dev);
			} else if (!strcmp(argv[i], "csv")) {
				m_bCsv = true;
				fileName = argv[++i];
			} else {
				printf("Unrecognized command: %s\n", argv[i]);
				printUsage(argv[0]);
				return 1;
			}
		}

		current_time = std::chrono::steady_clock::now();
		i = orig_i;
	} while ((current_time < pipetest_run_time) || run_forever);

	if (m_bCsv) {
		CreateStatisticsReport(fileName);
	}
	return (0);
}

int
main(int argc, char* argv[])
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
