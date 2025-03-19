############################################################################
# XEM8305 - Xilinx constraints file
#
# Pin mappings for the XEM8305.  Use this as a template and comment out 
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2023 Opal Kelly Incorporated
############################################################################

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

############################################################################
## FrontPanel Host Interface
############################################################################
set_property PACKAGE_PIN W19 [get_ports {okHU[0]}]
set_property PACKAGE_PIN Y26 [get_ports {okHU[1]}]
set_property PACKAGE_PIN AA24 [get_ports {okHU[2]}]
set_property SLEW FAST [get_ports {okHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okHU[*]}]

set_property PACKAGE_PIN V23 [get_ports {okUH[0]}]
set_property PACKAGE_PIN U22 [get_ports {okUH[1]}]
set_property PACKAGE_PIN W25 [get_ports {okUH[2]}]
set_property PACKAGE_PIN U26 [get_ports {okUH[3]}]
set_property PACKAGE_PIN AA23 [get_ports {okUH[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUH[*]}]

set_property PACKAGE_PIN P26 [get_ports {okUHU[0]}]
set_property PACKAGE_PIN P25 [get_ports {okUHU[1]}]
set_property PACKAGE_PIN R26 [get_ports {okUHU[2]}]
set_property PACKAGE_PIN R25 [get_ports {okUHU[3]}]
set_property PACKAGE_PIN R23 [get_ports {okUHU[4]}]
set_property PACKAGE_PIN R22 [get_ports {okUHU[5]}]
set_property PACKAGE_PIN P21 [get_ports {okUHU[6]}]
set_property PACKAGE_PIN P20 [get_ports {okUHU[7]}]
set_property PACKAGE_PIN R21 [get_ports {okUHU[8]}]
set_property PACKAGE_PIN R20 [get_ports {okUHU[9]}]
set_property PACKAGE_PIN P23 [get_ports {okUHU[10]}]
set_property PACKAGE_PIN N23 [get_ports {okUHU[11]}]
set_property PACKAGE_PIN T25 [get_ports {okUHU[12]}]
set_property PACKAGE_PIN N24 [get_ports {okUHU[13]}]
set_property PACKAGE_PIN N22 [get_ports {okUHU[14]}]
set_property PACKAGE_PIN V26 [get_ports {okUHU[15]}]
set_property PACKAGE_PIN W20 [get_ports {okUHU[16]}]
set_property PACKAGE_PIN T23 [get_ports {okUHU[17]}]
set_property PACKAGE_PIN V21 [get_ports {okUHU[18]}]
set_property PACKAGE_PIN V22 [get_ports {okUHU[19]}]
set_property PACKAGE_PIN T22 [get_ports {okUHU[20]}]
set_property PACKAGE_PIN U25 [get_ports {okUHU[21]}]
set_property PACKAGE_PIN P19 [get_ports {okUHU[22]}]
set_property PACKAGE_PIN W26 [get_ports {okUHU[23]}]
set_property PACKAGE_PIN N21 [get_ports {okUHU[24]}]
set_property PACKAGE_PIN U20 [get_ports {okUHU[25]}]
set_property PACKAGE_PIN U21 [get_ports {okUHU[26]}]
set_property PACKAGE_PIN AA25 [get_ports {okUHU[27]}]
set_property PACKAGE_PIN T20 [get_ports {okUHU[28]}]
set_property PACKAGE_PIN N19 [get_ports {okUHU[29]}]
set_property PACKAGE_PIN W21 [get_ports {okUHU[30]}]
set_property PACKAGE_PIN Y23 [get_ports {okUHU[31]}]
set_property SLEW FAST [get_ports {okUHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUHU[*]}]


set_property PACKAGE_PIN T19 [get_ports {okAA}]
set_property IOSTANDARD LVCMOS18 [get_ports {okAA}]


create_clock -name okUH0 -period 9.920 [get_ports {okUH[0]}]

set_input_delay -add_delay -max -clock [get_clocks {okUH0}]  8.000 [get_ports {okUH[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okUH0}] 9.920 [get_ports {okUH[*]}]
#set_multicycle_path -setup -from [get_ports {okUH[*]}] 2

set_input_delay -add_delay -max -clock [get_clocks {okUH0}]  7.000 [get_ports {okUHU[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okUH0}]  2.000 [get_ports {okUHU[*]}]
#set_multicycle_path -setup -from [get_ports {okUHU[*]}] 2

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okHU[*]}]

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okUHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okUHU[*]}]

############################################################################
## System Clock / DDR4 Refclk
############################################################################
set_property IOSTANDARD LVDS [get_ports {ddr4_refclk_p}]
set_property PACKAGE_PIN J23 [get_ports {ddr4_refclk_p}]

set_property IOSTANDARD LVDS [get_ports {ddr4_refclk_n}]
set_property PACKAGE_PIN J24 [get_ports {ddr4_refclk_n}]

set_property DIFF_TERM FALSE [get_ports {ddr4_refclk_p}]

create_clock -name ddr4_refclk -period 6.4 [get_ports ddr4_refclk_p]

#We know that the okClk domain will be asynchronous to the sys_clk domain. WireIns controls will cause timing errors.
set_clock_groups -name async-groups -asynchronous \
-group [get_clocks -include_generated_clocks okUH0] \
-group [get_clocks -include_generated_clocks ddr4_refclk]

# LEDs #####################################################################
set_property PACKAGE_PIN U19 [get_ports {led[0]}]
set_property PACKAGE_PIN V19 [get_ports {led[1]}]
set_property PACKAGE_PIN T24 [get_ports {led[2]}]
set_property PACKAGE_PIN U24 [get_ports {led[3]}]
set_property PACKAGE_PIN V24 [get_ports {led[4]}]
set_property PACKAGE_PIN W23 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[*]}]

############################################################################
## DDR4 #IOSTANDARD, OUTPUT_IMPEDANCE, SLEW, etc. are set by the MIG generated outputs.
############################################################################
set_property PACKAGE_PIN J20 [get_ports {ddr4_addr[0]}]
set_property PACKAGE_PIN M26 [get_ports {ddr4_addr[1]}]
set_property PACKAGE_PIN J19 [get_ports {ddr4_addr[2]}]
set_property PACKAGE_PIN L23 [get_ports {ddr4_addr[3]}]
set_property PACKAGE_PIN M25 [get_ports {ddr4_addr[4]}]
set_property PACKAGE_PIN L20 [get_ports {ddr4_addr[5]}]
set_property PACKAGE_PIN J21 [get_ports {ddr4_addr[6]}]
set_property PACKAGE_PIN M20 [get_ports {ddr4_addr[7]}]
set_property PACKAGE_PIN K20 [get_ports {ddr4_addr[8]}]
set_property PACKAGE_PIN M24 [get_ports {ddr4_addr[9]}]
set_property PACKAGE_PIN L25 [get_ports {ddr4_addr[10]}]
set_property PACKAGE_PIN K25 [get_ports {ddr4_addr[11]}]
set_property PACKAGE_PIN L22 [get_ports {ddr4_addr[12]}]
set_property PACKAGE_PIN M21 [get_ports {ddr4_addr[13]}]
set_property PACKAGE_PIN F22 [get_ports {ddr4_addr[14]}]
set_property PACKAGE_PIN K23 [get_ports {ddr4_addr[15]}]
set_property PACKAGE_PIN K22 [get_ports {ddr4_addr[16]}]
set_property PACKAGE_PIN K18 [get_ports {ddr4_ba[0]}]
set_property PACKAGE_PIN L18 [get_ports {ddr4_ba[1]}]
set_property PACKAGE_PIN G22 [get_ports {ddr4_bg[0]}]
set_property PACKAGE_PIN E23 [get_ports {ddr4_dq[0]}]
set_property PACKAGE_PIN D25 [get_ports {ddr4_dq[1]}]
set_property PACKAGE_PIN D24 [get_ports {ddr4_dq[2]}]
set_property PACKAGE_PIN C26 [get_ports {ddr4_dq[3]}]
set_property PACKAGE_PIN F23 [get_ports {ddr4_dq[4]}]
set_property PACKAGE_PIN B25 [get_ports {ddr4_dq[5]}]
set_property PACKAGE_PIN D26 [get_ports {ddr4_dq[6]}]
set_property PACKAGE_PIN B26 [get_ports {ddr4_dq[7]}]
set_property PACKAGE_PIN H26 [get_ports {ddr4_dq[8]}]
set_property PACKAGE_PIN H22 [get_ports {ddr4_dq[9]}]
set_property PACKAGE_PIN G26 [get_ports {ddr4_dq[10]}]
set_property PACKAGE_PIN H24 [get_ports {ddr4_dq[11]}]
set_property PACKAGE_PIN J26 [get_ports {ddr4_dq[12]}]
set_property PACKAGE_PIN H21 [get_ports {ddr4_dq[13]}]
set_property PACKAGE_PIN J25 [get_ports {ddr4_dq[14]}]
set_property PACKAGE_PIN H23 [get_ports {ddr4_dq[15]}]
set_property PACKAGE_PIN G25 [get_ports {ddr4_act_n[0]}]
set_property PACKAGE_PIN M19 [get_ports {ddr4_ck_t[0]}]
set_property PACKAGE_PIN L19 [get_ports {ddr4_ck_c[0]}]
set_property PACKAGE_PIN K21 [get_ports {ddr4_cke[0]}]
set_property PACKAGE_PIN K26 [get_ports {ddr4_cs_n[0]}]
set_property PACKAGE_PIN E26 [get_ports {ddr4_odt[0]}]
set_property PACKAGE_PIN D23 [get_ports ddr4_dqs_t[0]]
set_property PACKAGE_PIN C24 [get_ports ddr4_dqs_c[0]]
set_property PACKAGE_PIN F24 [get_ports ddr4_dqs_t[1]]
set_property PACKAGE_PIN F25 [get_ports ddr4_dqs_c[1]]
set_property PACKAGE_PIN E25 [get_ports ddr4_dm[0]]
set_property PACKAGE_PIN G24 [get_ports ddr4_dm[1]]
set_property PACKAGE_PIN L24 [get_ports ddr4_reset_n]
