
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;        -- @suppress "Deprecated package"
use ieee.numeric_std.all;
use work.okt_ecu_pkg.all;
use work.okt_global_pkg.all;

entity okt_ecu is                       -- Event Capture Unit
	Port(
		clk       : in  std_logic;
		rst_n     : in  std_logic;
		req_n     : in  std_logic;
		aer_data  : in  std_logic_vector(BUFFER_BITS_WIDTH - 1 downto 0);
		ack_n     : out std_logic;
		out_data  : out std_logic_vector(BUFFER_BITS_WIDTH - 1 downto 0);
		out_rd    : in  std_logic;
		out_ready : out std_logic
	);
end okt_ecu;

architecture Behavioral of okt_ecu is

	type state is (idle, req_fall_0, req_fall_1, wait_req_rise, timestamp_overflow_0, timestamp_overflow_1);
	signal r_okt_ecu_control_state, n_okt_ecu_control_state : state;

	signal r_timestamp, n_timestamp : std_logic_vector(TIMESTAMP_BITS_WIDTH - 1 downto 0);
	signal n_ack_n                  : std_logic;

	signal fifo_w_data : std_logic_vector(BUFFER_BITS_WIDTH - 1 downto 0);
	signal fifo_w_en   : std_logic;
	signal fifo_r_data : std_logic_vector(BUFFER_BITS_WIDTH - 1 downto 0);
	signal fifo_r_en   : std_logic;
	signal fifo_empty  : std_logic;
	signal fifo_full   : std_logic;

	-- DEBUG
	attribute MARK_DEBUG : string;
	attribute MARK_DEBUG of r_okt_ecu_control_state, n_okt_ecu_control_state, r_timestamp, n_timestamp, n_ack_n : signal is "TRUE";

begin

	ack_n <= n_ack_n;

	caputre_fifo : entity work.okt_fifo
		generic map(
			DEPTH => FIFO_DEPTH
		)
		port map(
			clk    => clk,
			rst_n  => rst_n,
			w_data => fifo_w_data,
			w_en   => fifo_w_en,
			r_data => fifo_r_data,
			r_en   => fifo_r_en,
			empty  => fifo_empty,
			full   => fifo_full
		);
	out_data  <= fifo_r_data;
	fifo_r_en <= out_rd;
	out_ready <= not fifo_empty;

	signals_update : process(clk, rst_n)
	begin
		if rst_n = '0' then
			r_okt_ecu_control_state <= idle;
			r_timestamp             <= (others => '0');

		elsif rising_edge(clk) then
			r_okt_ecu_control_state <= n_okt_ecu_control_state;
			r_timestamp             <= n_timestamp;
		end if;

	end process signals_update;

	process(r_okt_ecu_control_state, req_n, r_timestamp, aer_data, fifo_full)
	begin
		n_okt_ecu_control_state <= r_okt_ecu_control_state;
		n_timestamp             <= r_timestamp + 1;
		n_ack_n                 <= '1';
		fifo_w_data             <= (others => '0');
		fifo_w_en               <= '0';

		case r_okt_ecu_control_state is
			when idle =>
				if (req_n = '0') then
					n_okt_ecu_control_state <= req_fall_0;

				elsif (r_timestamp = TIMESTAMP_OVF) then
					n_okt_ecu_control_state <= timestamp_overflow_0;
				end if;

			when req_fall_0 =>
				if (r_timestamp = TIMESTAMP_OVF) then
					n_okt_ecu_control_state <= timestamp_overflow_0;

				elsif (fifo_full = '0') then
					fifo_w_data(TIMESTAMP_BITS_WIDTH - 1 downto 0) <= r_timestamp;
					fifo_w_en                                      <= '1';
					n_timestamp                                    <= (others => '0');
					n_okt_ecu_control_state                        <= req_fall_1;
				end if;

			when req_fall_1 =>
				if (fifo_full = '0') then
					fifo_w_data(BUFFER_BITS_WIDTH - 1 downto 0) <= aer_data;
					fifo_w_en                                   <= '1';
					n_timestamp                                 <= (others => '0');
					n_ack_n                                     <= '0';
					n_okt_ecu_control_state                     <= wait_req_rise;
				end if;

			when wait_req_rise =>
				n_ack_n <= '0';
				if (req_n = '1') then
					n_okt_ecu_control_state <= idle;
				end if;

			when timestamp_overflow_0 =>
				if (fifo_full = '0') then
					fifo_w_data             <= (others => '1');
					fifo_w_en               <= '1';
					n_timestamp             <= (others => '0');
					n_okt_ecu_control_state <= timestamp_overflow_1;
				end if;

			when timestamp_overflow_1 =>
				if (fifo_full = '0') then
					fifo_w_data             <= (others => '0');
					fifo_w_en               <= '1';
					n_timestamp             <= (others => '0');
					n_okt_ecu_control_state <= idle;
				end if;
		end case;
	end process;

end Behavioral;

