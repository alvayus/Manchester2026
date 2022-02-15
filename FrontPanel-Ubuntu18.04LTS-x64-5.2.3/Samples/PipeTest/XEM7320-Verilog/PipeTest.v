// PipeTest.v
//
// This is simple HDL that implements barebones PipeIn and PipeOut 
// functionality.  The logic generates and compares againt a pseudorandom 
// sequence of data as a way to verify transfer integrity and benchmark the pipe 
// transfer speeds.
//
// Copyright (c) 2005-2011  Opal Kelly Incorporated
// $Rev$ $Date$
//------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none

module PipeTest(
	input  wire [4:0]   okUH,
	output wire [3:0]   okHU,
	input  wire [3:0]   okRSVD,
	inout wire  [31:0]  okUHU,
	inout  wire         okAA,

	output wire [7:0]   led
	);

// Capability bitfield, used to indicate features supported by this bitfile
// [0] - Fixed pattern feature
localparam CAPABILITY = 16'h0001;

// Target interface bus:
wire         okClk;
wire [112:0] okHE;
wire [64:0]  okEH;

wire [31:0]  ep00wire, throttle_in, throttle_out, fixed_pattern;
wire [31:0]  rcv_errors;


function [7:0] xem7320_led;
input [7:0] a;
integer i;
begin
	for(i=0; i<8; i=i+1) begin: u
		xem7320_led[i] = (a[i]==1'b1) ? (1'b0) : (1'bz);
	end
end
endfunction

assign led = xem7320_led({fixed_pattern[3:0], rcv_errors[3:0]});

// Pipe In
wire        pipe_in_write;
wire        pipe_in_ready;
wire [31:0] pipe_in_data;
pipe_in_check pic0 (.clk           (okClk),
                    .reset         (ep00wire[0]),
                    .pipe_in_write (pipe_in_write),
                    .pipe_in_data  (pipe_in_data),
                    .pipe_in_ready (pipe_in_ready),
                    .throttle_set  (ep00wire[1]),
                    .throttle_val  (throttle_in),
                    .fixed_pattern (fixed_pattern),
                    .pattern       (ep00wire[4:2]),
                    .error_count   (rcv_errors)
                    );

// Pipe Out
wire        pipe_out_read;
wire        pipe_out_ready;
wire [31:0] pipe_out_data;
pipe_out_check poc0 (.clk            (okClk),
                     .reset          (ep00wire[0]),
                     .pipe_out_read  (pipe_out_read),
                     .pipe_out_data  (pipe_out_data),
                     .pipe_out_ready (pipe_out_ready),
                     .throttle_set   (ep00wire[1]),
                     .throttle_val   (throttle_out),
                     .fixed_pattern  (fixed_pattern),
                     .pattern        (ep00wire[4:2])
                     );

// Instantiate the okHost and connect endpoints.
wire [65*6-1:0]  okEHx;

okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okRSVD(okRSVD),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE), 
	.okEH(okEH)
);

okWireOR # (.N(6)) wireOR (okEH, okEHx);

okWireIn     wi00(.okHE(okHE),                             .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireIn     wi01(.okHE(okHE),                             .ep_addr(8'h01), .ep_dataout(throttle_out));
okWireIn     wi02(.okHE(okHE),                             .ep_addr(8'h02), .ep_dataout(throttle_in));
okWireIn     wi03(.okHE(okHE),                             .ep_addr(8'h03), .ep_dataout(fixed_pattern));
okWireOut    wo20(.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(32'h12345678));
okWireOut    wo21(.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'h21), .ep_datain(rcv_errors));
okWireOut    wo3e(.okHE(okHE), .okEH(okEHx[ 2*65 +: 65 ]), .ep_addr(8'h3e), .ep_datain(CAPABILITY));
okWireOut    wo3f(.okHE(okHE), .okEH(okEHx[ 3*65 +: 65 ]), .ep_addr(8'h3f), .ep_datain(32'hbeeff00d));
okBTPipeIn   ep80(.okHE(okHE), .okEH(okEHx[ 4*65 +: 65 ]), .ep_addr(8'h80), .ep_write(pipe_in_write), .ep_blockstrobe(), .ep_dataout(pipe_in_data), .ep_ready(pipe_in_ready));
okBTPipeOut  epA0(.okHE(okHE), .okEH(okEHx[ 5*65 +: 65 ]), .ep_addr(8'ha0), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(pipe_out_data), .ep_ready(pipe_out_ready));

endmodule
`default_nettype wire
