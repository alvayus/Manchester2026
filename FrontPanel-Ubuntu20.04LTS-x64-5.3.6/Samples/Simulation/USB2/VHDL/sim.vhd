--------------------------------------------------------------------------
-- Sim.vhd
--
-- A simple example for getting started with FrontPanel simulation.
-- This sample illustrates the use of the FrontPanel simulation files
--   and calls to the simulated FrontPanel Host Interface.
--
--------------------------------------------------------------------------
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
-- $Rev: 80 $ $Date: 2015-01-06 11:26:37 -0800 (Tue, 06 Jan 2015) $
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;
use work.FRONTPANEL.all;

entity sim is
	port (
		hi_in    : in std_logic_vector(7 downto 0);
		hi_out   : out std_logic_vector(1 downto 0);
		hi_inout : inout std_logic_vector(15 downto 0);
		led      : out std_logic_vector(7 downto 0)
		);
end sim;

architecture arch of sim is
	signal ti_clk : std_logic;
	signal ok1    : std_logic_vector(30 downto 0);
	signal ok2    : std_logic_vector(16 downto 0);
	signal ok2s   : std_logic_vector(17*3-1 downto 0);

	signal ep00wire : std_logic_vector(15 downto 0);
	signal ep01wire : std_logic_vector(15 downto 0);
	signal ep02wire : std_logic_vector(15 downto 0);
	signal ep20wire : std_logic_vector(15 downto 0);

	signal epModeTrig  : std_logic_vector(15 downto 0);

	signal epPipeIn    : std_logic_vector(15 downto 0);
	signal epPipeWrite : std_logic;

	signal epPipeOut   : std_logic_vector(15 downto 0);
	signal epPipeRead  : std_logic;

	constant MODE_LFSR       : std_logic_vector (1 downto 0) := b"01";
	constant MODE_COUNTER    : std_logic_vector (1 downto 0) := b"10";
	constant MODE_OFF        : std_logic_vector (1 downto 0) := b"00";
	constant MODE_CONTINUOUS : std_logic_vector (1 downto 0) := b"01";
	constant MODE_PIPED      : std_logic_vector (1 downto 0) := b"10";

	signal lfsr         : std_logic_vector(31 downto 0);
	signal reset        : std_logic;
	signal ep01_ref     : std_logic_vector(15 downto 0);
	signal LFSR_MODE    : std_logic_vector(1 downto 0) := MODE_OFF;
	signal REFRESH_MODE : std_logic_vector(1 downto 0) := MODE_OFF;
	signal led_data     : bit_vector(1023 downto 0) := (others => '0');
	signal led_store    : std_logic_vector(15 downto 0) := x"0000";
	signal led_temp     : bit_vector(15 downto 0);
	signal clk_en       : std_logic;
	signal clock_count  : std_logic_vector(31 downto 0) := x"0000_0000";

begin
	
	-- Wires update on ti_clk
	-- Keep the design synchronous by deriving reset
	--    directly from okWireIn endpoint
	reset <= ep00wire(0);

	-- Select mode
	process(ti_clk)
	begin
		if rising_edge(ti_clk) then
			case epModeTrig(4 downto 0) is
				when b"00001" => LFSR_MODE <= MODE_LFSR;
				when b"00010" => LFSR_MODE <= MODE_COUNTER;
				when b"00100" => REFRESH_MODE <= MODE_OFF;
				when b"01000" => REFRESH_MODE <= MODE_CONTINUOUS;
				when b"10000" => REFRESH_MODE <= MODE_PIPED;
				when others   => LFSR_MODE <= LFSR_MODE;
				                 REFRESH_MODE <= REFRESH_MODE;
			end case;
		end if;
	end process;

	-- LFSR/Counter
	process(ti_clk)
	begin
		if rising_edge(ti_clk) then
			if reset = '1' then
				lfsr <= x"00000000";
				ep01_ref <= x"0000";
				epPipeOut <= x"0000";
			end if;

			ep20wire <= lfsr(15 downto 0);

			case REFRESH_MODE is
				when MODE_OFF =>
					lfsr <= lfsr;
				when MODE_CONTINUOUS =>
					case LFSR_MODE is
						when MODE_LFSR =>
								if ep01wire /= ep01_ref then
									lfsr(15 downto 0 ) <= ep01wire;
									lfsr(31 downto 16) <= ep02wire;
									ep01_ref <= ep01wire;
								else
									lfsr <= lfsr(30 downto 0) & (lfsr(31) xor lfsr(21) xor lfsr(1));
								end if;
						when MODE_COUNTER =>
								lfsr <= lfsr + b"1";
						when others => lfsr <= lfsr;
					end case;
				when MODE_PIPED =>
					-- When prompted, PipeOut the current lfsr value
					if epPipeRead = '1' then
						case LFSR_MODE is
							when MODE_LFSR =>
								epPipeOut <= lfsr(15 downto 0);
								lfsr <= lfsr(30 downto 0) & (lfsr(31) xor lfsr(21) xor lfsr(1));
							when MODE_COUNTER =>
								epPipeOut <= lfsr(15 downto 0);
								lfsr <= lfsr + b"1";
							when others => lfsr <= lfsr;
						end case;
					end if;
				when others => lfsr <= lfsr;
			end case;
		end if;
	end process;

	-- When prompted, update the values used by the LEDs
	process(ti_clk)
	begin
		if rising_edge(ti_clk) then
			if reset = '1' then
				led_temp <= x"0000";
				led_data <= (others => '0');
				led_store <= x"0000";
				led <= not x"00";
			end if;

			led_temp <= led_data(1023 downto 1008);
			led_data <= led_data sll 16;
			led_data (15 downto 0) <= led_temp;

			if epPipeWrite = '1' then
				led_data(15 downto 0) <= to_bitvector(epPipeIn);
			end if;

			-- LEDs get lower bytes of PipeIn XOR'd with upper bytes
			if clk_en = '1' then
				led_store <= to_stdlogicvector(led_data(15 downto 0));
				led <= not (led_store(15 downto 8) xor led_store(7 downto 0));
			end if;
		end if;
	end process;

	-- Slows the rate at which LEDs update so the changing values are visible
	process(ti_clk)
	begin
		if rising_edge(ti_clk) then
			clock_count <= clock_count + b"1";

			if (clock_count and x"0000_00f1") > x"0000_0000" then
				clk_en <= '0';
			else 
				clk_en <= '1';
			end if;
		end if;
	end process;

	okHI : okHost port map (
		hi_in=>hi_in, hi_out=>hi_out, hi_inout=>hi_inout,
		ti_clk=>ti_clk, ok1=>ok1, ok2=>ok2);

	okWO : okWireOr generic map (N=>3) port map (ok2=>ok2, ok2s=>ok2s);

	ep00 : okWireIn  port map (ok1=>ok1,                                  ep_addr=>x"00", ep_dataout=>ep00wire);
	ep01 : okWireIn  port map (ok1=>ok1,                                  ep_addr=>x"01", ep_dataout=>ep01wire);
	ep02 : okWireIn  port map (ok1=>ok1,                                  ep_addr=>x"02", ep_dataout=>ep02wire);
	ep20 : okWireOut port map (ok1=>ok1, ok2=>ok2s( 1*17-1 downto 0*17 ), ep_addr=>x"20", ep_datain =>ep20wire);

	epMode : okTriggerIn port map (ok1=>ok1, ep_addr=>x"40", ep_clk=>ti_clk, ep_trigger=>epModeTrig);

	epPipe80 : okPipeIn  port map (ok1=>ok1, ok2=>ok2s( 2*17-1 downto 1*17 ), ep_addr=>x"80", ep_dataout=>epPipeIn,  ep_write=>epPipeWrite);
	epPipea0 : okPipeOut port map (ok1=>ok1, ok2=>ok2s( 3*17-1 downto 2*17 ), ep_addr=>x"a0", ep_datain =>epPipeOut, ep_read=>epPipeRead);

end arch;