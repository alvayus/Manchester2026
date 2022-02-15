//------------------------------------------------------------------------
// si_i2c.v
//
// HDL for the Si5338 sample.  This HDL instantiates an I2C IP to
// interface with the Si5338 clock generator IC used on the XEM8350.
//
// Copyright (c) 2019
// Opal Kelly Incorporated
//------------------------------------------------------------------------

`default_nettype none

module si_i2c(
	input  wire [4:0]   okUH,
	output wire [2:0]   okHU,
	inout  wire [31:0]  okUHU,
	inout  wire         okAA,
	
	output wire         ok_done,
	
	input  wire         sys_clkp,
	input  wire         sys_clkn,

	inout  wire         si5338_scl,
	inout  wire         si5338_sda,
	
	output wire [7:0]   led
	);
	
wire sys_clk;
IBUFGDS osc_clk(.O(sys_clk), .I(sys_clkp), .IB(sys_clkn));

// Target interface bus:
wire         okClk;
wire [112:0] okHE;
wire [64:0]  okEH;

wire [31:0]  ep00wire, ti40_okclk, ti60_okclk;
wire [31:0]  i2c_memdin, i2c_memdout;

reg  [31:0]  counter;

assign led = {counter[31:24]};

always @(posedge sys_clk)
begin
	counter <= counter + 1'b1;
end

i2cController #(
	.CLOCK_STRETCH_SUPPORT (1),
	.CLOCK_DIVIDER         (228)
) i2c_ctrl0 (
	.clk (okClk),
	.reset    (ep00wire[0]),
	.start    (ti40_okclk[0]),
	.done     (ti60_okclk[0]),
	.memclk   (okClk),
	.memstart (ti40_okclk[1]),
	.memwrite (ti40_okclk[2]),
	.memread  (ti40_okclk[3]),
	.memdin   (i2c_memdin[7:0]),
	.memdout  (i2c_memdout[7:0]),
	.i2c_sclk (si5338_scl),
	.i2c_sdat (si5338_sda)
);

// Instantiate the okHost and connect endpoints.
wire [65*2-1:0]  okEHx;
okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE), 
	.okEH(okEH),
	.okUHs(),
	.okHUs(),
	.okUHUs(),
	.okClks(),
	.okHEs(), 
	.okEHs(),
	.ok_done(ok_done)
);

okWireOR # (.N(2)) wireOR (okEH, okEHx);

okWireIn     wi00(.okHE(okHE),                             .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireIn     wi01(.okHE(okHE),                             .ep_addr(8'h01), .ep_dataout(i2c_memdin));
okWireOut    wo20(.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(i2c_memdout));
okTriggerIn  ti40(.okHE(okHE),                             .ep_addr(8'h40), .ep_clk(okClk), .ep_trigger(ti40_okclk));
okTriggerOut to60(.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'h60), .ep_clk(okClk), .ep_trigger(ti60_okclk));

endmodule
