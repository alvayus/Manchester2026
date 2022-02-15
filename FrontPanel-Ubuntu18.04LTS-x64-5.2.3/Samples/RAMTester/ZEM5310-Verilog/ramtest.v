//------------------------------------------------------------------------
// ramtest.v
//
// This sample uses the hard Altera DDR3 controller with UniPHY and HDL
// to move data from the PC to the DDR3 and vice-versa.
//
// Host Interface registers:
// WireIn 0x00
//     0 - DDR3 read enable (0=disabled, 1=enabled)
//     1 - DDR3 write enable (0=disabled, 1=enabled)
//     2 - Reset
//
// PipeIn 0x80 - DDR3 write port (U11, DDR3)
// PipeOut 0xA0 - DDR3 read port (U11, DDR3)
//
// This sample is included for reference only.  No guarantees, either
// expressed or implied, are to be drawn.
//------------------------------------------------------------------------
// tabstop 3
// Copyright (c) 2005-2016 Opal Kelly Incorporated
// $Rev$ $Date$
//------------------------------------------------------------------------
`timescale 1ns/1ps

module ramtest (
	input  wire [  4: 0]       okUH,
	output wire [  2: 0]       okHU,
	inout  wire [ 31: 0]       okUHU,
	inout  wire                okAA,

	input  wire                sys_clk_p,
	input  wire                sys_clk_n,

	output wire [  3: 0]       led,

	output wire [ 14: 0]       mem_addr,
	output wire [  2: 0]       mem_ba,
	output wire                mem_cas_n,
	output wire [  0: 0]       mem_cke,
	output wire [  0: 0]       mem_clk,
	output wire [  0: 0]       mem_clk_n,
	output wire [  0: 0]       mem_cs_n,
	output wire [  1: 0]       mem_dm,
	inout  wire [ 15: 0]       mem_dq,
	inout  wire [  1: 0]       mem_dqs,
	inout  wire [  1: 0]       mem_dqs_n,
	output wire [  0: 0]       mem_odt,
	output wire                mem_ras_n,
	output wire                mem_we_n,
	input  wire [  0: 0]       mem_rzqin,
	output wire                mem_reset_n
	);

localparam BLOCK_SIZE      = 128;   // 512 bytes / 4 byte per word;
localparam FIFO_SIZE       = 1024;  // Number of 32-bit words stored in input/output FIFOs
localparam BUFFER_HEADROOM = 20; // headroom for the FIFO count to account for latency

// Target interface bus:
wire           okClk;
wire [112:0]   okHE;
wire [64:0]    okEH;

//Wires
wire [31:0]  ep00wire;

// Pipes
wire         pipe_in_start;
wire         pipe_in_done;
wire         pipe_in_read;
wire [127:0] pipe_in_data;
wire [8:0]   pipe_in_rd_count;
wire [10:0]   pipe_in_wr_count;
wire         pipe_in_full;
wire         pipe_in_empty;
reg          pipe_in_ready;

wire         pipe_out_start;
wire         pipe_out_done;
wire         pipe_out_write;
wire [127:0] pipe_out_data;
wire [10:0]   pipe_out_rd_count;
wire [8:0]   pipe_out_wr_count;
wire         pipe_out_full;
wire         pipe_out_empty;
reg          pipe_out_ready;

// Pipe Fifos
wire        pi0_ep_write, po0_ep_read;
wire [31:0] pi0_ep_dataout, po0_ep_datain;

//DDR3 Interface
wire        phy_clk;              // 333MHz Memory PHY Clk
reg         global_reset_n;
wire        sys_clk;

wire        afi_reset_n;

wire           mem_avl_ready;
wire           mem_avl_burstbegin;
wire [24:0]    mem_avl_addr;
wire           mem_avl_rdata_valid;
wire [127:0]   mem_avl_rdata;
wire [127:0]   mem_avl_wdata;
wire [15:0]    mem_avl_be;
wire           mem_avl_read_req;
wire           mem_avl_write_req;
wire [7:0]     mem_avl_size;

wire           mem_avl_clk;
wire           mem_init_done;
wire           mem_cal_success;
wire           mem_cal_fail;

wire           mem_pll_locked;

function [3:0] zem5305_led;
input [3:0] a;
integer i;
begin
	for(i=0; i<4; i=i+1) begin: u
		zem5305_led[i] = (a[i]==1'b1) ? (1'b0) : (1'bz);
	end
end
endfunction

assign led = zem5305_led({ep00wire[0],ep00wire[1],mem_avl_ready,mem_init_done});

//Memory Interface Reset
reg [3:0] rst_cnt;
initial rst_cnt = 4'b0;
always @(posedge okClk) begin
	if(rst_cnt < 4'b1000) begin
		rst_cnt <= rst_cnt + 1;
		global_reset_n <= 1'b0;
	end
	else begin
		global_reset_n <= 1'b1;
	end
end


//Block Throttle
always @(posedge okClk) begin
	// Check for enough space in input FIFO to pipe in another block
	// The count is compared against a reduced size to account for delays in
	// FIFO count updates.
	if(pipe_in_wr_count <= (FIFO_SIZE-BUFFER_HEADROOM-BLOCK_SIZE) ) begin
		pipe_in_ready <= 1'b1;
	end else begin
		pipe_in_ready <= 1'b0;
	end

	if(pipe_out_rd_count >= BLOCK_SIZE) begin
		pipe_out_ready <= 1'b1;
	end else begin
		pipe_out_ready <= 1'b0;
	end
end

//------------------------------------------------------------------------
// Instantiate the okHost and connect endpoints.
//------------------------------------------------------------------------
wire [65*2-1:0]  okEHx;

okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE),
	.okEH(okEH)
	);

okWireOR # (.N(2)) wireOR (okEH, okEHx);
okWireIn       wi00 (.okHE(okHE),                             .ep_addr(8'h00), .ep_dataout(ep00wire));
okBTPipeIn     pi0  (.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h80), .ep_write(pi0_ep_write), .ep_blockstrobe(), .ep_dataout(pi0_ep_dataout), .ep_ready(pipe_in_ready));
okBTPipeOut    po0  (.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'ha0), .ep_read(po0_ep_read),   .ep_blockstrobe(), .ep_datain(po0_ep_datain),   .ep_ready(pipe_out_ready));

mem_pll mem_pll_inst (
	.refclk   (phy_clk),         //  refclk.clk
	.rst      (~global_reset_n), //   reset.reset
	.outclk_0 (mem_avl_clk),     // outclk0.clk
	.locked   (mem_pll_locked)   //  locked.export
	);

alt_inbuf_diff sys_clk_io(.i(sys_clk_p), .ibar(sys_clk_n), .o(sys_clk));

ddr3_interface ddr3_interface_inst (
	.pll_ref_clk                (sys_clk),             //        pll_ref_clk.clk
	.global_reset_n             (global_reset_n),      //       global_reset.reset_n
	.soft_reset_n               (1'b1),                //         soft_reset.reset_n

	.afi_clk                    (phy_clk),             //            afi_clk.clk
	.afi_half_clk               (),                    //       afi_half_clk.clk
	.afi_reset_n                (),                    //          afi_reset.reset_n
	.afi_reset_export_n         (),                    //   afi_reset_export.reset_n

	.mem_a                      (mem_addr[14 : 0]),    //             memory.mem_a
	.mem_ba                     (mem_ba[2 : 0]),       //                   .mem_ba
	.mem_ck                     (mem_clk),             //                   .mem_ck
	.mem_ck_n                   (mem_clk_n),           //                   .mem_ck_n
	.mem_cke                    (mem_cke),             //                   .mem_cke
	.mem_cs_n                   (mem_cs_n),            //                   .mem_cs_n
	.mem_dm                     (mem_dm[1 : 0]),       //                   .mem_dm
	.mem_ras_n                  (mem_ras_n),           //                   .mem_ras_n
	.mem_cas_n                  (mem_cas_n),           //                   .mem_cas_n
	.mem_we_n                   (mem_we_n),            //                   .mem_we_n
	.mem_reset_n                (mem_reset_n),         //                   .mem_reset_n
	.mem_dq                     (mem_dq),              //                   .mem_dq
	.mem_dqs                    (mem_dqs[1 : 0]),      //                   .mem_dqs
	.mem_dqs_n                  (mem_dqs_n[1 : 0]),    //                   .mem_dqs_n
	.mem_odt                    (mem_odt),             //                   .mem_odt

	.avl_ready_0                (mem_avl_ready),       //              avl_0.waitrequest_n
	.avl_burstbegin_0           (mem_avl_burstbegin),  //                   .beginbursttransfer
	.avl_addr_0                 (mem_avl_addr),        //                   .address
	.avl_rdata_valid_0          (mem_avl_rdata_valid), //                   .readdatavalid
	.avl_rdata_0                (mem_avl_rdata),       //                   .readdata
	.avl_wdata_0                (mem_avl_wdata),       //                   .writedata
	.avl_be_0                   (mem_avl_be),          //                   .byteenable
	.avl_read_req_0             (mem_avl_read_req),    //                   .read
	.avl_write_req_0            (mem_avl_write_req),   //                   .write
	.avl_size_0                 (mem_avl_size),        //                   .burstcount

	.mp_cmd_clk_0_clk           (mem_avl_clk),         //       mp_cmd_clk_0.clk
	.mp_cmd_reset_n_0_reset_n   (1'b1),                //   mp_cmd_reset_n_0.reset_n
	.mp_rfifo_clk_0_clk         (mem_avl_clk),         //     mp_rfifo_clk_0.clk
	.mp_rfifo_reset_n_0_reset_n (1'b1),                // mp_rfifo_reset_n_0.reset_n
	.mp_wfifo_clk_0_clk         (mem_avl_clk),         //     mp_wfifo_clk_0.clk
	.mp_wfifo_reset_n_0_reset_n (1'b1),                // mp_wfifo_reset_n_0.reset_n
	.mp_rfifo_clk_1_clk         (mem_avl_clk),         //     mp_rfifo_clk_1.clk
	.mp_rfifo_reset_n_1_reset_n (1'b1),                // mp_rfifo_reset_n_1.reset_n
	.mp_wfifo_clk_1_clk         (mem_avl_clk),         //     mp_wfifo_clk_1.clk
	.mp_wfifo_reset_n_1_reset_n (1'b1),                // mp_wfifo_reset_n_1.reset_n

	.local_init_done            (mem_init_done),       //             status.local_init_done
	.local_cal_success          (mem_cal_success),     //                   .local_cal_success
	.local_cal_fail             (mem_cal_fail),        //                   .local_cal_fail
	.oct_rzqin                  (mem_rzqin),           //                oct.rzqin

	.pll_mem_clk                (),                    //        pll_sharing.pll_mem_clk
	.pll_write_clk              (),                    //                   .pll_write_clk
	.pll_locked                 (),                    //                   .pll_locked
	.pll_write_clk_pre_phy_clk  (),                    //                   .pll_write_clk_pre_phy_clk
	.pll_addr_cmd_clk           (),                    //                   .pll_addr_cmd_clk
	.pll_avl_clk                (),                    //                   .pll_avl_clk
	.pll_config_clk             (),                    //                   .pll_config_clk
	.pll_mem_phy_clk            (),                    //                   .pll_mem_phy_clk
	.afi_phy_clk                (),                    //                   .afi_phy_clk
	.pll_avl_phy_clk            ()                     //                   .pll_avl_phy_clk
	);

ddr3_test ddr3_tb (
	.clk             (mem_avl_clk),
	.reset           (ep00wire[2]),
	.writes_en       (ep00wire[1]),
	.reads_en        (ep00wire[0]),
	.calib_done      (mem_init_done),

	.ib_re           (pipe_in_read),
	.ib_data         (pipe_in_data),
	.ib_count        (pipe_in_rd_count),
	.ib_empty        (pipe_in_empty),

	.ob_we           (pipe_out_write),
	.ob_data         (pipe_out_data),
	.ob_count        (pipe_out_wr_count),

	.avl_ready       (mem_avl_ready),
	.avl_burstbegin  (mem_avl_burstbegin),
	.avl_address     (mem_avl_addr),
	.avl_size        (mem_avl_size),

	.avl_read_req    (mem_avl_read_req),
	.avl_rdata_valid (mem_avl_rdata_valid),
	.avl_rdata       (mem_avl_rdata),

	.avl_write_req   (mem_avl_write_req),
	.avl_wdata       (mem_avl_wdata),
	.avl_be          (mem_avl_be)
	);

fifo_w32_1024_r128_256 okPipeIn_fifo (
	.aclr      (ep00wire[2]),
	.wrclk     (okClk),
	.rdclk     (mem_avl_clk),
	.data      (pi0_ep_dataout),     // Bus [31 : 0]
	.wrreq     (pi0_ep_write),
	.rdreq     (pipe_in_read),
	.q         (pipe_in_data),       // Bus [127 : 0]
	.wrfull    (pipe_in_full),
	.rdempty   (pipe_in_empty),
	.rdusedw   (pipe_in_rd_count),   // Bus [7 : 0]
	.wrusedw   (pipe_in_wr_count)    // Bus [9 : 0]
	);

fifo_w128_256_r32_1024 okPipeOut_fifo (
	.aclr      (ep00wire[2]),
	.wrclk     (mem_avl_clk),
	.rdclk     (okClk),
	.data      (pipe_out_data),      // Bus [127 : 0]
	.wrreq     (pipe_out_write),
	.rdreq     (po0_ep_read),
	.q         (po0_ep_datain),      // Bus [31 : 0]
	.wrfull    (pipe_out_full),
	.rdempty   (pipe_out_empty),
	.rdusedw   (pipe_out_rd_count),  // Bus [10 : 0]
	.wrusedw   (pipe_out_wr_count)   // Bus [8 : 0]
	);

endmodule
