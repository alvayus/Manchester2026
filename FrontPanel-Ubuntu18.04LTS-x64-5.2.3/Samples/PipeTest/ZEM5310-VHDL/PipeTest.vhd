--------------------------------------------------------------------------
-- PipeTest.vhd
--
-- This is simple HDL that implements barebones PipeIn and PipeOut 
-- functionality.  The logic generates and compares againt a pseudorandom 
-- sequence of data as a way to verify transfer integrity and benchmark the pipe 
-- transfer speeds.
--
-- Copyright (c) 2005-2010  Opal Kelly Incorporated
-- $Rev: 6 $ $Date: 2014-05-02 08:45:29 -0700 (Fri, 02 May 2014) $
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;
use work.FRONTPANEL.all;

entity PipeTest is
	generic (
		-- Capability bitfield, used to indicate features supported by this bitfile
		-- [0] - Fixed pattern feature
		CAPABILITY : STD_LOGIC_VECTOR(31 downto 0) := x"00000001"
	);
	port (
		okUH      : in     STD_LOGIC_VECTOR(4 downto 0);
		okHU      : out    STD_LOGIC_VECTOR(2 downto 0);
		okUHU     : inout  STD_LOGIC_VECTOR(31 downto 0);
		okAA      : inout  STD_LOGIC;
		
		led       : out    STD_LOGIC_VECTOR(3 downto 0)
	);
end PipeTest;

architecture arch of PipeTest is

  component pipe_in_check port (
		clk           : in  STD_LOGIC;
		reset         : in  STD_LOGIC;
		pipe_in_write : in  STD_LOGIC;
		pipe_in_data  : in  STD_LOGIC_VECTOR(31 downto 0);
		pipe_in_ready : out STD_LOGIC;
		throttle_set  : in  STD_LOGIC;
		throttle_val  : in  STD_LOGIC_VECTOR(31 downto 0);
		fixed_pattern : in  STD_LOGIC_VECTOR(31 downto 0);
		pattern       : in  STD_LOGIC_VECTOR(2 downto 0);
		error_count   : out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	
  component pipe_out_check port (
		clk            : in  STD_LOGIC;
		reset          : in  STD_LOGIC;
		pipe_out_read  : in  STD_LOGIC;
		pipe_out_data  : out STD_LOGIC_VECTOR(31 downto 0);
		pipe_out_ready : out STD_LOGIC;
		throttle_set   : in  STD_LOGIC;
		throttle_val   : in  STD_LOGIC_VECTOR(31 downto 0);
		fixed_pattern : in  STD_LOGIC_VECTOR(31 downto 0);
		pattern        : in  STD_LOGIC_VECTOR(2 downto 0));
	end component;
  
	signal okClk      : STD_LOGIC;
	signal okHE       : STD_LOGIC_VECTOR(112 downto 0);
	signal okEH       : STD_LOGIC_VECTOR(64 downto 0);
	signal okEHx      : STD_LOGIC_VECTOR(65*6-1 downto 0);

  -- Endpoint connections:
	signal ep00wire        : STD_LOGIC_VECTOR(31 downto 0);
	signal ep20wire        : STD_LOGIC_VECTOR(31 downto 0);
	signal ep3fwire        : STD_LOGIC_VECTOR(31 downto 0);
	signal throttle_in     : STD_LOGIC_VECTOR(31 downto 0);
	signal throttle_out    : STD_LOGIC_VECTOR(31 downto 0);
	signal fixed_pattern   : STD_LOGIC_VECTOR(31 downto 0);
	signal rcv_errors      : STD_LOGIC_VECTOR(31 downto 0);

	signal pipe_in_write   : STD_LOGIC;
	signal pipe_in_ready   : STD_LOGIC;
	signal pipe_in_data    : STD_LOGIC_VECTOR(31 downto 0);
	
	signal pipe_out_read   : STD_LOGIC;
	signal pipe_out_ready  : STD_LOGIC;
	signal pipe_out_data   : STD_LOGIC_VECTOR(31 downto 0);
	
	signal bs_in, bs_out   : STD_LOGIC;
	signal mode_select     : STD_LOGIC_VECTOR(2 downto 0);

begin

led(3)       <= '0' when (rcv_errors(3) = '1') else 'Z';
led(2)       <= '0' when (rcv_errors(2) = '1') else 'Z';
led(1)       <= '0' when (rcv_errors(1) = '1') else 'Z';
led(0)       <= '0' when (rcv_errors(0) = '1') else 'Z';

mode_select <= ep00wire(4 downto 2);
ep20wire <= x"12345678";
ep3fwire <= x"beeff00d";

-- Pipe In
pic0 : pipe_in_check port map( clk            => okClk,
                               reset          => ep00wire(0),
                               pipe_in_write  => pipe_in_write,
                               pipe_in_data   => pipe_in_data,
                               pipe_in_ready  => pipe_in_ready,
                               throttle_set   => ep00wire(1),
                               throttle_val   => throttle_in,
                               fixed_pattern  => fixed_pattern,
                               pattern        => mode_select,
                               error_count    => rcv_errors
                             );
-- Pipe Out
poc0 : pipe_out_check port map( clk           => okClk,
                               reset          => ep00wire(0),
                               pipe_out_read  => pipe_out_read,
                               pipe_out_data  => pipe_out_data,
                               pipe_out_ready => pipe_out_ready,
                               throttle_set   => ep00wire(1),
                               throttle_val   => throttle_out,
                               fixed_pattern  => fixed_pattern,
                               pattern        => mode_select
                             );
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

okWO : okWireOR     generic map (N=>6) port map (okEH=>okEH, okEHx=>okEHx);

wi00 : okWireIn    port map (okHE=>okHE,                                     ep_addr=>x"00", ep_dataout=>ep00wire);
wi01 : okWireIn    port map (okHE=>okHE,                                     ep_addr=>x"01", ep_dataout=>throttle_out);
wi02 : okWireIn    port map (okHE=>okHE,                                     ep_addr=>x"02", ep_dataout=>throttle_in);
wi03 : okWireIn    port map (okHE=>okHE,                                     ep_addr=>x"03", ep_dataout=>fixed_pattern);
wo20 : okWireOut   port map (okHE=>okHE, okEH=>okEHx( 1*65-1 downto 0*65 ),  ep_addr=>x"20", ep_datain=>ep20wire);
wo21 : okWireOut   port map (okHE=>okHE, okEH=>okEHx( 2*65-1 downto 1*65 ),  ep_addr=>x"21", ep_datain=>rcv_errors);
wo3e : okWireOut   port map (okHE=>okHE, okEH=>okEHx( 3*65-1 downto 2*65 ),  ep_addr=>x"3e", ep_datain=>CAPABILITY);
wo3f : okWireOut   port map (okHE=>okHE, okEH=>okEHx( 4*65-1 downto 3*65 ),  ep_addr=>x"3f", ep_datain=>ep3fwire);
ep80 : okBTPipeIn  port map (okHE=>okHE, okEH=>okEHx( 5*65-1 downto 4*65 ),  ep_addr=>x"80", 
                             ep_write=>pipe_in_write, ep_blockstrobe=>bs_in, ep_dataout=>pipe_in_data, ep_ready=>pipe_in_ready);
epA0 : okBTPipeOut port map (okHE=>okHE, okEH=>okEHx( 6*65-1 downto 5*65 ),  ep_addr=>x"A0", 
                             ep_read=>pipe_out_read, ep_blockstrobe=>bs_out, ep_datain=>pipe_out_data, ep_ready=>pipe_out_ready);

end arch;
