############################################################################
# ZEM4310 - Quartus Constraints File
#
# Timing constraints for the ZEM4310.
#
# Copyright (c) 2004-2010 Opal Kelly Incorporated
# $Rev: 584 $ $Date: 2010-10-01 11:14:42 -0500 (Fri, 01 Oct 2010) $
############################################################################
create_clock -name {sys_clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {sys_clk}]
set_clock_groups -asynchronous -group  [get_clocks {okHI|ok_altpll0|altpll_component|auto_generated|pll1|clk[0]}]  -group [get_clocks {sys_clk}]