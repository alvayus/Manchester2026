//------------------------------------------------------------------------
// okWireOut
//
// This module simulates the "Wire Out" endpoint.
//
//------------------------------------------------------------------------
// Copyright (c) 2005-2010 Opal Kelly Incorporated
// $Rev$ $Date$
//------------------------------------------------------------------------
`default_nettype none
`timescale 1ns / 1ps

module okWireOut(
	input  wire [30:0] ok1,
	output wire [16:0] ok2,
	input  wire [7:0]  ep_addr,
	input  wire [15:0] ep_datain
	);

`include "parameters.v" 
`include "mappings.v"

reg  [15:0] wirehold;

assign ok2[OK_DATAOUT_END:OK_DATAOUT_START] = (ti_addr == ep_addr) ? (wirehold) : (0);
assign ok2[OK_READY]                        = 0;

always @(posedge ti_clock) begin
	if (ti_reset == 1)
		wirehold <= 0;
	else if (ti_wireupdate == 1)
		wirehold <= ep_datain;
end

initial begin
	if ((ep_addr < 8'h20) || (ep_addr > 8'h3F)) begin
		$error("okWireOut endpoint address outside valid range, must be between 0x20 and 0x3F");
		$finish;
	end
end

endmodule

