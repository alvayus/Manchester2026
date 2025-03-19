//////////////////////////////////////////////////////////////////////////////////
// Company: Opal Kelly, Inc.
// Engineer: Alex McConnell
// 
// Create Date:    09:44:28 01/06/2015 
// Design Name: Simulation sample for USB2 in Verilog
// Module Name:    sim 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`default_nettype none

module sim_dual(
	input  wire [4:0]  okUH,
	output wire [2:0]  okHU,
	inout  wire [31:0] okUHU,
	input  wire [4:0]  okUHs,
	output wire [2:0]  okHUs,
	inout  wire [31:0] okUHUs,
	inout  wire        okAA,
	
	output reg  [7:0]  led
    );

	parameter MODE_LFSR = 2'b01;
	parameter MODE_COUNTER = 2'b10;
	parameter MODE_OFF = 2'b00;
	parameter MODE_CONTINUOUS = 2'b01;
	parameter MODE_PIPED = 2'b10;
	 
	// Target interface bus
	wire okClk;
	wire [112:0]    okHE;
	wire [64:0]     okEH;
	wire [65*4-1:0] okEHx;
	wire okClks;
	wire [112:0]    okHEs;
	wire [64:0]     okEHs;
	wire [65*4-1:0] okEHxs;
	 
	// Endpoint connections
	wire [31:0] ep00wire, ep00wire_s;
	wire [31:0] ep01wire, ep01wire_s;
	reg  [31:0] ep20wire, ep20wire_s;

	wire [31:0] epModeTrig, epModeTrig_s;
	wire [31:0] ep41Trig, ep41Trig_s;

	reg  [31:0] epPipeOut, epPipeOut_s;
	wire        epPipeRead, epPipeRead_s;

	wire [31:0] epPipeIn, epPipeIn_s;
	wire        epPipeWrite, epPipeWrite_s;

	wire        regWrite, regWrite_s;
	wire        regRead, regRead_s;
	wire [31:0] regAddress, regAddress_s;
	wire [31:0] regWriteData, regWriteData_s;
	wire [31:0] regReadData, regReadData_s;
	
	// Design behavior buses and wires
	reg  [31:0]   lfsr, lfsr_s;
	wire          reset, reset_s;
	reg  [31:0]   ep01_ref, ep01_ref_s;
	reg  [1 :0]   LFSR_MODE, LFSR_MODE_S;
	reg  [2 :0]   REFRESH_MODE, REFRESH_MODE_S;

	wire          clk_en;
	reg  [1023:0] led_data;
	reg  [15:0]   led_store;
	reg  [31:0]   led_temp;
	 
	//*********************Begin Design*********************//
	 
	// Wires update on okClk.
	// Keep the design synchronous by deriving reset from an okWireIn endpoint
	assign reset = ep00wire[0];
	assign reset_s = ep00wire_s[0];

	// Select mode
	always @(posedge okClk) begin
		case (epModeTrig[4:0])
			5'b00001: LFSR_MODE <= MODE_LFSR;
			5'b00010: LFSR_MODE <= MODE_COUNTER;
			5'b00100: REFRESH_MODE <= MODE_OFF;
			5'b01000: REFRESH_MODE <= MODE_CONTINUOUS;
			5'b10000: REFRESH_MODE <= MODE_COUNTER;
			default:
				begin
					LFSR_MODE <= LFSR_MODE;
					REFRESH_MODE <= REFRESH_MODE;
				end
		endcase
	end
	always @(posedge okClks) begin
		case (epModeTrig_s[4:0])
			5'b00001: LFSR_MODE_S <= MODE_LFSR;
			5'b00010: LFSR_MODE_S <= MODE_COUNTER;
			5'b00100: REFRESH_MODE_S <= MODE_OFF;
			5'b01000: REFRESH_MODE_S <= MODE_CONTINUOUS;
			5'b10000: REFRESH_MODE_S <= MODE_COUNTER;
			default:
				begin
					LFSR_MODE_S <= LFSR_MODE_S;
					REFRESH_MODE_S <= REFRESH_MODE_S;
				end
		endcase
	end
	 
	// LFSR/Counter
	always @(posedge okClk) begin
	 	if(reset) begin
	 		lfsr <= 32'h0000_0000;
	 		ep01_ref <= 32'h0000_0000;
	 		epPipeOut <= 32'h0000_0000;
	 		LFSR_MODE <= MODE_OFF;
	 		REFRESH_MODE <= MODE_OFF;
	 	end
	 	case(REFRESH_MODE)
	 		MODE_OFF:
	 			begin
	 				lfsr <= lfsr;
	 			end
	 		MODE_CONTINUOUS:
	 			begin
				 	case(LFSR_MODE)
						1: 
							begin
								if (ep01wire != ep01_ref) begin
							 		lfsr <= ep01wire;
							 		ep01_ref <= ep01wire;
							 	end else begin
									lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1]};
								end
							end
						2:
							begin
								lfsr <= lfsr + 1'b1;
							end
						default: lfsr <= lfsr;
					endcase
				end
			MODE_PIPED:
				begin
					// When prompted, PipeOut the current LFSR value
					case(LFSR_MODE)
						MODE_LFSR:
							begin
								if(epPipeRead == 1'b1) begin
									epPipeOut <= lfsr;
									lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1]};
								end
							end
						MODE_COUNTER:
							begin
								if(epPipeRead == 1'b1) begin
									epPipeOut <= lfsr;
									lfsr <= lfsr + 1'b1;
								end
							end
						default: lfsr <= lfsr;
					endcase
				end
		endcase

		ep20wire <= lfsr;
	end
	always @(posedge okClks) begin
	 	if(reset_s) begin
	 		lfsr_s <= 32'h0000_0000;
	 		ep01_ref_s <= 32'h0000_0000;
	 		epPipeOut_s <= 32'h0000_0000;
	 		LFSR_MODE_S <= MODE_OFF;
	 		REFRESH_MODE_S <= MODE_OFF;
	 	end
	 	case(REFRESH_MODE_S)
	 		MODE_OFF:
	 			begin
	 				lfsr_s <= lfsr_s;
	 			end
	 		MODE_CONTINUOUS:
	 			begin
				 	case(LFSR_MODE)
						1: 
							begin
								if (ep01wire_s != ep01_ref_s) begin
							 		lfsr_s <= ep01wire_s;
							 		ep01_ref_s <= ep01wire_s;
							 	end else begin
									lfsr_s <= {lfsr_s[30:0], lfsr_s[31] ^ lfsr_s[21] ^ lfsr_s[1]};
								end
							end
						2:
							begin
								lfsr_s <= lfsr_s + 1'b1;
							end
						default: lfsr_s <= lfsr_s;
					endcase
				end
			MODE_PIPED:
				begin
					// When prompted, PipeOut the current LFSR value
					case(LFSR_MODE)
						MODE_LFSR:
							begin
								if(epPipeRead_s == 1'b1) begin
									epPipeOut_s <= lfsr_s;
									lfsr_s <= {lfsr_s[30:0], lfsr_s[31] ^ lfsr_s[21] ^ lfsr_s[1]};
								end
							end
						MODE_COUNTER:
							begin
								if(epPipeRead_s == 1'b1) begin
									epPipeOut_s <= lfsr_s;
									lfsr_s <= lfsr_s + 1'b1;
								end
							end
						default: lfsr_s <= lfsr_s;
					endcase
				end
		endcase

		ep20wire_s <= lfsr_s;
	end

	// When prompted, PipeOut the current lfsr value
	always @(posedge okClk) begin
	 	if (epPipeRead == 1'b1) begin
	 		epPipeOut <= lfsr;
	 	end
	end
	always @(posedge okClks) begin
	 	if (epPipeRead_s == 1'b1) begin
	 		epPipeOut_s <= lfsr_s;
	 	end
	end

	// LEDs get lower bytes of PipeIn XOR'd with upper bytes
	// When prompted, update the values used by LEDs
	always @(posedge okClk) begin
		if(reset) begin
			led_temp = 32'h0000_0000;
			led_data = 1024'h0;
		end
		led_temp = led_data[1023:992];
		led_data = led_data << 32;
		led_data[32:0] = led_temp;
	 	if(epPipeWrite == 1'b1) begin
	 		led_data[31:0] = epPipeIn;
		end
	end

	Clock_Div slow(.okClk(okClk), .clk_en(clk_en));

	always @(posedge okClk) begin
		if(reset) begin
			led_store <= 16'h0000;
			led <= ~8'h00;
		end
		if(|led_data[15:0] == 1'b1) begin
			led_store <= led_data[15:0];
		end
		if(clk_en == 1'b1) begin
			led <= ~(led_store[15:8] ^ led_store[7:0]);
		end
	end

	// Instantiate the RAM

	pseudoRAM RAM_block(
		.regWrite(regWrite),
		.regRead(regRead),
		.regAddress(regAddress),
		.regWriteData(regWriteData),
		.regReadData(regReadData),
		.okClk(okClk)
	);

	pseudoRAM RAM_block_secondary(
		.regWrite(regWrite_s),
		.regRead(regRead_s),
		.regAddress(regAddress_s),
		.regWriteData(regWriteData_s),
		.regReadData(regReadData_s),
		.okClk(okClks)
	);
	 
	// Instantiate the okHost and connect endpoints
	 
	okDualHost okHI(
		.okUH(okUH),
		.okHU(okHU),
		.okUHU(okUHU),
		.okUHs(okUHs),
		.okHUs(okHUs),
		.okUHUs(okUHUs),
		.okAA(okAA),
		.okClk(okClk),
		.okHE(okHE),
		.okEH(okEH),
		.okClks(okClks),
		.okHEs(okHEs),
		.okEHs(okEHs)
	);
	 
	okWireOR # (.N(4)) wireOR (.okEH(okEH), .okEHx(okEHx));
	okWireOR # (.N(4)) wireORs (.okEH(okEHs), .okEHx(okEHxs));
	 
	okWireIn  ep00    (.okHE(okHE),                             .ep_addr(8'h00), .ep_dataout(ep00wire));
	okWireIn  ep01    (.okHE(okHE),                             .ep_addr(8'h01), .ep_dataout(ep01wire));
	okWireOut ep20    (.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain (ep20wire));
	okWireIn  ep00s   (.okHE(okHEs),                             .ep_addr(8'h00), .ep_dataout(ep00wire_s));
	okWireIn  ep01s   (.okHE(okHEs),                             .ep_addr(8'h01), .ep_dataout(ep01wire_s));
	okWireOut ep20s   (.okHE(okHEs), .okEH(okEHxs[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain (ep20wire_s));

	okTriggerIn  epMode  (.okHE(okHE), .ep_addr(8'h40), .ep_clk(okClk), .ep_trigger(epModeTrig));
	okTriggerIn  epInErr (.okHE(okHE), .ep_addr(8'h41), .ep_clk(okClk), .ep_trigger(ep41Trig));
	okTriggerIn  epModes  (.okHE(okHEs), .ep_addr(8'h40), .ep_clk(okClks), .ep_trigger(epModeTrig_s));
	okTriggerIn  epInErrs (.okHE(okHEs), .ep_addr(8'h41), .ep_clk(okClks), .ep_trigger(ep41Trig_s));

	okPipeIn  epPipe8b (.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'h80), .ep_dataout(epPipeIn), .ep_write(epPipeWrite));
	okPipeOut epPipea5 (.okHE(okHE), .okEH(okEHx[ 2*65 +: 65 ]), .ep_addr(8'ha0), .ep_datain(epPipeOut), .ep_read (epPipeRead ));
	okPipeIn  epPipe8bs (.okHE(okHEs), .okEH(okEHxs[ 1*65 +: 65 ]), .ep_addr(8'h80), .ep_dataout(epPipeIn_s), .ep_write(epPipeWrite_s));
	okPipeOut epPipea5s (.okHE(okHEs), .okEH(okEHxs[ 2*65 +: 65 ]), .ep_addr(8'ha0), .ep_datain(epPipeOut_s), .ep_read (epPipeRead_s ));

	okRegisterBridge regBridge (.okHE(okHE), .okEH(okEHx[ 3*65 +: 65]), .ep_write(regWrite), .ep_read(regRead),
		.ep_address(regAddress), .ep_dataout(regWriteData), .ep_datain(regReadData));

	okRegisterBridge regBridges (.okHE(okHEs), .okEH(okEHxs[ 3*65 +: 65]), .ep_write(regWrite_s), .ep_read(regRead_s),
		.ep_address(regAddress_s), .ep_dataout(regWriteData_s), .ep_datain(regReadData_s));
endmodule

module Clock_Div(
	input  wire okClk,
	output reg  clk_en
	);

	reg [31:0] clock_count = 32'h0000_00000;

	always @(posedge okClk) begin
		clock_count <= clock_count + 1'b1;
		clk_en <= ~|(clock_count & 32'h0000_00f0);
	end
	
endmodule

module pseudoRAM(
	input  wire        regWrite,
	input  wire        regRead,
	input  wire [31:0] regAddress,
	input  wire [31:0] regWriteData,
	output reg  [31:0] regReadData,
	input  wire        okClk
	);

	reg  [31:0] block_ram [1023:0];
	reg  [31:0] i;

	// Initial not synthesizable, included for easier simulation checking
	initial begin
		regReadData = 32'h0000_0000;
		for(i=0; i<1024; i=i+1'b1) begin
			block_ram[i] = 32'h0000_0000;
		end
	end

	// When write indicated by regWrite, use regAddress to write data to that address
	// When read indicated by regRead use regAddress to read data from that address
	// Limit the number of bits in the address to prevent out-of-range writes
	// At random as determined by the test fixture (using signal insertError),
	//     insert an error in the block RAM
	always @(posedge okClk) begin
		if(regWrite == 1'b1) begin
			block_ram[regAddress[9:0]] <= regWriteData;
		end else if(regRead == 1'b1) begin
			regReadData <= block_ram[regAddress[9:0]];
		end
	end

endmodule
`default_nettype wire
