############################################################################
# ZEM5305 sys_clk - Quartus Constraints File
#
# Timing constraints for the ZEM5305 sys_clk.
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
# $Rev: 584 $ $Date: 2010-10-01 11:14:42 -0500 (Fri, 01 Oct 2010) $
############################################################################

create_clock -name {sys_clk_p} -period 10.000 -waveform { 0.000 5.000 } [get_ports {sys_clk_p}]

set_clock_groups -asynchronous -group [get_clocks {sys_clk_p}] -group [get_clocks {okUH0 virt_okUH0 okHI|ok_altera_pll0|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]