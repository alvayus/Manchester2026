--------------------------------------------------------------------------
-- pipe_out_check.vhd
--
-- Generates pseudorandom data for Pipe Out verifications.
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

entity pipe_out_check is
	port (
		clk            : in   STD_LOGIC;
		reset          : in   STD_LOGIC;
		pipe_out_read  : in   STD_LOGIC;
		pipe_out_data  : out  STD_LOGIC_VECTOR(31 downto 0);
		pipe_out_ready : out  STD_LOGIC;
		throttle_set   : in   STD_LOGIC;
		throttle_val   : in   STD_LOGIC_VECTOR(31 downto 0);
		fixed_pattern  : in   STD_LOGIC_VECTOR(31 downto 0);
		pattern        : in   STD_LOGIC_VECTOR(2 downto 0)
	);
end pipe_out_check;

architecture arch of pipe_out_check is

	component pattern_gen
	generic (WIDTH : integer := 1);
	port (
		clk           : in  STD_LOGIC;
		reset         : in  STD_LOGIC;
		enable        : in  STD_LOGIC;
		mode          : in  STD_LOGIC_VECTOR(2 downto 0);
		fixed_pattern : in  STD_LOGIC_VECTOR(31 downto 0);
		dout          : out STD_LOGIC_VECTOR(31 downto 0));
	end component;

	signal lfsr               : STD_LOGIC_VECTOR(63 downto 0);
	signal lfsr_p1            : STD_LOGIC_VECTOR(31 downto 0);
	signal throttle           : STD_LOGIC_VECTOR(31 downto 0);
	signal level              : STD_LOGIC_VECTOR(15 downto 0);
	signal pg_dout            : STD_LOGIC_VECTOR(31 downto 0);
	
	signal state              : STD_LOGIC_VECTOR(1 downto 0);

begin

state          <= pipe_out_read & throttle(0);

pattern_gen0 : pattern_gen  generic map (WIDTH=>32) 
	port map (
		clk           => clk, 
		reset         => reset,
		enable        => pipe_out_read,
		mode          => pattern,
		fixed_pattern => fixed_pattern,
		dout          => pg_dout
	);
	
process (clk) begin
	if rising_edge(clk) then
		if (reset = '1') then
			throttle <= throttle_val;
			pipe_out_ready <= '0';
			level <= x"0000";
			
		else
			if (pipe_out_read = '1') then
				pipe_out_data <= pg_dout;
			end if;
		
			if (level >= 1024) then
				pipe_out_ready <= '1';
			else
				pipe_out_ready <= '0';
			end if;
		
			-- Update our virtual FIFO level.
			case (state) is
				when "00" =>
				
				-- Write : Increase the FIFO level
				when "01" =>
					if (level < 65535) then
						level <= level + '1';
					end if;
				
				-- Read : Decrease the FIFO level
				when "10" =>
					if (level > 0) then
						level <= level - '1';
					end if;
				
				-- Read/Write : No net change
				when "11" =>
				
				when others =>
				
			end case;
			
			-- The throttle is a circular register.
			-- 1 enabled read or write this cycle.
			-- 0 disables read or write this cycle.
			-- So a single bit (0x00000001) would lead to 1/32 data rate.
			-- Similarly 0xAAAAAAAA would lead to 1/2 data rate.
			if (throttle_set = '1') then
				throttle <= throttle_val;
			else
				throttle <= throttle(0) & throttle(31 downto 1);
			end if;
			
		end if;
	end if; 
end process;

end arch;
