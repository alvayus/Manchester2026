--------------------------------------------------------------------------
-- okDualHost.vhd
--
--	Description:
--		This file is a simulation replacement for okCore for
--		FrontPanel. It receives data from host calls copied to the top
--      level test fixture from okHostCalls_vhd.txt which are 
--		then restructured and timed to communicate with the endpoint
--		simulation modules.
--
--      This file is designed to simulate dual-fx3 devices.
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.parameters.all;
use work.mappings.all;

entity okDualHost is
	port (
		okUH      : in    std_logic_vector(4 downto 0);
		okHU      : out   std_logic_vector(2 downto 0);
		okUHU     : inout std_logic_vector(31 downto 0);
		okUHs     : in    std_logic_vector(4 downto 0);
		okHUs     : out   std_logic_vector(2 downto 0);
		okUHUs    : inout std_logic_vector(31 downto 0);
		okAA      : inout std_logic;
		okClk     : out   std_logic;
		okHE      : out   std_logic_vector(112 downto 0);
		okEH      : in    std_logic_vector(64 downto 0);
		okClks    : out   std_logic;
		okHEs     : out   std_logic_vector(112 downto 0);
		okEHs     : in    std_logic_vector(64 downto 0);
		ok_done   : out   std_logic
	);
end okDualHost;

architecture arch of okDualHost is
	component okHost port(
		okUH   : in    std_logic_vector(4 downto 0);
		okHU   : out   std_logic_vector(2 downto 0);
		okUHU  : inout std_logic_vector(31 downto 0);
		okAA   : inout std_logic;
		okClk  : out   std_logic;
		okHE   : out   std_logic_vector(112 downto 0);
		okEH   : in    std_logic_vector(64 downto 0));
	end component;
begin

ok_done <= '1';
	
host1: okHost port map (
	okUH  => okUH,
	okHU  => okHU,
	okUHU => okUHU,
	okAA  => okAA,
	okClk => okClk,
	okHE  => okHE,
	okEH  => okEH
);

host2: okHost port map (
	okUH  => okUHs,
	okHU  => okHUs,
	okUHU => okUHUs,
	okClk => okClks,
	okHE  => okHEs,
	okEH  => okEHs
);

end arch;
