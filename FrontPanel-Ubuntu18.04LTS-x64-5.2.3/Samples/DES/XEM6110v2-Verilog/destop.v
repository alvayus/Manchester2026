//------------------------------------------------------------------------
// destop.v
//
// Verilog source for the toplevel OpenCores.org DES tutorial.
// This source includes an instantiation of the DES module, hooks to 
// the FrontPanel host interface, as well as a short behavioral 
// description of the DES stepping to complete an encrypt/decrypt
// process.  This part includes PipeIn / PipeOut interfaces to allow block
// encryption and decryption.
//
// Copyright (c) 2005-2009  Opal Kelly Incorporated
// $Rev$ $Date$
//------------------------------------------------------------------------
`default_nettype none
`timescale 1ns / 1ps

module destop(
	input  wire [28:0]         okGH,
	output wire [27:0]         okHG,
	inout  wire                okAA,
	input  wire                sys_clkp,       // Running at 100 Mhz (for the SDRAM)
	input  wire                sys_clkn,       // Running at 100 Mhz (for the SDRAM)
	output wire [7:0]          led,
	output wire                init
	);

wire         ti_clk;
wire [46:0]  okHE;
wire [32:0]  okEH;
wire [43:0]  okHEO;
wire [102:0] okEHO;
wire [99:0]  okHEI;
wire [37:0]  okEHI;

wire clk1;
IBUFGDS #(.IOSTANDARD("LVDS_25")) osc_clk(.O(clk1), .I(sys_clkp), .IB(sys_clkn));

wire [63:0] des_out;
reg  [63:0] des_in;
wire [63:0] des_key;
wire [55:0] des_keyshort;
wire        des_decrypt;
reg  [3:0]  des_roundSel;
reg  [63:0] des_result;

wire [31:0] WireIn10;
wire [31:0] TrigIn40;
wire [31:0] TrigIn41;
wire [31:0] TrigOut60;

reg         pipe_in_read;
wire [63:0] pipe_in_data;
wire        pipe_in_valid;
wire        pipe_in_empty;
wire        pipe_in_start;
wire        pipe_in_done;

reg         pipe_out_write;
wire [63:0] pipe_out_data;
wire        pipe_out_full;
wire        pipe_out_start;
reg         pipe_out_started;

reg  [8:0]  ramI_addrA;
reg  [8:0]  ramI_addrB;
wire [63:0] ramI_dout;

reg  [8:0]  ramO_addrA;
reg  [8:0]  ramO_addrB;
reg  [63:0] ramO_din;
reg         ramO_write;

wire        start;
wire        reset;
wire        ram_reset;
reg         done;
wire        dcm_clk;
wire        dcm_clkfb;
wire        dcm_locked;

assign init = 1'b1;

assign led          = ~{dcm_locked, 3'd0, des_roundSel[3:0]};
assign reset        = WireIn10[0];
assign des_decrypt  = WireIn10[4];
assign start        = TrigIn40[0];
assign ram_reset    = TrigIn41[0];
assign TrigOut60[0] = done;

// Remove KEY parity bits.
assign des_keyshort = {des_key[63:57], des_key[55:49],
                       des_key[47:41], des_key[39:33],
                       des_key[31:25], des_key[23:17],
                       des_key[15:9],  des_key[7:1]};


// Block DES state machine.
//
// This machine is triggered to perform the DES encrypt/decrypt algorithm
// on a full block RAM.  Upon triggering, it performs the DES algorithm
// on 64-bit sections for the entire 2048-byte block RAM.  When complete,
// it asserts DONE for a single cycle.
parameter s_idle = 0,
          s_loadinput1 = 10,
          s_loadinput2 = 11,
          s_dodes1 = 20,
          s_saveoutput1 = 30,
          s_saveoutput2 = 31,
          s_done = 40;
integer state;

always @(posedge dcm_clk) begin
	if (reset == 1'b1) begin
		done <= 1'b0;
		state <= s_idle;
	end else begin
		done <= 1'b0;
		ramO_write <= 1'b0;
		
		case (state)
			s_idle: begin
				if (start == 1'b1) begin
					state <= s_loadinput1;
					ramI_addrB <= 9'd0;
					ramO_addrB <= 9'd0;
				end
			end
		
			s_loadinput1: begin
				state <= s_loadinput2;
				ramI_addrB <= ramI_addrB + 1;
			end
			
			s_loadinput2: begin
				state <= s_dodes1;
				des_in <= ramI_dout;
				des_roundSel <= 4'd0;
			end

			s_dodes1: begin
				state <= s_dodes1;
				des_roundSel <= des_roundSel + 1;
				if (des_roundSel == 4'd15) begin
					des_result <= des_out;
					state <= s_saveoutput1;
				end
			end
		
			s_saveoutput1: begin
				state <= s_saveoutput2;
				ramO_din <= des_result;
				ramO_write <= 1'b1;
			end
			
			s_saveoutput2: begin
				ramO_addrB <= ramO_addrB + 1;
				if (ramI_addrB == 9'd0)
					state <= s_done;
				else
					state <= s_loadinput1;
			end
		
			s_done: begin
				state <= s_idle;
				done <= 1'b1;
			end
		endcase
	end
end

DCM_SP #(
	.CLKDV_DIVIDE(2.0),
	.CLKIN_PERIOD(10.0)
	)
	dcm_div_by_2 (
	  .CLK0(dcm_clkfb),
		.CLKDV(dcm_clk),       
		.LOCKED(dcm_locked),     
		.CLKFB(dcm_clkfb),      
		.CLKIN(clk1), 
		.PSEN(1'b0),  
		.RST(1'b0)         
	);
	
// Pipe <--> RAM Process
// The PCI PipeIn and PipeOut are 64bit wide and via internal 512 word FIFOs
// This process manages pipe fifo control and addressing for the input/output
// RAMB pairs.
always @(posedge ti_clk) begin
	if (ram_reset == 1'b1) begin
		ramI_addrA <= 9'd0;
		ramO_addrA <= 9'd0;
		pipe_out_started <= 1'b0;
		pipe_in_read <= 1'b0;
		pipe_out_write <= 1'b0;
	end else begin
		pipe_out_write <= 1'b0;
		
		if (1'b1 == pipe_in_start) begin
				pipe_in_read <= 1'b1;
		end
		
		if (1'b1 == pipe_out_start) begin
				pipe_out_started <= 1'b1;
		end
		
		if ( (1'b1 == pipe_in_valid) ) begin
			ramI_addrA <= ramI_addrA + 1;
		end

		if ((1'b0 == pipe_out_full) & (1'b1 == pipe_out_started) ) begin
			pipe_out_write <= 1'b1;
			ramO_addrA <= ramO_addrA + 1;
		end
		
	end
end
	
// Instantiate the input block RAM
RAMB16_S36_S36 ram_IL(.CLKA(ti_clk), .SSRA(reset), .ENA(1'b1),
                     .WEA(pipe_in_valid), .ADDRA(ramI_addrA),
                     .DIA(pipe_in_data[31:0]), .DIPA(4'b0), .DOA(), .DOPA(),
                     .CLKB(dcm_clk), .SSRB(reset), .ENB(1'b1),
                     .WEB(1'b0), .ADDRB(ramI_addrB),
                     .DIB(32'b0), .DIPB(4'b0), .DOB(ramI_dout[31:0]), .DOPB());
RAMB16_S36_S36 ram_IU(.CLKA(ti_clk), .SSRA(reset), .ENA(1'b1),
                     .WEA(pipe_in_valid), .ADDRA(ramI_addrA),
                     .DIA(pipe_in_data[63:32]), .DIPA(4'b0), .DOA(), .DOPA(),
                     .CLKB(dcm_clk), .SSRB(reset), .ENB(1'b1),
                     .WEB(1'b0), .ADDRB(ramI_addrB),
                     .DIB(32'b0), .DIPB(4'b0), .DOB(ramI_dout[63:32]), .DOPB());

// Instantiate the output block RAM
RAMB16_S36_S36 ram_OL(.CLKA(ti_clk), .SSRA(reset), .ENA(1'b1),
                     .WEA(1'b0), .ADDRA(ramO_addrA),
                     .DIA(32'b0), .DIPA(4'b0), .DOA(pipe_out_data[31:0]), .DOPA(),
                     .CLKB(dcm_clk), .SSRB(reset), .ENB(1'b1),
                     .WEB(ramO_write), .ADDRB(ramO_addrB),
                     .DIB(ramO_din[31:0]), .DIPB(4'b0), .DOB(), .DOPB());
RAMB16_S36_S36 ram_OU(.CLKA(ti_clk), .SSRA(reset), .ENA(1'b1),
                     .WEA(1'b0), .ADDRA(ramO_addrA),
                     .DIA(32'b0), .DIPA(4'b0), .DOA(pipe_out_data[63:32]), .DOPA(),
                     .CLKB(dcm_clk), .SSRB(reset), .ENB(1'b1),
                     .WEB(ramO_write), .ADDRB(ramO_addrB),
                     .DIB(ramO_din[63:32]), .DIPB(4'b0), .DOB(), .DOPB());

// Instantiate the OpenCores.org DES module.
des desModule(
		.clk(dcm_clk), .roundSel(des_roundSel),
		.desOut(des_out), .desIn(des_in),
		.key(des_keyshort), .decrypt(des_decrypt));

// Instantiate the okHost and connect endpoints.
okHost host (
	.okGH(okGH),
	.okHG(okHG),
	.okAA(okAA),
	.okHE(okHE),
	.okEH(okEH),
	.okHEO(okHEO),
	.okEHO(okEHO),
	.okHEI(okHEI),
	.okEHI(okEHI),
	.ti_clk(ti_clk)
	);

wire [15:0] msb0, msb1, msb2, msb3;
wire [33*1-1:0]  okEHx;
okWireOR # (.N(1)) wireOR (okEH, okEHx);

okWireIn     ep08 (.ok1(okHE),                             .ep_addr(8'h08), .ep_dataout({msb0, des_key[15:0]}));
okWireIn     ep09 (.ok1(okHE),                             .ep_addr(8'h09), .ep_dataout({msb1, des_key[31:16]}));
okWireIn     ep0A (.ok1(okHE),                             .ep_addr(8'h0a), .ep_dataout({msb2, des_key[47:32]}));
okWireIn     ep0B (.ok1(okHE),                             .ep_addr(8'h0b), .ep_dataout({msb3, des_key[63:48]}));
okWireIn     ep10 (.ok1(okHE),                             .ep_addr(8'h10), .ep_dataout(WireIn10));
okTriggerIn  ep40 (.ok1(okHE),                             .ep_addr(8'h40), .ep_clk(dcm_clk), .ep_trigger(TrigIn40));
okTriggerIn  ep41 (.ok1(okHE),                             .ep_addr(8'h41), .ep_clk(ti_clk), .ep_trigger(TrigIn41));
okTriggerOut ep60 (.ok1(okHE), .ok2(okEHx[ 0*33  +: 33 ]), .ep_addr(8'h60), .ep_clk(dcm_clk), .ep_trigger(TrigOut60));

okPipeIn ep80 (.okHEI               (okHEI),
               .okEHI               (okEHI),
               .ep_clk              (ti_clk),
               .ep_start            (pipe_in_start),
               .ep_done             (pipe_in_done),
               .ep_fifo_reset       (pipe_in_start),
               .ep_read             (pipe_in_read),
               .ep_data             (pipe_in_data),
               .ep_count            (),
               .ep_valid            (pipe_in_valid),
               .ep_empty            (pipe_in_empty)
               );

okPipeOut epA0 (.okHEO              (okHEO),
                .okEHO              (okEHO),
                .ep_clk             (ti_clk),
                .ep_start           (pipe_out_start),
                .ep_done            (),
                .ep_fifo_reset      (pipe_in_done),
                .ep_write           (pipe_out_write),
                .ep_data            (pipe_out_data),
                .ep_count           (),
                .ep_full            (pipe_out_full)
               );
endmodule
