--------------------------------------------------------------------------
-- pattern_gen.vhd
--
-- Parameterizable pattern generator for bus testing.
--
-- DATA_PATTERN:
--    000 - Counter, starting at 0.  32-bits wide.
--    001 - LFSR, 32-bit: x^32 + x^22 + x^2 + 1
--    010 - Walking 1's
--    011 - Walking 0's
--    100 - Hammer (alternating 1's 0's on the data bus)
--    101 - Neighbor (hammer, but with a single 0 at all times)
--    110 - N/A
--    111 - N/A
--
-- Copyright (c) 2010-2011  Opal Kelly Incorporated
-- CONFIDENTIAL AND PROPRIETARY
-- $Rev$ $Date$
---------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;
use work.FRONTPANEL.all;
library UNISIM;
use UNISIM.VComponents.all;

entity pattern_gen is
	generic (
		WIDTH        : integer := 32;
		LFSR_RESET   : STD_LOGIC_VECTOR(31 downto 0) := x"04030201"
	);
	port (
		clk           : in   STD_LOGIC;
		reset         : in   STD_LOGIC;
		enable        : in   STD_LOGIC;
		mode          : in   STD_LOGIC_VECTOR(2 downto 0);
		dout          : out  STD_LOGIC_VECTOR(WIDTH-1 downto 0)
	);
end pattern_gen;

architecture arch of pattern_gen is

	signal neighbor : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	signal mode_d   : STD_LOGIC_VECTOR(2 downto 0);
	signal toggle   : STD_LOGIC;
	signal preg     : STD_LOGIC_VECTOR(63 downto 0);

	
begin

dout   <= preg(WIDTH-1 downto 0);


-- Resets when RESET=1.
-- Generates a new word in the pattern when ENABLE=1.
process (clk) begin
	if rising_edge(clk) then
		if (reset = '1') then
			toggle   <= '1';
			mode_d   <= mode;
			neighbor <= x"fffffffe";
			case (mode) is
				when "000"  => preg <= x"0000000000000001";            -- Counter
				when "001"  => preg <= x"00000000" & LFSR_RESET;             -- LFSR
				when "010"  => preg <= x"0000000000000001";            -- Walking 1's
				when "011"  => preg <= x"00000000fffffffe";            -- Walking 0's
				when "100"  => preg <= x"0000000000000000";            -- Hammer
				when "101"  => preg <= x"0000000000000000";            -- Neighbor (hammer except one bit is always low)
				when "110"  => preg <= x"0000000000000000";
				when "111"  => preg <= x"0000000000000000";
				when others => preg <= x"0000000000000000";
			end case;
		else
			if (enable = '1') then
				toggle      <= not(toggle);
				if (toggle = '0') then
					neighbor    <= neighbor(WIDTH-2 downto 0) & neighbor(WIDTH-1);
				end if;
				case (mode_d) is
					when "000" => preg <= preg + '1';                                                             -- Counter
					when "001" => preg <= x"00000000" & preg(30 downto 0) & (preg(31) xor preg(21) xor preg(1));  -- LFSR
					when "010" => preg <= x"00000000" & preg(WIDTH-2 downto 0) & preg(WIDTH-1);                                 -- Walking 1's
					when "011" => preg <= x"00000000" & preg(WIDTH-2 downto 0) & preg(WIDTH-1);                                 -- Walking 0's
					when "100" => preg <= (others => toggle);                                                     -- Hammer
					when "101" => 
						if (toggle = '1') then
							preg <= x"00000000" & neighbor;
						else
							preg <= x"0000000000000000";
						end if;                               -- Neighbor
					when "110" => preg <= x"0000000000000000";
					when "111" => preg <= x"0000000000000000";
					when others => preg <= x"0000000000000000";
				end case;
			end if;
		end if;
	end if;
end process;

end arch;