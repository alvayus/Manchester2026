//------------------------------------------------------------------------
// pipe_out_check.v
//
// Generates pseudorandom data for Pipe Out verifications.
//
// Copyright (c) 2005-2010  Opal Kelly Incorporated
// $Rev$ $Date$
//------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none

module pipe_out_check(
	input  wire            clk,
	input  wire            reset,
	input  wire            pipe_out_read,
	output wire [15:0]     pipe_out_data,
	output reg             pipe_out_ready,
	input  wire            throttle_set,
	input  wire [31:0]     throttle_val,
	input  wire            mode                // 0=Count, 1=LFSR
	);


reg  [63:0]  lfsr;
reg  [15:0]  lfsr_p1;
reg  [31:0]  throttle;
reg  [15:0]  level;

assign pipe_out_data = lfsr_p1;

//------------------------------------------------------------------------
// LFSR mode signals
//
// 32-bit: x^32 + x^22 + x^2 + 1
// lfsr_out_reg[0] <= r[31] ^ r[21] ^ r[1]
//------------------------------------------------------------------------
reg [31:0] temp;
always @(posedge clk) begin
	if (reset == 1'b1) begin
		throttle <= throttle_val;
		pipe_out_ready <= 1'b0;
		level <= 16'd0;

		if (mode == 1'b1) begin
			lfsr  <= 64'h0D0C0B0A04030201;
		end else begin
			lfsr  <= 64'h0000000100000001;
		end
	end else begin
		lfsr_p1 <= lfsr[15:0];
		
		if (level >= 16'd1024) begin
			pipe_out_ready <= 1'b1;
		end else begin
			pipe_out_ready <= 1'b0;
		end
	
		// Update our virtual FIFO level.
		case ({pipe_out_read, throttle[0]})
			2'b00: begin
			end
			
			// Write : Increase the FIFO level
			2'b01: begin
				if (level < 16'd65535) begin
					level <= level + 1'b1;
				end
			end
			
			// Read : Decrease the FIFO level
			2'b10: begin
				if (level > 16'd0) begin
					level <= level - 1'b1;
				end
			end
			
			// Read/Write : No net change
			2'b11: begin
			end
		endcase
	
		// The throttle is a circular register.
		// 1 enabled read or write this cycle.
		// 0 disables read or write this cycle.
		// So a single bit (0x00000001) would lead to 1/32 data rate.
		// Similarly 0xAAAAAAAA would lead to 1/2 data rate.
		if (throttle_set == 1'b1) begin
			throttle <= throttle_val;
		end else begin
			throttle <= {throttle[0], throttle[31:1]};
		end
		
		// Cycle the LFSR
		if (pipe_out_read == 1'b1) begin
			if (mode == 1'b1) begin
				temp = lfsr[31:0];
				lfsr[31:0]  <= {temp[30:0], temp[31] ^ temp[21] ^ temp[1]};
				temp = lfsr[63:32];
				lfsr[63:32] <= {temp[30:0], temp[31] ^ temp[21] ^ temp[1]};
			end else begin
				lfsr[31:0]  <= lfsr[31:0]  + 1'b1;
				lfsr[63:32] <= lfsr[63:32] + 1'b1;
			end
		end
	end
end

endmodule
