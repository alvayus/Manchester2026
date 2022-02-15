############################################################################
# XEM7360 - Xilinx constraints file
#
# Pin mappings for the XEM7360.  Use this as a template and comment out 
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2016 Opal Kelly Incorporated
############################################################################

set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

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

set_input_delay -add_delay -max -clock [get_clocks {okUH0}]  8.000 [get_ports {okUH[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okUH0}] 10.000 [get_ports {okUH[*]}]
set_multicycle_path -setup -from [get_ports {okUH[*]}] 2

set_input_delay -add_delay -max -clock [get_clocks {okUH0}]  8.000 [get_ports {okUHU[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okUH0}]  2.000 [get_ports {okUHU[*]}]
set_multicycle_path -setup -from [get_ports {okUHU[*]}] 2

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okHU[*]}]

set_output_delay -add_delay -max -clock [get_clocks {okUH0}]  2.000 [get_ports {okUHU[*]}]
set_output_delay -add_delay -min -clock [get_clocks {okUH0}]  -0.500 [get_ports {okUHU[*]}]


############################################################################
## System Clock
############################################################################
set_property IOSTANDARD LVDS [get_ports {sys_clkp}]
set_property PACKAGE_PIN AB11 [get_ports {sys_clkp}]

set_property IOSTANDARD LVDS [get_ports {sys_clkn}]
set_property PACKAGE_PIN AC11 [get_ports {sys_clkn}]

create_clock -name sys_clk -period 5 [get_ports sys_clkp]
set_clock_groups -asynchronous -group [get_clocks {sys_clk}] -group [get_clocks {mmcm0_clk0}]

# MC1-1 
set_property PACKAGE_PIN B17 [get_ports {xbusp[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[0]}]

# MC1-2 
set_property PACKAGE_PIN C19 [get_ports {xbusp[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[1]}]

# MC1-3 
set_property PACKAGE_PIN A17 [get_ports {xbusn[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[0]}]

# MC1-4 
set_property PACKAGE_PIN B19 [get_ports {xbusn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[1]}]

# MC1-7 
set_property PACKAGE_PIN G17 [get_ports {xbusp[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[2]}]

# MC1-8 
set_property PACKAGE_PIN A18 [get_ports {xbusp[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[3]}]

# MC1-9 
set_property PACKAGE_PIN F18 [get_ports {xbusn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[2]}]

# MC1-10 
set_property PACKAGE_PIN A19 [get_ports {xbusn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[3]}]

# MC1-13 
set_property PACKAGE_PIN G19 [get_ports {xbusp[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[4]}]

# MC1-14 
set_property PACKAGE_PIN E15 [get_ports {xbusp[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[5]}]

# MC1-15 
set_property PACKAGE_PIN F20 [get_ports {xbusn[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[4]}]

# MC1-16 
set_property PACKAGE_PIN E16 [get_ports {xbusn[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[5]}]

# MC1-19 
set_property PACKAGE_PIN F19 [get_ports {xbusp[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[6]}]

# MC1-20 
set_property PACKAGE_PIN H19 [get_ports {xbusp[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[7]}]

# MC1-21 
set_property PACKAGE_PIN E20 [get_ports {xbusn[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[6]}]

# MC1-22 
set_property PACKAGE_PIN G20 [get_ports {xbusn[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[7]}]

# MC1-25 
set_property PACKAGE_PIN F17 [get_ports {xbusp[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[8]}]

# MC1-26 
set_property PACKAGE_PIN C17 [get_ports {xbusp[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[9]}]

# MC1-27 
set_property PACKAGE_PIN E17 [get_ports {xbusn[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[8]}]

# MC1-28 
set_property PACKAGE_PIN C18 [get_ports {xbusn[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[9]}]

# MC1-31 
set_property PACKAGE_PIN L19 [get_ports {xbusp[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[10]}]

# MC1-32 
set_property PACKAGE_PIN C16 [get_ports {xbusp[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[11]}]

# MC1-33 
set_property PACKAGE_PIN L20 [get_ports {xbusn[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[10]}]

# MC1-34 
set_property PACKAGE_PIN B16 [get_ports {xbusn[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[11]}]

# MC1-37 
set_property PACKAGE_PIN J18 [get_ports {xbusp[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[12]}]

# MC1-38 
set_property PACKAGE_PIN H17 [get_ports {xbusp[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[13]}]

# MC1-39 
set_property PACKAGE_PIN J19 [get_ports {xbusn[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[12]}]

# MC1-40 
set_property PACKAGE_PIN H18 [get_ports {xbusn[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[13]}]

# MC1-43 
set_property PACKAGE_PIN G15 [get_ports {xbusp[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[14]}]

# MC1-44 
set_property PACKAGE_PIN D19 [get_ports {xbusp[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[15]}]

# MC1-45 
set_property PACKAGE_PIN F15 [get_ports {xbusn[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[14]}]

# MC1-46 
set_property PACKAGE_PIN D20 [get_ports {xbusn[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[15]}]

# MC1-49 
set_property PACKAGE_PIN H16 [get_ports {xbusp[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[16]}]

# MC1-50 
set_property PACKAGE_PIN E18 [get_ports {xbusp[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[17]}]

# MC1-51 
set_property PACKAGE_PIN G16 [get_ports {xbusn[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[16]}]

# MC1-52 
set_property PACKAGE_PIN D18 [get_ports {xbusn[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[17]}]

# MC1-55 
set_property PACKAGE_PIN K16 [get_ports {xbusp[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[18]}]

# MC1-56 
set_property PACKAGE_PIN J15 [get_ports {xbusp[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[19]}]

# MC1-57 
set_property PACKAGE_PIN K17 [get_ports {xbusn[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[18]}]

# MC1-58 
set_property PACKAGE_PIN J16 [get_ports {xbusn[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[19]}]

# MC1-61 
set_property PACKAGE_PIN E11 [get_ports {xbusp[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[20]}]

# MC1-62 
set_property PACKAGE_PIN H14 [get_ports {xbusp[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[21]}]

# MC1-63 
set_property PACKAGE_PIN D11 [get_ports {xbusn[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[20]}]

# MC1-64 
set_property PACKAGE_PIN G14 [get_ports {xbusn[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[21]}]

# MC1-67 
set_property PACKAGE_PIN J13 [get_ports {xbusp[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[22]}]

# MC1-68 
set_property PACKAGE_PIN G12 [get_ports {xbusp[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[23]}]

# MC1-69 
set_property PACKAGE_PIN H13 [get_ports {xbusn[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[22]}]

# MC1-70 
set_property PACKAGE_PIN F12 [get_ports {xbusn[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[23]}]

# MC1-73 
set_property PACKAGE_PIN D14 [get_ports {xbusp[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[24]}]

# MC1-74 
set_property PACKAGE_PIN F14 [get_ports {xbusp[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[25]}]

# MC1-75 
set_property PACKAGE_PIN D13 [get_ports {xbusn[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[24]}]

# MC1-76 
set_property PACKAGE_PIN F13 [get_ports {xbusn[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[25]}]

# MC1-79 
set_property PACKAGE_PIN E13 [get_ports {xbusp[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[26]}]

# MC1-80 
set_property PACKAGE_PIN B12 [get_ports {xbusp[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[27]}]

# MC1-81 
set_property PACKAGE_PIN E12 [get_ports {xbusn[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[26]}]

# MC1-82 
set_property PACKAGE_PIN B11 [get_ports {xbusn[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[27]}]

# MC1-85 
set_property PACKAGE_PIN E10 [get_ports {xbusp[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[28]}]

# MC1-86 
set_property PACKAGE_PIN C12 [get_ports {xbusp[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[29]}]

# MC1-87 
set_property PACKAGE_PIN D10 [get_ports {xbusn[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[28]}]

# MC1-88 
set_property PACKAGE_PIN C11 [get_ports {xbusn[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[29]}]

# MC1-91 
set_property PACKAGE_PIN D9 [get_ports {xbusp[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[30]}]

# MC1-92 
set_property PACKAGE_PIN B14 [get_ports {xbusp[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[31]}]

# MC1-93 
set_property PACKAGE_PIN D8 [get_ports {xbusn[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[30]}]

# MC1-94 
set_property PACKAGE_PIN A14 [get_ports {xbusn[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[31]}]

# MC1-97 
set_property PACKAGE_PIN F9 [get_ports {xbusp[32]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[32]}]

# MC1-98 
set_property PACKAGE_PIN G11 [get_ports {xbusp[33]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[33]}]

# MC1-99 
set_property PACKAGE_PIN F8 [get_ports {xbusn[32]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[32]}]

# MC1-100 
set_property PACKAGE_PIN F10 [get_ports {xbusn[33]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[33]}]

# MC1-103 
set_property PACKAGE_PIN J11 [get_ports {xbusp[34]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[34]}]

# MC1-104 
set_property PACKAGE_PIN B10 [get_ports {xbusp[35]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[35]}]

# MC1-105 
set_property PACKAGE_PIN J10 [get_ports {xbusn[34]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[34]}]

# MC1-106 
set_property PACKAGE_PIN A10 [get_ports {xbusn[35]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[35]}]

# MC1-109 
set_property PACKAGE_PIN G10 [get_ports {xbusp[36]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[36]}]

# MC1-110 
set_property PACKAGE_PIN C9 [get_ports {xbusp[37]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[37]}]

# MC1-111 
set_property PACKAGE_PIN G9 [get_ports {xbusn[36]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[36]}]

# MC1-112 
set_property PACKAGE_PIN B9 [get_ports {xbusn[37]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[37]}]

# MC1-115 
set_property PACKAGE_PIN H9 [get_ports {xbusp[38]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[38]}]

# MC1-116 
set_property PACKAGE_PIN A9 [get_ports {xbusp[39]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[39]}]

# MC1-117 
set_property PACKAGE_PIN H8 [get_ports {xbusn[38]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[38]}]

# MC1-118 
set_property PACKAGE_PIN A8 [get_ports {xbusn[39]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[39]}]

# MC2-1 
set_property PACKAGE_PIN AE23 [get_ports {ybusp[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[0]}]

# MC2-2 
set_property PACKAGE_PIN U26 [get_ports {ybusp[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[1]}]

# MC2-3 
set_property PACKAGE_PIN AF23 [get_ports {ybusn[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[0]}]

# MC2-4 
set_property PACKAGE_PIN V26 [get_ports {ybusn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[1]}]

# MC2-7 
set_property PACKAGE_PIN AC23 [get_ports {ybusp[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[2]}]

# MC2-8 
set_property PACKAGE_PIN V21 [get_ports {ybusp[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[3]}]

# MC2-9 
set_property PACKAGE_PIN AC24 [get_ports {ybusn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[2]}]

# MC2-10 
set_property PACKAGE_PIN W21 [get_ports {ybusn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[3]}]

# MC2-13 
set_property PACKAGE_PIN AF24 [get_ports {ybusp[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[4]}]

# MC2-14 
set_property PACKAGE_PIN W25 [get_ports {ybusp[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[5]}]

# MC2-15 
set_property PACKAGE_PIN AF25 [get_ports {ybusn[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[4]}]

# MC2-16 
set_property PACKAGE_PIN W26 [get_ports {ybusn[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[5]}]

# MC2-19 
set_property PACKAGE_PIN Y25 [get_ports {ybusp[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[6]}]

# MC2-20 
set_property PACKAGE_PIN W23 [get_ports {ybusp[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[7]}]

# MC2-21 
set_property PACKAGE_PIN Y26 [get_ports {ybusn[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[6]}]

# MC2-22 
set_property PACKAGE_PIN W24 [get_ports {ybusn[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[7]}]

# MC2-25 
set_property PACKAGE_PIN Y23 [get_ports {ybusp[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[8]}]

# MC2-26 
set_property PACKAGE_PIN AB21 [get_ports {ybusp[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[9]}]

# MC2-27 
set_property PACKAGE_PIN AA24 [get_ports {ybusn[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[8]}]

# MC2-28 
set_property PACKAGE_PIN AC21 [get_ports {ybusn[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[9]}]

# MC2-31 
set_property PACKAGE_PIN AD26 [get_ports {ybusp[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[10]}]

# MC2-32 
set_property PACKAGE_PIN AA25 [get_ports {ybusp[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[11]}]

# MC2-33 
set_property PACKAGE_PIN AE26 [get_ports {ybusn[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[10]}]

# MC2-34 
set_property PACKAGE_PIN AB25 [get_ports {ybusn[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[11]}]

# MC2-37 
set_property PACKAGE_PIN AD25 [get_ports {ybusp[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[12]}]

# MC2-38 
set_property PACKAGE_PIN AA23 [get_ports {ybusp[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[13]}]

# MC2-39 
set_property PACKAGE_PIN AE25 [get_ports {ybusn[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[12]}]

# MC2-40 
set_property PACKAGE_PIN AB24 [get_ports {ybusn[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[13]}]

# MC2-43 
set_property PACKAGE_PIN AD23 [get_ports {ybusp[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[14]}]

# MC2-44 
set_property PACKAGE_PIN AB22 [get_ports {ybusp[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[15]}]

# MC2-45 
set_property PACKAGE_PIN AD24 [get_ports {ybusn[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[14]}]

# MC2-46 
set_property PACKAGE_PIN AC22 [get_ports {ybusn[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[15]}]

# MC2-49 
set_property PACKAGE_PIN AD21 [get_ports {ybusp[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[16]}]

# MC2-50 
set_property PACKAGE_PIN W20 [get_ports {ybusp[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[17]}]

# MC2-51 
set_property PACKAGE_PIN AE21 [get_ports {ybusn[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[16]}]

# MC2-52 
set_property PACKAGE_PIN Y21 [get_ports {ybusn[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[17]}]

# MC2-55 
set_property PACKAGE_PIN AE22 [get_ports {ybusp[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[18]}]

# MC2-56 
set_property PACKAGE_PIN AB26 [get_ports {ybusp[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[19]}]

# MC2-57 
set_property PACKAGE_PIN AF22 [get_ports {ybusn[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[18]}]

# MC2-58 
set_property PACKAGE_PIN AC26 [get_ports {ybusn[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[19]}]

# MC2-61 
set_property PACKAGE_PIN AE17 [get_ports {ybusp[20]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[20]}]

# MC2-62 
set_property PACKAGE_PIN W18 [get_ports {ybusp[21]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[21]}]

# MC2-63 
set_property PACKAGE_PIN AF17 [get_ports {ybusn[20]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[20]}]

# MC2-64 
set_property PACKAGE_PIN W19 [get_ports {ybusn[21]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[21]}]

# MC2-67 
set_property PACKAGE_PIN AF19 [get_ports {ybusp[22]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[22]}]

# MC2-68 
set_property PACKAGE_PIN Y17 [get_ports {ybusp[23]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[23]}]

# MC2-69 
set_property PACKAGE_PIN AF20 [get_ports {ybusn[22]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[22]}]

# MC2-70 
set_property PACKAGE_PIN Y18 [get_ports {ybusn[23]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[23]}]

# MC2-73 
set_property PACKAGE_PIN AA17 [get_ports {ybusp[24]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[24]}]

# MC2-74 
set_property PACKAGE_PIN V16 [get_ports {ybusp[25]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[25]}]

# MC2-75 
set_property PACKAGE_PIN AA18 [get_ports {ybusn[24]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[24]}]

# MC2-76 
set_property PACKAGE_PIN V17 [get_ports {ybusn[25]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[25]}]

# MC2-79 
set_property PACKAGE_PIN AA14 [get_ports {ybusp[26]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[26]}]

# MC2-80 
set_property PACKAGE_PIN Y15 [get_ports {ybusp[27]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[27]}]

# MC2-81 
set_property PACKAGE_PIN AA15 [get_ports {ybusn[26]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[26]}]

# MC2-82 
set_property PACKAGE_PIN Y16 [get_ports {ybusn[27]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[27]}]

# MC2-85 
set_property PACKAGE_PIN AB16 [get_ports {ybusp[28]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[28]}]

# MC2-86 
set_property PACKAGE_PIN AC14 [get_ports {ybusp[29]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[29]}]

# MC2-87 
set_property PACKAGE_PIN AC16 [get_ports {ybusn[28]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[28]}]

# MC2-88 
set_property PACKAGE_PIN AD14 [get_ports {ybusn[29]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[29]}]

# MC2-91 
set_property PACKAGE_PIN AE18 [get_ports {ybusp[30]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[30]}]

# MC2-92 
set_property PACKAGE_PIN AD20 [get_ports {ybusp[31]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[31]}]

# MC2-93 
set_property PACKAGE_PIN AF18 [get_ports {ybusn[30]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[30]}]

# MC2-94 
set_property PACKAGE_PIN AE20 [get_ports {ybusn[31]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[31]}]

# MC2-97 
set_property PACKAGE_PIN AB17 [get_ports {ybusp[32]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[32]}]

# MC2-98 
set_property PACKAGE_PIN AC19 [get_ports {ybusp[33]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[33]}]

# MC2-99 
set_property PACKAGE_PIN AC17 [get_ports {ybusn[32]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[32]}]

# MC2-100 
set_property PACKAGE_PIN AD19 [get_ports {ybusn[33]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[33]}]

# MC2-103 
set_property PACKAGE_PIN AB14 [get_ports {ybusp[34]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[34]}]

# MC2-104 
set_property PACKAGE_PIN AC18 [get_ports {ybusp[35]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[35]}]

# MC2-105 
set_property PACKAGE_PIN AB15 [get_ports {ybusn[34]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[34]}]

# MC2-106 
set_property PACKAGE_PIN AD18 [get_ports {ybusn[35]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[35]}]

# MC2-109 
set_property PACKAGE_PIN AF14 [get_ports {ybusp[36]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[36]}]

# MC2-110 
set_property PACKAGE_PIN AB19 [get_ports {ybusp[37]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[37]}]

# MC2-111 
set_property PACKAGE_PIN AF15 [get_ports {ybusn[36]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[36]}]

# MC2-112 
set_property PACKAGE_PIN AB20 [get_ports {ybusn[37]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[37]}]

# MC2-115 
set_property PACKAGE_PIN AD15 [get_ports {ybusp[38]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[38]}]

# MC2-116 
set_property PACKAGE_PIN AA19 [get_ports {ybusp[39]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusp[39]}]

# MC2-117 
set_property PACKAGE_PIN AE15 [get_ports {ybusn[38]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[38]}]

# MC2-118 
set_property PACKAGE_PIN AA20 [get_ports {ybusn[39]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ybusn[39]}]

# LEDs #####################################################################
set_property PACKAGE_PIN T24 [get_ports {led[0]}]
set_property PACKAGE_PIN T25 [get_ports {led[1]}]
set_property PACKAGE_PIN R25 [get_ports {led[2]}]
set_property PACKAGE_PIN P26 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
