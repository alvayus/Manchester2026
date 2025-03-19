//------------------------------------------------------------------------
// ramtest.v
//
// This sample uses the Xilinx MIG DDR3 controller and HDL to move data
// from the PC to the DDR3 and vice-versa.
//
// Host Interface registers:
// WireIn 0x00
//     0 - DDR2 read enable (0=disabled, 1=enabled)
//     1 - DDR2 write enable (0=disabled, 1=enabled)
//     2 - Reset
//
// PipeIn 0x80 - DDR2 write port (U11, DDR2)
// PipeOut 0xA0 - DDR2 read port (U11, DDR2)
//
// This sample is included for reference only.  No guarantees, either 
// expressed or implied, are to be drawn.
//------------------------------------------------------------------------
// tabstop 3
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
// $Rev: 10 $ $Date: 2014-05-03 14:30:14 -0700 (Sat, 03 May 2014) $
//------------------------------------------------------------------------
`timescale 1ns/1ps
`default_nettype none

module ramtest(	
	input  wire [4:0]   okUH,
	output wire [2:0]   okHU,
	inout  wire [31:0]  okUHU,
	inout  wire         okAA,

	input  wire         sys_clk_p,
	input  wire         sys_clk_n,
	
	output wire [3:0]   led,
	
	inout  wire [15:0]  ddr3_dq,
	output wire [14:0]  ddr3_addr,
	output wire [ 2:0]  ddr3_ba,
	output wire [ 0:0]  ddr3_ck_p,
	output wire [ 0:0]  ddr3_ck_n,
	output wire [ 0:0]  ddr3_cke,
	output wire [ 0:0]  ddr3_cs_n,
	output wire         ddr3_cas_n,
	output wire         ddr3_ras_n,
	output wire         ddr3_we_n,
	output wire [ 0:0]  ddr3_odt,
	output wire [ 1:0]  ddr3_dm,
	inout  wire [ 1:0]  ddr3_dqs_p,
	inout  wire [ 1:0]  ddr3_dqs_n,
	output wire         ddr3_reset_n
	);


    //OK RamTest Parameters
	localparam BLOCK_SIZE      = 128;  // 512 bytes / 4 byte per word;
	localparam FIFO_SIZE       = 1023; // note that Xilinx does not allow use of the full 1024 words
	localparam BUFFER_HEADROOM = 20; // headroom for the FIFO count to account for latency

	// Capability bitfield, used to indicate features supported by this bitfile:
	// [0] - Supports passing calibration status through FrontPanel
	localparam CAPABILITY = 16'h0001;
	

/////////////////////////////////////////////////////////////////
//UI signals.
////////////////////////////////////////////////////////////////

    // MIG signals
    wire           app_rdy;
    wire           app_en;
    wire [2:0]     app_cmd;
    wire [27:0]    app_addr;
    wire [127:0]   app_rd_data;
    wire           app_rd_data_end;
    wire           app_rd_data_valid;
    wire           app_wdf_rdy;
    wire           app_wdf_wren;
    wire [127:0]   app_wdf_data;
    wire           app_wdf_end;
    wire [15:0]    app_wdf_mask;

	wire           init_calib_complete;
	reg            sys_rst;
    
    wire            clk;
    wire            rst;

	// Front Panel

	// Target interface bus:
	wire         okClk;
	wire [112:0] okHE;
	wire [64:0]  okEH;
	
	wire [31:0]  ep00wire;
	
	wire                            pipe_in_read;
	wire [127:0]                    pipe_in_data;
	wire [7:0]                      pipe_in_rd_count;
	(* KEEP = "TRUE" *)wire [9:0]   pipe_in_wr_count;
	wire                            pipe_in_valid;
	(* KEEP = "TRUE" *)wire         pipe_in_full;
	wire                            pipe_in_empty;
	(* KEEP = "TRUE" *)reg          pipe_in_ready;
	
	wire                            pipe_out_write;
	wire [127:0]                    pipe_out_data;
	(* KEEP = "TRUE" *)wire [9:0]   pipe_out_rd_count;
	wire [7:0]                      pipe_out_wr_count;
	wire                            pipe_out_full;
	(* KEEP = "TRUE" *)wire         pipe_out_empty;
	(* KEEP = "TRUE" *)reg          pipe_out_ready;
	
	// Pipe Fifos
	(* KEEP = "TRUE" *)wire        pi0_ep_write;
	(* KEEP = "TRUE" *)wire        po0_ep_read;
	(* KEEP = "TRUE" *)wire [31:0] pi0_ep_dataout;
	(* KEEP = "TRUE" *)wire [31:0] po0_ep_datain;

	assign led = ~{ep00wire[0], app_wdf_rdy, ep00wire[1], init_calib_complete};
	
	//MIG Infrastructure Reset
	reg [31:0] rst_cnt;
	initial rst_cnt = 32'b0;
	always @(posedge okClk) begin
		if(rst_cnt < 32'h0400_0000) begin // minimum 5 ns reset pulse (UG586)
			rst_cnt <= rst_cnt + 1;		  // 1 okClk cycle is 9.92 ns
			sys_rst <= 1'b1;			  // longer reset used for reliablility
		end								  // reasons for older XEM7350 boards (Exx and earlier)
		else begin
			sys_rst <= 1'b0;
		end
	end


// MIG User Interface instantiation
// Signal widths will vary depending on the device
ddr3_interface u_ddr3_interface (
	// Memory interface ports
	.ddr3_addr                      (ddr3_addr),  // output [14:0]		ddr3_addr
	.ddr3_ba                        (ddr3_ba),  // output [2:0]		ddr3_ba
	.ddr3_cas_n                     (ddr3_cas_n),  // output			ddr3_cas_n
	.ddr3_ck_n                      (ddr3_ck_n),  // output [0:0]		ddr3_ck_n
	.ddr3_ck_p                      (ddr3_ck_p),  // output [0:0]		ddr3_ck_p
	.ddr3_cke                       (ddr3_cke),  // output [0:0]		ddr3_cke
	.ddr3_ras_n                     (ddr3_ras_n),  // output			ddr3_ras_n
	.ddr3_reset_n                   (ddr3_reset_n),  // output			ddr3_reset_n
	.ddr3_we_n                      (ddr3_we_n),  // output			ddr3_we_n
	.ddr3_dq                        (ddr3_dq),  // inout [15:0]		ddr3_dq
	.ddr3_dqs_n                     (ddr3_dqs_n),  // inout [1:0]		ddr3_dqs_n
	.ddr3_dqs_p                     (ddr3_dqs_p),  // inout [1:0]		ddr3_dqs_p
	.init_calib_complete            (init_calib_complete),  // output			init_calib_complete

	.ddr3_cs_n                      (ddr3_cs_n),  // output [0:0]		ddr3_cs_n
	.ddr3_dm                        (ddr3_dm),  // output [1:0]		ddr3_dm
	.ddr3_odt                       (ddr3_odt),  // output [0:0]		ddr3_odt
	// Application interface ports
	.app_addr                       (app_addr),  // input [28:0]		app_addr
	.app_cmd                        (app_cmd),  // input [2:0]		app_cmd
	.app_en                         (app_en),  // input				app_en
	.app_wdf_data                   (app_wdf_data),  // input [127:0]		app_wdf_data
	.app_wdf_end                    (app_wdf_end),  // input				app_wdf_end
	.app_wdf_wren                   (app_wdf_wren),  // input				app_wdf_wren
	.app_rd_data                    (app_rd_data),  // output [127:0]		app_rd_data
	.app_rd_data_end                (app_rd_data_end),  // output			app_rd_data_end
	.app_rd_data_valid              (app_rd_data_valid),  // output			app_rd_data_valid
	.app_rdy                        (app_rdy),  // output			app_rdy
	.app_wdf_rdy                    (app_wdf_rdy),  // output			app_wdf_rdy
	.app_sr_req                     (1'b0),  // input			app_sr_req
	.app_ref_req                    (1'b0),  // input			app_ref_req
	.app_zq_req                     (1'b0),  // input			app_zq_req
	.app_sr_active                  (),  // output			app_sr_active
	.app_ref_ack                    (),  // output			app_ref_ack
	.app_zq_ack                     (),  // output			app_zq_ack
	.ui_clk                         (clk),  // output			ui_clk
	.ui_clk_sync_rst                (rst),  // output			ui_clk_sync_rst
	.app_wdf_mask                   (app_wdf_mask),  // input [15:0]		app_wdf_mask
	// System Clock Ports
	.sys_clk_p                       (sys_clk_p),  // input				sys_clk_p
	.sys_clk_n                       (sys_clk_n),  // input				sys_clk_n
	.sys_rst                        (sys_rst) // input sys_rst
	);

// OK MIG DDR3 Testbench Instatiation 
ddr3_test ddr3_tb (
	.clk                (clk),
	.reset              (ep00wire[2] | rst), 
	.reads_en           (ep00wire[0]),
	.writes_en          (ep00wire[1]),
	.calib_done         (init_calib_complete), 

	.ib_re              (pipe_in_read),
	.ib_data            (pipe_in_data),
	.ib_count           (pipe_in_rd_count),
	.ib_valid           (pipe_in_valid),
	.ib_empty           (pipe_in_empty),
	
	.ob_we              (pipe_out_write),
	.ob_data            (pipe_out_data),
	.ob_count           (pipe_out_wr_count),
	.ob_full            (pipe_out_full),
	
	.app_rdy            (app_rdy),
	.app_en             (app_en),
	.app_cmd            (app_cmd),
	.app_addr           (app_addr),
	
	.app_rd_data        (app_rd_data),
	.app_rd_data_end    (app_rd_data_end),
	.app_rd_data_valid  (app_rd_data_valid),
	
	.app_wdf_rdy        (app_wdf_rdy),
	.app_wdf_wren       (app_wdf_wren),
	.app_wdf_data       (app_wdf_data),
	.app_wdf_end        (app_wdf_end),
	.app_wdf_mask       (app_wdf_mask)
);
  
   // End of IBUF_inst instantiation
	
//Block Throttle
always @(posedge okClk) begin
	// Check for enough space in input FIFO to pipe in another block
	// The count is compared against a reduced size to account for delays in
	// FIFO count updates.
	if(pipe_in_wr_count <= (FIFO_SIZE-BUFFER_HEADROOM-BLOCK_SIZE) ) begin
	  pipe_in_ready <= 1'b1;
	end
	else begin
		pipe_in_ready <= 1'b0;
	end
	
	if(pipe_out_rd_count >= BLOCK_SIZE) begin
	  pipe_out_ready <= 1'b1;
	end
	else begin
		pipe_out_ready <= 1'b0;
	end
	
end
	

// Instantiate the okHost and connect endpoints.
wire [65*4-1:0]  okEHx;

okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE), 
	.okEH(okEH)
);

okWireOR # (.N(4)) wireOR (okEH, okEHx);
okWireIn       wi00 (.okHE(okHE),                             .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireOut      wo00 (.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain({31'h00, init_calib_complete}));
okWireOut      wo01 (.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'h3e), .ep_datain(CAPABILITY));
okBTPipeIn     pi0  (.okHE(okHE), .okEH(okEHx[ 2*65 +: 65 ]), .ep_addr(8'h80), .ep_write(pi0_ep_write), .ep_blockstrobe(), .ep_dataout(pi0_ep_dataout), .ep_ready(pipe_in_ready));
okBTPipeOut    po0  (.okHE(okHE), .okEH(okEHx[ 3*65 +: 65 ]), .ep_addr(8'ha0), .ep_read(po0_ep_read),   .ep_blockstrobe(), .ep_datain(po0_ep_datain),   .ep_ready(pipe_out_ready));

fifo_w32_1024_r128_256 okPipeIn_fifo (
	.rst(ep00wire[2]),
	.wr_clk(okClk),
	.rd_clk(clk),
	.din(pi0_ep_dataout), // Bus [31 : 0] 
	.wr_en(pi0_ep_write),
	.rd_en(pipe_in_read),
	.dout(pipe_in_data), // Bus [127 : 0] 
	.full(pipe_in_full),
	.empty(pipe_in_empty),
	.valid(pipe_in_valid),
	.rd_data_count(pipe_in_rd_count), // Bus [7 : 0] 
	.wr_data_count(pipe_in_wr_count)); // Bus [9 : 0] 

fifo_w128_256_r32_1024 okPipeOut_fifo (
	.rst(ep00wire[2]),
	.wr_clk(clk),
	.rd_clk(okClk),
	.din(pipe_out_data), // Bus [127 : 0] 
	.wr_en(pipe_out_write),
	.rd_en(po0_ep_read),
	.dout(po0_ep_datain), // Bus [31 : 0] 
	.full(pipe_out_full),
	.empty(pipe_out_empty),
	.valid(),
	.rd_data_count(pipe_out_rd_count), // Bus [9 : 0] 
	.wr_data_count(pipe_out_wr_count)); // Bus [7 : 0] 

endmodule
`default_nettype wire
