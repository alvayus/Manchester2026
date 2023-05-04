----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:02:24 03/20/2023 
-- Design Name: 
-- Module Name:    okt_osu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.okt_global_pkg.all;
use work.okt_osu_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity okt_osu is						-- Output Sequencer Unit
    Port(  
		     clk   				: in  std_logic;
           rst_n 				: in  std_logic;
           aer_in_data  	: in  std_logic_vector (BUFFER_BITS_WIDTH - 1 downto 0);
           req_in_data_n 	: in  std_logic;
           ecu_ack_n 		: in  std_logic;
           cmd 				: in  std_logic_vector (COMMAND_BIT_WIDTH - 1 downto 0);
           node_data 		: out std_logic_vector(NODE_DATA_BITS_WIDTH - 1 downto 0);
           node_req_n 		: out std_logic;
           node_ack_n 		: in  std_logic;
			  out_ack         : out std_logic
);
end okt_osu;

architecture Behavioral of okt_osu is

signal n_command: std_logic_vector(COMMAND_BIT_WIDTH - 1 downto 0);
signal osu_in_data: std_logic_vector (BUFFER_BITS_WIDTH - 1 downto 0);
signal osu_out_data: std_logic_vector(NODE_DATA_BITS_WIDTH - 1 downto 0);

begin

	n_command <= cmd;
	osu_in_data <= aer_in_data;
	osu_out_data <= node_data;

	process(ecu_ack_n, node_ack_n, cmd)
	
		begin
		
			if (ecu_ack_n = '0' and node_ack_n = '0') then
				out_ack <= '0';
				case n_command is
					when "010" | "011" | "101" =>       
						osu_in_data <= osu_out_data;
					when others =>
						null;
						-- aer_in_data <= 0;
			end case;
			else
				out_ack <= '1';
			end if;	
			
	end process;
	
end Behavioral;

