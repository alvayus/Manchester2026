//------------------------------------------------------------------------
// FlashLoader.v
//
// This is the toplevel HDL for a simple SPI Flash programmer for the XEM8350.
// This toplevel stitches together the various modules:
//   + Host interface
//   + SPI Flash memory controller main state machine (flash_b.v)
//   + SPI Flash memory low level controller (flash_a.v)
//   + Input and output FIFO Coregens that convert data from 16 to 8 bits
//   + DCM coregen for 180 degree clock sync
//------------------------------------------------------------------------
// Copyright (c) 2004-2023 Opal Kelly Incorporated
// $Id: FlashLoader.v 2 2014-05-02 15:39:50Z janovetz $
//------------------------------------------------------------------------

`default_nettype none
`timescale 1ns / 1ps

module flashLoad (
	input  wire         okClk,
	input  wire [112:0] okHE,
	output wire [64:0]  okEH,

	// SPI Flash memory interface
	output wire        flash_c,
	output wire        flash_d,
	output wire        flash_s_n,
	input  wire        flash_q
	);

wire         clk = okClk;

wire [31:0]  ep00wire;
wire [31:0]  ep01wire;
wire [31:0]  ep02wire;
wire [31:0]  ep40trig;

wire         reset = ep02wire[0];

wire [7:0]   flash_din;
wire [7:0]   flash_dout;
wire         flash_write;
wire         flash_read;
wire         flash_done;
wire [31:0]  flash_status;

// 32bit endpoints
wire [31:0]  pipeIn_data_32;
wire [31:0]  pipeOut_data_32;


//------------------------------------------------------------------------
// FLASH CONTROLLER
//   The flash controller is command-driven from TriggerIn signals to 
//   erase, program, and read Flash contents.  It acts as a master to
//   its byte-wide read/write interfaces.
//------------------------------------------------------------------------
flash_b flash0 (
		.clk(clk),
		.reset(reset),
		.cmd_erasesectors(ep40trig[3]),
		.cmd_read(ep40trig[4]),
		.cmd_write(ep40trig[5]),
		.cmd_setqe(ep40trig[6]),
		.write(flash_write),
		.read(flash_read),
		.done(flash_done),
		.addr(ep00wire),
		.length(ep01wire),
		.din(flash_din),
		.dout(flash_dout),
		.status(flash_status),
		.flash_q(flash_q),
		.flash_d(flash_d),
		.flash_c(flash_c),
		.flash_s_n(flash_s_n));


//------------------------------------------------------------------------
// Output PipeOut and FIFO
//   This FIFO is used retrieve data from Flash
//------------------------------------------------------------------------
wire          pipeOut_read;
wire  [7:0]   fifo_rd_count;
wire          fifo_rd_empty;
fifo_w8_r32 FIFO_Out (
		.rst(reset),
		.din(flash_dout),
		.wr_clk(clk),
		.wr_en(flash_write),
		.rd_clk(okClk),
		.rd_en(pipeOut_read),
		.dout(pipeOut_data_32),
		.rd_data_count(fifo_rd_count),
		.wr_data_count(),
		.empty(fifo_rd_empty),
		.full(),
		.wr_rst_busy(),
		.rd_rst_busy());

//------------------------------------------------------------------------
// Input PipeIn and FIFO
//   This FIFO receives transfers of data for the Flash
//------------------------------------------------------------------------
wire          pipeIn_write;
fifo_w32_r8 FIFO_In (
		.rst(reset),
		.din(pipeIn_data_32),
		.wr_clk(okClk),
		.wr_en(pipeIn_write),
		.rd_clk(clk),
		.rd_en(flash_read),
		.dout(flash_din),
		.wr_data_count(),
		.rd_data_count(),
		.empty(),
		.full(),
		.wr_rst_busy(),
		.rd_rst_busy());


// Connect endpoints.
wire [65*4-1:0]  okEHx;

okWireOR # (.N(4)) wireOR (okEH, okEHx);

okWireIn     ep00 (.okHE(okHE),                             .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireIn     ep01 (.okHE(okHE),                             .ep_addr(8'h01), .ep_dataout(ep01wire));
okWireIn     ep02 (.okHE(okHE),                             .ep_addr(8'h02), .ep_dataout(ep02wire));
okTriggerIn  ep40 (.okHE(okHE),                             .ep_addr(8'h40), .ep_clk(clk), .ep_trigger(ep40trig));
okWireOut    ep20 (.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(flash_status));
okTriggerOut ep60 (.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'h60), .ep_clk(clk), .ep_trigger({31'h0, flash_done}));
okPipeIn     ep80 (.okHE(okHE), .okEH(okEHx[ 2*65 +: 65 ]), .ep_addr(8'h80), .ep_write(pipeIn_write),
                   .ep_dataout({pipeIn_data_32[7:0], pipeIn_data_32[15:8], pipeIn_data_32[23:16], pipeIn_data_32[31:24]}));
okPipeOut    epA0 (.okHE(okHE), .okEH(okEHx[ 3*65 +: 65 ]), .ep_addr(8'ha0), .ep_read(pipeOut_read),
                   .ep_datain({pipeOut_data_32[7:0], pipeOut_data_32[15:8], pipeOut_data_32[23:16], pipeOut_data_32[31:24]}));

endmodule
`default_nettype wire
