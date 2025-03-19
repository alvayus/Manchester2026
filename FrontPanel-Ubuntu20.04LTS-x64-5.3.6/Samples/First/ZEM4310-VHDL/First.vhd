--------------------------------------------------------------------------
-- First.vhd
--
-- A simple example for getting started with FrontPanel.  This sample
-- connects the on-board buttons to Wire Outs and the on-board LEDs
-- to Wire Ins so that FrontPanel can observe the buttons and control
-- the LEDs.
--
--------------------------------------------------------------------------
-- Copyright (c) 2005 Opal Kelly Incorporated
-- $Id$
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;
use work.FRONTPANEL.all;

entity First is
	port (
		okUH      : in     STD_LOGIC_VECTOR(4 downto 0);
		okHU      : out    STD_LOGIC_VECTOR(2 downto 0);
		okUHU     : inout  STD_LOGIC_VECTOR(31 downto 0);
		okAA      : inout  STD_LOGIC;

		led       : out    STD_LOGIC_VECTOR(1 downto 0)
	);
end First;

architecture arch of First is
	signal okClk      : STD_LOGIC;
	signal okHE       : STD_LOGIC_VECTOR(112 downto 0);
	signal okEH       : STD_LOGIC_VECTOR(64 downto 0);
	signal okEHx      : STD_LOGIC_VECTOR(65*2-1 downto 0);
	
	signal ep00wire   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep01wire   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep02wire   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep20wire   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep21wire   : STD_LOGIC_VECTOR(31 downto 0);

begin

-- Implement the logic (pretty simple for First).
led      <= not ep00wire(1 downto 0);
ep20wire <= (x"0000_0000");
ep21wire <= ep01wire + ep02wire;

-- Instantiate the okHost and connect endpoints
okHI : okHost port map (
	okUH=>okUH, 
	okHU=>okHU, 
	okUHU=>okUHU, 
	okAA=>okAA,
	okClk=>okClk, 
	okHE=>okHE, 
	okEH=>okEH
);

okWO : okWireOR     generic map (N=>2) port map (okEH=>okEH, okEHx=>okEHx);

ep00 : okWireIn     port map (okHE=>okHE,                                    ep_addr=>x"00", ep_dataout=>ep00wire);
ep01 : okWireIn     port map (okHE=>okHE,                                    ep_addr=>x"01", ep_dataout=>ep01wire);
ep02 : okWireIn     port map (okHE=>okHE,                                    ep_addr=>x"02", ep_dataout=>ep02wire);
ep20 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 1*65-1 downto 0*65 ), ep_addr=>x"20", ep_datain=>ep20wire);
ep21 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 2*65-1 downto 1*65 ), ep_addr=>x"21", ep_datain=>ep21wire);

end arch;
