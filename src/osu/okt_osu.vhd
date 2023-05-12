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
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
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
		     clk   					: in  std_logic;
           rst_n 					: in  std_logic;
           aer_in_data  		: in  std_logic_vector (BUFFER_BITS_WIDTH - 1 downto 0);
           req_in_data_n 		: in  std_logic;
           ecu_in_ack_n 		: in  std_logic;
           cmd 					: in  std_logic_vector (COMMAND_BIT_WIDTH - 1 downto 0);
           node_in_data 		: out std_logic_vector(NODE_IN_DATA_BITS_WIDTH - 1 downto 0);
           node_req_n 			: out std_logic;
           node_in_osu_ack_n 	: in  std_logic;
			  ecu_node_out_ack_n : out std_logic
);
end okt_osu;

architecture Behavioral of okt_osu is

	constant Mask_MON     :    std_logic_vector(2 downto 0):="001";
	constant Mask_PASS    :    std_logic_vector(2 downto 0):="010";
	constant Mask_PASSMON :    std_logic_vector(2 downto 0):="011";
	constant Mask_SEQ     :    std_logic_vector(2 downto 0):="100";
	
signal n_command: std_logic_vector(COMMAND_BIT_WIDTH - 1 downto 0);
signal ecu_node_ack_n : std_logic := '1'; --Latched signal

begin

	n_command <= cmd;

Output_MUX: process (clk, rst_n, cmd, ecu_in_ack_n, node_in_osu_ack_n, ecu_node_ack_n)
begin
  if rst_n = '0' then --Reset all values to inactive when RST is active (low)
    node_req_n <= '1';
    ecu_node_out_ack_n <= '1';
    node_in_data <= (others => '0');
  else
	node_req_n <= '1';
   ecu_node_out_ack_n <= '1';
	node_in_data <= (others => '0');
	  
    case cmd is
	 
      when "001" => --State MON switches off output and connects its EMU_ACK to IMU_ACK
			ecu_node_out_ack_n <= ecu_in_ack_n;

      when "010" => --State PASS bypasses output and connects OUT_ACK to IMU_ACK
			ecu_node_out_ack_n <= node_in_osu_ack_n;
			node_in_data <= aer_in_data;
			node_req_n <= req_in_data_n;

      when "011" => --State MON_AND_PASS bypasses output and connects OUT_ACK and EMU_ACK to IMU_ACK via or gate
			ecu_node_out_ack_n <= ecu_node_ack_n;
			node_in_data <= aer_in_data;
			node_req_n <= req_in_data_n;

      when others =>
		--State IDLE keeps ACK and REQ in inactive level (high)		  
		
    end case;
  end if;
end process;

Element_C: process (ecu_in_ack_n, node_in_osu_ack_n)
begin
	if ecu_in_ack_n = '0' and node_in_osu_ack_n = '0' then
		ecu_node_ack_n <= '0';
	elsif ecu_in_ack_n = '1' and node_in_osu_ack_n = '1' then
		ecu_node_ack_n <= '1';
	end if;
end process;
	
	
end Behavioral;

