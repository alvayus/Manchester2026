############################################################################
# XEM7350 - Xilinx constraints file
#
# Pin mappings for the XEM7350.  Use this as a template and comment out 
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2014 Opal Kelly Incorporated
############################################################################

############################################################################
## FrontPanel Host Interface
############################################################################
set_property PACKAGE_PIN F23 [get_ports {okHU[0]}]
set_property PACKAGE_PIN H23 [get_ports {okHU[1]}]
set_property PACKAGE_PIN J25 [get_ports {okHU[2]}]
set_property SLEW FAST [get_ports {okHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okHU[*]}]

set_property PACKAGE_PIN F22 [get_ports {okUH[0]}]
set_property PACKAGE_PIN G24 [get_ports {okUH[1]}]
set_property PACKAGE_PIN J26 [get_ports {okUH[2]}]
set_property PACKAGE_PIN G26 [get_ports {okUH[3]}]
set_property PACKAGE_PIN C23 [get_ports {okUH[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUH[*]}]

set_property PACKAGE_PIN B21 [get_ports {okUHU[0]}]
set_property PACKAGE_PIN C21 [get_ports {okUHU[1]}]
set_property PACKAGE_PIN E22 [get_ports {okUHU[2]}]
set_property PACKAGE_PIN A20 [get_ports {okUHU[3]}]
set_property PACKAGE_PIN B20 [get_ports {okUHU[4]}]
set_property PACKAGE_PIN C22 [get_ports {okUHU[5]}]
set_property PACKAGE_PIN D21 [get_ports {okUHU[6]}]
set_property PACKAGE_PIN C24 [get_ports {okUHU[7]}]
set_property PACKAGE_PIN C26 [get_ports {okUHU[8]}]
set_property PACKAGE_PIN D26 [get_ports {okUHU[9]}]
set_property PACKAGE_PIN A24 [get_ports {okUHU[10]}]
set_property PACKAGE_PIN A23 [get_ports {okUHU[11]}]
set_property PACKAGE_PIN A22 [get_ports {okUHU[12]}]
set_property PACKAGE_PIN B22 [get_ports {okUHU[13]}]
set_property PACKAGE_PIN A25 [get_ports {okUHU[14]}]
set_property PACKAGE_PIN B24 [get_ports {okUHU[15]}]
set_property PACKAGE_PIN G21 [get_ports {okUHU[16]}]
set_property PACKAGE_PIN E23 [get_ports {okUHU[17]}]
set_property PACKAGE_PIN E21 [get_ports {okUHU[18]}]
set_property PACKAGE_PIN H22 [get_ports {okUHU[19]}]
set_property PACKAGE_PIN D23 [get_ports {okUHU[20]}]
set_property PACKAGE_PIN J21 [get_ports {okUHU[21]}]
set_property PACKAGE_PIN K22 [get_ports {okUHU[22]}]
set_property PACKAGE_PIN D24 [get_ports {okUHU[23]}]
set_property PACKAGE_PIN K23 [get_ports {okUHU[24]}]
set_property PACKAGE_PIN H24 [get_ports {okUHU[25]}]
set_property PACKAGE_PIN F24 [get_ports {okUHU[26]}]
set_property PACKAGE_PIN D25 [get_ports {okUHU[27]}]
set_property PACKAGE_PIN J24 [get_ports {okUHU[28]}]
set_property PACKAGE_PIN B26 [get_ports {okUHU[29]}]
set_property PACKAGE_PIN H26 [get_ports {okUHU[30]}]
set_property PACKAGE_PIN E26 [get_ports {okUHU[31]}]
set_property SLEW FAST [get_ports {okUHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUHU[*]}]

set_property PACKAGE_PIN R26 [get_ports {okAA}]
set_property IOSTANDARD LVCMOS33 [get_ports {okAA}]


create_clock -name okUH0 -period 9.920 [get_ports {okUH[0]}]
create_clock -name virt_okUH0 -period 9.920

set_clock_groups -name async-mmcm-user-virt -asynchronous -group {mmcm0_clk0} -group {virt_okUH0}

set_input_delay -add_delay -max -clock [get_clocks {virt_okUH0}]  8.000 [get_ports {okUH[*]}]
set_input_delay -add_delay -min -clock [get_clocks {virt_okUH0}]  0.000 [get_ports {okUH[*]}]

set_input_delay -add_delay -max -clock [get_clocks {virt_okUH0}]  8.000 [get_ports {okUHU[*]}]
set_input_delay -add_delay -min -clock [get_clocks {virt_okUH0}]  2.000 [get_ports {okUHU[*]}]

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okHU[*]}]

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okUHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okUHU[*]}]


############################################################################
## System Clock
############################################################################
set_property IOSTANDARD LVDS [get_ports {sys_clkp}]
set_property PACKAGE_PIN AC4 [get_ports {sys_clkp}]

set_property IOSTANDARD LVDS [get_ports {sys_clkn}]
set_property PACKAGE_PIN AC3 [get_ports {sys_clkn}]

create_clock -name sys_clk -period 5 [get_ports sys_clkp]

# LEDs #####################################################################
set_property PACKAGE_PIN T24 [get_ports {led[0]}]
set_property PACKAGE_PIN T25 [get_ports {led[1]}]
set_property PACKAGE_PIN R25 [get_ports {led[2]}]
set_property PACKAGE_PIN P26 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# LA[33..0] ######################################
set_property IOSTANDARD LVCMOS25 [get_ports {la_p[*]}]
set_property IOSTANDARD LVCMOS25 [get_ports {la_n[*]}]

set_property PACKAGE_PIN H17 [get_ports {la_p[0]}]
set_property PACKAGE_PIN H18 [get_ports {la_n[0]}]
set_property PACKAGE_PIN G17 [get_ports {la_p[1]}]
set_property PACKAGE_PIN F18 [get_ports {la_n[1]}]
set_property PACKAGE_PIN G19 [get_ports {la_p[2]}]
set_property PACKAGE_PIN F20 [get_ports {la_n[2]}]
set_property PACKAGE_PIN A18 [get_ports {la_p[3]}]
set_property PACKAGE_PIN A19 [get_ports {la_n[3]}]
set_property PACKAGE_PIN D19 [get_ports {la_p[4]}]
set_property PACKAGE_PIN D20 [get_ports {la_n[4]}]
set_property PACKAGE_PIN C17 [get_ports {la_p[5]}]
set_property PACKAGE_PIN C18 [get_ports {la_n[5]}]
set_property PACKAGE_PIN C19 [get_ports {la_p[6]}]
set_property PACKAGE_PIN B19 [get_ports {la_n[6]}]
set_property PACKAGE_PIN J18 [get_ports {la_p[7]}]
set_property PACKAGE_PIN J19 [get_ports {la_n[7]}]

set_property PACKAGE_PIN F19 [get_ports {la_p[8]}]
set_property PACKAGE_PIN E20 [get_ports {la_n[8]}]
set_property PACKAGE_PIN L19 [get_ports {la_p[9]}]
set_property PACKAGE_PIN L20 [get_ports {la_n[9]}]
set_property PACKAGE_PIN B17 [get_ports {la_p[10]}]
set_property PACKAGE_PIN A17 [get_ports {la_n[10]}]
set_property PACKAGE_PIN C16 [get_ports {la_p[11]}]
set_property PACKAGE_PIN B16 [get_ports {la_n[11]}]
set_property PACKAGE_PIN H19 [get_ports {la_p[12]}]
set_property PACKAGE_PIN G20 [get_ports {la_n[12]}]
set_property PACKAGE_PIN E15 [get_ports {la_p[13]}]
set_property PACKAGE_PIN E16 [get_ports {la_n[13]}]
set_property PACKAGE_PIN H16 [get_ports {la_p[14]}]
set_property PACKAGE_PIN G16 [get_ports {la_n[14]}]
set_property PACKAGE_PIN K16 [get_ports {la_p[15]}]
set_property PACKAGE_PIN K17 [get_ports {la_n[15]}]

set_property PACKAGE_PIN A9 [get_ports {la_p[16]}]
set_property PACKAGE_PIN A8 [get_ports {la_n[16]}]
set_property PACKAGE_PIN E10 [get_ports {la_p[17]}]
set_property PACKAGE_PIN D10 [get_ports {la_n[17]}]
set_property PACKAGE_PIN F17 [get_ports {la_p[18]}]
set_property PACKAGE_PIN E17 [get_ports {la_n[18]}]
set_property PACKAGE_PIN M17 [get_ports {la_p[19]}]
set_property PACKAGE_PIN L18 [get_ports {la_n[19]}]
set_property PACKAGE_PIN L17 [get_ports {la_p[20]}]
set_property PACKAGE_PIN K18 [get_ports {la_n[20]}]
set_property PACKAGE_PIN G15 [get_ports {la_p[21]}]
set_property PACKAGE_PIN F15 [get_ports {la_n[21]}]
set_property PACKAGE_PIN G11 [get_ports {la_p[22]}]
set_property PACKAGE_PIN F10 [get_ports {la_n[22]}]
set_property PACKAGE_PIN F14 [get_ports {la_p[23]}]
set_property PACKAGE_PIN F13 [get_ports {la_n[23]}]

set_property PACKAGE_PIN H14 [get_ports {la_p[24]}]
set_property PACKAGE_PIN G14 [get_ports {la_n[24]}]
set_property PACKAGE_PIN J15 [get_ports {la_p[25]}]
set_property PACKAGE_PIN J16 [get_ports {la_n[25]}]
set_property PACKAGE_PIN C9 [get_ports {la_p[26]}]
set_property PACKAGE_PIN B9 [get_ports {la_n[26]}]
set_property PACKAGE_PIN D9 [get_ports {la_p[27]}]
set_property PACKAGE_PIN D8 [get_ports {la_n[27]}]
set_property PACKAGE_PIN G12 [get_ports {la_p[28]}]
set_property PACKAGE_PIN F12 [get_ports {la_n[28]}]
set_property PACKAGE_PIN J13 [get_ports {la_p[29]}]
set_property PACKAGE_PIN H13 [get_ports {la_n[29]}]
set_property PACKAGE_PIN G10 [get_ports {la_p[30]}]
set_property PACKAGE_PIN G9 [get_ports {la_n[30]}]
set_property PACKAGE_PIN J11 [get_ports {la_p[31]}]
set_property PACKAGE_PIN J10 [get_ports {la_n[31]}]

set_property PACKAGE_PIN H9 [get_ports {la_p[32]}]
set_property PACKAGE_PIN H8 [get_ports {la_n[32]}]
set_property PACKAGE_PIN F9 [get_ports {la_p[33]}]
set_property PACKAGE_PIN F8 [get_ports {la_n[33]}]
