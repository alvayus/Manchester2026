############################################################################
# ZEM4310 - Quartus Constraints File
#
# Timing constraints for the ZEM4310.
#
# Copyright (c) 2004-2010 Opal Kelly Incorporated
# $Rev: 584 $ $Date: 2010-10-01 11:14:42 -0500 (Fri, 01 Oct 2010) $
############################################################################
set_clock_groups -asynchronous -group  [get_clocks {okHI|ok_altpll0|altpll_component|auto_generated|pll1|clk[0]}]  -group [get_clocks {ddr2_interface_inst|ddr2_interface_controller_phy_inst|ddr2_interface_phy_inst|ddr2_interface_phy_alt_mem_phy_inst|clk|pll|altpll_component|auto_generated|pll1|clk[1]}]