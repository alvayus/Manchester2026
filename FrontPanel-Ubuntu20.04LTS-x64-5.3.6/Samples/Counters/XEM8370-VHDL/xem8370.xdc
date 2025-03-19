############################################################################
# XEM8370 - Xilinx constraints file
#
# Pin mappings for the XEM8370.  Use this as a template and comment out
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2023 Opal Kelly Incorporated
############################################################################

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

############################################################################
## FrontPanel Host Interface - Primary
############################################################################
set_property PACKAGE_PIN G26 [get_ports {okHU[0]}]
set_property PACKAGE_PIN M24 [get_ports {okHU[1]}]
set_property PACKAGE_PIN N23 [get_ports {okHU[2]}]
set_property SLEW FAST [get_ports {okHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okHU[*]}]

set_property PACKAGE_PIN M25 [get_ports {okUH[0]}]
set_property PACKAGE_PIN P26 [get_ports {okUH[1]}]
set_property PACKAGE_PIN T27 [get_ports {okUH[2]}]
set_property PACKAGE_PIN M27 [get_ports {okUH[3]}]
set_property PACKAGE_PIN L24 [get_ports {okUH[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUH[*]}]

set_property PACKAGE_PIN R26 [get_ports {okUHU[0]}]
set_property PACKAGE_PIN R25 [get_ports {okUHU[1]}]
set_property PACKAGE_PIN P23 [get_ports {okUHU[2]}]
set_property PACKAGE_PIN R23 [get_ports {okUHU[3]}]
set_property PACKAGE_PIN M22 [get_ports {okUHU[4]}]
set_property PACKAGE_PIN N22 [get_ports {okUHU[5]}]
set_property PACKAGE_PIN P21 [get_ports {okUHU[6]}]
set_property PACKAGE_PIN P20 [get_ports {okUHU[7]}]
set_property PACKAGE_PIN R22 [get_ports {okUHU[8]}]
set_property PACKAGE_PIN R21 [get_ports {okUHU[9]}]
set_property PACKAGE_PIN L20 [get_ports {okUHU[10]}]
set_property PACKAGE_PIN M20 [get_ports {okUHU[11]}]
set_property PACKAGE_PIN N26 [get_ports {okUHU[12]}]
set_property PACKAGE_PIN L25 [get_ports {okUHU[13]}]
set_property PACKAGE_PIN N24 [get_ports {okUHU[14]}]
set_property PACKAGE_PIN P25 [get_ports {okUHU[15]}]
set_property PACKAGE_PIN L22 [get_ports {okUHU[16]}]
set_property PACKAGE_PIN G27 [get_ports {okUHU[17]}]
set_property PACKAGE_PIN H23 [get_ports {okUHU[18]}]
set_property PACKAGE_PIN M21 [get_ports {okUHU[19]}]
set_property PACKAGE_PIN H24 [get_ports {okUHU[20]}]
set_property PACKAGE_PIN K23 [get_ports {okUHU[21]}]
set_property PACKAGE_PIN J23 [get_ports {okUHU[22]}]
set_property PACKAGE_PIN G25 [get_ports {okUHU[23]}]
set_property PACKAGE_PIN J26 [get_ports {okUHU[24]}]
set_property PACKAGE_PIN L23 [get_ports {okUHU[25]}]
set_property PACKAGE_PIN J24 [get_ports {okUHU[26]}]
set_property PACKAGE_PIN K21 [get_ports {okUHU[27]}]
set_property PACKAGE_PIN K25 [get_ports {okUHU[28]}]
set_property PACKAGE_PIN K20 [get_ports {okUHU[29]}]
set_property PACKAGE_PIN N21 [get_ports {okUHU[30]}]
set_property PACKAGE_PIN J25 [get_ports {okUHU[31]}]
set_property SLEW FAST [get_ports {okUHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUHU[*]}]

set_property PACKAGE_PIN K22 [get_ports {okAA}]
set_property IOSTANDARD LVCMOS18 [get_ports {okAA}]


create_clock -name okUH0 -period 9.920 [get_ports {okUH[0]}]

set_input_delay -add_delay -max -clock [get_clocks {okUH0}]  8.000 [get_ports {okUH[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okUH0}] 9.920 [get_ports {okUH[*]}]

set_input_delay -add_delay -max -clock [get_clocks {okUH0}]  7.000 [get_ports {okUHU[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okUH0}]  2.000 [get_ports {okUHU[*]}]

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okHU[*]}]

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okUHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okUHU[*]}]

############################################################################
## System Clock(FABRIC_REFCLK)
############################################################################
set_property IOSTANDARD LVDS [get_ports {sys_clkp}]
set_property PACKAGE_PIN E22 [get_ports {sys_clkp}]

set_property IOSTANDARD LVDS [get_ports {sys_clkn}]
set_property PACKAGE_PIN E23 [get_ports {sys_clkn}]

set_property DIFF_TERM FALSE [get_ports {sys_clkp}]

create_clock -name sys_clk -period 5 [get_ports sys_clkp]
set_clock_groups -asynchronous -group [get_clocks {sys_clk}] -group [get_clocks {mmcm0_clk0 okUH0}]

############################################################################
## LEDs
############################################################################
set_property PACKAGE_PIN E20 [get_ports {led[0]}]
set_property PACKAGE_PIN F20 [get_ports {led[1]}]
set_property PACKAGE_PIN G20 [get_ports {led[2]}]
set_property PACKAGE_PIN E21 [get_ports {led[3]}]
set_property PACKAGE_PIN F23 [get_ports {led[4]}]
set_property PACKAGE_PIN G24 [get_ports {led[5]}]
set_property PACKAGE_PIN F24 [get_ports {led[6]}]
set_property PACKAGE_PIN F25 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[*]}]

