############################################################################
# XEM7010 - Xilinx constraints file
#
# Pin mappings for the XEM7010.  Use this as a template and comment out 
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2016 Opal Kelly Incorporated
############################################################################

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

set_property PACKAGE_PIN P20 [get_ports {hi_muxsel}]
set_property IOSTANDARD LVCMOS33 [get_ports {hi_muxsel}]

############################################################################
## FrontPanel Host Interface
############################################################################
set_property PACKAGE_PIN Y18  [get_ports {hi_in[0]}]
set_property PACKAGE_PIN V17  [get_ports {hi_in[1]}]
set_property PACKAGE_PIN AA19 [get_ports {hi_in[2]}]
set_property PACKAGE_PIN V20  [get_ports {hi_in[3]}]
set_property PACKAGE_PIN W17  [get_ports {hi_in[4]}]
set_property PACKAGE_PIN AB20 [get_ports {hi_in[5]}]
set_property PACKAGE_PIN V19  [get_ports {hi_in[6]}]
set_property PACKAGE_PIN AA18 [get_ports {hi_in[7]}]

set_property SLEW FAST [get_ports {hi_in[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hi_in[*]}]

set_property PACKAGE_PIN Y21 [get_ports {hi_out[0]}]
set_property PACKAGE_PIN U20 [get_ports {hi_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hi_out[*]}]

set_property PACKAGE_PIN AB22 [get_ports {hi_inout[0]}]
set_property PACKAGE_PIN AB21 [get_ports {hi_inout[1]}]
set_property PACKAGE_PIN Y22  [get_ports {hi_inout[2]}]
set_property PACKAGE_PIN AA21 [get_ports {hi_inout[3]}]
set_property PACKAGE_PIN AA20 [get_ports {hi_inout[4]}]
set_property PACKAGE_PIN W22  [get_ports {hi_inout[5]}]
set_property PACKAGE_PIN W21  [get_ports {hi_inout[6]}]
set_property PACKAGE_PIN T20  [get_ports {hi_inout[7]}]
set_property PACKAGE_PIN R19  [get_ports {hi_inout[8]}]
set_property PACKAGE_PIN P19  [get_ports {hi_inout[9]}]
set_property PACKAGE_PIN U21  [get_ports {hi_inout[10]}]
set_property PACKAGE_PIN T21  [get_ports {hi_inout[11]}]
set_property PACKAGE_PIN R21  [get_ports {hi_inout[12]}]
set_property PACKAGE_PIN P21  [get_ports {hi_inout[13]}]
set_property PACKAGE_PIN R22  [get_ports {hi_inout[14]}]
set_property PACKAGE_PIN P22  [get_ports {hi_inout[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hi_inout[*]}]

set_property PACKAGE_PIN V22 [get_ports {hi_aa}]
set_property IOSTANDARD LVCMOS33 [get_ports {hi_aa}]


create_clock -name okHostClk -period 20.83 [get_ports {hi_in[0]}]

set_input_delay -add_delay -max -clock [get_clocks {okHostClk}]  11.000 [get_ports {hi_inout[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okHostClk}]  0.000  [get_ports {hi_inout[*]}]
set_multicycle_path -setup -from [get_ports {hi_inout[*]}] 2

set_input_delay -add_delay -max -clock [get_clocks {okHostClk}]  6.700 [get_ports {hi_in[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okHostClk}]  0.000 [get_ports {hi_in[*]}]
set_multicycle_path -setup -from [get_ports {hi_in[*]}] 2

set_output_delay -add_delay -clock [get_clocks {okHostClk}]  8.900 [get_ports {hi_out[*]}]

set_output_delay -add_delay -clock [get_clocks {okHostClk}]  9.200 [get_ports {hi_inout[*]}]


set_property IOSTANDARD LVDS_25 [get_ports {sys_clk_p}]
set_property IOSTANDARD LVDS_25 [get_ports {sys_clk_n}]
set_property PACKAGE_PIN K4 [get_ports {sys_clk_p}]
set_property PACKAGE_PIN J4 [get_ports {sys_clk_n}]


#---------------------
# Expansion (MC1-XBUS)
#---------------------

# MC1-8 
set_property PACKAGE_PIN B20 [get_ports {xbus[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[0]}]

# MC1-15 
set_property PACKAGE_PIN P5 [get_ports {xbus[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[1]}]

# MC1-16 
set_property PACKAGE_PIN R1 [get_ports {xbus[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[2]}]

# MC1-17 
set_property PACKAGE_PIN P4 [get_ports {xbus[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[3]}]

# MC1-18 
set_property PACKAGE_PIN P1 [get_ports {xbus[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[4]}]

# MC1-19 
set_property PACKAGE_PIN P6 [get_ports {xbus[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[5]}]

# MC1-20 
set_property PACKAGE_PIN P2 [get_ports {xbus[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[6]}]

# MC1-21 
set_property PACKAGE_PIN N5 [get_ports {xbus[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[7]}]

# MC1-22 
set_property PACKAGE_PIN N2 [get_ports {xbus[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[8]}]

# MC1-23 
set_property PACKAGE_PIN N4 [get_ports {xbus[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[9]}]

# MC1-24 
set_property PACKAGE_PIN M3 [get_ports {xbus[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[10]}]

# MC1-25 
set_property PACKAGE_PIN N3 [get_ports {xbus[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[11]}]

# MC1-26 
set_property PACKAGE_PIN M2 [get_ports {xbus[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[12]}]

# MC1-27 
set_property PACKAGE_PIN M1 [get_ports {xbus[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[13]}]

# MC1-28 
set_property PACKAGE_PIN M6 [get_ports {xbus[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[14]}]

# MC1-29 
set_property PACKAGE_PIN L1 [get_ports {xbus[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[15]}]

# MC1-30 
set_property PACKAGE_PIN M5 [get_ports {xbus[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[16]}]

# MC1-31 
set_property PACKAGE_PIN L3 [get_ports {xbus[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[17]}]

# MC1-32 
set_property PACKAGE_PIN L5 [get_ports {xbus[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[18]}]

# MC1-33 
set_property PACKAGE_PIN K3 [get_ports {xbus[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[19]}]

# MC1-34 
set_property PACKAGE_PIN L4 [get_ports {xbus[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[20]}]

# MC1-37 
set_property PACKAGE_PIN K1 [get_ports {xbus[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[21]}]

# MC1-38 
set_property PACKAGE_PIN K2 [get_ports {xbus[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[22]}]

# MC1-39 
set_property PACKAGE_PIN J1 [get_ports {xbus[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[23]}]

# MC1-40 
set_property PACKAGE_PIN J2 [get_ports {xbus[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[24]}]

# MC1-41 
set_property PACKAGE_PIN H2 [get_ports {xbus[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[25]}]

# MC1-42 
set_property PACKAGE_PIN K6 [get_ports {xbus[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[26]}]

# MC1-43 
set_property PACKAGE_PIN G2 [get_ports {xbus[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[27]}]

# MC1-44 
set_property PACKAGE_PIN J6 [get_ports {xbus[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[28]}]

# MC1-45 
set_property PACKAGE_PIN H3 [get_ports {xbus[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[29]}]

# MC1-46 
set_property PACKAGE_PIN J5 [get_ports {xbus[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[30]}]

# MC1-47 
set_property PACKAGE_PIN G3 [get_ports {xbus[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[31]}]

# MC1-48 
set_property PACKAGE_PIN H5 [get_ports {xbus[32]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[32]}]

# MC1-49 
set_property PACKAGE_PIN E2 [get_ports {xbus[33]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[33]}]

# MC1-50 
set_property PACKAGE_PIN G1 [get_ports {xbus[34]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[34]}]

# MC1-51 
set_property PACKAGE_PIN D2 [get_ports {xbus[35]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[35]}]

# MC1-52 
set_property PACKAGE_PIN F1 [get_ports {xbus[36]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[36]}]

# MC1-53 
set_property PACKAGE_PIN E1 [get_ports {xbus[37]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[37]}]

# MC1-54 
set_property PACKAGE_PIN F3 [get_ports {xbus[38]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[38]}]

# MC1-57 
set_property PACKAGE_PIN D1 [get_ports {xbus[39]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[39]}]

# MC1-58 
set_property PACKAGE_PIN E3 [get_ports {xbus[40]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[40]}]

# MC1-59 
set_property PACKAGE_PIN B1 [get_ports {xbus[41]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[41]}]

# MC1-60 
set_property PACKAGE_PIN C2 [get_ports {xbus[42]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[42]}]

# MC1-61 
set_property PACKAGE_PIN A1 [get_ports {xbus[43]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[43]}]

# MC1-62 
set_property PACKAGE_PIN B2 [get_ports {xbus[44]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[44]}]

# MC1-63 
set_property PACKAGE_PIN E13 [get_ports {xbus[45]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[45]}]

# MC1-64 
set_property PACKAGE_PIN F13 [get_ports {xbus[46]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[46]}]

# MC1-65 
set_property PACKAGE_PIN E14 [get_ports {xbus[47]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[47]}]

# MC1-66 
set_property PACKAGE_PIN F14 [get_ports {xbus[48]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[48]}]

# MC1-67 
set_property PACKAGE_PIN C14 [get_ports {xbus[49]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[49]}]

# MC1-68 
set_property PACKAGE_PIN D14 [get_ports {xbus[50]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[50]}]

# MC1-69 
set_property PACKAGE_PIN C15 [get_ports {xbus[51]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[51]}]

# MC1-70 
set_property PACKAGE_PIN D15 [get_ports {xbus[52]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[52]}]

# MC1-71 
set_property PACKAGE_PIN B15 [get_ports {xbus[53]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[53]}]

# MC1-72 
set_property PACKAGE_PIN F16 [get_ports {xbus[54]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[54]}]

# MC1-73 
set_property PACKAGE_PIN B16 [get_ports {xbus[55]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[55]}]

# MC1-74 
set_property PACKAGE_PIN E17 [get_ports {xbus[56]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[56]}]

# MC1-75 
set_property PACKAGE_PIN E16 [get_ports {xbus[57]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[57]}]

# MC1-76 
set_property PACKAGE_PIN D16 [get_ports {xbus[58]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[58]}]

# MC1-77 
set_property PACKAGE_PIN H4 [get_ports {xbus[59]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[59]}]

# MC1-79 
set_property PACKAGE_PIN G4 [get_ports {xbus[60]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbus[60]}]

# MC2-10 
set_property PACKAGE_PIN J16 [get_ports {ybus[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[0]}]

# MC2-11 
set_property PACKAGE_PIN A20 [get_ports {ybus[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[1]}]

# MC2-12 
set_property PACKAGE_PIN M17 [get_ports {ybus[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[2]}]

# MC2-15 
set_property PACKAGE_PIN N18 [get_ports {ybus[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[3]}]

# MC2-16 
set_property PACKAGE_PIN N20 [get_ports {ybus[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[4]}]

# MC2-17 
set_property PACKAGE_PIN N19 [get_ports {ybus[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[5]}]

# MC2-18 
set_property PACKAGE_PIN M20 [get_ports {ybus[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[6]}]

# MC2-19 
set_property PACKAGE_PIN M15 [get_ports {ybus[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[7]}]

# MC2-20 
set_property PACKAGE_PIN M13 [get_ports {ybus[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[8]}]

# MC2-21 
set_property PACKAGE_PIN M16 [get_ports {ybus[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[9]}]

# MC2-22 
set_property PACKAGE_PIN L13 [get_ports {ybus[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[10]}]

# MC2-23 
set_property PACKAGE_PIN N22 [get_ports {ybus[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[11]}]

# MC2-24 
set_property PACKAGE_PIN M18 [get_ports {ybus[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[12]}]

# MC2-25 
set_property PACKAGE_PIN M22 [get_ports {ybus[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[13]}]

# MC2-26 
set_property PACKAGE_PIN L18 [get_ports {ybus[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[14]}]

# MC2-27 
set_property PACKAGE_PIN M21 [get_ports {ybus[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[15]}]

# MC2-28 
set_property PACKAGE_PIN L14 [get_ports {ybus[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[16]}]

# MC2-29 
set_property PACKAGE_PIN L21 [get_ports {ybus[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[17]}]

# MC2-30 
set_property PACKAGE_PIN L15 [get_ports {ybus[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[18]}]

# MC2-31 
set_property PACKAGE_PIN L19 [get_ports {ybus[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[19]}]

# MC2-32 
set_property PACKAGE_PIN K21 [get_ports {ybus[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[20]}]

# MC2-33 
set_property PACKAGE_PIN L20 [get_ports {ybus[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[21]}]

# MC2-34 
set_property PACKAGE_PIN K22 [get_ports {ybus[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[22]}]

# MC2-37 
set_property PACKAGE_PIN L16 [get_ports {ybus[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[23]}]

# MC2-38 
set_property PACKAGE_PIN K18 [get_ports {ybus[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[24]}]

# MC2-39 
set_property PACKAGE_PIN K16 [get_ports {ybus[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[25]}]

# MC2-40 
set_property PACKAGE_PIN K19 [get_ports {ybus[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[26]}]

# MC2-41 
set_property PACKAGE_PIN K13 [get_ports {ybus[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[27]}]

# MC2-42 
set_property PACKAGE_PIN J20 [get_ports {ybus[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[28]}]

# MC2-43 
set_property PACKAGE_PIN K14 [get_ports {ybus[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[29]}]

# MC2-44 
set_property PACKAGE_PIN J21 [get_ports {ybus[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[30]}]

# MC2-45 
set_property PACKAGE_PIN K17 [get_ports {ybus[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[31]}]

# MC2-46 
set_property PACKAGE_PIN J15 [get_ports {ybus[32]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[32]}]

# MC2-47 
set_property PACKAGE_PIN J17 [get_ports {ybus[33]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[33]}]

# MC2-48 
set_property PACKAGE_PIN H15 [get_ports {ybus[34]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[34]}]

# MC2-49 
set_property PACKAGE_PIN H17 [get_ports {ybus[35]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[35]}]

# MC2-50 
set_property PACKAGE_PIN J14 [get_ports {ybus[36]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[36]}]

# MC2-51 
set_property PACKAGE_PIN H18 [get_ports {ybus[37]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[37]}]

# MC2-52 
set_property PACKAGE_PIN H14 [get_ports {ybus[38]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[38]}]

# MC2-53 
set_property PACKAGE_PIN J22 [get_ports {ybus[39]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[39]}]

# MC2-54 
set_property PACKAGE_PIN H20 [get_ports {ybus[40]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[40]}]

# MC2-57 
set_property PACKAGE_PIN H22 [get_ports {ybus[41]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[41]}]

# MC2-58 
set_property PACKAGE_PIN G20 [get_ports {ybus[42]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[42]}]

# MC2-59 
set_property PACKAGE_PIN H13 [get_ports {ybus[43]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[43]}]

# MC2-60 
set_property PACKAGE_PIN G17 [get_ports {ybus[44]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[44]}]

# MC2-61 
set_property PACKAGE_PIN G13 [get_ports {ybus[45]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[45]}]

# MC2-62 
set_property PACKAGE_PIN G18 [get_ports {ybus[46]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[46]}]

# MC2-63 
set_property PACKAGE_PIN G21 [get_ports {ybus[47]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[47]}]

# MC2-64 
set_property PACKAGE_PIN G15 [get_ports {ybus[48]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[48]}]

# MC2-65 
set_property PACKAGE_PIN G22 [get_ports {ybus[49]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[49]}]

# MC2-66 
set_property PACKAGE_PIN G16 [get_ports {ybus[50]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[50]}]

# MC2-67 
set_property PACKAGE_PIN E22 [get_ports {ybus[51]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[51]}]

# MC2-68 
set_property PACKAGE_PIN E21 [get_ports {ybus[52]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[52]}]

# MC2-69 
set_property PACKAGE_PIN D22 [get_ports {ybus[53]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[53]}]

# MC2-70 
set_property PACKAGE_PIN D21 [get_ports {ybus[54]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[54]}]

# MC2-71 
set_property PACKAGE_PIN D20 [get_ports {ybus[55]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[55]}]

# MC2-72 
set_property PACKAGE_PIN C22 [get_ports {ybus[56]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[56]}]

# MC2-73 
set_property PACKAGE_PIN C20 [get_ports {ybus[57]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[57]}]

# MC2-74 
set_property PACKAGE_PIN B22 [get_ports {ybus[58]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[58]}]

# MC2-75 
set_property PACKAGE_PIN B21 [get_ports {ybus[59]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[59]}]

# MC2-76 
set_property PACKAGE_PIN A21 [get_ports {ybus[60]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[60]}]

# MC2-77 
set_property PACKAGE_PIN J19 [get_ports {ybus[61]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[61]}]

# MC2-79 
set_property PACKAGE_PIN H19 [get_ports {ybus[62]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybus[62]}]

# LEDs #####################################################################
set_property PACKAGE_PIN N13 [get_ports {led[0]}]
set_property PACKAGE_PIN N14 [get_ports {led[1]}]
set_property PACKAGE_PIN P15 [get_ports {led[2]}]
set_property PACKAGE_PIN P16 [get_ports {led[3]}]
set_property PACKAGE_PIN N17 [get_ports {led[4]}]
set_property PACKAGE_PIN P17 [get_ports {led[5]}]
set_property PACKAGE_PIN R16 [get_ports {led[6]}]
set_property PACKAGE_PIN R17 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
