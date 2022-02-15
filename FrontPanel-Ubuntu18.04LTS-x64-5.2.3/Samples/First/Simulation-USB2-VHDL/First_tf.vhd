--------------------------------------------------------------------------
-- First_tf.vhd
--
-- A simple text fixture example for getting started with FrontPanel
-- simulation.  This sample connects the top-level signals from First.vhd
-- to a call system that, when integrated with Opal Kelly simulation
-- libraries, mimics the functionality of FrontPanel.  Listed below are
-- the procedure and functions that can be called.  They are designed to
-- replicate calls made from the PC via FrontPanel API, Python, Java, DLL,
-- etc.
--
--------------------------------------------------------------------------
-- Copyright (c) 2005-2015 Opal Kelly Incorporated
-- $Rev$ $Date$
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;

library STD;
use std.textio.all;

use work.mappings.all;
use work.parameters.all;

entity FIRST_TEST is
end FIRST_TEST;

architecture sim of FIRST_TEST is

	component First port (
		hi_in       : in    std_logic_vector(7 downto 0);
		hi_out      : out   std_logic_vector(1 downto 0);
		hi_inout    : inout std_logic_vector(15 downto 0);
		led         : out   std_logic_vector(7 downto 0);
		button      : in    std_logic_vector(3 downto 0));
	end component;

	signal hi_in      : std_logic_vector(7 downto 0) := x"00";
	signal hi_out     : std_logic_vector(1 downto 0);
	signal hi_inout   : std_logic_vector(15 downto 0);
	signal led        : std_logic_vector(7 downto 0);
	signal button     : std_logic_vector(3 downto 0) := x"F";

	signal hi_clk     : std_logic;
	signal hi_dataout : std_logic_vector(15 downto 0) := x"0000";

	constant tCK      : time := 10.417 ns;
	
--------------------------------------------------------------------------
-- Begin functional body
--------------------------------------------------------------------------
begin

	dut : First port map (
		hi_in => hi_in,
		hi_out => hi_out,
		hi_inout => hi_inout,
		led => led,
		button => button
	);

	hi_in(0) <= hi_clk;
	hi_inout <= hi_dataout when (hi_in(1) = '1') else (others => 'Z');
	
	-- Clock Generation Process
	hi_clk_gen : process is
	begin
		hi_clk <= '0';
		wait for tCk;
		hi_clk <= '1'; 
		wait for tCk; 
	end process hi_clk_gen;

	--------------------------------------------------------------------------
	-- Begin Simulation Process 
	--------------------------------------------------------------------------
	sim_process : process is

	--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS START PASTE HERE >>>>>>>>>>>>>>>>>>>>-- 
	
		-----------------------------------------------------------------------
		-- User defined data for pipe procedures
		-----------------------------------------------------------------------
		variable BlockDelayStates : integer := 5;  -- REQUIRED: # of clocks between blocks of pipe data
		variable ReadyCheckDelay  : integer := 5;  -- REQUIRED: # of clocks before block transfer before
		                                           --    host interface checks for ready (0-255)
		variable PostReadyDelay   : integer := 5;  -- REQUIRED: # of clocks after ready is asserted and
		                                           --    check that the block transfer begins (0-255)
		variable pipeInSize       : integer := 1024; 
		variable pipeOutSize      : integer := 1024;
	
		-- If you require multiple pipe arrays, you may create more arrays here
		-- duplicate the desired pipe procedures as required, change the names
		-- of the duplicated procedure to a unique identifiers, and alter the
		-- pipe array in that procedure to your newly generated arrays here.
		type PIPEIN_ARRAY is array (0 to pipeInSize - 1) of std_logic_vector(7 downto 0);
		variable pipeIn   : PIPEIN_ARRAY;
	
		type PIPEOUT_ARRAY is array (0 to pipeOutSize - 1) of std_logic_vector(7 downto 0);
		variable pipeOut  : PIPEOUT_ARRAY;
	
		-----------------------------------------------------------------------
		-- Required data for procedures and functions
		-----------------------------------------------------------------------
		type STD_ARRAY is array (0 to 31) of std_logic_vector(15 downto 0);
		variable WireIns, WireOuts, Triggered  :  STD_ARRAY;
	
		constant DNOP                 : std_logic_vector(3 downto 0) := x"0";
		constant DReset               : std_logic_vector(3 downto 0) := x"1";
		constant DUpdateWireIns       : std_logic_vector(3 downto 0) := x"3";
		constant DUpdateWireOuts      : std_logic_vector(3 downto 0) := x"5";
		constant DActivateTriggerIn   : std_logic_vector(3 downto 0) := x"6";
		constant DUpdateTriggerOuts   : std_logic_vector(3 downto 0) := x"7";
		constant DWriteToPipeIn       : std_logic_vector(3 downto 0) := x"9";
		constant DReadFromPipeOut     : std_logic_vector(3 downto 0) := x"a";
		constant DWriteToBlockPipeIn  : std_logic_vector(3 downto 0) := x"b";
		constant DReadFromBlockPipeOut: std_logic_vector(3 downto 0) := x"c";
	
		-----------------------------------------------------------------------
		-- FrontPanelReset
		-----------------------------------------------------------------------
		procedure FrontPanelReset is
			variable i : integer := 0;
		begin
				for i in 31 downto 0 loop
					WireIns(i) := (others => '0');
					WireOuts(i) := (others => '0');
					Triggered(i) := (others => '0');
				end loop;
	
				wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DReset;
				wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DNOP;
				wait until (hi_out(0) = '0');
		end procedure FrontPanelReset;
	
		-----------------------------------------------------------------------
		-- SetWireInValue
		-----------------------------------------------------------------------
		procedure SetWireInValue (
			ep   : in  std_logic_vector(7 downto 0);
			val  : in  std_logic_vector(15 downto 0);
			mask : in  std_logic_vector(15 downto 0)) is
			
			variable tmp_slv16 :     std_logic_vector(15 downto 0);
			variable tmpI      :     integer;
		begin
			tmpI := CONV_INTEGER(ep);
			tmp_slv16 := WireIns(tmpI) and (not mask);
			WireIns(tmpI) := (tmp_slv16 or (val and mask));
		end procedure SetWireInValue;
	
		-----------------------------------------------------------------------
		-- GetWireOutValue
		-----------------------------------------------------------------------
		impure function GetWireOutValue (
			ep : std_logic_vector) return std_logic_vector is
			
			variable tmp_slv16 : std_logic_vector(15 downto 0);
			variable tmpI      : integer;
		begin
			tmpI := CONV_INTEGER(ep);
			tmp_slv16 := WireOuts(tmpI - 16#20#);
			return (tmp_slv16);
		end GetWireOutValue;
	
		-----------------------------------------------------------------------
		-- IsTriggered
		-----------------------------------------------------------------------
		impure function IsTriggered (
			ep   : std_logic_vector;
			mask : std_logic_vector(15 downto 0)) return BOOLEAN is
			
			variable tmp_slv16   : std_logic_vector(15 downto 0);
			variable tmpI        : integer;
			variable msg_line    : line;
		begin
			tmpI := CONV_INTEGER(ep);
			tmp_slv16 := (Triggered(tmpI - 16#60#) and mask);
	
			if (tmp_slv16 >= 0) then
				if (tmp_slv16 = 0) then
					return FALSE;
				else
					return TRUE;
				end if;
			else
				write(msg_line, STRING'("***FRONTPANEL ERROR: IsTriggered mask 0x"));
				hwrite(msg_line, mask);
				write(msg_line, STRING'(" covers unused Triggers"));
				writeline(output, msg_line);
				return FALSE;        
			end if;     
		end IsTriggered;
	
		-----------------------------------------------------------------------
		-- UpdateWireIns
		-----------------------------------------------------------------------
		procedure UpdateWireIns is
			variable i : integer := 0;
		begin
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DUpdateWireIns; wait for 1 ps;
			hi_in(1) <= '1'; wait for 1 ps;
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DNOP; wait for 1 ps;
			for i in 0 to 31 loop
				hi_dataout <= WireIns(i); wait for 1 ps; wait until (rising_edge(hi_clk)); wait for 1 ps;
			end loop;
			wait until (hi_out(0) = '0'); wait for 1 ps; 
		end procedure UpdateWireIns;
	   
		-----------------------------------------------------------------------
		-- UpdateWireOuts
		-----------------------------------------------------------------------
		procedure UpdateWireOuts is
			variable i : integer := 0;
		begin
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DUpdateWireOuts; wait for 1 ps;
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DNOP; wait for 1 ps;
			wait until (rising_edge(hi_clk)); hi_in(1) <= '0'; wait for 1 ps;
			wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk)); wait for 1 ps;
			for i in 0 to 31 loop
				wait until (rising_edge(hi_clk)); WireOuts(i) := hi_inout; wait for 1 ps;
			end loop;
			wait until (hi_out(0) = '0'); wait for 1 ps;
		end procedure UpdateWireOuts;
	
		-----------------------------------------------------------------------
		-- ActivateTriggerIn
		-----------------------------------------------------------------------
		procedure ActivateTriggerIn (
			ep  : in  std_logic_vector(7 downto 0);
			bit : in  integer) is 
			
			variable tmp_slv4 :     std_logic_vector(3 downto 0);
		begin
			tmp_slv4 := CONV_std_logic_vector(bit, 4);
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DActivateTriggerIn;
			hi_in(1) <= '1';
			hi_dataout <= (x"00" & ep);
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DNOP;
			hi_dataout <= SHL(x"0001", tmp_slv4);
			wait until (rising_edge(hi_clk)); hi_dataout <= x"0000";
			wait until (hi_out(0) = '0');
		end procedure ActivateTriggerIn;
	
		-----------------------------------------------------------------------
		-- UpdateTriggerOuts
		-----------------------------------------------------------------------
		procedure UpdateTriggerOuts is
			variable i: integer := 0;
		begin
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DUpdateTriggerOuts;
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DNOP;
			wait until (rising_edge(hi_clk)); hi_in(1) <= '0';
			wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
			wait until (rising_edge(hi_clk));
			
			for i in 0 to (UPDATE_TO_READOUT_CLOCKS-1) loop
					wait until (rising_edge(hi_clk));  
			end loop;
			
			for i in 0 to 31 loop
				wait until (rising_edge(hi_clk)); Triggered(i) := hi_inout;
			end loop;
			wait until (hi_out(0) = '0');
		end procedure UpdateTriggerOuts;
	
		-----------------------------------------------------------------------
		-- WriteToPipeIn
		-----------------------------------------------------------------------
		procedure WriteToPipeIn (
			ep			: in  std_logic_vector(7 downto 0);
			length	: in  integer) is
	
			variable len, i, j, k, blockSize : integer;
			variable tmp_slv8                : std_logic_vector(7 downto 0);
			variable tmp_slv32               : std_logic_vector(31 downto 0);
		begin
			len := (length / 2); j := 0; k := 0; blockSize := 1024;
			tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
			tmp_slv32 := CONV_std_logic_vector(len, 32);
			wait until (rising_edge(hi_clk)); hi_in(1) <= '1';
			hi_in(7 downto 4) <= DWriteToPipeIn;
			hi_dataout <= (tmp_slv8 & ep);
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DNOP;
			hi_dataout <= tmp_slv32(15 downto 0);
			wait until (rising_edge(hi_clk));
			hi_dataout <= tmp_slv32(31 downto 16);
			for i in 0 to len - 1 loop
				wait until (rising_edge(hi_clk));
				hi_dataout(7 downto 0) <= pipeIn(i*2);
				hi_dataout(15 downto 8) <= pipeIn((i*2)+1);
				j := j + 2;
				if (j = blockSize) then
					for k in 0 to BlockDelayStates - 1 loop
						wait until (rising_edge(hi_clk));
					end loop;
					j := 0;
				end if;
			end loop;
			wait until (hi_out(0) = '0');
		end procedure WriteToPipeIn;
	
		-----------------------------------------------------------------------
		-- ReadFromPipeOut
		-----------------------------------------------------------------------
		procedure ReadFromPipeOut (
			ep     : in  std_logic_vector(7 downto 0);
			length : in  integer) is
			
			variable len, i, j, k, blockSize : integer;
			variable tmp_slv8                : std_logic_vector(7 downto 0);
			variable tmp_slv32               : std_logic_vector(31 downto 0);
		begin
			len := (length / 2); j := 0; blockSize := 1024;
			tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
			tmp_slv32 := CONV_std_logic_vector(len, 32);
			wait until (rising_edge(hi_clk)); hi_in(1) <= '1';
			hi_in(7 downto 4) <= DReadFromPipeOut;
			hi_dataout <= (tmp_slv8 & ep);
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DNOP;
			hi_dataout <= tmp_slv32(15 downto 0);
			wait until (rising_edge(hi_clk));
			hi_dataout <= tmp_slv32(31 downto 16);
			wait until (rising_edge(hi_clk));
			hi_in(1) <= '0';
			for i in 0 to len - 1 loop
				wait until (rising_edge(hi_clk));
				pipeOut(i*2) := hi_inout(7 downto 0);
				pipeOut((i*2)+1) := hi_inout(15 downto 8);
				j := j + 2;
				if (j = blockSize) then
					for k in 0 to BlockDelayStates - 1 loop
						wait until (rising_edge(hi_clk));
					end loop;
					j := 0;
				end if;
			end loop;
			wait until (hi_out(0) = '0');
		end procedure ReadFromPipeOut;
	
		-----------------------------------------------------------------------
		-- WriteToBlockPipeIn
		-----------------------------------------------------------------------
		procedure WriteToBlockPipeIn (
			ep          : in std_logic_vector(7 downto 0);
			blockLength : in integer;
			length      : in integer) is
			
			variable len, i, j, k, blockSize, blockNum : integer;
			variable tmp_slv8                          : std_logic_vector(7 downto 0);
			variable tmp_slv16                         : std_logic_vector(15 downto 0);
			variable tmp_slv32                         : std_logic_vector(31 downto 0);
		begin
			len := (length/2); blockSize := (blockLength/2); j := 0; k := 0;
			blockNum := (len/blockSize);
			tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
			tmp_slv32 := CONV_std_logic_vector(len, 32);
			wait until (rising_edge(hi_clk)); hi_in(1) <= '1';
			hi_in(7 downto 4) <= DWriteToBlockPipeIn;
			hi_dataout <= (tmp_slv8 & ep);
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DNOP;
			hi_dataout <= tmp_slv32(15 downto 0);
			wait until (rising_edge(hi_clk)); hi_dataout <= tmp_slv32(31 downto 16);
			tmp_slv16 := CONV_std_logic_vector(blockSize, 16);
			wait until (rising_edge(hi_clk)); hi_dataout <= tmp_slv16;
			wait until (rising_edge(hi_clk));
			tmp_slv16 := (CONV_std_logic_vector(PostReadyDelay, 8) & CONV_std_logic_vector(ReadyCheckDelay, 8));
			hi_dataout <= tmp_slv16;
			for i in 1 to blockNum loop
				while (hi_out(0) = '1') loop wait until (rising_edge(hi_clk)); end loop;
				while (hi_out(0) = '0') loop wait until (rising_edge(hi_clk)); end loop;
				wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
				for j in 1 to blockSize loop
					hi_dataout(7 downto 0) <= pipeIn(k);
					hi_dataout(15 downto 8) <= pipeIn(k+1);
					wait until (rising_edge(hi_clk)); k:=k+2;
				end loop;
				for j in 1 to BlockDelayStates loop 
					wait until (rising_edge(hi_clk)); 
				end loop;
			end loop;
			wait until (hi_out(0) = '0');
		end procedure WriteToBlockPipeIn;
	
		-----------------------------------------------------------------------
		-- ReadFromBlockPipeOut
		-----------------------------------------------------------------------
		procedure ReadFromBlockPipeOut (
			ep          : in std_logic_vector(7 downto 0);
			blockLength : in integer;
			length      : in integer) is
			
			variable len, i, j, k, blockSize, blockNum : integer;
			variable tmp_slv8                          : std_logic_vector(7 downto 0);
			variable tmp_slv16                         : std_logic_vector(15 downto 0);
			variable tmp_slv32                         : std_logic_vector(31 downto 0);
		begin
			len := (length/2); blockSize := (blockLength/2); j := 0; k := 0;
			blockNum := (len/blockSize);
			tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
			tmp_slv32 := CONV_std_logic_vector(len, 32);
			wait until (rising_edge(hi_clk));
			hi_in(1) <= '1';
			hi_in(7 downto 4) <= DReadFromBlockPipeOut;
			hi_dataout <= (tmp_slv8 & ep);
			wait until (rising_edge(hi_clk)); hi_in(7 downto 4) <= DNOP;
			hi_dataout <= tmp_slv32(15 downto 0);
			wait until (rising_edge(hi_clk)); hi_dataout <= tmp_slv32(31 downto 16);
			tmp_slv16 := CONV_std_logic_vector(blockSize, 16);
			wait until (rising_edge(hi_clk)); hi_dataout <= tmp_slv16;
			wait until (rising_edge(hi_clk));
			tmp_slv16 := (CONV_std_logic_vector(PostReadyDelay, 8) & CONV_std_logic_vector(ReadyCheckDelay, 8));
			hi_dataout <= tmp_slv16;
			wait until (rising_edge(hi_clk)); hi_in(1) <= '0';
			for i in 1 to blockNum loop
				while (hi_out(0) = '1') loop wait until (rising_edge(hi_clk)); end loop;
				while (hi_out(0) = '0') loop wait until (rising_edge(hi_clk)); end loop;
				wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
				for j in 1 to blockSize loop
					pipeOut(k) := hi_inout(7 downto 0); pipeOut(k+1) := hi_inout(15 downto 8);
					wait until (rising_edge(hi_clk)); k:=k+2;
				end loop;
				for j in 1 to BlockDelayStates loop wait until (rising_edge(hi_clk)); end loop;
			end loop;
			wait until (hi_out(0) = '0');
		end procedure ReadFromBlockPipeOut;
	
		-----------------------------------------------------------------------
		-- Available User Task and Function Calls:
		--    FrontPanelReset;              -- Always start routine with FrontPanelReset;
		--    SetWireInValue(ep, val, mask);
		--    UpdateWireIns;
		--    UpdateWireOuts;
		--    GetWireOutValue(ep);          -- returns a 16 bit SLV
		--    ActivateTriggerIn(ep, bit);   -- bit is an integer 0-15
		--    UpdateTriggerOuts;
		--    IsTriggered(ep, mask);        -- returns a BOOLEAN
		--    WriteToPipeIn(ep, length);    -- pass pipeIn array data; length is integer
		--    ReadFromPipeOut(ep, length);  -- pass data to pipeOut array; length is integer
		--    WriteToBlockPipeIn(ep, blockSize, length);   -- pass pipeIn array data; blockSize and length are integers
		--    ReadFromBlockPipeOut(ep, blockSize, length); -- pass data to pipeOut array; blockSize and length are integers
		--
		-- *  Pipes operate by passing arrays of data back and forth to the user's
		--    design.  If you need multiple arrays, you can create a new procedure
		--    above and connect it to a differnet array.  More information is
		--    available in Opal Kelly documentation and online support tutorial.
		-----------------------------------------------------------------------

	--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS END PASTE HERE >>>>>>>>>>>>>>>>>>>>>>-- 
	
		variable msg_line           : line;     -- type defined in textio.vhd
		variable k                  : integer;
		variable  r1, r2, exp, sum  : std_logic_vector(15 downto 0) := x"0000";
		
		begin
			FrontPanelReset;                      -- Start routine with FrontPanelReset;
			
			r1 := x"0123";
			r2 := x"0000";
	    wait for 1 ns;
			--------------------------------------------------------------------
			-- Sample procedure and function operations
			--    We'll generate changing numbers, send them to the DUT using
			--    simulated FrontPanel API calls and pull out the result of the 
			--    DUT 'add' function.  We will also automate the verification 
			--    process.
			--------------------------------------------------------------------
			for k in 0 to 3 loop
				-- Set the two ADDER inputs to changing 16-bit values.
				r1 := r1 + x"1111";
				r2 := r2 + x"2222";
				wait for 1 ns;
				exp := r1 + r2;
				SetWireInValue(x"01", r1, x"ffff");   -- FRONTPANEL API
				SetWireInValue(x"02", r2, x"ffff");   -- FRONTPANEL API
				UpdateWireIns;                        -- FRONTPANEL API
	
				-- The ADDER result will be ready.  UpdateWireOuts to get it.
				UpdateWireOuts;                   -- FRONTPANEL API
				sum := GetWireOutValue(x"21");    -- FRONTPANEL API
				if (exp = sum) then
					write(msg_line, STRING'("SUCCESS -- Expected: 0x"));
					hwrite(msg_line, exp);
					write(msg_line, STRING'("   Received: 0x"));
					hwrite(msg_line, sum);
					write(msg_line, STRING'(" at time "));
					write(msg_line, now);
					
					writeline(output, msg_line);
				else
					write(msg_line, STRING'("FAILURE -- Expected: 0x"));
					hwrite(msg_line, exp);
					write(msg_line, STRING'("   Received: 0x"));
					hwrite(msg_line, sum);
					write(msg_line, STRING'(" at time "));
					write(msg_line, now);
					
					writeline(output, msg_line);
				end if;
			end loop;
			
			wait;
	end process;

end sim;
