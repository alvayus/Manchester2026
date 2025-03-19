//------------------------------------------------------------------------
// pipe_out_check.v
//
// Generates pseudorandom data for Pipe Out verifications.
//
// Copyright (c) 2005-2023  Opal Kelly Incorporated
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
`timescale 1ns / 1ps
`default_nettype none

module pipe_out_check(
	input  wire            clk,
	input  wire            reset,
	input  wire            pipe_out_read,
	output reg  [31:0]     pipe_out_data,
	output reg             pipe_out_ready,
	input  wire            throttle_set,
	input  wire [31:0]     throttle_val,
	input  wire [31:0]     fixed_pattern,
	input  wire [2:0]      pattern
	);


reg  [63:0]  lfsr;
reg  [31:0]  lfsr_p1;
reg  [31:0]  throttle;
reg  [15:0]  level;
wire [31:0]  pg_dout;


pattern_gen #(
		.WIDTH    (32)
	) pg0 (
		.clk           (clk),
		.reset         (reset),
		.enable        (pipe_out_read),
		.mode          (pattern),
		.fixed_pattern (fixed_pattern),
		.dout          (pg_dout)
	);


always @(posedge clk) begin
	if (reset == 1'b1) begin
		throttle       <= throttle_val;
		pipe_out_ready <= 1'b0;
		level          <= 16'd0;
	end else begin
		if (pipe_out_read) begin
			pipe_out_data <= pg_dout;
		end

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
	end
end

endmodule
`default_nettype wire
