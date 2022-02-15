//------------------------------------------------------------------------
// Controls.v
//
// A simple example used to exercise various FrontPanel controls.
//
// This HDL contains two counters and several wired-through wires.
//
// Counter0[15:0]  -> WireOut 0x20
// Counter0[31:16] -> WireOut 0x21
// Counter1[15:0]  -> WireOut 0x22
// Counter1[31:16] -> WireOut 0x23
// xbus[15:0]      -> WireOut 0x24
// xbus[31:16]     -> WireOut 0x25
// xbus[35:32]     -> WireOut 0x26
// ybus[15:0]      -> WireOut 0x27
// ybus[31:16]     -> WireOut 0x28
// ybus[35:32]     -> WireOut 0x29
// zbus[13:0]      -> WireOut 0x2a
//
// WireIn 0x00     -> WireOut 0x30
// WireIn 0x01     -> WireOut 0x31
// WireIn 0x02     -> WireOut 0x32
// WireIn 0x03     -> WireOut 0x33
// WireIn 0x04     -> WireOut 0x34
// WireIn 0x05     -> WireOut 0x35
// WireIn 0x06     -> WireOut 0x36
// WireIn 0x07     -> WireOut 0x37
// WireIn 0x08     -> WireOut 0x38
// WireIn 0x09     -> WireOut 0x39
//
// WireIn 0x1F     -> {x, x, x, x, x, x, x, direction}
//
// ~Buttons, 0010  -> WireOut 0x3A
//
// TriggerIn 40 -> {x, x, x, x, x, countdown, countup, reset}
//
// Copyright (c) 2004-2006 Opal Kelly Incorporated
//------------------------------------------------------------------------

`default_nettype none

module Controls(
	input  wire [4:0]   okUH,
	output wire [2:0]   okHU,
	inout  wire [31:0]  okUHU,
	inout  wire         okAA,

	input  wire         sys_clkp,
	input  wire         sys_clkn,
	
	inout  wire [33:0]  la_p,
	inout  wire [33:0]  la_n,

	output wire [3:0]   led
	);

// Clock
wire sys_clk;
IBUFGDS osc_clk(.O(sys_clk), .I(sys_clkp), .IB(sys_clkn));

// Target interface bus:
wire         okClk;
wire [112:0] okHE;
wire [64:0]  okEH;

// Endpoint connections:
wire [31:0]  ep00wire, ep01wire, ep02wire, ep03wire;
wire [31:0]  ep04wire, ep05wire, ep06wire, ep07wire;
wire [31:0]  ep08wire, ep09wire;
wire [31:0]  ep1Fwire;
wire [31:0]  ep40wire;

// Counters:
reg  [31:0] count0;
reg  [31:0] count1;
wire        reset;
wire        countup;
wire        countdown;
wire [7:0]  scnt;
wire        direction;
wire [35:0] xbus;
wire [35:0] ybus;

assign led = ~scnt[3:0];
assign {countdown, countup, reset} = ep40wire[2:0];
assign {la_p} = xbus[33:0];
assign {la_n} = ybus[33:0];

// direction=0 means drive the xbus.
assign direction = ep1Fwire[0];
assign scnt = count0[30:23];
assign xbus = (direction==1'b0) ? ({scnt[3:0], scnt, scnt, scnt, scnt})
								: (36'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz);
assign ybus = (direction==1'b0) ? ({scnt[3:0], scnt, scnt, scnt, scnt})
								: (36'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz);

// Counter0 - Always running.
always @(posedge sys_clk) begin
	count0 <= count0 + 1;
end

// Counter1 - Up/Down triggered counter.
always @(posedge sys_clk) begin
	if (reset == 1'b1) begin
		count1 <= 32'd0;
	end else if (countup == 1'b1) begin
		count1 <= count1 + 1;
	end else if (countdown == 1'b1) begin
		count1 <= count1 - 1;
	end
end


// Instantiate the okHost and connect endpoints.
wire [65*22-1:0]  okEHx;
okHost okHI(
	.okUH(okUH),
	.okHU(okHU),
	.okUHU(okUHU),
	.okAA(okAA),
	.okClk(okClk),
	.okHE(okHE), 
	.okEH(okEH)
);

okWireOR # (.N(22)) wireOR (okEH, okEHx);

okWireIn    ep00 (.okHE(okHE),                              .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireIn    ep01 (.okHE(okHE),                              .ep_addr(8'h01), .ep_dataout(ep01wire));
okWireIn    ep02 (.okHE(okHE),                              .ep_addr(8'h02), .ep_dataout(ep02wire));
okWireIn    ep03 (.okHE(okHE),                              .ep_addr(8'h03), .ep_dataout(ep03wire));
okWireIn    ep04 (.okHE(okHE),                              .ep_addr(8'h04), .ep_dataout(ep04wire));
okWireIn    ep05 (.okHE(okHE),                              .ep_addr(8'h05), .ep_dataout(ep05wire));
okWireIn    ep06 (.okHE(okHE),                              .ep_addr(8'h06), .ep_dataout(ep06wire));
okWireIn    ep07 (.okHE(okHE),                              .ep_addr(8'h07), .ep_dataout(ep07wire));
okWireIn    ep08 (.okHE(okHE),                              .ep_addr(8'h08), .ep_dataout(ep08wire));
okWireIn    ep09 (.okHE(okHE),                              .ep_addr(8'h09), .ep_dataout(ep09wire));
okWireIn    ep1F (.okHE(okHE),                              .ep_addr(8'h1f), .ep_dataout(ep1Fwire));

okTriggerIn ep40 (.okHE(okHE),                              .ep_addr(8'h40), .ep_clk(sys_clk), .ep_trigger(ep40wire));

okWireOut   ep30 (.okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]),  .ep_addr(8'h30), .ep_datain(ep00wire));
okWireOut   ep31 (.okHE(okHE), .okEH(okEHx[ 1*65 +: 65 ]),  .ep_addr(8'h31), .ep_datain(ep01wire));
okWireOut   ep32 (.okHE(okHE), .okEH(okEHx[ 2*65 +: 65 ]),  .ep_addr(8'h32), .ep_datain(ep02wire));
okWireOut   ep33 (.okHE(okHE), .okEH(okEHx[ 3*65 +: 65 ]),  .ep_addr(8'h33), .ep_datain(ep03wire));
okWireOut   ep34 (.okHE(okHE), .okEH(okEHx[ 4*65 +: 65 ]),  .ep_addr(8'h34), .ep_datain(ep04wire));
okWireOut   ep35 (.okHE(okHE), .okEH(okEHx[ 5*65 +: 65 ]),  .ep_addr(8'h35), .ep_datain(ep05wire));
okWireOut   ep36 (.okHE(okHE), .okEH(okEHx[ 6*65 +: 65 ]),  .ep_addr(8'h36), .ep_datain(ep06wire));
okWireOut   ep37 (.okHE(okHE), .okEH(okEHx[ 7*65 +: 65 ]),  .ep_addr(8'h37), .ep_datain(ep07wire));
okWireOut   ep38 (.okHE(okHE), .okEH(okEHx[ 8*65 +: 65 ]),  .ep_addr(8'h38), .ep_datain(ep08wire));
okWireOut   ep39 (.okHE(okHE), .okEH(okEHx[ 9*65 +: 65 ]),  .ep_addr(8'h39), .ep_datain(ep09wire));

okWireOut   ep20 (.okHE(okHE), .okEH(okEHx[ 10*65 +: 65 ]), .ep_addr(8'h20), .ep_datain(count0[15:0]));
okWireOut   ep21 (.okHE(okHE), .okEH(okEHx[ 11*65 +: 65 ]), .ep_addr(8'h21), .ep_datain(count0[31:16]));
okWireOut   ep22 (.okHE(okHE), .okEH(okEHx[ 12*65 +: 65 ]), .ep_addr(8'h22), .ep_datain(count1[15:0]));
okWireOut   ep23 (.okHE(okHE), .okEH(okEHx[ 13*65 +: 65 ]), .ep_addr(8'h23), .ep_datain(count1[31:16]));
okWireOut   ep24 (.okHE(okHE), .okEH(okEHx[ 14*65 +: 65 ]), .ep_addr(8'h24), .ep_datain(xbus[15:0]));
okWireOut   ep25 (.okHE(okHE), .okEH(okEHx[ 15*65 +: 65 ]), .ep_addr(8'h25), .ep_datain(xbus[31:16]));
okWireOut   ep26 (.okHE(okHE), .okEH(okEHx[ 16*65 +: 65 ]), .ep_addr(8'h26), .ep_datain({12'd0, xbus[35:32]}));
okWireOut   ep27 (.okHE(okHE), .okEH(okEHx[ 17*65 +: 65 ]), .ep_addr(8'h27), .ep_datain(ybus[15:0]));
okWireOut   ep28 (.okHE(okHE), .okEH(okEHx[ 18*65 +: 65 ]), .ep_addr(8'h28), .ep_datain(ybus[31:16]));
okWireOut   ep29 (.okHE(okHE), .okEH(okEHx[ 19*65 +: 65 ]), .ep_addr(8'h29), .ep_datain({12'd0, ybus[35:32]}));

endmodule
