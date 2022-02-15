--------------------------------------------------------------------------
-- PipeTest.vhd
--
-- This is simple HDL that implements barebones PipeIn and PipeOut 
-- functionality.  The logic generates and compares againt a pseudorandom 
-- sequence of data as a way to verify transfer integrity and benchmark the pipe 
-- transfer speeds.
--
-- Copyright (c) 2005-2010  Opal Kelly Incorporated
-- $Rev$ $Date$
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;
use work.FRONTPANEL.all;

library UNISIM;
use UNISIM.VComponents.all;

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
		okUHs     : in     STD_LOGIC_VECTOR(4 downto 0);
		okHUs     : out    STD_LOGIC_VECTOR(2 downto 0);
		okUHUs    : inout  STD_LOGIC_VECTOR(31 downto 0);
		ok_done   : out    STD_LOGIC;
		okAA      : inout  STD_LOGIC;
		
		led       : out    STD_LOGIC_VECTOR(7 downto 0)
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
	
	signal okClks     : STD_LOGIC;
	signal okHEs      : STD_LOGIC_VECTOR(112 downto 0);
	signal okEHs      : STD_LOGIC_VECTOR(64 downto 0);
	signal okEHxs     : STD_LOGIC_VECTOR(65*6-1 downto 0);

  -- Endpoint connections:
	signal ep00wire          : STD_LOGIC_VECTOR(31 downto 0);
	signal ep20wire          : STD_LOGIC_VECTOR(31 downto 0);
	signal ep3fwire          : STD_LOGIC_VECTOR(31 downto 0);
	signal throttle_in       : STD_LOGIC_VECTOR(31 downto 0);
	signal throttle_out      : STD_LOGIC_VECTOR(31 downto 0);
	signal fixed_pattern     : STD_LOGIC_VECTOR(31 downto 0);
	signal rcv_errors        : STD_LOGIC_VECTOR(31 downto 0);
	
	signal ep00wire_s        : STD_LOGIC_VECTOR(31 downto 0);
	signal ep20wire_s        : STD_LOGIC_VECTOR(31 downto 0);
	signal ep3fwire_s        : STD_LOGIC_VECTOR(31 downto 0);
	signal throttle_in_s     : STD_LOGIC_VECTOR(31 downto 0);
	signal throttle_out_s    : STD_LOGIC_VECTOR(31 downto 0);
	signal fixed_pattern_s   : STD_LOGIC_VECTOR(31 downto 0);
	signal rcv_errors_s      : STD_LOGIC_VECTOR(31 downto 0);

	signal pipe_in_write     : STD_LOGIC;
	signal pipe_in_ready     : STD_LOGIC;
	signal pipe_in_data      : STD_LOGIC_VECTOR(31 downto 0);
	
	signal pipe_in_write_s   : STD_LOGIC;
	signal pipe_in_ready_s   : STD_LOGIC;
	signal pipe_in_data_s    : STD_LOGIC_VECTOR(31 downto 0);
	
	signal pipe_out_read     : STD_LOGIC;
	signal pipe_out_ready    : STD_LOGIC;
	signal pipe_out_data     : STD_LOGIC_VECTOR(31 downto 0);
	
	signal pipe_out_read_s   : STD_LOGIC;
	signal pipe_out_ready_s  : STD_LOGIC;
	signal pipe_out_data_s   : STD_LOGIC_VECTOR(31 downto 0);
	
	signal bs_in, bs_out     : STD_LOGIC;
	signal mode_select       : STD_LOGIC_VECTOR(2 downto 0);
	
	signal bs_in_s, bs_out_s : STD_LOGIC;
	signal mode_select_s     : STD_LOGIC_VECTOR(2 downto 0);

begin

led(7 downto 4) <= rcv_errors_s(3 downto 0);
led(3 downto 0) <= rcv_errors(3 downto 0);

mode_select <= ep00wire(4 downto 2);
mode_select_s <= ep00wire_s(4 downto 2);
ep20wire <= x"12345678";
ep3fwire <= x"beeff00d";
ep20wire_s <= x"12345678";
ep3fwire_s <= x"beeff00d";

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
-- Pipe In - Secondary
pic0_s : pipe_in_check port map( clk              => okClks,
                                 reset            => ep00wire_s(0),
                                 pipe_in_write    => pipe_in_write_s,
                                 pipe_in_data     => pipe_in_data_s,
                                 pipe_in_ready    => pipe_in_ready_s,
                                 throttle_set     => ep00wire_s(1),
                                 throttle_val     => throttle_in_s,
                                 fixed_pattern    => fixed_pattern_s,
                                 pattern          => mode_select_s,
                                 error_count      => rcv_errors_s
                             );
-- Pipe Out - Secondary
poc0_s : pipe_out_check port map( clk            => okClks,
                                  reset          => ep00wire_s(0),
                                  pipe_out_read  => pipe_out_read_s,
                                  pipe_out_data  => pipe_out_data_s,
                                  pipe_out_ready => pipe_out_ready_s,
                                  throttle_set   => ep00wire_s(1),
                                  throttle_val   => throttle_out_s,
                                  fixed_pattern  => fixed_pattern_s,
                                  pattern        => mode_select_s
                                );
-- Instantiate the okHost and connect endpoints
okHI : okHost port map (
	okUH=>okUH, 
	okHU=>okHU, 
	okUHs=>okUHs,
	okHUs=>okHUs,
	okUHU=>okUHU, 
	okUHUs=>okUHUs, 
	okAA=>okAA,
	okClk=>okClk,
	okClks=>okClks,
	okHE=>okHE,
	okEH=>okEH,
	okHEs=>okHEs, 
	okEHs=>okEHs,
	ok_done=>ok_done
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
                             
                             
okWOs : okWireOR     generic map (N=>6) port map (okEH=>okEHs, okEHx=>okEHxs);

wi00s : okWireIn    port map (okHE=>okHEs,                                      ep_addr=>x"00", ep_dataout=>ep00wire_s);
wi01s : okWireIn    port map (okHE=>okHEs,                                      ep_addr=>x"01", ep_dataout=>throttle_out_s);
wi02s : okWireIn    port map (okHE=>okHEs,                                      ep_addr=>x"02", ep_dataout=>throttle_in_s);
wi03s : okWireIn    port map (okHE=>okHEs,                                      ep_addr=>x"03", ep_dataout=>fixed_pattern_s);
wo20s : okWireOut   port map (okHE=>okHEs, okEH=>okEHxs( 1*65-1 downto 0*65 ),  ep_addr=>x"20", ep_datain=>ep20wire_s);
wo21s : okWireOut   port map (okHE=>okHEs, okEH=>okEHxs( 2*65-1 downto 1*65 ),  ep_addr=>x"21", ep_datain=>rcv_errors_s);
wo3es : okWireOut   port map (okHE=>okHEs, okEH=>okEHxs( 3*65-1 downto 2*65 ),  ep_addr=>x"3e", ep_datain=>CAPABILITY);
wo3fs : okWireOut   port map (okHE=>okHEs, okEH=>okEHxs( 4*65-1 downto 3*65 ),  ep_addr=>x"3f", ep_datain=>ep3fwire_s);
ep80s : okBTPipeIn  port map (okHE=>okHEs, okEH=>okEHxs( 5*65-1 downto 4*65 ),  ep_addr=>x"80", 
                             ep_write=>pipe_in_write_s, ep_blockstrobe=>bs_in_s, ep_dataout=>pipe_in_data_s, ep_ready=>pipe_in_ready_s);
epA0s : okBTPipeOut port map (okHE=>okHEs, okEH=>okEHxs( 6*65-1 downto 5*65 ),  ep_addr=>x"A0", 
                             ep_read=>pipe_out_read_s, ep_blockstrobe=>bs_out_s, ep_datain=>pipe_out_data_s, ep_ready=>pipe_out_ready_s);

end arch;
