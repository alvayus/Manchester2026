//------------------------------------------------------------------------
// flash_b.v
//    This is the flash "B" controller which handles the macro commands
//    to the flash device.  This includes full commands such as
//    sector erase, page program, and so on.
//
//    This controller uses the "A" controller for direct control of the
//    flash.
//
// Commands:
//  ERASE_SECTORS
//     + ADDR is the sector address to start erasing (0..511)
//     + LENGTH is the number of sectors to erase in sequence
//  WRITE
//     + ADDR is the page address to start writing (0..65535)
//     + LENGTH is the number of full (256-byte) pages to write.
//  READ
//     + ADDR is the page address to start reading (0..65535)
//     + LENGTH is the number of full (256-byte) pages to read.
//------------------------------------------------------------------------
// Copyright (c) 2004-2022 Opal Kelly Incorporated
// $Id$
//------------------------------------------------------------------------

`default_nettype none
`timescale 1ns / 1ps
module flash_b(
	input  wire        clk,
	input  wire        reset,

	input  wire        cmd_erasesectors,
	input  wire        cmd_write,
	input  wire        cmd_read,
	input  wire        cmd_setqe,
	input  wire [31:0] addr,
	input  wire [31:0] length,
	input  wire [7:0]  din,
	output reg  [7:0]  dout,
	output reg         read,
	output reg         write,
	output reg         done,
	output wire [31:0] status,
	
	// Flash interface
	input  wire        flash_q,
	output wire        flash_c,
	output wire        flash_s_n,
	output wire        flash_d
	);

reg        a_write;
reg        a_read;
reg        a_deselect;
wire       a_done;
wire [7:0] a_dout;
reg  [7:0] a_din;

reg  [31:0] count_a;
reg  [31:0] count_b;
reg  [31:0] count_c;

assign status = count_b;

flash_a f0(
	.clk(clk),
	.reset(reset),
	.write(a_write),
	.read(a_read),
	.deselect(a_deselect),
	.din(a_din),
	.dout(a_dout),
	.done(a_done),
	.flash_c(flash_c),
	.flash_s_n(flash_s_n),
	.flash_d(flash_d),
	.flash_q(flash_q));

parameter s_idle       = 0,
          s_erase1     = 1,
          s_erase1w    = 2,
          s_erase2     = 3,
          s_erase2w    = 4,
          s_erase3     = 5,
          s_erase3w    = 6,
          s_erase4     = 7,
          s_erase4w    = 8,
          s_erase5     = 9,
          s_erase5w    = 10,
          s_erase6     = 11,
          s_erase6w    = 12,
          s_erase7     = 13,
          s_erase7w    = 14,
          s_erase8     = 15,
          s_erase8w    = 16,
          s_erase9     = 17,
          
          s_erase_sr1  = 100,
          s_erase_sr1w = 101,
          s_erase_sr2  = 102,
          s_erase_sr2w = 103,
          
          s_write1     = 20,
          s_write1w    = 21,
          s_write2     = 22,
          s_write2w    = 23,
          s_write3     = 24,
          s_write3w    = 25,
          s_write4     = 26,
          s_write4w    = 27,
          s_write5     = 28,
          s_write5w    = 29,
          s_write6     = 30,
          s_write6w    = 31,
          s_write7     = 32,
          s_write7w    = 33,
          s_write8     = 34,
          s_write8w    = 35,
          s_write9     = 36,
          s_write9w    = 37,
          s_write10    = 38,
          
          s_read1      = 40,
          s_read1w     = 41,
          s_read2      = 42,
          s_read2w     = 43,
          s_read3      = 44,
          s_read3w     = 45,
          s_read4      = 46,
          s_read4w     = 47,
          s_read5      = 48,
          s_read5w     = 49,
          s_read6      = 50,
          s_read6w     = 51,
          s_read7      = 52,
          s_read7w     = 53,
          s_read8      = 54,
          
          s_setqe1     = 60,
          s_setqe1w    = 61,
          s_setqe2     = 62,
          s_setqe2w    = 63,
          s_setqe3     = 64,
          s_setqe3w    = 65,
          s_setqe4     = 66,
          s_setqe4w    = 67,
          s_setqe5     = 68,
          s_setqe5w    = 69;
reg [31:0] state;
always @(posedge clk) begin
	if (reset == 1'b1) begin
		state <= s_idle;
		done <= 1'b0;
		read <= 1'b0;
		write <= 1'b0;
	end else begin
		done <= 1'b0;
		read <= 1'b0;
		write <= 1'b0;
		a_write <= 1'b0;
		a_read  <= 1'b0;
		a_deselect <= 1'b0;
		
		case (state)
			s_idle: begin
				if (cmd_erasesectors == 1'b1) begin
					state <= s_erase1;
					count_a <= addr;
					count_b <= length;
				end else if (cmd_write == 1'b1) begin
					state <= s_write1;
					count_a <= addr;
					count_b <= length;
				end else if (cmd_read == 1'b1) begin
					state <= s_read1;
					count_a <= addr;
					count_c <= {length, 8'hff};
				end else if (cmd_setqe == 1'b1) begin
					state <= s_setqe1;
				end
			end

			//===============================================================
			// ERASE SECTORS
			//===============================================================
			// WREN
			s_erase1: begin
				a_write    <= 1'b1;
				a_deselect <= 1'b1;
				a_din      <= 8'h06;
				state <= s_erase1w;
			end
			s_erase1w: begin
				if (a_done == 1'b1)
					state <= s_erase_sr1;
			end
			
			// RDSR - check that WREN was successful
			s_erase_sr1: begin
				a_write <= 1'b1;
				a_din <= 8'h05;
				state <= s_erase_sr1w;
			end
			s_erase_sr1w: begin
				if (a_done == 1'b1)
					state <= s_erase_sr2;
			end

			s_erase_sr2: begin
				a_read <= 1'b1;
				a_deselect <= 1'b1;
				state <= s_erase_sr2w;
			end
			s_erase_sr2w: begin
				if (a_done == 1'b1) begin
					if (a_dout[1] == 1'b1)
						state <= s_erase2;
					else
						state <= s_erase1;
				end
			end
			
			// SE
			s_erase2: begin
				a_write <= 1'b1;
				a_din <= 8'hdc; // 4-byte address erase
				state <= s_erase2w;
			end
			s_erase2w: begin
				if (a_done == 1'b1)
					state <= s_erase3;
			end

			// ADDR[31:24]			
			s_erase3: begin
				a_write <= 1'b1;
				a_din <= count_a[15:8];
				state <= s_erase3w;
			end
			s_erase3w: begin
				if (a_done == 1'b1)
					state <= s_erase4;
			end

			// ADDR[23:16]			
			s_erase4: begin
				a_write <= 1'b1;
				a_din <= count_a[7:0];
				state <= s_erase4w;
			end
			s_erase4w: begin
				if (a_done == 1'b1)
					state <= s_erase5;
			end

			// ADDR[15:8]
			s_erase5: begin
				a_write <= 1'b1;
				a_din <= 8'h00;
				state <= s_erase5w;
			end
			s_erase5w: begin
				if (a_done == 1'b1)
					state <= s_erase6;
			end

			// ADDR[7:0]
			s_erase6: begin
				a_write <= 1'b1;
				a_din <= 8'h00;
				a_deselect <= 1'b1;
				state <= s_erase6w;
			end
			s_erase6w: begin
				if (a_done == 1'b1)
					state <= s_erase7;
			end


			// RDSR - wait for erase to complete
			s_erase7: begin
				a_write <= 1'b1;
				a_din <= 8'h05;
				state <= s_erase7w;
			end
			s_erase7w: begin
				if (a_done == 1'b1)
					state <= s_erase8;
			end

			s_erase8: begin
				a_read <= 1'b1;
				a_deselect <= 1'b1;
				state <= s_erase8w;
			end
			s_erase8w: begin
				if (a_done == 1'b1) begin
					if (a_dout[0] == 1'b1)
						state <= s_erase7;
					else begin
						state <= s_erase9;
						count_b <= count_b - 1;
						count_a <= count_a + 1;
					end
				end
			end

			// Loop until all requested sectors are erased.
			s_erase9: begin
				if (count_b == 0) begin
					state <= s_idle;
					done <= 1'b1;
				end else begin
					state <= s_erase1;
				end
			end


			//===============================================================
			// WRITE DATA
			//===============================================================
			// WREN
			s_write1: begin
				a_write <= 1'b1;
				a_deselect <= 1'b1;
				a_din <= 8'h06;
				state <= s_write1w;
			end
			s_write1w: begin
				if (a_done == 1'b1)
					state <= s_write2;
			end
			
			// PP
			s_write2: begin
				a_write <= 1'b1;
				a_din <= 8'h12; // 4-byte address write
				state <= s_write2w;
			end
			s_write2w: begin
				if (a_done == 1'b1)
					state <= s_write3;
			end

			// ADDR[31:24]
			s_write3: begin
				a_write <= 1'b1;
				a_din <= count_a[23:16];
				state <= s_write3w;
			end
			s_write3w: begin
				if (a_done == 1'b1)
					state <= s_write4;
			end

			// ADDR[23:16]
			s_write4: begin
				a_write <= 1'b1;
				a_din <= count_a[15:8];
				state <= s_write4w;
			end
			s_write4w: begin
				if (a_done == 1'b1)
					state <= s_write5;
			end

			// ADDR[15:8]
			s_write5: begin
				a_write <= 1'b1;
				a_din <= count_a[7:0];
				state <= s_write5w;
			end
			s_write5w: begin
				if (a_done == 1'b1)
					state <= s_write6;
			end

			// ADDR[7:0]
			s_write6: begin
				a_write <= 1'b1;
				a_din <= 8'h00;
				read <= 1'b1;			// Gets the first data word ready.
				state <= s_write6w;
			end
			s_write6w: begin
				if (a_done == 1'b1) begin
					state <= s_write7;
					count_c <= 8'd255;
				end
			end

			// DATA[0..255]
			s_write7: begin
				state <= s_write7w;
				a_write <= 1'b1;
				a_din <= din;
				if (count_c == 0) begin
					a_deselect <= 1'b1;
				end else begin
					read <= 1'b1;		// Gets next word from memory.
				end
			end
			s_write7w: begin
				if (a_done == 1'b1) begin
					count_c <= count_c - 1;
					if (count_c == 0) begin
						state <= s_write8;
					end else begin
						state <= s_write7;
					end
				end
			end
			
			// RDSR
			s_write8: begin
				a_write <= 1'b1;
				a_din <= 8'h05;
				state <= s_write8w;
			end
			s_write8w: begin
				if (a_done == 1'b1)
					state <= s_write9;
			end

			s_write9: begin
				a_read <= 1'b1;
				a_deselect <= 1'b1;
				state <= s_write9w;
			end
			s_write9w: begin
				if (a_done == 1'b1) begin
					if (a_dout[0] == 1'b1)
						state <= s_write8;
					else
						state <= s_write10;
				end
			end

			// Loop until all pages have been written
			s_write10: begin
				count_a <= count_a + 1;
				count_b <= count_b - 1;
				if (count_b == 0) begin
					done <= 1'b1;
					state <= s_idle;
				end else begin
					state <= s_write1;
				end
			end


			//===============================================================
			// READ DATA
			//===============================================================
			// FAST_READ
			s_read1: begin
				a_write <= 1'b1;
				a_din <= 8'h0c; // 4-byte address fast read
				state <= s_read1w;
			end
			s_read1w: begin
				if (a_done == 1'b1)
					state <= s_read2;
			end

			// ADDR[31:24]
			s_read2: begin
				a_write <= 1'b1;
				a_din <= count_a[23:16];
				state <= s_read2w;
			end
			s_read2w: begin
				if (a_done == 1'b1)
					state <= s_read3;
			end

			// ADDR[23:16]
			s_read3: begin
				a_write <= 1'b1;
				a_din <= count_a[15:8];
				state <= s_read3w;
			end
			s_read3w: begin
				if (a_done == 1'b1)
					state <= s_read4;
			end

			// ADDR[15:8]
			s_read4: begin
				a_write <= 1'b1;
				a_din <= count_a[7:0];
				state <= s_read4w;
			end
			s_read4w: begin
				if (a_done == 1'b1)
					state <= s_read5;
			end

			// ADDR[7:0]
			s_read5: begin
				a_write <= 1'b1;
				a_din <= 8'h00;
				state <= s_read5w;
			end
			s_read5w: begin
				if (a_done == 1'b1) begin
					state <= s_read6;
				end
			end

			// DUMMY
			s_read6: begin
				a_read <= 1'b1;
				state <= s_read6w;
			end
			s_read6w: begin
				if (a_done == 1'b1) begin
					state <= s_read7;
				end
			end

			// DATA[n]
			s_read7: begin
				a_read <= 1'b1;
				state <= s_read7w;
				if (count_c == 0) begin
					a_deselect <= 1'b1;
				end
			end
			s_read7w: begin
				if (a_done == 1'b1) begin
					write <= 1'b1;
					dout <= a_dout;
					state <= s_read8;
				end
			end
			
			s_read8: begin
				count_c <= count_c - 1;
				if (count_c == 0) begin
					state <= s_idle;
					done <= 1'b1;
				end else begin
					state <= s_read7;
				end
			end
			
			//===============================================================
			// WRITE STATUS REGISTER QE-bit Non-Volatile
			//===============================================================
			// WREN
			s_setqe1: begin
				a_write <= 1'b1;
				a_deselect <= 1'b1;
				a_din <= 8'h06;
				state <= s_setqe1w;
			end
			s_setqe1w: begin
				if (a_done == 1'b1)
					state <= s_setqe2;
			end
			
			// WRSR
			s_setqe2: begin
				a_write <= 1'b1;
				a_din <= 8'h01; // write status register
				state <= s_setqe2w;
			end
			s_setqe2w: begin
				if (a_done == 1'b1)
					state <= s_setqe3;
			end

			// Data
			s_setqe3: begin
				a_write <= 1'b1;
				a_din <= 8'h40; // Set QE-bit
				state <= s_setqe3w;
				a_deselect <= 1'b1;
			end
			s_setqe3w: begin
				if (a_done == 1'b1)
					state <= s_setqe4;
			end
			
			// RDSR
			s_setqe4: begin
				a_write <= 1'b1;
				a_din <= 8'h05;
				state <= s_setqe4w;
			end
			s_setqe4w: begin
				if (a_done == 1'b1)
					state <= s_setqe5;
			end

			s_setqe5: begin
				a_read <= 1'b1;
				a_deselect <= 1'b1;
				state <= s_setqe5w;
			end
			s_setqe5w: begin
				if (a_done == 1'b1) begin
					if (a_dout[0] == 1'b1)
						state <= s_setqe4;
					else
						state <= s_idle;
				end
			end
		endcase
	end
end

endmodule
`default_nettype wire
