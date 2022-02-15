//------------------------------------------------------------------------
// ramtest.v
//
// This sample uses the Xilinx MIG DDR3 controller and HDL to move data
// from the PC to the DDR4 and vice-versa. Based on MIG generated example_top.v
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

module ramtest
	(

	input  wire [7:0]    hi_in,
	output wire [1:0]    hi_out,
	inout  wire [15:0]   hi_inout,
	inout  wire          hi_aa,
	output wire          hi_muxsel,
	
	output wire [7:0]    led,
	
	input  wire          sys_clk_p,
	input  wire          sys_clk_n,

	inout  wire [16-1:0] ddr3_dq,
	output wire [15-1:0] ddr3_addr,
	output wire [3-1:0]  ddr3_ba,
	output wire          ddr3_ras_n,
	output wire          ddr3_cas_n,
	output wire          ddr3_we_n,
	output wire          ddr3_odt,
	output wire          ddr3_cke,
	output wire [2-1:0]  ddr3_dm,
	inout  wire [2-1:0]  ddr3_dqs_p,
	inout  wire [2-1:0]  ddr3_dqs_n,
	output wire          ddr3_ck_p,
	output wire          ddr3_ck_n,
	output wire          ddr3_reset_n
	);
	
	// Capability bitfield, used to indicate features supported by this bitfile:
	// [0] - Supports passing calibration status through FrontPanel
	localparam CAPABILITY = 16'h0001;

	wire          init_calib_complete;
    reg           sys_rst;
    
    wire [28 :0]  app_addr;
    wire [2  :0]  app_cmd;
    wire          app_en;
    wire          app_rdy;
    wire [127:0]  app_rd_data;
    wire          app_rd_data_end;
    wire          app_rd_data_valid;
    wire [127:0]  app_wdf_data;
    wire          app_wdf_end;
    wire [15 :0]  app_wdf_mask;
    wire          app_wdf_rdy;
    wire          app_wdf_wren;
    
    wire          clk;
    wire          rst;
	
	// Front Panel

	// USB Host Interface
	wire        ti_clk;
	wire [30:0] ok1;
	wire [16:0] ok2;
	wire [15:0]  ep00wire;
	
	wire        pipe_in_start;
	wire        pipe_in_done;
	wire        pipe_in_read;
	wire [127:0] pipe_in_data;
	wire [8:0]  pipe_in_rd_count;
	wire        pipe_in_valid;
	wire        pipe_in_empty;
	wire        pipe_in_full;
	
	wire        pipe_out_start;
	wire        pipe_out_done;
	wire        pipe_out_write;
	wire [127:0] pipe_out_data;
	wire [8:0]  pipe_out_wr_count;
	wire        pipe_out_full;
	wire        pipe_out_empty;
	
	// Pipe Fifos
	wire        pi0_ep_write, po0_ep_read;
	wire [15:0] pi0_ep_dataout, po0_ep_datain;

    function [7:0] xem7010_led;
    input [7:0] a;
    integer i;
    begin
        for(i=0; i<8; i=i+1) begin: u
            xem7010_led[i] = (a[i]==1'b1) ? (1'b0) : (1'bz);
        end
    end
    endfunction
    
    assign led = xem7010_led({pipe_out_full,pipe_in_full,pipe_out_empty,pipe_in_empty,ep00wire[0],ep00wire[1],app_wdf_rdy,init_calib_complete});
	
	assign hi_muxsel  = 1'b0;
	
	//MIG Infrastructure Reset
	reg [31:0] rst_cnt;
	initial rst_cnt = 32'b0;
	always @(posedge ti_clk) begin
		if(rst_cnt < 32'h0400_0000) begin
			rst_cnt <= rst_cnt + 1;
			sys_rst <= 1'b1;
		end else begin
			sys_rst <= 1'b0;
		end
	end
	
ddr3_256_16 u_ddr3_256_16 (

    // Memory interface ports
    .ddr3_addr                      (ddr3_addr),  // output [14:0]        ddr3_addr
    .ddr3_ba                        (ddr3_ba),  // output [2:0]        ddr3_ba
    .ddr3_cas_n                     (ddr3_cas_n),  // output            ddr3_cas_n
    .ddr3_ck_n                      (ddr3_ck_n),  // output [0:0]        ddr3_ck_n
    .ddr3_ck_p                      (ddr3_ck_p),  // output [0:0]        ddr3_ck_p
    .ddr3_cke                       (ddr3_cke),  // output [0:0]        ddr3_cke
    .ddr3_ras_n                     (ddr3_ras_n),  // output            ddr3_ras_n
    .ddr3_reset_n                   (ddr3_reset_n),  // output            ddr3_reset_n
    .ddr3_we_n                      (ddr3_we_n),  // output            ddr3_we_n
    .ddr3_dq                        (ddr3_dq),  // inout [15:0]        ddr3_dq
    .ddr3_dqs_n                     (ddr3_dqs_n),  // inout [1:0]        ddr3_dqs_n
    .ddr3_dqs_p                     (ddr3_dqs_p),  // inout [1:0]        ddr3_dqs_p
    .init_calib_complete            (init_calib_complete),  // output            init_calib_complete
     
    .ddr3_dm                        (ddr3_dm),  // output [1:0]        ddr3_dm
    .ddr3_odt                       (ddr3_odt),  // output [0:0]        ddr3_odt
    // Application interface ports
    .app_addr                       (app_addr),  // input [28:0]        app_addr
    .app_cmd                        (app_cmd),  // input [2:0]        app_cmd
    .app_en                         (app_en),  // input                app_en
    .app_wdf_data                   (app_wdf_data),  // input [127:0]        app_wdf_data
    .app_wdf_end                    (app_wdf_end),  // input                app_wdf_end
    .app_wdf_wren                   (app_wdf_wren),  // input                app_wdf_wren
    .app_rd_data                    (app_rd_data),  // output [127:0]        app_rd_data
    .app_rd_data_end                (app_rd_data_end),  // output            app_rd_data_end
    .app_rd_data_valid              (app_rd_data_valid),  // output            app_rd_data_valid
    .app_rdy                        (app_rdy),  // output            app_rdy
    .app_wdf_rdy                    (app_wdf_rdy),  // output            app_wdf_rdy
    .app_sr_req                     (1'b0),  // input            app_sr_req
    .app_ref_req                    (1'b0),  // input            app_ref_req
    .app_zq_req                     (1'b0),  // input            app_zq_req
    .app_sr_active                  (),  // output            app_sr_active
    .app_ref_ack                    (),  // output            app_ref_ack
    .app_zq_ack                     (),  // output            app_zq_ack
    .ui_clk                         (clk),  // output            ui_clk
    .ui_clk_sync_rst                (rst),  // output            ui_clk_sync_rst
    .app_wdf_mask                   (app_wdf_mask),  // input [15:0]        app_wdf_mask
    // System Clock Ports
    .sys_clk_p                      (sys_clk_p),  // input                sys_clk_p
    .sys_clk_n                      (sys_clk_n),  // input                sys_clk_n
    .sys_rst                        (sys_rst) // input sys_rst
);

 ddr3_test ddr3_tb
	(
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
	

// Instantiate the okHost and connect endpoints.
okHost host (
	.hi_in(hi_in),
	.hi_out(hi_out),
	.hi_inout(hi_inout),
	.hi_aa(hi_aa),
	.ti_clk(ti_clk),
	.ok1(ok1), 
	.ok2(ok2)
	);

wire [17*4-1:0]  ok2x;
okWireOR # (.N(4)) wireOR (ok2, ok2x);
okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireOut    wo00 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain({15'h00, init_calib_complete}));
okWireOut    wo01 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'h3e), .ep_datain(CAPABILITY));
okPipeIn     pi0  (.ok1(ok1), .ok2(ok2x[ 2*17 +: 17 ]), .ep_addr(8'h80), .ep_write(pi0_ep_write), .ep_dataout(pi0_ep_dataout));
okPipeOut    po0  (.ok1(ok1), .ok2(ok2x[ 3*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(po0_ep_read),   .ep_datain(po0_ep_datain));

fifo_w16_2048_r128_256 okPipeIn_fifo (
	.rst(ep00wire[2]),
	.wr_clk(ti_clk),
	.rd_clk(clk),
	.din(pi0_ep_dataout), // Bus [15 : 0] 
	.wr_en(pi0_ep_write),
	.rd_en(pipe_in_read),
	.dout(pipe_in_data), // Bus [127 : 0] 
	.full(pipe_in_full),
	.empty(pipe_in_empty),
	.valid(pipe_in_valid),
	.rd_data_count(pipe_in_rd_count), // Bus [7 : 0] 
	.wr_data_count()); // Bus [10 : 0] 

fifo_w128_256_r16_2048 okPipeOut_fifo (
	.rst(ep00wire[2]),
	.wr_clk(clk),
	.rd_clk(ti_clk),
	.din(pipe_out_data), // Bus [127 : 0] 
	.wr_en(pipe_out_write),
	.rd_en(po0_ep_read),
	.dout(po0_ep_datain), // Bus [15 : 0] 
	.full(pipe_out_full),
	.empty(pipe_out_empty),
	.valid(),
	.rd_data_count(), // Bus [10 : 0] 
	.wr_data_count(pipe_out_wr_count)); // Bus [7 : 0] 

endmodule
