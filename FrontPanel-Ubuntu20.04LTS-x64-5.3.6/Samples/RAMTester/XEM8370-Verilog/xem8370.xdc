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
## System Clock. Additional constraints are set by the MIG generated outputs.
############################################################################
set_property PACKAGE_PIN E22 [get_ports {ddr4_refclk_p}]
set_property PACKAGE_PIN E23 [get_ports {ddr4_refclk_n}]

#We know that the okClk domain will be asynchronous to the sys_clk domain. WireIns controls will cause timing errors.
set_clock_groups -name async-groups -asynchronous \
-group [get_clocks -include_generated_clocks okUH0] \
-group [get_clocks -include_generated_clocks ddr4_refclk_p]


# LEDS #####################################################################
set_property PACKAGE_PIN E20 [get_ports {led[0]}]
set_property PACKAGE_PIN F20 [get_ports {led[1]}]
set_property PACKAGE_PIN G20 [get_ports {led[2]}]
set_property PACKAGE_PIN E21 [get_ports {led[3]}]
set_property PACKAGE_PIN F23 [get_ports {led[4]}]
set_property PACKAGE_PIN G24 [get_ports {led[5]}]
set_property PACKAGE_PIN F24 [get_ports {led[6]}]
set_property PACKAGE_PIN F25 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[*]}]

############################################################################
## DDR4
############################################################################
set_property PACKAGE_PIN C18 [get_ports {ddr4_dq[0]}]
set_property PACKAGE_PIN A18 [get_ports {ddr4_dq[1]}]
set_property PACKAGE_PIN A19 [get_ports {ddr4_dq[2]}]
set_property PACKAGE_PIN A15 [get_ports {ddr4_dq[3]}]
set_property PACKAGE_PIN B17 [get_ports {ddr4_dq[4]}]
set_property PACKAGE_PIN B16 [get_ports {ddr4_dq[5]}]
set_property PACKAGE_PIN C17 [get_ports {ddr4_dq[6]}]
set_property PACKAGE_PIN B15 [get_ports {ddr4_dq[7]}]
set_property PACKAGE_PIN E17 [get_ports {ddr4_dq[8]}]
set_property PACKAGE_PIN D16 [get_ports {ddr4_dq[9]}]
set_property PACKAGE_PIN E18 [get_ports {ddr4_dq[10]}]
set_property PACKAGE_PIN E15 [get_ports {ddr4_dq[11]}]
set_property PACKAGE_PIN E16 [get_ports {ddr4_dq[12]}]
set_property PACKAGE_PIN D15 [get_ports {ddr4_dq[13]}]
set_property PACKAGE_PIN F14 [get_ports {ddr4_dq[14]}]
set_property PACKAGE_PIN F15 [get_ports {ddr4_dq[15]}]
set_property PACKAGE_PIN H19 [get_ports {ddr4_dq[16]}]
set_property PACKAGE_PIN H17 [get_ports {ddr4_dq[17]}]
set_property PACKAGE_PIN F18 [get_ports {ddr4_dq[18]}]
set_property PACKAGE_PIN G15 [get_ports {ddr4_dq[19]}]
set_property PACKAGE_PIN H18 [get_ports {ddr4_dq[20]}]
set_property PACKAGE_PIN H16 [get_ports {ddr4_dq[21]}]
set_property PACKAGE_PIN F17 [get_ports {ddr4_dq[22]}]
set_property PACKAGE_PIN G14 [get_ports {ddr4_dq[23]}]
set_property PACKAGE_PIN L18 [get_ports {ddr4_dq[24]}]
set_property PACKAGE_PIN K16 [get_ports {ddr4_dq[25]}]
set_property PACKAGE_PIN K18 [get_ports {ddr4_dq[26]}]
set_property PACKAGE_PIN K17 [get_ports {ddr4_dq[27]}]
set_property PACKAGE_PIN L19 [get_ports {ddr4_dq[28]}]
set_property PACKAGE_PIN L15 [get_ports {ddr4_dq[29]}]
set_property PACKAGE_PIN K15 [get_ports {ddr4_dq[30]}]
set_property PACKAGE_PIN J16 [get_ports {ddr4_dq[31]}]
set_property PACKAGE_PIN B14 [get_ports {ddr4_dm[0]}]
set_property PACKAGE_PIN D14 [get_ports {ddr4_dm[1]}]
set_property PACKAGE_PIN G17 [get_ports {ddr4_dm[2]}]
set_property PACKAGE_PIN J15 [get_ports {ddr4_dm[3]}]
set_property PACKAGE_PIN C19 [get_ports {ddr4_dqs_t[0]}]
set_property PACKAGE_PIN B19 [get_ports {ddr4_dqs_c[0]}]
set_property PACKAGE_PIN D19 [get_ports {ddr4_dqs_t[1]}]
set_property PACKAGE_PIN D18 [get_ports {ddr4_dqs_c[1]}]
set_property PACKAGE_PIN G19 [get_ports {ddr4_dqs_t[2]}]
set_property PACKAGE_PIN F19 [get_ports {ddr4_dqs_c[2]}]
set_property PACKAGE_PIN J19 [get_ports {ddr4_dqs_t[3]}]
set_property PACKAGE_PIN J18 [get_ports {ddr4_dqs_c[3]}]
set_property PACKAGE_PIN A24 [get_ports {ddr4_act_n[0]}]
set_property PACKAGE_PIN C23 [get_ports {ddr4_addr[0]}]
set_property PACKAGE_PIN D23 [get_ports {ddr4_addr[1]}]
set_property PACKAGE_PIN D25 [get_ports {ddr4_addr[2]}]
set_property PACKAGE_PIN B27 [get_ports {ddr4_addr[3]}]
set_property PACKAGE_PIN C22 [get_ports {ddr4_addr[4]}]
set_property PACKAGE_PIN C28 [get_ports {ddr4_addr[5]}]
set_property PACKAGE_PIN C26 [get_ports {ddr4_addr[6]}]
set_property PACKAGE_PIN B29 [get_ports {ddr4_addr[7]}]
set_property PACKAGE_PIN C27 [get_ports {ddr4_addr[8]}]
set_property PACKAGE_PIN A29 [get_ports {ddr4_addr[9]}]
set_property PACKAGE_PIN A25 [get_ports {ddr4_addr[10]}]
set_property PACKAGE_PIN E28 [get_ports {ddr4_addr[11]}]
set_property PACKAGE_PIN B22 [get_ports {ddr4_addr[12]}]
set_property PACKAGE_PIN D28 [get_ports {ddr4_addr[13]}]
set_property PACKAGE_PIN A23 [get_ports {ddr4_addr[14]}]
set_property PACKAGE_PIN A27 [get_ports {ddr4_addr[15]}]
set_property PACKAGE_PIN B26 [get_ports {ddr4_addr[16]}]
set_property PACKAGE_PIN A28 [get_ports {ddr4_ba[1]}]
set_property PACKAGE_PIN B25 [get_ports {ddr4_ba[0]}]
set_property PACKAGE_PIN B24 [get_ports {ddr4_bg[0]}]
set_property PACKAGE_PIN F27 [get_ports {ddr4_ck_t[0]}]
set_property PACKAGE_PIN E27 [get_ports {ddr4_ck_c[0]}]
set_property PACKAGE_PIN A22 [get_ports {ddr4_cke[0]}]
set_property PACKAGE_PIN C21 [get_ports {ddr4_cs_n[0]}]
set_property PACKAGE_PIN B21 [get_ports {ddr4_odt[0]}]
set_property PACKAGE_PIN E25 [get_ports ddr4_reset_n]
set_property PACKAGE_PIN D29 [get_ports ddr4_alert_b]
set_property IOSTANDARD LVCMOS12 [get_ports {ddr4_alert_b}]
set_property PACKAGE_PIN D26 [get_ports ddr4_par]
set_property IOSTANDARD LVCMOS12 [get_ports {ddr4_par}]
