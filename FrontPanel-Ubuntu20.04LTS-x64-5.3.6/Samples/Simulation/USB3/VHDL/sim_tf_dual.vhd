--------------------------------------------------------------------------------
-- sim_tf.vhd
--
-- Version: USB3
-- Language: VHDL
--
-- A test fixture example that illustrates how to simulate FrontPanel
-- designs.
--
--------------------------------------------------------------------------------
-- Copyright (c) 2005-2023 Opal Kelly Incorporated
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
-- 
-- $Rev: 0 $ $Date: 2014-12-4 16:07:50 -0700 (Thur, 4 Dec 2014) $
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;
use work.FrontPanel.all;

library STD;
use std.textio.all;

use work.mappings.all;
use work.parameters.all;

entity SIM_TEST is
end SIM_TEST;

architecture simulate of SIM_TEST is

	component sim_dual is port(
		okUH  : in    STD_LOGIC_VECTOR (4  downto 0);
		okHU  : out   STD_LOGIC_VECTOR (2  downto 0);
		okUHU : inout STD_LOGIC_VECTOR (31 downto 0);
		okUHs  : in    STD_LOGIC_VECTOR (4  downto 0);
		okHUs  : out   STD_LOGIC_VECTOR (2  downto 0);
		okUHUs : inout STD_LOGIC_VECTOR (31 downto 0);
		led   : out   STD_LOGIC_vector (7  downto 0)
	);
	end component;

	signal led : std_logic_vector(7 downto 0);

	-- FrontPanel Host --------------------------------------------------------------------------

	signal okUH       : std_logic_vector(4 downto 0) := b"00000";
	signal okHU       : std_logic_vector(2 downto 0);
	signal okUHU      : std_logic_vector(31 downto 0);
	signal okUHs      : std_logic_vector(4 downto 0) := b"00000";
	signal okHUs      : std_logic_vector(2 downto 0);
	signal okUHUs     : std_logic_vector(31 downto 0);
	signal okAA       : std_logic;

	---------------------------------------------------------------------------------------------

	-- okHostCalls Simulation Parameters & Signals ----------------------------------------------
	constant tCK        : time := 5 ns; --Half of the hi_clk frequency @ 1ns timing = 100MHz
	constant Tsys_clk   : time := 5 ns; --Half of the hi_clk frequency @ 1ns timing = 100MHz
	
	signal   hi_clk     : std_logic;
	signal   hi_drive   : std_logic := '0';
	signal   hi_cmd     : std_logic_vector(2 downto 0) := "000";
	signal   hi_busy    : std_logic;
	signal   hi_datain  : std_logic_vector(31 downto 0) := x"00000000";
	signal   hi_dataout : std_logic_vector(31 downto 0) := x"00000000";
	signal   hi_clk_s     : std_logic;
	signal   hi_drive_s   : std_logic := '0';
	signal   hi_cmd_s     : std_logic_vector(2 downto 0) := "000";
	signal   hi_busy_s    : std_logic;
	signal   hi_datain_s  : std_logic_vector(31 downto 0) := x"00000000";
	signal   hi_dataout_s : std_logic_vector(31 downto 0) := x"00000000";

	signal sys_clkp   : std_logic;
	signal sys_clkn   : std_logic;

	
	-- Clocks
	signal sys_clk    : std_logic := '0';

	---------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------
	-- Begin functional body
	--------------------------------------------------------------------------
begin

	dut : sim_dual port map (
		okUH => okUH,
		okHU => okHU,
		okUHU => okUHU,
		okUHs => okUHs,
		okHUs => okHUs,
		okUHUs => okUHUs,
		led => led
		);

	-- okHostCalls Simulation okHostCall<->okHost Mapping  --------------------------------------
	okUH(0)          <= hi_clk;
	okUH(1)          <= hi_drive;
	okUH(4 downto 2) <= hi_cmd; 
	hi_datain        <= okUHU;
	hi_busy          <= okHU(0); 
	okUHU            <= hi_dataout when (hi_drive = '1') else (others => 'Z');
	okUHs(0)          <= hi_clk_s;
	okUHs(1)          <= hi_drive_s;
	okUHs(4 downto 2) <= hi_cmd_s; 
	hi_datain_s       <= okUHUs;
	hi_busy_s         <= okHUs(0); 
	okUHUs            <= hi_dataout_s when (hi_drive_s = '1') else (others => 'Z');
	---------------------------------------------------------------------------------------------

	-- Clock Generation
	hi_clk_gen : process is
	begin
		hi_clk <= '0';
		hi_clk_s <= '0';
		wait for tCk;
		hi_clk <= '1'; 
		hi_clk_s <= '1'; 
		wait for tCk; 
	end process hi_clk_gen;

	sys_clk_gen : process is
	begin
		sys_clk <= '0';
		sys_clkp <= '0';
		sys_clkn <= '1';
		wait for Tsys_clk;
		sys_clk <= '1';
		sys_clkp <= '1';
		sys_clkn <= '0'; 
		wait for Tsys_clk; 
	end process sys_clk_gen;
	-- Simulation Process
sim_process : process is

--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS START PASTE HERE >>>>>>>>>>>>>>>>>>>>-- 

	-----------------------------------------------------------------------
	-- User defined data for pipe and register procedures
	-----------------------------------------------------------------------
	variable BlockDelayStates : integer := 5;    -- REQUIRED: # of clocks between blocks of pipe data
	variable ReadyCheckDelay  : integer := 5;    -- REQUIRED: # of clocks before block transfer before
	                                             --    host interface checks for ready (0-255)
	variable PostReadyDelay   : integer := 5;    -- REQUIRED: # of clocks after ready is asserted and
	                                             --    check that the block transfer begins (0-255)
	variable pipeInSize       : integer := 1024; -- REQUIRED: byte (must be even) length of default
                                               --    PipeIn; Integer 0-2^32
	variable pipeOutSize      : integer := 1024; -- REQUIRED: byte (must be even) length of default
                                               --    PipeOut; Integer 0-2^32
	variable registerSetSize  : integer := 32;   -- Size of array for register set commands.
                                                                                            
	-----------------------------------------------------------------------
	-- Required data for procedures and functions
	-----------------------------------------------------------------------
	-- If you require multiple pipe arrays, you may create more arrays here
	-- duplicate the desired pipe procedures as required, change the names
	-- of the duplicated procedure to a unique identifiers, and alter the
	-- pipe array in that procedure to your newly generated arrays here.
	type PIPEIN_ARRAY is array (0 to pipeInSize - 1) of std_logic_vector(7 downto 0);
	variable pipeIn   : PIPEIN_ARRAY;

	type PIPEOUT_ARRAY is array (0 to pipeOutSize - 1) of std_logic_vector(7 downto 0);
	variable pipeOut  : PIPEOUT_ARRAY;

	type STD_ARRAY is array (0 to 31) of std_logic_vector(31 downto 0);
	variable WireIns    :  STD_ARRAY; -- 32x32 array storing WireIn values
	variable WireOuts   :  STD_ARRAY; -- 32x32 array storing WireOut values 
  	variable Triggered  :  STD_ARRAY; -- 32x32 array storing IsTriggered values
	
	type REGISTER_ARRAY is array (0 to registerSetSize - 1) of std_logic_vector(31 downto 0);
	variable u32Address  : REGISTER_ARRAY;
	variable u32Data     : REGISTER_ARRAY;
	variable u32Count    : std_logic_vector(31 downto 0);
	variable ReadRegisterData    : std_logic_vector(31 downto 0);
	
	constant DNOP                  : std_logic_vector(2 downto 0) := "000";
	constant DReset                : std_logic_vector(2 downto 0) := "001";
	constant DWires                : std_logic_vector(2 downto 0) := "010";
	constant DUpdateWireIns        : std_logic_vector(2 downto 0) := "001";
	constant DUpdateWireOuts       : std_logic_vector(2 downto 0) := "010";
	constant DTriggers             : std_logic_vector(2 downto 0) := "011";
	constant DActivateTriggerIn    : std_logic_vector(2 downto 0) := "001";
	constant DUpdateTriggerOuts    : std_logic_vector(2 downto 0) := "010";
	constant DPipes                : std_logic_vector(2 downto 0) := "100";
	constant DWriteToPipeIn        : std_logic_vector(2 downto 0) := "001";
	constant DReadFromPipeOut      : std_logic_vector(2 downto 0) := "010";
	constant DWriteToBlockPipeIn   : std_logic_vector(2 downto 0) := "011";
	constant DReadFromBlockPipeOut : std_logic_vector(2 downto 0) := "100";
	constant DRegisters            : std_logic_vector(2 downto 0) := "101";
	constant DWriteRegister        : std_logic_vector(2 downto 0) := "001";
	constant DReadRegister         : std_logic_vector(2 downto 0) := "010";
	constant DWriteRegisterSet     : std_logic_vector(2 downto 0) := "011";
	constant DReadRegisterSet      : std_logic_vector(2 downto 0) := "100";

	-----------------------------------------------------------------------
	-- FrontPanelReset
	-----------------------------------------------------------------------
	procedure FrontPanelReset is
		variable i : integer := 0;
		variable msg_line           : line;
	begin
			for i in 31 downto 0 loop
				WireIns(i) := (others => '0');
				WireOuts(i) := (others => '0');
				Triggered(i) := (others => '0');
			end loop;
			wait until (rising_edge(hi_clk)); hi_cmd <= DReset;
			wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
			wait until (hi_busy = '0');
	end procedure FrontPanelReset;

	-----------------------------------------------------------------------
	-- SetWireInValue
	-----------------------------------------------------------------------
	procedure SetWireInValue (
		ep   : in  std_logic_vector(7 downto 0);
		val  : in  std_logic_vector(31 downto 0);
		mask : in  std_logic_vector(31 downto 0)) is
		
		variable tmp_slv32 :     std_logic_vector(31 downto 0);
		variable tmpI      :     integer;
	begin
		tmpI := CONV_INTEGER(ep);
		tmp_slv32 := WireIns(tmpI) and (not mask);
		WireIns(tmpI) := (tmp_slv32 or (val and mask));
	end procedure SetWireInValue;

	-----------------------------------------------------------------------
	-- GetWireOutValue
	-----------------------------------------------------------------------
	impure function GetWireOutValue (
		ep : std_logic_vector) return std_logic_vector is
		
		variable tmp_slv32 : std_logic_vector(31 downto 0);
		variable tmpI      : integer;
	begin
		tmpI := CONV_INTEGER(ep);
		tmp_slv32 := WireOuts(tmpI - 16#20#);
		return (tmp_slv32);
	end GetWireOutValue;

	-----------------------------------------------------------------------
	-- IsTriggered
	-----------------------------------------------------------------------
	impure function IsTriggered (
		ep   : std_logic_vector;
		mask : std_logic_vector(31 downto 0)) return BOOLEAN is
		
		variable tmp_slv32   : std_logic_vector(31 downto 0);
		variable tmpI        : integer;
		variable msg_line    : line;
	begin
		tmpI := CONV_INTEGER(ep);
		tmp_slv32 := (Triggered(tmpI - 16#60#) and mask);

		if (tmp_slv32 >= 0) then
			if (tmp_slv32 = 0) then
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
		wait until (rising_edge(hi_clk)); hi_cmd <= DWires; 
		wait until (rising_edge(hi_clk)); hi_cmd <= DUpdateWireIns; 
		wait until (rising_edge(hi_clk));
		hi_drive <= '1'; 
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP; 
		for i in 0 to 31 loop
			hi_dataout <= WireIns(i);  wait until (rising_edge(hi_clk)); 
		end loop;
		wait until (hi_busy = '0');  
	end procedure UpdateWireIns;
   
	-----------------------------------------------------------------------
	-- UpdateWireOuts
	-----------------------------------------------------------------------
	procedure UpdateWireOuts is
		variable i : integer := 0;
	begin
		wait until (rising_edge(hi_clk)); hi_cmd <= DWires; 
		wait until (rising_edge(hi_clk)); hi_cmd <= DUpdateWireOuts; 
		wait until (rising_edge(hi_clk));
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP; 
		wait until (rising_edge(hi_clk)); hi_drive <= '0'; 
		wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk)); 
		for i in 0 to 31 loop
			wait until (rising_edge(hi_clk)); WireOuts(i) := hi_datain; 
		end loop;
		wait until (hi_busy = '0'); 
	end procedure UpdateWireOuts;

	-----------------------------------------------------------------------
	-- ActivateTriggerIn
	-----------------------------------------------------------------------
	procedure ActivateTriggerIn (
		ep  : in  std_logic_vector(7 downto 0);
		bit : in  integer) is 
		
		variable tmp_slv5 :     std_logic_vector(4 downto 0);
	begin
		tmp_slv5 := CONV_std_logic_vector(bit, 5);
		wait until (rising_edge(hi_clk)); hi_cmd <= DTriggers;
		wait until (rising_edge(hi_clk)); hi_cmd <= DActivateTriggerIn;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_dataout <= (x"000000" & ep);
		wait until (rising_edge(hi_clk)); hi_dataout <= SHL(x"00000001", tmp_slv5); 
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= x"00000000";
		wait until (hi_busy = '0');
	end procedure ActivateTriggerIn;

	-----------------------------------------------------------------------
	-- UpdateTriggerOuts
	-----------------------------------------------------------------------
	procedure UpdateTriggerOuts is
	begin
		wait until (rising_edge(hi_clk)); hi_cmd <= DTriggers;
		wait until (rising_edge(hi_clk)); hi_cmd <= DUpdateTriggerOuts;
		wait until (rising_edge(hi_clk));
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_drive <= '0';
		wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
		wait until (rising_edge(hi_clk));
		
		for i in 0 to (UPDATE_TO_READOUT_CLOCKS-1) loop
				wait until (rising_edge(hi_clk));  
		end loop;
		
		for i in 0 to 31 loop
			wait until (rising_edge(hi_clk)); Triggered(i) := hi_datain;
		end loop;
		wait until (hi_busy = '0');
	end procedure UpdateTriggerOuts;

	-----------------------------------------------------------------------
	-- WriteToPipeIn
	-----------------------------------------------------------------------
	procedure WriteToPipeIn (
		ep      : in  std_logic_vector(7 downto 0);
		length  : in  integer) is

		variable len, i, j, k, blockSize : integer;
		variable tmp_slv8                : std_logic_vector(7 downto 0);
		variable tmp_slv32               : std_logic_vector(31 downto 0);
	begin
		len := (length / 4); j := 0; k := 0; blockSize := 1024;
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk)); hi_cmd <= DPipes;
		wait until (rising_edge(hi_clk)); hi_cmd <= DWriteToPipeIn;
		wait until (rising_edge(hi_clk)); 
		hi_drive <= '1';
		hi_dataout <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		hi_dataout <= tmp_slv32;
		for i in 0 to len - 1 loop
			wait until (rising_edge(hi_clk));
			hi_dataout(7 downto 0) <= pipeIn(i*4);
			hi_dataout(15 downto 8) <= pipeIn((i*4)+1);
			hi_dataout(23 downto 16) <= pipeIn((i*4)+2);
			hi_dataout(31 downto 24) <= pipeIn((i*4)+3);
			j := j + 4;
			if (j = blockSize) then
				for k in 0 to BlockDelayStates - 1 loop
					wait until (rising_edge(hi_clk));
				end loop;
				j := 0;
			end if;
		end loop;
		wait until (hi_busy = '0');
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
		len := (length / 4); j := 0; blockSize := 1024;
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk)); hi_cmd <= DPipes;
		wait until (rising_edge(hi_clk)); hi_cmd <= DReadFromPipeOut;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_dataout <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		hi_dataout <= tmp_slv32;
		wait until (rising_edge(hi_clk));
		hi_drive <= '0';
		for i in 0 to len - 1 loop
			wait until (rising_edge(hi_clk));
			pipeOut(i*4) := hi_datain(7 downto 0);
			pipeOut((i*4)+1) := hi_datain(15 downto 8);
			pipeOut((i*4)+2) := hi_datain(23 downto 16);
			pipeOut((i*4)+3) := hi_datain(31 downto 24);
			j := j + 4;
			if (j = blockSize) then
				for k in 0 to BlockDelayStates - 1 loop
					wait until (rising_edge(hi_clk));
				end loop;
				j := 0;
			end if;
		end loop;
		wait until (hi_busy = '0');
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
		len := (length/4); blockSize := (blockLength/4); j := 0; k := 0;
		blockNum := (len/blockSize);
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv16 := CONV_std_logic_vector(blockSize, 16);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk)); hi_cmd <= DPipes;
		wait until (rising_edge(hi_clk)); hi_cmd <= DWriteToBlockPipeIn;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_dataout <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		hi_dataout <= tmp_slv32;
		wait until (rising_edge(hi_clk)); hi_dataout <= x"0000" & tmp_slv16;
		wait until (rising_edge(hi_clk));
		tmp_slv16 := (CONV_std_logic_vector(PostReadyDelay, 8) & CONV_std_logic_vector(ReadyCheckDelay, 8));
		hi_dataout <= x"0000" & tmp_slv16;
		for i in 1 to blockNum loop
			while (hi_busy = '1') loop wait until (rising_edge(hi_clk)); end loop;
			while (hi_busy = '0') loop wait until (rising_edge(hi_clk)); end loop;
			wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
			for j in 1 to blockSize loop
				hi_dataout(7 downto 0) <= pipeIn(k);
				hi_dataout(15 downto 8) <= pipeIn(k+1);
				hi_dataout(23 downto 16) <= pipeIn(k+2);
				hi_dataout(31 downto 24) <= pipeIn(k+3);
				wait until (rising_edge(hi_clk)); k:=k+4;
			end loop;
			for j in 1 to BlockDelayStates loop 
				wait until (rising_edge(hi_clk)); 
			end loop;
		end loop;
		wait until (hi_busy = '0');
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
		len := (length/4); blockSize := (blockLength/4); j := 0; k := 0;
		blockNum := (len/blockSize);
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv16 := CONV_std_logic_vector(blockSize, 16);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk)); hi_cmd <= DPipes;
		wait until (rising_edge(hi_clk)); hi_cmd <= DReadFromBlockPipeOut;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_dataout <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		hi_dataout <= tmp_slv32;
		wait until (rising_edge(hi_clk)); hi_dataout <= x"0000" & tmp_slv16;
		wait until (rising_edge(hi_clk));
		tmp_slv16 := (CONV_std_logic_vector(PostReadyDelay, 8) & CONV_std_logic_vector(ReadyCheckDelay, 8));
		hi_dataout <= x"0000" & tmp_slv16;
		wait until (rising_edge(hi_clk)); hi_drive <= '0';
		for i in 1 to blockNum loop
			while (hi_busy = '1') loop wait until (rising_edge(hi_clk)); end loop;
			while (hi_busy = '0') loop wait until (rising_edge(hi_clk)); end loop;
			wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
			for j in 1 to blockSize loop
				pipeOut(k) := hi_datain(7 downto 0); 
				pipeOut(k+1) := hi_datain(15 downto 8);
				pipeOut(k+2) := hi_datain(23 downto 16);
				pipeOut(k+3) := hi_datain(31 downto 24);
				wait until (rising_edge(hi_clk)); k:=k+4;
			end loop;
			for j in 1 to BlockDelayStates loop wait until (rising_edge(hi_clk)); end loop;
		end loop;
		wait until (hi_busy = '0');
	end procedure ReadFromBlockPipeOut;
	
	-----------------------------------------------------------------------
	-- WriteRegister
	-----------------------------------------------------------------------
	procedure WriteRegister (
		address  : in  std_logic_vector(31 downto 0);
		data     : in  std_logic_vector(31 downto 0)) is
	begin
		wait until (rising_edge(hi_clk)); hi_cmd <= DRegisters;
		wait until (rising_edge(hi_clk)); hi_cmd <= DWriteRegister;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= address; 
		wait until (rising_edge(hi_clk)); hi_dataout <= data;
		wait until (hi_busy = '0'); hi_drive <= '0';  
	end procedure WriteRegister;
	
	-----------------------------------------------------------------------
	-- ReadRegister
	-----------------------------------------------------------------------
	procedure ReadRegister (
		address  : in  std_logic_vector(31 downto 0);
		data     : out std_logic_vector(31 downto 0)) is
	begin
		wait until (rising_edge(hi_clk)); hi_cmd <= DRegisters;
		wait until (rising_edge(hi_clk)); hi_cmd <= DReadRegister;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= address; 
		wait until (rising_edge(hi_clk)); hi_drive <= '0';
		wait until (rising_edge(hi_clk));
		wait until (rising_edge(hi_clk)); data := hi_datain;
		wait until (hi_busy = '0');
	end procedure ReadRegister;
	
	
	-----------------------------------------------------------------------
	-- WriteRegisterSet
	-----------------------------------------------------------------------
	procedure WriteRegisterSet is
		variable i             :     integer;
		variable u32Count_int  :     integer;
	begin
	  u32Count_int := CONV_INTEGER(u32Count);
		wait until (rising_edge(hi_clk)); hi_cmd <= DRegisters;
		wait until (rising_edge(hi_clk)); hi_cmd <= DWriteRegisterSet;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= u32Count; 
		for i in 1 to u32Count_int loop
			wait until (rising_edge(hi_clk)); hi_dataout <= u32Address(i-1);
			wait until (rising_edge(hi_clk)); hi_dataout <= u32Data(i-1);
			wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
		end loop;
		wait until (hi_busy = '0'); hi_drive <= '0';  
	end procedure WriteRegisterSet;
	
	-----------------------------------------------------------------------
	-- ReadRegisterSet
	-----------------------------------------------------------------------
	procedure ReadRegisterSet is
		variable i             :     integer;
		variable u32Count_int  :     integer;
	begin
	  u32Count_int := CONV_INTEGER(u32Count);
		wait until (rising_edge(hi_clk)); hi_cmd <= DRegisters;
		wait until (rising_edge(hi_clk)); hi_cmd <= DReadRegisterSet;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= u32Count; 
		for i in 1 to u32Count_int loop
			wait until (rising_edge(hi_clk)); hi_dataout <= u32Address(i-1);
			wait until (rising_edge(hi_clk)); hi_drive <= '0'; 
			wait until (rising_edge(hi_clk)); 
			wait until (rising_edge(hi_clk)); u32Data(i-1) := hi_datain;
			hi_drive <= '1';
		end loop;
		wait until (hi_busy = '0');
	end procedure ReadRegisterSet;
	
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
	--    WriteRegister(addr, data);  
	--    ReadRegister(addr, data);
	--    WriteRegisterSet();  
	--    ReadRegisterSet();
	--
	-- *  Pipes operate by passing arrays of data back and forth to the user's
	--    design.  If you need multiple arrays, you can create a new procedure
	--    above and connect it to a differnet array.  More information is
	--    available in Opal Kelly documentation and online support tutorial.
	-----------------------------------------------------------------------

--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS END PASTE HERE >>>>>>>>>>>>>>>>>>>>>>--
--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS SECONDARY START PASTE HERE >>>>>>>>>>>>>>>>>>>>-- 
		-----------------------------------------------------------------------
	-- Required data for procedures and functions
	-----------------------------------------------------------------------
	-- If you require multiple pipe arrays, you may create more arrays here
	-- duplicate the desired pipe procedures as required, change the names
	-- of the duplicated procedure to a unique identifiers, and alter the
	-- pipe array in that procedure to your newly generated arrays here.
	variable pipeIn_s   : PIPEIN_ARRAY;

	variable pipeOut_s  : PIPEOUT_ARRAY;

	variable WireIns_s    :  STD_ARRAY; -- 32x32 array storing WireIn values
	variable WireOuts_s   :  STD_ARRAY; -- 32x32 array storing WireOut values 
	variable Triggered_s  :  STD_ARRAY; -- 32x32 array storing IsTriggered values
	
	variable u32Address_s  : REGISTER_ARRAY;
	variable u32Data_s     : REGISTER_ARRAY;
	variable u32Count_s    : std_logic_vector(31 downto 0);
	variable ReadRegisterData_s    : std_logic_vector(31 downto 0);

	-----------------------------------------------------------------------
	-- FrontPanelResetSecondary
	-----------------------------------------------------------------------
	procedure FrontPanelResetSecondary is
		variable i : integer := 0;
		variable msg_line           : line;
	begin
			for i in 31 downto 0 loop
				WireIns_s(i) := (others => '0');
				WireOuts_s(i) := (others => '0');
				Triggered_s(i) := (others => '0');
			end loop;
			wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DReset;
			wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DNOP;
			wait until (hi_busy_s = '0');
	end procedure FrontPanelResetSecondary;

	-----------------------------------------------------------------------
	-- SetWireInValueSecondary
	-----------------------------------------------------------------------
	procedure SetWireInValueSecondary (
		ep   : in  std_logic_vector(7 downto 0);
		val  : in  std_logic_vector(31 downto 0);
		mask : in  std_logic_vector(31 downto 0)) is
		
		variable tmp_slv32 :     std_logic_vector(31 downto 0);
		variable tmpI      :     integer;
	begin
		tmpI := CONV_INTEGER(ep);
		tmp_slv32 := WireIns_s(tmpI) and (not mask);
		WireIns_s(tmpI) := (tmp_slv32 or (val and mask));
	end procedure SetWireInValueSecondary;

	-----------------------------------------------------------------------
	-- GetWireOutValueSecondary
	-----------------------------------------------------------------------
	impure function GetWireOutValueSecondary (
		ep : std_logic_vector) return std_logic_vector is
		
		variable tmp_slv32 : std_logic_vector(31 downto 0);
		variable tmpI      : integer;
	begin
		tmpI := CONV_INTEGER(ep);
		tmp_slv32 := WireOuts_s(tmpI - 16#20#);
		return (tmp_slv32);
	end GetWireOutValueSecondary;

	-----------------------------------------------------------------------
	-- IsTriggeredSecondary
	-----------------------------------------------------------------------
	impure function IsTriggeredSecondary (
		ep   : std_logic_vector;
		mask : std_logic_vector(31 downto 0)) return BOOLEAN is
		
		variable tmp_slv32   : std_logic_vector(31 downto 0);
		variable tmpI        : integer;
		variable msg_line    : line;
	begin
		tmpI := CONV_INTEGER(ep);
		tmp_slv32 := (Triggered_s(tmpI - 16#60#) and mask);

		if (tmp_slv32 >= 0) then
			if (tmp_slv32 = 0) then
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
	end IsTriggeredSecondary;

	-----------------------------------------------------------------------
	-- UpdateWireInsSecondary
	-----------------------------------------------------------------------
	procedure UpdateWireInsSecondary is
		variable i : integer := 0;
	begin
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DWires; 
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DUpdateWireIns; 
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '1'; 
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DNOP; 
		for i in 0 to 31 loop
			hi_dataout_s <= WireIns_s(i);  wait until (rising_edge(hi_clk_s)); 
		end loop;
		wait until (hi_busy_s = '0');  
	end procedure UpdateWireInsSecondary;
   
	-----------------------------------------------------------------------
	-- UpdateWireOutsSecondary
	-----------------------------------------------------------------------
	procedure UpdateWireOutsSecondary is
		variable i : integer := 0;
	begin
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DWires; 
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DUpdateWireOuts; 
		wait until (rising_edge(hi_clk_s));
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DNOP; 
		wait until (rising_edge(hi_clk_s)); hi_drive_s <= '0'; 
		wait until (rising_edge(hi_clk_s)); wait until (rising_edge(hi_clk_s)); 
		for i in 0 to 31 loop
			wait until (rising_edge(hi_clk_s)); WireOuts_s(i) := hi_datain_s; 
		end loop;
		wait until (hi_busy_s = '0'); 
	end procedure UpdateWireOutsSecondary;

	-----------------------------------------------------------------------
	-- ActivateTriggerInSecondary
	-----------------------------------------------------------------------
	procedure ActivateTriggerInSecondary (
		ep  : in  std_logic_vector(7 downto 0);
		bit : in  integer) is 
		
		variable tmp_slv5 :     std_logic_vector(4 downto 0);
	begin
		tmp_slv5 := CONV_std_logic_vector(bit, 5);
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DTriggers;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DActivateTriggerIn;
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '1';
		hi_dataout_s <= (x"000000" & ep);
		wait until (rising_edge(hi_clk_s)); hi_dataout_s <= SHL(x"00000001", tmp_slv5); 
		hi_cmd_s <= DNOP;
		wait until (rising_edge(hi_clk_s)); hi_dataout_s <= x"00000000";
		wait until (hi_busy_s = '0');
	end procedure ActivateTriggerInSecondary;

	-----------------------------------------------------------------------
	-- UpdateTriggerOutsSecondary
	-----------------------------------------------------------------------
	procedure UpdateTriggerOutsSecondary is
	begin
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DTriggers;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DUpdateTriggerOuts;
		wait until (rising_edge(hi_clk_s));
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DNOP;
		wait until (rising_edge(hi_clk_s)); hi_drive_s <= '0';
		wait until (rising_edge(hi_clk_s)); wait until (rising_edge(hi_clk_s));
		wait until (rising_edge(hi_clk_s));
		
		for i in 0 to (UPDATE_TO_READOUT_CLOCKS-1) loop
				wait until (rising_edge(hi_clk_s));  
		end loop;
		
		for i in 0 to 31 loop
			wait until (rising_edge(hi_clk_s)); Triggered_s(i) := hi_datain_s;
		end loop;
		wait until (hi_busy_s = '0');
	end procedure UpdateTriggerOutsSecondary;

	-----------------------------------------------------------------------
	-- WriteToPipeInSecondary
	-----------------------------------------------------------------------
	procedure WriteToPipeInSecondary (
		ep      : in  std_logic_vector(7 downto 0);
		length  : in  integer) is

		variable len, i, j, k, blockSize : integer;
		variable tmp_slv8                : std_logic_vector(7 downto 0);
		variable tmp_slv32               : std_logic_vector(31 downto 0);
	begin
		len := (length / 4); j := 0; k := 0; blockSize := 1024;
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DPipes;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DWriteToPipeIn;
		wait until (rising_edge(hi_clk_s)); 
		hi_drive_s <= '1';
		hi_dataout_s <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DNOP;
		hi_dataout_s <= tmp_slv32;
		for i in 0 to len - 1 loop
			wait until (rising_edge(hi_clk_s));
			hi_dataout_s(7 downto 0) <= pipeIn_s(i*4);
			hi_dataout_s(15 downto 8) <= pipeIn_s((i*4)+1);
			hi_dataout_s(23 downto 16) <= pipeIn_s((i*4)+2);
			hi_dataout_s(31 downto 24) <= pipeIn_s((i*4)+3);
			j := j + 4;
			if (j = blockSize) then
				for k in 0 to BlockDelayStates - 1 loop
					wait until (rising_edge(hi_clk_s));
				end loop;
				j := 0;
			end if;
		end loop;
		wait until (hi_busy_s = '0');
	end procedure WriteToPipeInSecondary;

	-----------------------------------------------------------------------
	-- ReadFromPipeOutSecondary
	-----------------------------------------------------------------------
	procedure ReadFromPipeOutSecondary (
		ep     : in  std_logic_vector(7 downto 0);
		length : in  integer) is
		
		variable len, i, j, k, blockSize : integer;
		variable tmp_slv8                : std_logic_vector(7 downto 0);
		variable tmp_slv32               : std_logic_vector(31 downto 0);
	begin
		len := (length / 4); j := 0; blockSize := 1024;
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DPipes;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DReadFromPipeOut;
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '1';
		hi_dataout_s <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DNOP;
		hi_dataout_s <= tmp_slv32;
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '0';
		for i in 0 to len - 1 loop
			wait until (rising_edge(hi_clk_s));
			pipeOut_s(i*4) := hi_datain_s(7 downto 0);
			pipeOut_s((i*4)+1) := hi_datain_s(15 downto 8);
			pipeOut_s((i*4)+2) := hi_datain_s(23 downto 16);
			pipeOut_s((i*4)+3) := hi_datain_s(31 downto 24);
			j := j + 4;
			if (j = blockSize) then
				for k in 0 to BlockDelayStates - 1 loop
					wait until (rising_edge(hi_clk_s));
				end loop;
				j := 0;
			end if;
		end loop;
		wait until (hi_busy_s = '0');
	end procedure ReadFromPipeOutSecondary;

	-----------------------------------------------------------------------
	-- WriteToBlockPipeInSecondary
	-----------------------------------------------------------------------
	procedure WriteToBlockPipeInSecondary (
		ep          : in std_logic_vector(7 downto 0);
		blockLength : in integer;
		length      : in integer) is
		
		variable len, i, j, k, blockSize, blockNum : integer;
		variable tmp_slv8                          : std_logic_vector(7 downto 0);
		variable tmp_slv16                         : std_logic_vector(15 downto 0);
		variable tmp_slv32                         : std_logic_vector(31 downto 0);
	begin
		len := (length/4); blockSize := (blockLength/4); j := 0; k := 0;
		blockNum := (len/blockSize);
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv16 := CONV_std_logic_vector(blockSize, 16);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DPipes;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DWriteToBlockPipeIn;
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '1';
		hi_dataout_s <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DNOP;
		hi_dataout_s <= tmp_slv32;
		wait until (rising_edge(hi_clk_s)); hi_dataout_s <= x"0000" & tmp_slv16;
		wait until (rising_edge(hi_clk_s));
		tmp_slv16 := (CONV_std_logic_vector(PostReadyDelay, 8) & CONV_std_logic_vector(ReadyCheckDelay, 8));
		hi_dataout_s <= x"0000" & tmp_slv16;
		for i in 1 to blockNum loop
			while (hi_busy_s = '1') loop wait until (rising_edge(hi_clk_s)); end loop;
			while (hi_busy_s = '0') loop wait until (rising_edge(hi_clk_s)); end loop;
			wait until (rising_edge(hi_clk_s)); wait until (rising_edge(hi_clk_s));
			for j in 1 to blockSize loop
				hi_dataout_s(7 downto 0) <= pipeIn_s(k);
				hi_dataout_s(15 downto 8) <= pipeIn_s(k+1);
				hi_dataout_s(23 downto 16) <= pipeIn_s(k+2);
				hi_dataout_s(31 downto 24) <= pipeIn_s(k+3);
				wait until (rising_edge(hi_clk_s)); k:=k+4;
			end loop;
			for j in 1 to BlockDelayStates loop 
				wait until (rising_edge(hi_clk_s)); 
			end loop;
		end loop;
		wait until (hi_busy_s = '0');
	end procedure WriteToBlockPipeInSecondary;

	-----------------------------------------------------------------------
	-- ReadFromBlockPipeOutSecondary
	-----------------------------------------------------------------------
	procedure ReadFromBlockPipeOutSecondary (
		ep          : in std_logic_vector(7 downto 0);
		blockLength : in integer;
		length      : in integer) is
		
		variable len, i, j, k, blockSize, blockNum : integer;
		variable tmp_slv8                          : std_logic_vector(7 downto 0);
		variable tmp_slv16                         : std_logic_vector(15 downto 0);
		variable tmp_slv32                         : std_logic_vector(31 downto 0);
	begin
		len := (length/4); blockSize := (blockLength/4); j := 0; k := 0;
		blockNum := (len/blockSize);
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv16 := CONV_std_logic_vector(blockSize, 16);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DPipes;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DReadFromBlockPipeOut;
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '1';
		hi_dataout_s <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DNOP;
		hi_dataout_s <= tmp_slv32;
		wait until (rising_edge(hi_clk_s)); hi_dataout_s <= x"0000" & tmp_slv16;
		wait until (rising_edge(hi_clk_s));
		tmp_slv16 := (CONV_std_logic_vector(PostReadyDelay, 8) & CONV_std_logic_vector(ReadyCheckDelay, 8));
		hi_dataout_s <= x"0000" & tmp_slv16;
		wait until (rising_edge(hi_clk_s)); hi_drive_s <= '0';
		for i in 1 to blockNum loop
			while (hi_busy_s = '1') loop wait until (rising_edge(hi_clk_s)); end loop;
			while (hi_busy_s = '0') loop wait until (rising_edge(hi_clk_s)); end loop;
			wait until (rising_edge(hi_clk_s)); wait until (rising_edge(hi_clk_s));
			for j in 1 to blockSize loop
				pipeOut_s(k) := hi_datain_s(7 downto 0); 
				pipeOut_s(k+1) := hi_datain_s(15 downto 8);
				pipeOut_s(k+2) := hi_datain_s(23 downto 16);
				pipeOut_s(k+3) := hi_datain_s(31 downto 24);
				wait until (rising_edge(hi_clk_s)); k:=k+4;
			end loop;
			for j in 1 to BlockDelayStates loop wait until (rising_edge(hi_clk_s)); end loop;
		end loop;
		wait until (hi_busy_s = '0');
	end procedure ReadFromBlockPipeOutSecondary;
	
	-----------------------------------------------------------------------
	-- WriteRegisterSecondary
	-----------------------------------------------------------------------
	procedure WriteRegisterSecondary (
		address  : in  std_logic_vector(31 downto 0);
		data     : in  std_logic_vector(31 downto 0)) is
	begin
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DRegisters;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DWriteRegister;
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '1';
		hi_cmd_s <= DNOP;
		wait until (rising_edge(hi_clk_s)); hi_dataout_s <= address; 
		wait until (rising_edge(hi_clk_s)); hi_dataout_s <= data;
		wait until (hi_busy_s = '0'); hi_drive_s <= '0';  
	end procedure WriteRegisterSecondary;
	
	-----------------------------------------------------------------------
	-- ReadRegisterSecondary
	-----------------------------------------------------------------------
	procedure ReadRegisterSecondary (
		address  : in  std_logic_vector(31 downto 0);
		data     : out std_logic_vector(31 downto 0)) is
	begin
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DRegisters;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DReadRegister;
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '1';
		hi_cmd_s <= DNOP;
		wait until (rising_edge(hi_clk_s)); hi_dataout_s <= address; 
		wait until (rising_edge(hi_clk_s)); hi_drive_s <= '0';
		wait until (rising_edge(hi_clk_s));
		wait until (rising_edge(hi_clk_s)); data := hi_datain_s;
		wait until (hi_busy_s = '0');
	end procedure ReadRegisterSecondary;
	
	
	-----------------------------------------------------------------------
	-- WriteRegisterSetSecondary
	-----------------------------------------------------------------------
	procedure WriteRegisterSetSecondary is
		variable i             :     integer;
		variable u32Count_int  :     integer;
	begin
	  u32Count_int := CONV_INTEGER(u32Count_s);
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DRegisters;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DWriteRegisterSet;
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '1';
		hi_cmd_s <= DNOP;
		wait until (rising_edge(hi_clk_s)); hi_dataout_s <= u32Count_s; 
		for i in 1 to u32Count_int loop
			wait until (rising_edge(hi_clk_s)); hi_dataout_s <= u32Address_s(i-1);
			wait until (rising_edge(hi_clk_s)); hi_dataout_s <= u32Data_s(i-1);
			wait until (rising_edge(hi_clk_s)); wait until (rising_edge(hi_clk_s));
		end loop;
		wait until (hi_busy_s = '0'); hi_drive_s <= '0';  
	end procedure WriteRegisterSetSecondary;
	
	-----------------------------------------------------------------------
	-- ReadRegisterSetSecondary
	-----------------------------------------------------------------------
	procedure ReadRegisterSetSecondary is
		variable i             :     integer;
		variable u32Count_int  :     integer;
	begin
	  u32Count_int := CONV_INTEGER(u32Count_s);
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DRegisters;
		wait until (rising_edge(hi_clk_s)); hi_cmd_s <= DReadRegisterSet;
		wait until (rising_edge(hi_clk_s));
		hi_drive_s <= '1';
		hi_cmd_s <= DNOP;
		wait until (rising_edge(hi_clk_s)); hi_dataout_s <= u32Count_s; 
		for i in 1 to u32Count_int loop
			wait until (rising_edge(hi_clk_s)); hi_dataout_s <= u32Address_s(i-1);
			wait until (rising_edge(hi_clk_s)); hi_drive_s <= '0'; 
			wait until (rising_edge(hi_clk_s)); 
			wait until (rising_edge(hi_clk_s)); u32Data_s(i-1) := hi_datain_s;
			hi_drive_s <= '1';
		end loop;
		wait until (hi_busy_s = '0');
	end procedure ReadRegisterSetSecondary;
	
	-----------------------------------------------------------------------
	-- Available User Task and Function Calls:
	--    FrontPanelResetSecondary;              -- Always start routine with FrontPanelReset;
	--    SetWireInValueSecondary(ep, val, mask);
	--    UpdateWireInsSecondary;
	--    UpdateWireOutsSecondary;
	--    GetWireOutValueSecondary(ep);          -- returns a 16 bit SLV
	--    ActivateTriggerInSecondary(ep, bit);   -- bit is an integer 0-15
	--    UpdateTriggerOutsSecondary;
	--    IsTriggeredSecondary(ep, mask);        -- returns a BOOLEAN
	--    WriteToPipeInSecondary(ep, length);    -- pass pipeIn_s array data; length is integer
	--    ReadFromPipeOutSecondary(ep, length);  -- pass data to pipeOut_s array; length is integer
	--    WriteToBlockPipeInSecondary(ep, blockSize, length);   -- pass pipeIn_s array data; blockSize and length are integers
	--    ReadFromBlockPipeOutSecondary(ep, blockSize, length); -- pass data to pipeOut_s array; blockSize and length are integers
	--    WriteRegisterSecondary(addr, data);  
	--    ReadRegisterSecondary(addr, data);
	--    WriteRegisterSetSecondary();  
	--    ReadRegisterSetSecondary();
	--
	-- *  Pipes operate by passing arrays of data back and forth to the user's
	--    design.  If you need multiple arrays, you can create a new procedure
	--    above and connect it to a differnet array.  More information is
	--    available in Opal Kelly documentation and online support tutorial.
	-----------------------------------------------------------------------
--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS SECONDARY END PASTE HERE >>>>>>>>>>>>>>>>>>>>>>--


variable NO_MASK            : std_logic_vector(31 downto 0) := x"ffff_ffff";

-- LFSR/Counter modes
variable MODE_LFSR          : integer := 0;    -- Will set 0th bit
variable MODE_COUNTER       : integer := 1;    -- Will set 1st bit

-- Off/Continuous/Piped modes for LFSR/Counter
variable MODE_OFF           : integer := 2;   -- Will set 2nd bit
variable MODE_CONTINUOUS    : integer := 3;   -- Will set 3rd bit
variable MODE_PIPED         : integer := 4;   -- Will set 4th bit

variable msg_line           : line;     -- type defined in textio.vhd
variable i                  : integer;
variable j                  : natural;
variable ep01value          : std_logic_vector(31 downto 0);
variable ep20value          : std_logic_vector(31 downto 0);
variable ReadPipe           : PIPEOUT_ARRAY;

variable RegOutData         : REGISTER_ARRAY;
variable RegInData          : REGISTER_ARRAY;
variable RegAddresses       : REGISTER_ARRAY;

variable ep01value_s        : std_logic_vector(31 downto 0);
variable ep20value_s        : std_logic_vector(31 downto 0);
variable ReadPipe_s         : PIPEOUT_ARRAY;

variable RegOutData_s       : REGISTER_ARRAY;
variable RegInData_s        : REGISTER_ARRAY;
variable RegAddresses_s     : REGISTER_ARRAY;

-------------------------------------------------------------------
-- Check_LFSR
-- Sets the LFSR register mode to either Fibonacci LFSR or Counter
-- Seeds the register using WireIns
-- Checks and prints the current value using a WireOut
-------------------------------------------------------------------
procedure Check_LFSR (mode : integer) is
begin
	-- Set LFSR/Counter to run continuously
	ActivateTriggerIn(x"40", MODE_CONTINUOUS);
	ActivateTriggerInSecondary(x"40", MODE_CONTINUOUS);

	ActivateTriggerIn(x"40", mode);
	ActivateTriggerInSecondary(x"40", mode);
	if mode = MODE_LFSR then
		write(msg_line, STRING'("Mode: LFSR"));
	elsif mode = MODE_COUNTER then
		write(msg_line, STRING'("Mode: Counter"));
	end if;
	writeline(output, msg_line);

	-- Seed LFSR with initial value
	ep01value := x"5672_3237";
	SetWireInValue(x"01", ep01value, NO_MASK);
	UpdateWireIns;
	ep01value_s := x"5672_3237";
	SetWireInValueSecondary(x"01", ep01value_s, NO_MASK);
	UpdateWireInsSecondary;

	-- Check value on LFSR
	for i in 0 to 4 loop
		UpdateWireOuts;
		ep20value := GetWireOutValue(x"20");
		write(msg_line, STRING'("Read value: 0x"));
		hwrite(msg_line, STD_LOGIC_VECTOR'(ep20value));
		writeline(output, msg_line);

		UpdateWireOutsSecondary;
		ep20value_s := GetWireOutValueSecondary(x"20");
		write(msg_line, STRING'("(Secondary) Read value: 0x"));
		hwrite(msg_line, STD_LOGIC_VECTOR'(ep20value_s));
		writeline(output, msg_line);
	end loop;
	writeline(output, msg_line);   -- Formatting

end procedure Check_LFSR;

-------------------------------------------------------------------
-- Check_PipeOut
-- Selects Piped mode and the specified LFSR register mode
-- Reads in values from the LFSR using a PipeOut endpoint
-- Prints the values in the proper sequence to form a
--    complete 32-bit value
-------------------------------------------------------------------
procedure Check_PipeOut (mode : integer) is
begin
	-- Set modes
	ActivateTriggerIn(x"40", MODE_PIPED);
	ActivateTriggerIn(x"40", mode);
	ActivateTriggerInSecondary(x"40", MODE_PIPED);
	ActivateTriggerInSecondary(x"40", mode);

	-- Read values
	ReadFromPipeOut(x"a0", pipeOutSize);
	ReadFromPipeOutSecondary(x"a0", pipeOutSize);
	-- Display values
	if mode = MODE_LFSR then
		write(msg_line, STRING'("PipeOut LFSR excerpt: "));
	elsif mode = MODE_COUNTER then
		write(msg_line, STRING'("PipeOut Counter excerpt: "));
	end if;
	writeline(output, msg_line);
	j := 0;
	while j < 32 loop
		ReadPipe(j) := pipeOut(j);
		ReadPipe(j+1) := pipeOut(j+1);
		ReadPipe(j+2) := pipeOut(j+2);
		ReadPipe(j+3) := pipeOut(j+3);
		write(msg_line, STRING'("0x"));
		hwrite(msg_line, STD_LOGIC_VECTOR'(ReadPipe(j+3)) & STD_LOGIC_VECTOR'(ReadPipe(j+2)));
		hwrite(msg_line, STD_LOGIC_VECTOR'(ReadPipe(j+1)) & STD_LOGIC_VECTOR'(ReadPipe(j)));
		writeline(output, msg_line);

		ReadPipe_s(j) := pipeOut_s(j);
		ReadPipe_s(j+1) := pipeOut_s(j+1);
		ReadPipe_s(j+2) := pipeOut_s(j+2);
		ReadPipe_s(j+3) := pipeOut_s(j+3);
		write(msg_line, STRING'("0x"));
		hwrite(msg_line, STD_LOGIC_VECTOR'(ReadPipe_s(j+3)) & STD_LOGIC_VECTOR'(ReadPipe_s(j+2)));
		hwrite(msg_line, STD_LOGIC_VECTOR'(ReadPipe_s(j+1)) & STD_LOGIC_VECTOR'(ReadPipe_s(j)));
		writeline(output, msg_line);

		j := j + 4;
	end loop;
	writeline(output, msg_line);   -- Formatting
end procedure Check_PipeOut;

-------------------------------------------------------------------
-- Check_Registers
-- Stops the LFSR from updating (optional)
-- Sets up 32 values and 32 addresses
-- Sends the values to the FPGA and reads them back
-- Prints a comparison
-------------------------------------------------------------------
procedure Check_Registers is
begin
	-- Disable LFSR updating (optional)
	ActivateTriggerIn(x"40", MODE_OFF);
	ActivateTriggerInSecondary(x"40", MODE_OFF);

	-- Set up Register arrays
	for i in 0 to registerSetSize-1 loop
		RegOutData(i) := conv_std_logic_vector(i*23, registerSetSize);
		RegAddresses(i) := conv_std_logic_vector(i+3, registerSetSize);
		RegInData(i) := x"0000_0000";
		RegOutData_s(i) := conv_std_logic_vector(i*23, registerSetSize);
		RegAddresses_s(i) := conv_std_logic_vector(i+3, registerSetSize);
		RegInData_s(i) := x"0000_0000";
	end loop;

	-- Send data
	for i in 0 to registerSetSize-1 loop
		WriteRegister(RegAddresses(i), RegOutData(i));
		WriteRegisterSecondary(RegAddresses_s(i), RegOutData_s(i));
	end loop;

	write(msg_line, STRING'("Write to and read from block RAM using registers: "));
	writeline(output, msg_line);
	write(msg_line, STRING'("--------------------------------------------------"));
	writeline(output, msg_line);    -- formatting

	-- Retrieve data
	for i in 0 to registerSetSize-1 loop
		ReadRegister(RegAddresses(i), RegInData(i));
		write(msg_line, STRING'("Expected: "));
		hwrite(msg_line, STD_LOGIC_VECTOR'(RegOutData(i)));
		write(msg_line, STRING'(" Received: "));
		hwrite(msg_line, STD_LOGIC_VECTOR'(RegInData(i)));
		writeline(output, msg_line);

		ReadRegisterSecondary(RegAddresses_s(i), RegInData_s(i));
		write(msg_line, STRING'("Expected: "));
		hwrite(msg_line, STD_LOGIC_VECTOR'(RegOutData(i)));
		write(msg_line, STRING'(" Received: "));
		hwrite(msg_line, STD_LOGIC_VECTOR'(RegInData(i)));
		writeline(output, msg_line);
	end loop;
	writeline(output, msg_line);    --formatting

end procedure Check_Registers;


begin
	FrontPanelReset;
	FrontPanelResetSecondary;
	wait for 1 ns;

	-- Reset LFSR
	SetWireInValue(x"00", x"0000_0001", NO_MASK);
	UpdateWireIns;
	SetWireInValue(x"00", x"0000_0000", NO_MASK);
	UpdateWireIns;

	SetWireInValueSecondary(x"00", x"0000_0001", NO_MASK);
	UpdateWireInsSecondary;
	SetWireInValueSecondary(x"00", x"0000_0000", NO_MASK);
	UpdateWireInsSecondary;

	for j in 0 to 2 loop
		-- Select mode as LFSR to periodically read pseudo-random values
		Check_LFSR(MODE_LFSR);

		-- Select mode as Counter
		Check_LFSR(MODE_Counter);
	end loop;

	-- Read LFSR values in sequence using pipes
	Check_PipeOut(MODE_LFSR);

	-- Read Counter values in sequence using pipes
	Check_PipeOut(MODE_COUNTER);

	-- Send piped values back to FPGA
	for i in 0 to pipeInSize-1 loop
		pipeIn(i) := pipeOut(i);
		pipeIn_s(i) := pipeOut_s(i);
	end loop;
	WriteToPipeIn(x"80", pipeInSize);

	-- Send values to FPGA for storage and read them back
	Check_Registers;

	wait for 10 us;
end process;
end simulate;
