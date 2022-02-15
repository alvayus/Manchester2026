
`timescale 1ns/1ps
//`default_nettype none

module ddr2_test
	(
	input  wire          clk,
	input  wire          reset,
	input  wire          writes_en,
	input  wire          reads_en,
	input  wire          calib_done, 
	
	//DDR Input Buffer (ib_)
	output reg           ib_re,
	input  wire [31:0]   ib_data,
	input  wire [10:0]   ib_count,
	input  wire          ib_empty,
	
	//DDR Output Buffer (ob_)
	output reg           ob_we,
	output reg  [31:0]   ob_data,
	input  wire [10:0]   ob_count,
	
	output reg           local_read_req,
	input  wire          local_rdata_valid,
	input  wire [31:0]   local_rdata,
	
	input  wire          local_ready,
	output reg           local_burstbegin,

	output reg  [24:0]   local_address,
	output wire [2:0]    local_size,
	output reg           local_write_req,
	output wire [31:0]   local_wdata,
	output wire [3:0]    local_be
	);

localparam FIFO_SIZE      = 1024;
localparam BURST_LEN      = 4;  // Number of 32bit user words per DRAM command (Must be Multiple of 2)

reg  [24:0] local_addr_wr, local_addr_rd;
reg  [2:0]  burst_cnt;

reg         write_mode;
reg         read_mode;
reg         reset_d;


assign local_size  = BURST_LEN;
assign local_be    = 4'hF;
assign local_wdata = ib_data;

always @(posedge clk) write_mode <= writes_en;
always @(posedge clk) read_mode <= reads_en;
always @(posedge clk) reset_d <= reset;


integer state;
localparam s_idle  = 0,
           s_write0 = 10,
           s_write1 = 11,
           s_write2 = 12,
           s_write3 = 13,
           s_read1 = 20,
           s_read2 = 21,
           s_read3 = 22,
           s_read4 = 23;
always @(posedge clk) begin
	if (reset_d) begin
		state          <= s_idle;
		burst_cnt      <= 3'b000;
		local_addr_wr  <= 0;
		local_addr_rd  <= 0;
		local_address  <= 25'b0;
	end else begin
		local_burstbegin  <= 1'b0;
		local_write_req   <= 1'b0;
		ib_re             <= 1'b0;
		local_read_req    <= 1'b0;
		ob_we             <= 1'b0;


		case (state)
			s_idle: begin
				burst_cnt <= BURST_LEN;

				// only start writing when initialization done
				if (calib_done==1 && write_mode==1 && (ib_count >= BURST_LEN) && (local_ready == 1'b1) ) begin
					burst_cnt     <= BURST_LEN - 2;
					local_address <= local_addr_wr;
					local_addr_wr <= local_addr_wr + BURST_LEN;
					state <= s_write0;
				end else if (calib_done==1 && read_mode==1 && (ob_count<(FIFO_SIZE-1-BURST_LEN) ) && (local_ready == 1'b1) ) begin
					burst_cnt     <= BURST_LEN - 1;
					local_address <= local_addr_rd;
				  local_addr_rd <= local_addr_rd + BURST_LEN;
					state <= s_read1;
				end
			end
			
			s_write0: begin
				if (local_ready == 1'b1) begin
					ib_re <= 1'b1;
					state <= s_write1;
				end
			end
	
			s_write1: begin
				if (local_ready == 1'b1) begin
					local_burstbegin  <= 1'b1;
					local_write_req   <= 1'b1;
					ib_re <= 1'b1;
					state <= s_write2;
				end
			end
			
			s_write2: begin
				local_write_req   <= 1'b1;
				// Keep write request and data present until
				// controller is ready.
				if (local_ready == 1'b1) begin 
					if (burst_cnt == 3'd0) begin
						state <= s_idle;
					end else begin
						ib_re <= 1'b1;
						burst_cnt <= burst_cnt - 1'b1;
					end
				end
			end

			s_read1: begin
				local_burstbegin <= 1'b1;
				local_read_req   <= 1'b1;
				state            <= s_read2;
			end
			
			s_read2: begin
				if (local_rdata_valid == 1'b1) begin
					ob_data <= local_rdata;
					ob_we <= 1'b1;
					if (burst_cnt == 3'd0) begin
						state <= s_idle;
					end else begin
						burst_cnt <= burst_cnt - 1'b1;
					end
				end
			end
				
		endcase
	end
end


endmodule
