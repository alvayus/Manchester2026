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

module sim(
	input  wire [7:0]  hi_in,
	output wire [1:0]  hi_out,
	inout  wire [15:0] hi_inout,
	inout  wire        hi_aa,
	
	output reg  [7:0]  led
    );
	 
	parameter MODE_LFSR = 2'b01;
	parameter MODE_COUNTER = 2'b10;
	parameter MODE_OFF = 2'b00;
	parameter MODE_CONTINUOUS = 2'b01;
	parameter MODE_PIPED = 2'b10;

	// Target interface bus
	wire ti_clk;
	wire [30:0] ok1;
	wire [16:0] ok2;
	wire [17*3-1:0] ok2s;
	 
	// Endpoint connections
	wire [15:0] ep00wire;
	wire [15:0] ep01wire;
	wire [15:0] ep02wire;
	reg  [15:0] ep20wire;

	wire [15:0] epModeTrig;

	reg  [15:0] epPipeOut;
	wire        epPipeRead;

	wire [15:0] epPipeIn;
	wire        epPipeWrite;
	
	// Design behavior buses and wires
	reg  [31:0]   lfsr;
	wire          reset;
	reg  [15:0]   ep01_ref;
	reg  [1 :0]   LFSR_MODE;
	reg  [2 :0]   REFRESH_MODE;
	wire          clk_en;
	reg  [1023:0] led_data = 1024'h0;
	reg  [15:0]   led_store = 16'h0000;
	reg  [15:0]   led_temp;
	 
	// Design
	 
	// Wires update on ti_clk.
	// Keep the design synchronous by deriving reset
	//    directly from an okWireIn endpoint
	assign reset = ep00wire[0];

	// Select mode
	always @(posedge ti_clk) begin
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
	 
	// LFSR/Counter
	always @(posedge ti_clk) begin
	 	if(reset) begin
	 		lfsr <= 32'h0000_0000;
	 		ep01_ref <= 16'h0000;
	 		epPipeOut <= 16'h0000;
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
						MODE_LFSR: 
							begin
								if (ep01wire != ep01_ref) begin
							 		lfsr[15:0] <= ep01wire;
							 		lfsr[31:16] <= ep02wire;
							 		ep01_ref <= ep01wire;
							 	end else begin
									lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1]};
								end
							end
						MODE_COUNTER:
							begin
								lfsr <= lfsr + 1'b1;
							end
						default: lfsr <= lfsr;
					endcase
				end
			MODE_PIPED:
				begin
					// When prompted, PipeOut the current lfsr value
			 		case(LFSR_MODE)
			 			MODE_LFSR:
			 				begin
			 					if (epPipeRead == 1'b1) begin
					 				epPipeOut <= lfsr[15:0];
									lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1]};
								end
							end 
						MODE_COUNTER:
							begin
								if (epPipeRead == 1'b1) begin
					 				epPipeOut <= lfsr[15:0];
									lfsr <= lfsr + 1'b1;
								end
							end
						default: lfsr <= lfsr;
			 		endcase
				end
		endcase

		ep20wire <= lfsr[15:0];
	end

	// LEDs get lower bytes of PipeIn XOR'd with upper bytes
	// When prompted, update the values used by LEDs
	always @(posedge ti_clk) begin
		if(reset) begin
			led_temp = 16'h0000;
			led_data <= 1024'h0;
		end
		led_temp = led_data[1023:1008];
		led_data = led_data << 5'b10000;
		led_data[15:0] = led_temp;
	 	if(epPipeWrite == 1'b1) begin
	 		led_data[15:0] = epPipeIn;
		end
	end

	Clock_Div slow(.ti_clk(ti_clk), .clk_en(clk_en));

	always @(posedge ti_clk) begin
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
	 
	 // Instantiate the okHost and connect endpoints
	 
	okHost okHI(
		.hi_in(hi_in),
		.hi_out(hi_out),
		.hi_inout(hi_inout),
		.hi_aa(hi_aa),
		.ti_clk(ti_clk),
		.ok1(ok1),
		.ok2(ok2)
	);
	 
	okWireOR # (.N(3)) wireOR (.ok2(ok2), .ok2s(ok2s));
	 
	okWireIn  ep00 (.ok1(ok1),                          .ep_addr(8'h00), .ep_dataout(ep00wire));
	okWireIn  ep01 (.ok1(ok1),                          .ep_addr(8'h01), .ep_dataout(ep01wire));
	okWireIn  ep02 (.ok1(ok1),                          .ep_addr(8'h02), .ep_dataout(ep02wire));
	okWireOut ep20 (.ok1(ok1), .ok2(ok2s[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain (ep20wire));

	okTriggerIn epMode (.ok1(ok1), .ep_addr(8'h40), .ep_clk(ti_clk), .ep_trigger(epModeTrig));

	okPipeIn  epPipe80 (.ok1(ok1), .ok2(ok2s[ 1*17 +: 17 ]), .ep_addr(8'h80), .ep_dataout(epPipeIn), .ep_write(epPipeWrite));
	okPipeOut epPipea0 (.ok1(ok1), .ok2(ok2s[ 2*17 +: 17 ]), .ep_addr(8'ha0), .ep_datain(epPipeOut), .ep_read (epPipeRead ));

endmodule

module Clock_Div(
	input  wire ti_clk,
	output reg  clk_en
	);

	reg [31:0] clock_count = 32'h0000_00000;

	always @(posedge ti_clk) begin
		clock_count <= clock_count + 1'b1;
		clk_en <= ~|(clock_count & 32'h0000_00f0);
	end
	
endmodule
`default_nettype wire
