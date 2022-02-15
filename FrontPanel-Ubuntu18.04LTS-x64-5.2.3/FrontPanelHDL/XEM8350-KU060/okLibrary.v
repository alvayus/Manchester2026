//------------------------------------------------------------------------
// okLibrary.v
//
// FrontPanel Library Module Declarations (Verilog)
// XEM8350
//
// Copyright (c) 2004-2011 Opal Kelly Incorporated
// $Rev: 980 $ $Date: 2011-08-19 14:17:52 -0500 (Fri, 19 Aug 2011) $
//------------------------------------------------------------------------
module okHost
	(
	input  wire [4:0]   okUH,
	output wire [2:0]   okHU,
	inout  wire [31:0]  okUHU,
	input  wire [4:0]   okUHs,
	output wire [2:0]   okHUs,
	inout  wire [31:0]  okUHUs,
	inout  wire         okAA,
	output wire         okClk,
	output wire [112:0] okHE,
	input  wire [64:0]  okEH,
	output wire         okClks,
	output wire [112:0] okHEs,
	input  wire [64:0]  okEHs,
	output reg          ok_done,
	output wire [95:0]  dna,
	output wire         dna_valid
	);
	
	wire [38:0] okHC;
	wire [37:0] okCH;
	wire [38:0] okHCs;
	wire [37:0] okCHs;

	wire        okUH0_ibufg, okUHs0_ibufg;
	wire        mmcm0_clk0, mmcm1_clk0;
	wire        mmcm0_clkfb, mmcm0_clkfb_bufg, mmcm1_clkfb, mmcm1_clkfb_bufg;
	wire        mmcm0_locked, mmcm1_locked;
	
	wire [31:0] iobf0_o, iobf1_o;
	wire [31:0] regout0_q, regout1_q;
	wire [31:0] regvalid0_q, regvalid1_q;
	
	wire [3:0]  okUHx, okUHxs;
	
	assign okClk    =  okHC[0];
	assign okHC[38] = ~mmcm0_locked;

	IBUFG  okUH0_bufg  (.I(okUH[0]), .O(okUH0_ibufg));

	MMCME2_BASE #(
		.BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
		.CLKFBOUT_MULT_F(10),      // Multiply value for all CLKOUT (2.000-64.000).
		.CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000).
		.CLKIN1_PERIOD(9.920),     // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
		.CLKOUT0_DIVIDE_F(10.0),   // Divide amount for CLKOUT0 (1.000-128.000).
		.CLKOUT0_PHASE(36.0),      // Phase offset for each CLKOUT (-360.000-360.000).
		.DIVCLK_DIVIDE(1),         // Master division value (1-106)
		.REF_JITTER1(0.0),         // Reference input jitter in UI (0.000-0.999).
		.STARTUP_WAIT("FALSE")     // Delays DONE until MMCM is locked (FALSE, TRUE)
	)
	mmcm0 (
		.CLKOUT0(mmcm0_clk0),      // 1-bit output: CLKOUT0
		.CLKFBOUT(mmcm0_clkfb),    // 1-bit output: Feedback clock
		.LOCKED(mmcm0_locked),     // 1-bit output: LOCK
		.CLKIN1(okUH0_ibufg),     // 1-bit input: Clock
		.RST(1'b0),                // 1-bit input: Reset
		.CLKFBIN(mmcm0_clkfb_bufg) // 1-bit input: Feedback clock
	);

	BUFG  mmcm0_bufg   (.I(mmcm0_clk0), .O(okHC[0]));
	BUFG  mmcm0fb_bufg (.I(mmcm0_clkfb), .O(mmcm0_clkfb_bufg));

	
	//------------------------------------------------------------------------
	// Bidirectional IOB registers
	//------------------------------------------------------------------------
	
	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin : iob_regs0
			IOBUF iobf0 (.IO(okUHU[i]), .I(regout0_q[i]), .O(iobf0_o[i]), .T(regvalid0_q[i]));
	
			//Input Registering
			(* IOB = "true" *)
			FDRE regin0 (.D(iobf0_o[i]), .Q(okHC[i+5]), .C(okHC[0]), .CE(1'b1), .R(1'b0));
	
			// Output Registering
			(* IOB = "true" *)
			FDRE regout0 (.D(okCH[i+3]), .Q(regout0_q[i]), .C(okHC[0]), .CE(1'b1), .R(1'b0));
			
			// Tristate Drive
			FDRE regvalid0 (.D(~okCH[36]), .Q(regvalid0_q[i]), .C(okHC[0]), .CE(1'b1), .R(1'b0));
		end
	endgenerate
	
	IOBUF tbuf(.I(okCH[35]), .O(okHC[37]), .T(okCH[37]), .IO(okAA));

	//------------------------------------------------------------------------
	// Output IOB registers
	//------------------------------------------------------------------------
	(* IOB = "true" *)
	FDRE regctrlout0 (.D(okCH[2]), .C(okHC[0]), .CE(1'b1), .R(1'b0), .Q(okHU[2]));
	(* IOB = "true" *)
	FDRE regctrlout1 (.D(okCH[0]), .C(okHC[0]), .CE(1'b1), .R(1'b0), .Q(okHU[0]));
	(* IOB = "true" *)
	FDRE regctrlout2 (.D(okCH[1]), .C(okHC[0]), .CE(1'b1), .R(1'b0), .Q(okHU[1]));

	//------------------------------------------------------------------------
	// Input IOB registers
	//  - First registered on DCM0 (positive edge)
	//  - Then registered on DCM0 (negative edge)
	//------------------------------------------------------------------------
	(* IOB = "true" *)
	FDRE regctrlin0a (.C(okHC[0]),  .D(okUH[1]),  .Q(okHC[1]), .CE(1'b1), .R(1'b0));
	(* IOB = "true" *)
	FDRE regctrlin1a (.C(okHC[0]),  .D(okUH[2]),  .Q(okHC[2]), .CE(1'b1), .R(1'b0));
	(* IOB = "true" *)
	FDRE regctrlin2a (.C(okHC[0]),  .D(okUH[3]),  .Q(okHC[3]), .CE(1'b1), .R(1'b0));
	(* IOB = "true" *)
	FDRE regctrlin3a (.C(okHC[0]),  .D(okUH[4]),  .Q(okHC[4]), .CE(1'b1), .R(1'b0));

	assign okClks    =  okHCs[0];
	assign okHCs[38] = ~mmcm1_locked;

	IBUFG  okUHs0_bufg  (.I(okUHs[0]), .O(okUHs0_ibufg));

	MMCME2_BASE #(
		.BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
		.CLKFBOUT_MULT_F(10),      // Multiply value for all CLKOUT (2.000-64.000).
		.CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000).
		.CLKIN1_PERIOD(9.920),     // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
		.CLKOUT0_DIVIDE_F(10.0),   // Divide amount for CLKOUT0 (1.000-128.000).
		.CLKOUT0_PHASE(36.0),      // Phase offset for each CLKOUT (-360.000-360.000).
		.DIVCLK_DIVIDE(1),         // Master division value (1-106)
		.REF_JITTER1(0.0),         // Reference input jitter in UI (0.000-0.999).
		.STARTUP_WAIT("FALSE")     // Delays DONE until MMCM is locked (FALSE, TRUE)
	)
	mmcm1 (
		.CLKOUT0(mmcm1_clk0),      // 1-bit output: CLKOUT0
		.CLKFBOUT(mmcm1_clkfb),    // 1-bit output: Feedback clock
		.LOCKED(mmcm1_locked),     // 1-bit output: LOCK
		.CLKIN1(okUHs0_ibufg),     // 1-bit input: Clock
		.RST(1'b0),                // 1-bit input: Reset
		.CLKFBIN(mmcm1_clkfb_bufg) // 1-bit input: Feedback clock
	);

	BUFG  mmcm1_bufg   (.I(mmcm1_clk0), .O(okHCs[0]));
	BUFG  mmcm1fb_bufg (.I(mmcm1_clkfb), .O(mmcm1_clkfb_bufg));

	
	//------------------------------------------------------------------------
	// Bidirectional IOB registers
	//------------------------------------------------------------------------

	generate
		for (i=0; i<32; i=i+1) begin : iob_regs1
			IOBUF iobf1 (.IO(okUHUs[i]), .I(regout1_q[i]), .O(iobf1_o[i]), .T(regvalid1_q[i]));
	
			//Input Registering
			(* IOB = "true" *)
			FDRE regin1 (.D(iobf1_o[i]), .Q(okHCs[i+5]), .C(okHCs[0]), .CE(1'b1), .R(1'b0));
	
			// Output Registering
			(* IOB = "true" *)
			FDRE regout1 (.D(okCHs[i+3]), .Q(regout1_q[i]), .C(okHCs[0]), .CE(1'b1), .R(1'b0));
			
			// Tristate Drive
			FDRE regvalid1 (.D(~okCHs[36]), .Q(regvalid1_q[i]), .C(okHCs[0]), .CE(1'b1), .R(1'b0));
		end
	endgenerate
	
	//------------------------------------------------------------------------
	// Output IOB registers
	//------------------------------------------------------------------------
	(* IOB = "true" *)
	FDRE regctrlout3 (.D(okCHs[2]), .C(okHCs[0]), .CE(1'b1), .R(1'b0), .Q(okHUs[2]));
	(* IOB = "true" *)
	FDRE regctrlout4 (.D(okCHs[0]), .C(okHCs[0]), .CE(1'b1), .R(1'b0), .Q(okHUs[0]));
	(* IOB = "true" *)
	FDRE regctrlout5 (.D(okCHs[1]), .C(okHCs[0]), .CE(1'b1), .R(1'b0), .Q(okHUs[1]));

	//------------------------------------------------------------------------
	// Input IOB registers
	//  - First registered on DCM0 (positive edge)
	//  - Then registered on DCM0 (negative edge)
	//------------------------------------------------------------------------
	(* IOB = "true" *)
	FDRE regctrlin4a (.C(okHCs[0]),  .D(okUHs[1]),  .Q(okHCs[1]), .CE(1'b1), .R(1'b0));
	(* IOB = "true" *)
	FDRE regctrlin5a (.C(okHCs[0]),  .D(okUHs[2]),  .Q(okHCs[2]), .CE(1'b1), .R(1'b0));
	(* IOB = "true" *)
	FDRE regctrlin6a (.C(okHCs[0]),  .D(okUHs[3]),  .Q(okHCs[3]), .CE(1'b1), .R(1'b0));
	(* IOB = "true" *)
	FDRE regctrlin7a (.C(okHCs[0]),  .D(okUHs[4]),  .Q(okHCs[4]), .CE(1'b1), .R(1'b0));
	

	okCoreHarness core0(.okHC(okHC), .okCH(okCH), .okHE(okHE), .okEH(okEH),
		.okHCs(okHCs), .okCHs(okCHs), .okHEs(okHEs), .okEHs(okEHs), .dna(dna), .dna_valid(dna_valid));
	
	reg  [31:0] ok_done_cnt = 32'h00;
	always @(posedge okClk) begin
		ok_done <= 1'b0;
		if (ok_done_cnt < 32'd10000) begin
			ok_done_cnt <= ok_done_cnt + 1'b1;
		end else begin
			ok_done <= 1'b1;
		end
	end
endmodule

module okWireOR # (parameter N = 1)	(
	output reg  [64:0]     okEH,
	input  wire [N*65-1:0] okEHx
	);

	integer i;
	always @(okEHx)
	begin
		okEH = 0;
		for (i=0; i<N; i=i+1) begin: wireOR
			okEH = okEH | okEHx[ i*65 +: 65 ];
		end
	end
endmodule
