------------------------------------------------------------------------
--okLibrary.vhd 
--
--FrontPanel Library Module Declarations (VHDL)
-- XEM8350
--
-- Copyright (c) 2004-2011 Opal Kelly Incorporated
-- $Rev: 980 $ $Date: 2011-08-19 14:17:52 -0500 (Fri, 19 Aug 2011) $
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity okWireOR is
	generic (
		N     : integer := 1
	);
	port (
		okEH   : out std_logic_vector(64 downto 0);
		okEHx  : in  std_logic_vector(N*65-1 downto 0)
	);
end okWireOR;
architecture archWireOR of okWireOR is
begin
	process (okEHx)
		variable okEH_int : STD_LOGIC_VECTOR(64 downto 0);
	begin
		okEH_int:= '0' & x"0000_0000_0000_0000";
		for i in N-1 downto 0 loop
			okEH_int := okEH_int or okEHx( (i*65+64) downto (i*65) );
		end loop;
		okEH <= okEH_int;
	end process;
end archWireOR;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package FRONTPANEL is

	attribute box_type: string;
	
	component okHost port (
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
		ok_done   : out   std_logic;
		dna       : out   std_logic_vector(95 downto 0);
		dna_valid : out   std_logic);
	end component;

	component okCoreHarness port (
		okHC      : in  std_logic_vector(38 downto 0);
		okCH      : out std_logic_vector(37 downto 0);
		okHE      : out std_logic_vector(112 downto 0);
		okEH      : in  std_logic_vector(64 downto 0);
		okHCs     : in  std_logic_vector(38 downto 0);
		okCHs     : out std_logic_vector(37 downto 0);
		okHEs     : out std_logic_vector(112 downto 0);
		okEHs     : in  std_logic_vector(64 downto 0);
		dna       : out std_logic_vector(56 downto 0);
		dna_valid : out std_logic);
	end component;
	attribute box_type of okCoreHarness : component is "black_box";

	component okWireIn port (
		okHE       : in  std_logic_vector(112 downto 0);
		ep_addr    : in  std_logic_vector(7 downto 0);
		ep_dataout : out std_logic_vector(31 downto 0));
	end component;
	attribute box_type of okWireIn : component is "black_box";

	component okWireOut port (
		okHE       : in  std_logic_vector(112 downto 0);
		okEH       : out std_logic_vector(64 downto 0);
		ep_addr    : in  std_logic_vector(7 downto 0);
		ep_datain  : in  std_logic_vector(31 downto 0));
	end component;
	attribute box_type of okWireOut : component is "black_box";

	component okTriggerIn port (
		okHE       : in  std_logic_vector(112 downto 0);
		ep_addr    : in  std_logic_vector(7 downto 0);
		ep_clk     : in  std_logic;
		ep_trigger : out std_logic_vector(31 downto 0));
	end component;
	attribute box_type of okTriggerIn : component is "black_box";

	component okTriggerOut port (
		okHE       : in  std_logic_vector(112 downto 0);
		okEH       : out std_logic_vector(64 downto 0);
		ep_addr    : in  std_logic_vector(7 downto 0);
		ep_clk     : in  std_logic;
		ep_trigger : in  std_logic_vector(31 downto 0));
	end component;
	attribute box_type of okTriggerOut : component is "black_box";

	component okPipeIn port (
		okHE       : in  std_logic_vector(112 downto 0);
		okEH       : out std_logic_vector(64 downto 0);
		ep_addr    : in  std_logic_vector(7 downto 0);
		ep_write   : out std_logic;
		ep_dataout : out std_logic_vector(31 downto 0));
	end component;
	attribute box_type of okPipeIn : component is "black_box";

	component okPipeOut port (
		okHE       : in  std_logic_vector(112 downto 0);
		okEH       : out std_logic_vector(64 downto 0);
		ep_addr    : in  std_logic_vector(7 downto 0);
		ep_read    : out std_logic;
		ep_datain  : in  std_logic_vector(31 downto 0));
	end component;
	attribute box_type of okPipeOut : component is "black_box";

	component okBTPipeIn port (
		okHE           : in  std_logic_vector(112 downto 0);
		okEH           : out  std_logic_vector(64 downto 0);
		ep_addr        : in  std_logic_vector(7 downto 0);
		ep_write       : out std_logic;
		ep_blockstrobe : out std_logic;
		ep_dataout     : out std_logic_vector(31 downto 0);
		ep_ready       : in  std_logic);
	end component;
	attribute box_type of okBTPipeIn : component is "black_box";

	component okBTPipeOut port (
		okHE           : in  std_logic_vector(112 downto 0);
		okEH           : out std_logic_vector(64 downto 0);
		ep_addr        : in  std_logic_vector(7 downto 0);
		ep_read        : out std_logic;
		ep_blockstrobe : out std_logic;
		ep_datain      : in  std_logic_vector(31 downto 0);
		ep_ready       : in  std_logic);
	end component;
	attribute box_type of okBTPipeOut : component is "black_box";
	
	component okRegisterBridge port (
		okHE           : in  std_logic_vector(112 downto 0);
		okEH           : out std_logic_vector(64 downto 0);
		ep_address     : out std_logic_vector(31 downto 0);
		ep_write       : out std_logic;
		ep_dataout     : out std_logic_vector(31 downto 0);
		ep_read        : out std_logic;
		ep_datain      : in  std_logic_vector(31 downto 0));
	end component;
	attribute box_type of okRegisterBridge : component is "black_box";

	component okWireOR
	generic (N : integer := 1);
	port (
		okEH   : out std_logic_vector(64 downto 0);
		okEHx  : in  std_logic_vector(N*65-1 downto 0));
	end component;

end FRONTPANEL;
