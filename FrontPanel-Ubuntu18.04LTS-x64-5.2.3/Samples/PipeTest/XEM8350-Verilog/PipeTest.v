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
	output wire [2:0]   okHU,
	inout wire  [31:0]  okUHU,
	input  wire [4:0]   okUHs,
	output wire [2:0]   okHUs,
	inout  wire [31:0]  okUHUs,
	inout  wire         okAA,
	
	output wire         ok_done,

	output wire [7:0]   led
	);

localparam CAPABILITY = 16'h0001;

// Target interface bus:
wire         okClk, okClks;
wire [112:0] okHE, okHEs;
wire [64:0]  okEH, okEHs;

wire [31:0]  ep00wire, throttle_in, throttle_out, fixed_pattern;
wire [31:0]  ep00wire_s, throttle_in_s, throttle_out_s, fixed_pattern_s;
wire [31:0]  rcv_errors, rcv_errors_s;

assign led = rcv_errors[7:0];

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
                     
// Pipe In - Secondary
wire        pipe_in_write_s;
wire        pipe_in_ready_s;
wire [31:0] pipe_in_data_s;
pipe_in_check pic0s (.clk           (okClks),
                     .reset         (ep00wire_s[0]),
                     .pipe_in_write (pipe_in_write_s),
                     .pipe_in_data  (pipe_in_data_s),
                     .pipe_in_ready (pipe_in_ready_s),
                     .throttle_set  (ep00wire_s[1]),
                     .throttle_val  (throttle_in_s),
                     .fixed_pattern (fixed_pattern_s),
                     .pattern       (ep00wire_s[4:2]),
                     .error_count   (rcv_errors_s)
                     );

// Pipe Out - Secondary
wire        pipe_out_read_s;
wire        pipe_out_ready_s;
wire [31:0] pipe_out_data_s;
pipe_out_check poc0s (.clk            (okClks),
                      .reset          (ep00wire_s[0]),
                      .pipe_out_read  (pipe_out_read_s),
                      .pipe_out_data  (pipe_out_data_s),
                      .pipe_out_ready (pipe_out_ready_s),
                      .throttle_set   (ep00wire_s[1]),
                      .throttle_val   (throttle_out_s),
					  .fixed_pattern  (fixed_pattern_s),
                      .pattern        (ep00wire_s[4:2])
                      );


// Instantiate the okHost and connect endpoints.
wire [65*6-1:0]  okEHx, okEHsx;

okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE), 
	.okEH(okEH),
	.okUHs(okUHs),
	.okHUs(okHUs),
	.okUHUs(okUHUs),
	.okClks(okClks),
	.okHEs(okHEs), 
	.okEHs(okEHs),
	.ok_done(ok_done)
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

okWireOR # (.N(6)) wireORs (okEHs, okEHsx);

okWireIn     wi00s(.okHE(okHEs),                              .ep_addr(8'h00), .ep_dataout(ep00wire_s));
okWireIn     wi01s(.okHE(okHEs),                              .ep_addr(8'h01), .ep_dataout(throttle_out_s));
okWireIn     wi02s(.okHE(okHEs),                              .ep_addr(8'h02), .ep_dataout(throttle_in_s));
okWireIn     wi03s(.okHE(okHEs),                              .ep_addr(8'h03), .ep_dataout(fixed_pattern_s));
okWireOut    wo20s(.okHE(okHEs), .okEH(okEHsx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(32'h12345678));
okWireOut    wo21s(.okHE(okHEs), .okEH(okEHsx[ 1*65 +: 65 ]), .ep_addr(8'h21), .ep_datain(rcv_errors_s));
okWireOut    wo3es(.okHE(okHEs), .okEH(okEHsx[ 2*65 +: 65 ]), .ep_addr(8'h3e), .ep_datain(CAPABILITY));
okWireOut    wo3fs(.okHE(okHEs), .okEH(okEHsx[ 3*65 +: 65 ]), .ep_addr(8'h3f), .ep_datain(32'hbeeff00d));
okBTPipeIn   ep80s(.okHE(okHEs), .okEH(okEHsx[ 4*65 +: 65 ]), .ep_addr(8'h80), .ep_write(pipe_in_write_s), .ep_blockstrobe(), .ep_dataout(pipe_in_data_s), .ep_ready(pipe_in_ready));
okBTPipeOut  epA0s(.okHE(okHEs), .okEH(okEHsx[ 5*65 +: 65 ]), .ep_addr(8'ha0), .ep_read(pipe_out_read_s),  .ep_blockstrobe(), .ep_datain(pipe_out_data_s), .ep_ready(pipe_out_ready));

endmodule
`default_nettype wire
