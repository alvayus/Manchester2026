//------------------------------------------------------------------------
// ramtest.v
//
// This sample uses the Altera HPC DDR2 controller and HDL to move data
// from the PC to the DDR2 and vice-versa.
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
// Copyright (c) 2005-2009 Opal Kelly Incorporated
// $Rev$ $Date$
//------------------------------------------------------------------------
`timescale 1ns/1ps

module ramtest (
	input  wire [4:0]          okUH,
	output wire [2:0]          okHU,
	inout  wire [31:0]         okUHU,
	inout  wire                okAA,
	
	input  wire                sys_clk,
	
	output wire [1:0]          led,
	
	output wire [ 12: 0]       mem_addr,
	output wire [  2: 0]       mem_ba,
	output wire                mem_cas_n,
	output wire [  0: 0]       mem_cke,
	inout  wire [  0: 0]       mem_clk,
	inout  wire [  0: 0]       mem_clk_n,
	output wire [  0: 0]       mem_cs_n,
	output wire [  1: 0]       mem_dm,
	inout  wire [ 15: 0]       mem_dq,
	inout  wire [  1: 0]       mem_dqs,
	output wire [  0: 0]       mem_odt,
	output wire                mem_ras_n,
	output wire                mem_we_n
);

localparam BLOCK_SIZE      = 128;   // 512 bytes / 4 byte per word;
localparam FIFO_SIZE       = 1024;
localparam BUFFER_HEADROOM = 20; // headroom for the FIFO count to account for latency

// Target interface bus:
wire           okClk;
wire [112:0]   okHE;
wire [64:0]    okEH;

//Wires
wire [31:0]  ep00wire;

// Pipes
wire        pipe_in_start;
wire        pipe_in_done;
wire        pipe_in_read;
wire [31:0] pipe_in_data;
wire [9:0]  pipe_in_rd_count;
wire [9:0]  pipe_in_wr_count;
wire        pipe_in_full;
wire        pipe_in_empty;
reg         pipe_in_ready;

wire        pipe_out_start;
wire        pipe_out_done;
wire        pipe_out_write;
wire [31:0] pipe_out_data;
wire [10:0] pipe_out_rd_count;
wire [10:0] pipe_out_wr_count;
wire        pipe_out_full;
wire        pipe_out_empty;
reg         pipe_out_ready;

// Pipe Fifos
wire        pi0_ep_write, po0_ep_read;
wire [31:0] pi0_ep_dataout, po0_ep_datain;

//HPC DDR2 Interface
wire        phy_clk;               // 150MHz Local Interface clk
reg         global_reset_n;

wire        reset_phy_clk_n;       // Unused for now
wire        mem_aux_full_rate_clk; // Unused for now
wire        mem_aux_half_rate_clk; // Unused for now

wire        local_burstbegin;
wire        local_init_done;
wire        local_pll_locked;

wire [24:0] mem_local_addr;
wire [ 3:0] mem_local_be;
wire [ 9:0] mem_local_col_addr;
wire        mem_local_cs_addr;
wire [31:0] mem_local_rdata;
wire        mem_local_rdata_valid;
wire        mem_local_read_req;
wire        mem_local_ready;
wire [ 2:0] mem_local_size;
wire [31:0] mem_local_wdata;
wire        mem_local_write_req;

assign led = ~{ep00wire[1],local_init_done};

//MIG Infrastructure Reset
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


ddr2_test ddr2_tb
	(
	.clk                      (phy_clk),
	.reset                    (ep00wire[2] | ~reset_phy_clk_n), 
	.reads_en                 (ep00wire[0]),
	.writes_en                (ep00wire[1]),
	.calib_done               (local_init_done), 

	.ib_re                    (pipe_in_read),
	.ib_data                  (pipe_in_data),
	.ib_count                 (pipe_in_rd_count),
	.ib_empty                 (pipe_in_empty),
	
	.ob_we                    (pipe_out_write),
	.ob_data                  (pipe_out_data),
	.ob_count                 (pipe_out_wr_count),
	
	.local_burstbegin         (local_burstbegin),
	.local_address            (mem_local_addr),
	.local_be                 (mem_local_be),
	.local_rdata              (mem_local_rdata),
	.local_rdata_valid        (mem_local_rdata_valid),
	.local_read_req           (mem_local_read_req),
	.local_ready              (mem_local_ready),
	.local_size               (mem_local_size),
	.local_wdata              (mem_local_wdata),
	.local_write_req          (mem_local_write_req)
	);
	
ddr2_interface ddr2_interface_inst (
	.aux_full_rate_clk        (mem_aux_full_rate_clk),
	.aux_half_rate_clk        (mem_aux_half_rate_clk),
	.global_reset_n           (global_reset_n),
	
	.local_init_done          (local_init_done),
	.local_burstbegin         (local_burstbegin),
	
	.local_address            (mem_local_addr),
	.local_be                 (mem_local_be),
	.local_rdata              (mem_local_rdata),
	.local_rdata_valid        (mem_local_rdata_valid),
	.local_read_req           (mem_local_read_req),
	.local_ready              (mem_local_ready),
	.local_size               (mem_local_size),
	.local_wdata              (mem_local_wdata),
	.local_write_req          (mem_local_write_req),
	
	.mem_addr                 (mem_addr[12 : 0]),
	.mem_ba                   (mem_ba),
	.mem_cas_n                (mem_cas_n),
	.mem_cke                  (mem_cke),
	.mem_clk                  (mem_clk),
	.mem_clk_n                (mem_clk_n),
	.mem_cs_n                 (mem_cs_n),
	.mem_dm                   (mem_dm[1 : 0]),
	.mem_dq                   (mem_dq),
	.mem_dqs                  (mem_dqs[1 : 0]),
	.mem_odt                  (mem_odt),
	.mem_ras_n                (mem_ras_n),
	.mem_we_n                 (mem_we_n),
	
	.phy_clk                  (phy_clk),
	.pll_ref_clk              (sys_clk),
	.reset_phy_clk_n          (reset_phy_clk_n),
	.reset_request_n          (local_pll_locked),
	.soft_reset_n             (1'b1)
);
	
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

fifo_w32_1024_r32_1024 okPipeIn_fifo (
	.aclr      (ep00wire[2]),
	.wrclk     (okClk),
	.rdclk     (phy_clk),
	.data      (pi0_ep_dataout),     // Bus [31 : 0] 
	.wrreq     (pi0_ep_write),
	.rdreq     (pipe_in_read),
	.q         (pipe_in_data),       // Bus [31 : 0] 
	.wrfull    (pipe_in_full),
	.rdempty   (pipe_in_empty),
	.rdusedw   (pipe_in_rd_count),   // Bus [9 : 0] 
	.wrusedw   (pipe_in_wr_count));  // Bus [9 : 0] 

fifo_w32_1024_r32_1024 okPipeOut_fifo (
	.aclr      (ep00wire[2]),
	.wrclk     (phy_clk),
	.rdclk     (okClk),
	.data      (pipe_out_data),      // Bus [31 : 0] 
	.wrreq     (pipe_out_write),
	.rdreq     (po0_ep_read),
	.q         (po0_ep_datain),      // Bus [31 : 0] 
	.wrfull    (pipe_out_full),
	.rdempty   (pipe_out_empty),
	.rdusedw   (pipe_out_rd_count),  // Bus [9 : 0] 
	.wrusedw   (pipe_out_wr_count)); // Bus [9 : 0] 

endmodule
