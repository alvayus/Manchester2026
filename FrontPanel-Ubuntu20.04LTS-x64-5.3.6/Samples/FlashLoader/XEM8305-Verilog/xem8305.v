//------------------------------------------------------------------------
// xem8310.v
//
// This is the toplevel HDL for a simple SPI Flash programmer for the XEM8310.
//------------------------------------------------------------------------
// Copyright (c) 2006-2022 Opal Kelly Incorporated
// $Id: xem6010.v 2 2014-05-02 15:39:50Z janovetz $
//------------------------------------------------------------------------

`default_nettype none
`timescale 1ns / 1ps

module flashtop (
	input  wire [4:0]   okUH,
	output wire [2:0]   okHU,
	inout  wire [31:0]  okUHU,
	inout  wire         okAA,

	output wire [5:0]   led
	);

wire flash_c, flash_d, flash_s_n, flash_q, flash_hold, flash_w;

assign flash_hold = 1'b1;
assign flash_w = 1'b1;

assign led = {6'b101010};

// Target interface bus:
wire         okClk;
wire [112:0] okHE;
wire [64:0]  okEH;

// Connect endpoints.
wire [65*2-1:0]  okEHx;

flashLoad fl0(
	.okClk(okClk), .okHE(okHE), .okEH(okEHx[ 0*65 +: 65 ]),
	.flash_c(flash_c), .flash_d(flash_d), .flash_s_n(flash_s_n), .flash_q(flash_q));


// Instantiate the okHost and connect endpoints.
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

wire [3:0] startup_di;

assign flash_q = startup_di[1];

STARTUPE3 #(
  .PROG_USR("FALSE"),  // Activate program event security feature. Requires encrypted bitstreams.
  .SIM_CCLK_FREQ(0.0)  // Set the Configuration Clock Frequency (ns) for simulation
)
STARTUPE3_inst (
  .CFGCLK(),       // 1-bit output: Configuration main clock output
  .CFGMCLK(),     // 1-bit output: Configuration internal oscillator clock output
  .DI({startup_di}),               // 4-bit output: Allow receiving on the D input pin
  .EOS(),             // 1-bit output: Active-High output signal indicating the End Of Startup
  .PREQ(),           // 1-bit output: PROGRAM request to fabric output
  .DO({flash_hold, flash_w, 1'b0, flash_d}),               // 4-bit input: Allows control of the D pin output
  .DTS({2'b0, 1'b1, 1'b0}),             // 4-bit input: Allows tristate of the D pin
  .FCSBO(flash_s_n),         // 1-bit input: Controls the FCS_B pin for flash access
  .FCSBTS(1'b0),       // 1-bit input: Enable the FCS_B pin
  .GSR(1'b0),             // 1-bit input: Global Set/Reset input (GSR cannot be used for the port)
  .GTS(1'b0),             // 1-bit input: Global 3-state input (GTS cannot be used for the port name)
  .KEYCLEARB(1'b1), // 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
  .PACK(1'b1),           // 1-bit input: PROGRAM acknowledge input
  .USRCCLKO(flash_c),   // 1-bit input: User CCLK input
  .USRCCLKTS(1'b0), // 1-bit input: User CCLK 3-state enable input
  .USRDONEO(1'b1),   // 1-bit input: User DONE pin output control
  .USRDONETS(1'b1)  // 1-bit input: User DONE 3-state enable output
);
	
endmodule
`default_nettype wire
