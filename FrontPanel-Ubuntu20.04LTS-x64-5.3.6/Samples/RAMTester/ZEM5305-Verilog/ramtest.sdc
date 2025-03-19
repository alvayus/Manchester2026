############################################################################
# RamTester - Quartus Constraints File
#
# Extra constraints required when working with the RAMTester sample. These
#  constraints handle the relationships between the clocks added by the DDR3
#  interface and those already present in the design.
#
# Copyright (c) 2004-2023 Opal Kelly Incorporated
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
############################################################################

set_clock_groups -asynchronous -group {mem_clk[0] \
                                       mem_clk_n[0] \
                                       mem_dqs[0]_OUT \
                                       mem_dqs[1]_OUT \
                                       mem_dqs_n[0]_OUT \
                                       mem_dqs_n[1]_OUT \
                                       ddr3_interface_inst|ddr3_interface_inst|pll0|pll_write_clk \
                                       ddr3_interface_inst|ddr3_interface_inst|ddr3_interface_p0_sampling_clock \
                                       ddr3_interface_inst|ddr3_interface_inst|pll0|pll1~FRACTIONAL_PLL|vcoph[0] \
                                       ddr3_interface_inst|ddr3_interface_inst|pll0|pll1~PLL_OUTPUT_COUNTER|divclk \
                                       ddr3_interface_inst|ddr3_interface_inst|pll0|pll1_phy~PLL_OUTPUT_COUNTER|divclk \
                                       ddr3_interface_inst|ddr3_interface_inst|pll0|pll2_phy~PLL_OUTPUT_COUNTER|divclk \
                                       ddr3_interface_inst|ddr3_interface_inst|pll0|pll3~PLL_OUTPUT_COUNTER|divclk \
                                       mem_dqs[0]_IN \
                                       mem_dqs[1]_IN \
                                       } \
                                -group {ddr3_interface_inst|ddr3_interface_inst|pll0|pll6_phy~PLL_OUTPUT_COUNTER|divclk \
                                        ddr3_interface_inst|ddr3_interface_inst|pll0|pll_avl_clk \
                                        ddr3_interface_inst|ddr3_interface_inst|pll0|pll6~PLL_OUTPUT_COUNTER|divclk} \
                                -group {ddr3_interface_inst|ddr3_interface_inst|pll0|pll_config_clk \
                                        ddr3_interface_inst|ddr3_interface_inst|pll0|pll7~PLL_OUTPUT_COUNTER|divclk} \
                                -group {okHI|ok_altera_pll0|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk \
                                        okUH0 \
                                        virt_okUH0 \
                                        } \
                                -group {sys_clk_p} \
                                -group {mem_pll_inst|mem_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}
