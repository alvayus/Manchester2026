-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use work.okt_global_pkg.all;
use work.okt_top_pkg.all;

ENTITY okt_osu_tb IS
END okt_osu_tb;

ARCHITECTURE behavior OF okt_osu_tb IS 

-- inputs
  signal clk   				:  std_logic;
  signal rst_n 				:  std_logic;
  signal aer_data  			:  std_logic_vector (32 - 1 downto 0);
  signal req_data_n 			:  std_logic;
  signal ecu_ack_n 			:  std_logic;
  signal cmd 					:  std_logic_vector (3 - 1 downto 0);
  signal node_ack_n 			:  std_logic;
  
-- outputs
  signal node_data 		 	: std_logic_vector(32 - 1 downto 0);
  signal node_req_n 			: std_logic;
  signal out_ack_n 			: std_logic;
  
  constant CLK_period : time := 20 ns;
		  

BEGIN

	okt_osu : entity work.okt_osu
		port map(
			clk           				=> clk,
			rst_n      	  				=> rst_n,
			aer_in_data   				=> aer_data,
			req_in_data_n 				=> req_data_n,
			ecu_in_ack_n  				=> ecu_ack_n,
			cmd           				=> cmd,
			node_in_data  				=> node_data,
			node_req_n    				=> node_req_n,
			node_in_osu_ack_n    	=> node_ack_n,
			ecu_node_out_ack_n    	=> out_ack_n
		);
		
	CLK_process : process
	begin
		clk <= '0';
		wait for CLK_period / 2;
		clk <= '1';
		wait for CLK_period / 2;
	end process;
	
		
  --  Test Bench Statements
	stim_proc : process
	begin
	-- reset the system
		rst_n          <= '0';
		--node_data <= x"00000000";
		wait for CLK_period * 5;
		rst_n          <= '1';

		-- insert stimulus here
		wait for CLK_period;
		cmd <= b"000";
		req_data_n <= '1';
		
		wait for CLK_period * 20;
		aer_data <= x"00880088";
		cmd <= b"001";
		ecu_ack_n <= '0';
		node_ack_n <= '0';
		wait for CLK_period * 5;
		ecu_ack_n <= '0';
		node_ack_n <= '1';
		wait for CLK_period * 5;
		ecu_ack_n <= '1';
		node_ack_n <= '0';
		wait for CLK_period * 5;
		ecu_ack_n <= '1';
		node_ack_n <= '1';
		
		wait for CLK_period * 20;
		req_data_n <= '1';
		aer_data <= x"00770077";
		cmd <= b"010";
		ecu_ack_n <= '0';
		node_ack_n <= '0';
		wait for CLK_period * 5;
		ecu_ack_n <= '0';
		node_ack_n <= '1';
		wait for CLK_period * 5;
		ecu_ack_n <= '1';
		node_ack_n <= '0';
		wait for CLK_period * 5;
		ecu_ack_n <= '1';
		node_ack_n <= '1';
		
		wait for CLK_period * 20;
		req_data_n <= '0';
		aer_data <= x"00FF00FF";
		cmd <= b"011";
		ecu_ack_n <= '0';
		node_ack_n <= '0';
		wait for CLK_period * 5;
		ecu_ack_n <= '0';
		node_ack_n <= '1';
		wait for CLK_period * 5;
		ecu_ack_n <= '1';
		node_ack_n <= '0';
		wait for CLK_period * 5;
		ecu_ack_n <= '1';
		node_ack_n <= '1';
		
		wait for CLK_period * 20;
		req_data_n <= '1';
		aer_data <= x"00330033";
		cmd <= b"100";
		
		wait for CLK_period * 20;
		aer_data <= x"00110011";
		cmd <= b"111";
		
		wait;
	end process;
  --  End Test Bench 

  END;
