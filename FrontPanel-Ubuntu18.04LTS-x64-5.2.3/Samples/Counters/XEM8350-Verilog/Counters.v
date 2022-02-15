//------------------------------------------------------------------------
// Counters.v
//
// HDL for the counters sample.  This HDL describes two counters operating
// on different board clocks and with slightly different functionality.
// The counter controls and counter values are connected to endpoints so
// that FrontPanel may control and observe them.
//
// Copyright (c) 2005-2019
// Opal Kelly Incorporated
//------------------------------------------------------------------------

`default_nettype none

module Counters(
	input  wire [4:0]   okUH,
	output wire [2:0]   okHU,
	inout  wire [31:0]  okUHU,
	input  wire [4:0]   okUHs,
	output wire [2:0]   okHUs,
	inout  wire [31:0]  okUHUs,
	inout  wire         okAA,
	
	output wire         ok_done,

	input  wire         sys_clkp,
	input  wire         sys_clkn,
	
	output wire [7:0]   led
	);

// Clock
wire sys_clk;
IBUFGDS osc_clk(.O(sys_clk), .I(sys_clkp), .IB(sys_clkn));

// Target interface bus:
wire         okClk, okClks;
wire [112:0] okHE, okHEs;
wire [64:0]  okEH, okEHs;

// Endpoint connections:
wire [31:0]  ep00wire, ep00wire_s;
wire [31:0]  ep20wire, ep21wire, ep20wire_s, ep21wire_s;
wire [31:0]  ep40wire, ep40wire_s;
wire [31:0]  ep60trig, ep61trig, ep60trig_s, ep61trig_s;

// Counter 1:
reg  [23:0] div1;
reg         clk1div;
reg  [7:0]  count1, count1_s;
reg         count1eq00, count1eq00_s;
reg         count1eq80, count1eq80_s;
wire        reset1, reset1_s;
wire        disable1, disable1_s;

// Counter 2:
reg  [23:0] div2;
reg         clk2div;
reg  [7:0]  count2, count2_s;
reg         count2eqFF, count2eqFF_s;
wire        reset2, reset2_s;
wire        up2, up2_s;
wire        down2, down2_s;
wire        autocount2, autocount2_s;

// Counter 1:
assign reset1       = ep00wire[0];
assign disable1     = ep00wire[1];
assign autocount2   = ep00wire[2];
assign ep20wire     = {24'd0, count1};
assign ep21wire     = {24'd0, count2};
assign reset1_s     = ep00wire_s[0];
assign disable1_s   = ep00wire_s[1];
assign autocount2_s = ep00wire_s[2];
assign ep20wire_s   = {24'd0, count1_s};
assign ep21wire_s   = {24'd0, count2_s};

// Counter 2:
assign reset2     = ep40wire[0];
assign up2        = ep40wire[1];
assign down2      = ep40wire[2];
assign ep60trig   = {30'b0, count1eq80, count1eq00};
assign ep61trig   = {31'b0, count2eqFF};
assign reset2_s   = ep40wire_s[0];
assign up2_s      = ep40wire_s[1];
assign down2_s    = ep40wire_s[2];
assign ep60trig_s = {30'b0, count1eq80_s, count1eq00_s};
assign ep61trig_s = {31'b0, count2eqFF_s};

assign led = {count1_s[7:4], count1[3:0]};

// Counter #1
// + Counting using a divided sysclk.
// + Reset sets the counter to 0.
// + Disable turns off the counter.
always @(posedge sys_clk) begin
	div1 <= div1 - 1;
	if (div1 == 24'h000000) begin
		div1 <= 24'h400000;
		clk1div <= 1'b1;
	end else begin
		clk1div <= 1'b0;
	end
	
	if (clk1div == 1'b1) begin
		if (reset1 == 1'b1)
			count1 <= 8'h00;
		else if (disable1 == 1'b0)
			count1 <= count1 + 1;
			
		if (reset1_s == 1'b1)
			count1_s <= 8'h00;
		else if (disable1_s == 1'b0)
			count1_s <= count1_s + 1;
	end

	if (count1 == 8'h00)
		count1eq00 <= 1'b1;
	else
		count1eq00 <= 1'b0;

	if (count1 == 8'h80)
		count1eq80 <= 1'b1;
	else
		count1eq80 <= 1'b0;
		
	if (count1_s == 8'h00)
		count1eq00_s <= 1'b1;
	else
		count1eq00_s <= 1'b0;

	if (count1_s == 8'h80)
		count1eq80_s <= 1'b1;
	else
		count1eq80_s <= 1'b0;
end


// Counter #2
// + Reset, up, and down control counter.
// + If autocount is enabled, a divided sys_clk can also
//   upcount.
always @(posedge sys_clk) begin
	div2 <= div2 - 1;
	if (div2 == 24'h000000) begin
		div2 <= 24'h100000;
		clk2div <= 1'b1;
	end else begin
		clk2div <= 1'b0;
	end
   
	if (reset2 == 1'b1)
		count2 <= 8'h00;
	else if (up2 == 1'b1)
		count2 <= count2 + 1;
	else if (down2 == 1'b1)
		count2 <= count2 - 1;
	else if ((autocount2 == 1'b1) && (clk2div == 1'b1))
		count2 <= count2 + 1;

	if (count2 == 8'hff)
		count2eqFF <= 1'b1;
	else
		count2eqFF <= 1'b0;
		
	if (reset2_s == 1'b1)
		count2_s <= 8'h00;
	else if (up2_s == 1'b1)
		count2_s <= count2_s + 1;
	else if (down2_s == 1'b1)
		count2_s <= count2_s - 1;
	else if ((autocount2_s == 1'b1) && (clk2div == 1'b1))
		count2_s <= count2_s + 1;

	if (count2_s == 8'hff)
		count2eqFF_s <= 1'b1;
	else
		count2eqFF_s <= 1'b0;
end


// Instantiate the okHost and connect endpoints.
wire [65*5-1:0]  okEHx, okEHsx;
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

okWireOR # (.N(5)) wireOR (okEH, okEHx);

okWireIn     wi00(.okHE(okHE),                             .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireOut    wo20(.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(ep20wire));
okWireOut    wo21(.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]), .ep_addr(8'h21), .ep_datain(ep21wire));
okTriggerIn  ti40(.okHE(okHE),                             .ep_addr(8'h40), .ep_clk(sys_clk), .ep_trigger(ep40wire));
okTriggerOut to60(.okHE(okHE), .okEH(okEHx[ 3*65 +: 65 ]), .ep_addr(8'h60), .ep_clk(sys_clk), .ep_trigger(ep60trig));
okTriggerOut to61(.okHE(okHE), .okEH(okEHx[ 4*65 +: 65 ]), .ep_addr(8'h61), .ep_clk(sys_clk), .ep_trigger(ep61trig));

okWireOR # (.N(5)) wireORs (okEHs, okEHsx);

okWireIn     wi00s(.okHE(okHEs),                              .ep_addr(8'h00), .ep_dataout(ep00wire_s));
okWireOut    wo20s(.okHE(okHEs), .okEH(okEHsx[ 0*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(ep20wire_s));
okWireOut    wo21s(.okHE(okHEs), .okEH(okEHsx[ 1*65 +: 65 ]), .ep_addr(8'h21), .ep_datain(ep21wire_s));
okTriggerIn  ti40s(.okHE(okHEs),                              .ep_addr(8'h40), .ep_clk(sys_clk), .ep_trigger(ep40wire_s));
okTriggerOut to60s(.okHE(okHEs), .okEH(okEHsx[ 3*65 +: 65 ]), .ep_addr(8'h60), .ep_clk(sys_clk), .ep_trigger(ep60trig_s));
okTriggerOut to61s(.okHE(okHEs), .okEH(okEHsx[ 4*65 +: 65 ]), .ep_addr(8'h61), .ep_clk(sys_clk), .ep_trigger(ep61trig_s));

endmodule
