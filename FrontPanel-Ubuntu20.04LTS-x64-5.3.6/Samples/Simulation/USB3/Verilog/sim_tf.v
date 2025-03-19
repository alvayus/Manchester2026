//------------------------------------------------------------------------
// Sim_tf.v
//
// A simple text fixture example for getting started with FrontPanel
// simulation. 
//
//------------------------------------------------------------------------
// Copyright (c) 2005-2023 Opal Kelly Incorporated
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
// $Rev: 77 $ $Date: 2015-01-06 11:09:33 -0800 (Tue, 06 Jan 2015) $
//------------------------------------------------------------------------
`timescale 1ns/1ps
`default_nettype none

module SIM_TEST;

	wire  [4:0]   okUH;
	wire  [2:0]   okHU;
	wire  [31:0]  okUHU;
	wire          okAA;
	wire  [7:0]   led;

	sim dut (
		.okUH(okUH),
		.okHU(okHU),
		.okUHU(okUHU),
		.okAA(okAA),
		.led(led)
		);

	//------------------------------------------------------------------------
	// Begin okHostInterface simulation user configurable global data
	//------------------------------------------------------------------------
	parameter BlockDelayStates = 5;   // REQUIRED: # of clocks between blocks of pipe data
	parameter ReadyCheckDelay = 5;    // REQUIRED: # of clocks before block transfer before
	                                  //  host interface checks for ready (0-255)
	parameter PostReadyDelay = 5;     // REQUIRED: # of clocks after ready is asserted and
	                                  //  check that the block transfer begins (0-255)
	parameter pipeInSize = 128;       // REQUIRED: byte (must be even) length of default
	                                  //  PipeIn; Integer 0-2^32
	parameter pipeOutSize = 128;      // REQUIRED: byte (must be even) length of default
	                                  // PipeOut; Integer 0-2^32
	parameter registerSetSize = 32;   // Size of array for register set commands.

	parameter Tsys_clk = 5;           // 100Mhz
	//-------------------------------------------------------------------------

	// Pipes
	integer k;
	reg  [7:0]  pipeIn [0:(pipeInSize-1)];
	initial for (k=0; k<pipeInSize; k=k+1) pipeIn[k] = 8'h00;

	reg  [7:0]  pipeOut [0:(pipeOutSize-1)];
	initial for (k=0; k<pipeOutSize; k=k+1) pipeOut[k] = 8'h00;

	// Registers
	reg [31:0] u32Address  [0:(registerSetSize-1)];
	reg [31:0] u32Data     [0:(registerSetSize-1)];
	reg [31:0] u32Count;

	//------------------------------------------------------------------------
	//  Available User Task and Function Calls:
	//    FrontPanelReset;                 // Always start routine with FrontPanelReset;
	//    SetWireInValue(ep, val, mask);
	//    UpdateWireIns;
	//    UpdateWireOuts;
	//    GetWireOutValue(ep);
	//    ActivateTriggerIn(ep, bit);      // bit is an integer 0-15
	//    UpdateTriggerOuts;
	//    IsTriggered(ep, mask);           // Returns a 1 or 0
	//    WriteToPipeIn(ep, length);       // passes pipeIn array data
	//    ReadFromPipeOut(ep, length);     // passes data to pipeOut array
	//    WriteToBlockPipeIn(ep, blockSize, length);   // pass pipeIn array data; blockSize and length are integers
	//    ReadFromBlockPipeOut(ep, blockSize, length); // pass data to pipeOut array; blockSize and length are integers
	//		WriteRegister(address, data);
	//		ReadRegister(address, data);
	//		WriteRegisterSet;                // writes all values in u32Data to the addresses in u32Address
	//		ReadRegisterSet;                 // reads all values in the addresses in u32Address to the array u32Data
	//
	//    *Pipes operate by passing arrays of data back and forth to the user's
	//    design.  If you need multiple arrays, you can create a new procedure
	//    above and connect it to a differnet array.  More information is
	//    available in Opal Kelly documentation and online support tutorial.
	//------------------------------------------------------------------------

	wire [31:0] NO_MASK = 32'hffff_ffff;

	// LFSR/Counter modes
	wire [15:0] MODE_LFSR = 2'b00;        // Will set 0th bit
	wire [15:0] MODE_COUNTER = 2'b01;     // Will set 1st bit

	// Off/Continuous/Piped modes for LFSR/Counter
	wire [15:0] MODE_OFF = 2'b10;         // Will set 2nd bit
	wire [15:0] MODE_CONTINUOUS = 2'b11;  // Will set 3rd bit
	wire [15:0] MODE_PIPED = 3'b100;      // Will set 4th bit

	// Variables
	integer i, j;
	reg [31:0] ep01value;
	reg [31:0] ep20value;
	reg [31:0] mode;
	reg [7 :0] ReadPipe [0:(pipeOutSize-1)];
	reg [31:0] RegOutData [0:(registerSetSize-1)];
	reg [31:0] RegInData [0:(registerSetSize-1)];
	reg [31:0] RegAddresses [0:(registerSetSize-1)];
	integer    rand_error;
	reg        trig_error = 1'b0;
	reg [31:0] errorSim = 32'h0000_0000;

	initial for (k=0; k<pipeOutSize; k=k+1) ReadPipe[k] = 8'h00;
	initial for (k=0; k<registerSetSize; k=k+1) begin
		RegOutData[k] = 32'h0000_0000;
		RegInData[k] = 32'h0000_0000;
		RegAddresses[k] = 32'h0000_0000;
	end

	//************************************************************************
	// Check_LFSR
	// Sets the LFSR register mode to either Fibonacci LFSR or standard counter
	// Seeds the register using WireIns
	// Checks and prints the current value using a WireOut
	//************************************************************************
	task Check_LFSR (input [1:0] mode);
		begin
			// Set LFSR/Counter to run continuously
			ActivateTriggerIn(8'h40, MODE_CONTINUOUS);

			ActivateTriggerIn(8'h40, mode);
			if(mode == MODE_LFSR) begin
				$display("Mode: LFSR");
			end else if(mode == MODE_COUNTER) begin
				$display("Mode: Counter");
			end

			// Seed LFSR with initial value
			ep01value = $random;
			SetWireInValue(8'h01, ep01value, NO_MASK);
			UpdateWireIns;

			// Check value on LFSR/Counter
			for(i=0; i<5; i=i+1) begin
				UpdateWireOuts;
				ep20value = GetWireOutValue(8'h20);
				$display("Read value: 0x%04h", ep20value);
			end
			$write("\n");
		end
	endtask

	//************************************************************************
	// Check_PipeOut
	// Selects Piped mode and the specified LFSR register mode
	// Reads in values from the LFSR using a PipeOut endpoint
	// Prints the values in the proper sequence to form a
	//    complete 32-bit value
	//************************************************************************
	task Check_PipeOut (input [1:0] mode);
		begin
			ActivateTriggerIn(8'h40, MODE_PIPED);
			ActivateTriggerIn(8'h40, mode);
			// Read values
			ReadFromPipeOut(8'ha0, pipeOutSize);
			// Display values
			if(mode == MODE_LFSR) begin
				$display("PipeOut LFSR excerpt: ");
			end else if(mode == MODE_COUNTER) begin
				$display("PipeOut Counter excerpt: ");
			end

			for(i=0; i<64; i=i+4) begin
				ReadPipe[i] = pipeOut[i];
				ReadPipe[i+1] = pipeOut[i+1];
				ReadPipe[i+2] = pipeOut[i+2];
				ReadPipe[i+3] = pipeOut[i+3];
				$write("0x%2h%2h%2h%2h\n", ReadPipe[i+3], ReadPipe[i+2], ReadPipe[i+1], ReadPipe[i]);
			end
			$write("\n\n");
		end
	endtask

	//************************************************************************
	// Check_Registers
	// Stops the LFSR from updating (optional)
	// Sets up 32 values and 32 addresses
	// Sends the values to the FPGA and reads them back
	// Prints a comparison
	//************************************************************************
	task Check_Registers ();
		begin
			for(i=0; i<registerSetSize; i=i+1) begin
				RegOutData[i] = $random & 32'hffff_ffff;
				RegAddresses[i] = i+3;

				WriteRegister(RegAddresses[i], RegOutData[i]);
			end

			$display("Write to and read from block RAM using registers: ");
			$display("--------------------------------------------------");

			for(i=0; i<registerSetSize; i=i+1) begin
				ReadRegister(RegAddresses[i], RegInData[i]);
				$display("Expected 0x%04h, Received 0x%04h", RegOutData[i], RegInData[i]);
			end
			end
	endtask


	initial begin
		FrontPanelReset;

		// Reset LFSR
		SetWireInValue(8'h00, 32'h0000_0001, NO_MASK);
		UpdateWireIns;
		SetWireInValue(8'h00, 32'h0000_0000, NO_MASK);
		UpdateWireIns;

		for(j=0; j<2; j=j+1) begin
			// Select mode as LFSR to periodically read pseudo-random values
			Check_LFSR(MODE_LFSR);

			// Select mode as counter
			// Note: since counter runs continuously and the values are
			//    not continuously checked,
			//    these values will be sequential but will not increase
			//    by exactly one
			Check_LFSR(MODE_COUNTER);
			
		end

		// Switch to LFSR mode
		Check_PipeOut(MODE_LFSR);

		//Switch to Counter mode
		Check_PipeOut(MODE_COUNTER);

		// Perform an operation on the pipeOut data and send it back to the "FPGA"
		for(i=0; i<pipeInSize; i=i+1) begin
			pipeIn[i] = ((2 * pipeOut[i]) - 1) & 8'hff;
		end
		WriteToPipeIn(8'h80, pipeInSize);

		// Write to and read from pseudoRAM
		Check_Registers;

	end

	`include "./oksim/okHostCalls.vh"   // Do not remove!  The tasks, functions, and data stored
	                                   // in okHostCalls.vh must be included here.
endmodule
`default_nettype wire
