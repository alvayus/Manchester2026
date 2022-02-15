############################################################################
# XEM7305 - Xilinx constraints file
#
# Pin mappings for the XEM7305.  Use this as a template and comment out 
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2018 Opal Kelly Incorporated
############################################################################

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

############################################################################
## FrontPanel Host Interface
############################################################################
set_property PACKAGE_PIN T14 [get_ports {okHU[0]}]
set_property PACKAGE_PIN V14 [get_ports {okHU[1]}]
set_property PACKAGE_PIN T13 [get_ports {okHU[2]}]
set_property PACKAGE_PIN P13 [get_ports {okHU[3]}]
set_property SLEW FAST [get_ports {okHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okHU[*]}]

set_property PACKAGE_PIN N15 [get_ports {okUH[0]}]
set_property PACKAGE_PIN R16 [get_ports {okUH[1]}]
set_property PACKAGE_PIN U15 [get_ports {okUH[2]}]
set_property PACKAGE_PIN V17 [get_ports {okUH[3]}]
set_property PACKAGE_PIN M13 [get_ports {okUH[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUH[*]}]

set_property PACKAGE_PIN T18 [get_ports {okUHU[0]}]
set_property PACKAGE_PIN R18 [get_ports {okUHU[1]}]
set_property PACKAGE_PIN P18 [get_ports {okUHU[2]}]
set_property PACKAGE_PIN N18 [get_ports {okUHU[3]}]
set_property PACKAGE_PIN M18 [get_ports {okUHU[4]}]
set_property PACKAGE_PIN M17 [get_ports {okUHU[5]}]
set_property PACKAGE_PIN M16 [get_ports {okUHU[6]}]
set_property PACKAGE_PIN N13 [get_ports {okUHU[7]}]
set_property PACKAGE_PIN N14 [get_ports {okUHU[8]}]
set_property PACKAGE_PIN M14 [get_ports {okUHU[9]}]
set_property PACKAGE_PIN L18 [get_ports {okUHU[10]}]
set_property PACKAGE_PIN L17 [get_ports {okUHU[11]}]
set_property PACKAGE_PIN M15 [get_ports {okUHU[12]}]
set_property PACKAGE_PIN L14 [get_ports {okUHU[13]}]
set_property PACKAGE_PIN K18 [get_ports {okUHU[14]}]
set_property PACKAGE_PIN K17 [get_ports {okUHU[15]}]
set_property PACKAGE_PIN R13 [get_ports {okUHU[16]}]
set_property PACKAGE_PIN P16 [get_ports {okUHU[17]}]
set_property PACKAGE_PIN P17 [get_ports {okUHU[18]}]
set_property PACKAGE_PIN V13 [get_ports {okUHU[19]}]
set_property PACKAGE_PIN P14 [get_ports {okUHU[20]}]
set_property PACKAGE_PIN U12 [get_ports {okUHU[21]}]
set_property PACKAGE_PIN T11 [get_ports {okUHU[22]}]
set_property PACKAGE_PIN P15 [get_ports {okUHU[23]}]
set_property PACKAGE_PIN U11 [get_ports {okUHU[24]}]
set_property PACKAGE_PIN V15 [get_ports {okUHU[25]}]
set_property PACKAGE_PIN R17 [get_ports {okUHU[26]}]
set_property PACKAGE_PIN U18 [get_ports {okUHU[27]}]
set_property PACKAGE_PIN T12 [get_ports {okUHU[28]}]
set_property PACKAGE_PIN L16 [get_ports {okUHU[29]}]
set_property PACKAGE_PIN V16 [get_ports {okUHU[30]}]
set_property PACKAGE_PIN T15 [get_ports {okUHU[31]}]
set_property SLEW FAST [get_ports {okUHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUHU[*]}]

set_property PACKAGE_PIN U17 [get_ports {okRSVD[0]}]
set_property PACKAGE_PIN U16 [get_ports {okRSVD[1]}]
set_property PACKAGE_PIN R15 [get_ports {okRSVD[2]}]
set_property PACKAGE_PIN V12 [get_ports {okRSVD[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okRSVD[*]}]

set_property PACKAGE_PIN R11 [get_ports {okAA}]
set_property IOSTANDARD LVCMOS18 [get_ports {okAA}]


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
set_property IOSTANDARD LVDS_25 [get_ports {sys_clkp}]
set_property PACKAGE_PIN R2 [get_ports {sys_clkp}]

set_property IOSTANDARD LVDS_25 [get_ports {sys_clkn}]
set_property PACKAGE_PIN R1 [get_ports {sys_clkn}]

create_clock -name sys_clk -period 5 [get_ports sys_clkp]
set_clock_groups -asynchronous -group [get_clocks {sys_clk}] -group [get_clocks {mmcm0_clk0 okUH0}]

# MC1-15 
set_property PACKAGE_PIN H18 [get_ports {xbusp[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[0]}]

# MC1-16 
set_property PACKAGE_PIN K16 [get_ports {xbusp[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[1]}]

# MC1-17 
set_property PACKAGE_PIN G18 [get_ports {xbusn[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[0]}]

# MC1-18 
set_property PACKAGE_PIN J16 [get_ports {xbusn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[1]}]

# MC1-23 
set_property PACKAGE_PIN H15 [get_ports {xbusp[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[2]}]

# MC1-24 
set_property PACKAGE_PIN K14 [get_ports {xbusp[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[3]}]

# MC1-25 
set_property PACKAGE_PIN G15 [get_ports {xbusn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[2]}]

# MC1-26 
set_property PACKAGE_PIN J15 [get_ports {xbusn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[3]}]

# MC1-27 
set_property PACKAGE_PIN G16 [get_ports {xbusp[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[4]}]

# MC1-28 
set_property PACKAGE_PIN J13 [get_ports {xbusp[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[5]}]

# MC1-29 
set_property PACKAGE_PIN G17 [get_ports {xbusn[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[4]}]

# MC1-30 
set_property PACKAGE_PIN J14 [get_ports {xbusn[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[5]}]

# MC1-31 
set_property PACKAGE_PIN F13 [get_ports {xbusp[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[6]}]

# MC1-32 
set_property PACKAGE_PIN H13 [get_ports {xbusp[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[7]}]

# MC1-33 
set_property PACKAGE_PIN E13 [get_ports {xbusn[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[6]}]

# MC1-34 
set_property PACKAGE_PIN H14 [get_ports {xbusn[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[7]}]

# MC1-35 
set_property PACKAGE_PIN D18 [get_ports {xbusp[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[8]}]

# MC1-36 
set_property PACKAGE_PIN F18 [get_ports {xbusp[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[9]}]

# MC1-37 
set_property PACKAGE_PIN C18 [get_ports {xbusn[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[8]}]

# MC1-38 
set_property PACKAGE_PIN E18 [get_ports {xbusn[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[9]}]

# MC1-41 
set_property PACKAGE_PIN D16 [get_ports {xbusp[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[10]}]

# MC1-42 
set_property PACKAGE_PIN H16 [get_ports {xbusp[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[11]}]

# MC1-43 
set_property PACKAGE_PIN D17 [get_ports {xbusn[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[10]}]

# MC1-44 
set_property PACKAGE_PIN H17 [get_ports {xbusn[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[11]}]

# MC1-45 
set_property PACKAGE_PIN C13 [get_ports {xbusp[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[12]}]

# MC1-46 
set_property PACKAGE_PIN E16 [get_ports {xbusp[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[13]}]

# MC1-47 
set_property PACKAGE_PIN C14 [get_ports {xbusn[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[12]}]

# MC1-48 
set_property PACKAGE_PIN E17 [get_ports {xbusn[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[13]}]

# MC1-49 
set_property PACKAGE_PIN D14 [get_ports {xbusp[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[14]}]

# MC1-50 
set_property PACKAGE_PIN E14 [get_ports {xbusp[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[15]}]

# MC1-51 
set_property PACKAGE_PIN D15 [get_ports {xbusn[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[14]}]

# MC1-52 
set_property PACKAGE_PIN E15 [get_ports {xbusn[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[15]}]

# MC1-53 
set_property PACKAGE_PIN B17 [get_ports {xbusp[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[16]}]

# MC1-54 
set_property PACKAGE_PIN C17 [get_ports {xbusp[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[17]}]

# MC1-55 
set_property PACKAGE_PIN A17 [get_ports {xbusn[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[16]}]

# MC1-56 
set_property PACKAGE_PIN B18 [get_ports {xbusn[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[17]}]

# MC1-61 
set_property PACKAGE_PIN E12 [get_ports {xbusp[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[18]}]

# MC1-62 
set_property PACKAGE_PIN B14 [get_ports {xbusp[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[19]}]

# MC1-63 
set_property PACKAGE_PIN D12 [get_ports {xbusn[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[18]}]

# MC1-64 
set_property PACKAGE_PIN A14 [get_ports {xbusn[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[19]}]

# MC1-66 
set_property PACKAGE_PIN B16 [get_ports {xbusp[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[20]}]

# MC1-67 
set_property PACKAGE_PIN F14 [get_ports {xbusp[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[21]}]

# MC1-68 
set_property PACKAGE_PIN A16 [get_ports {xbusn[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[20]}]

# MC1-69 
set_property PACKAGE_PIN F15 [get_ports {xbusn[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[21]}]

# MC1-70 
set_property PACKAGE_PIN B15 [get_ports {xbusp[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[22]}]

# MC1-71 
set_property PACKAGE_PIN G13 [get_ports {xbusp[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusp[23]}]

# MC1-72 
set_property PACKAGE_PIN A15 [get_ports {xbusn[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[22]}]

# MC1-73 
set_property PACKAGE_PIN K13 [get_ports {xbusn[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {xbusn[23]}]

# MC2-3 
set_property PACKAGE_PIN V5 [get_ports {ybusp[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[0]}]

# MC2-4 
set_property PACKAGE_PIN V3 [get_ports {ybusp[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[1]}]

# MC2-5 
set_property PACKAGE_PIN V4 [get_ports {ybusn[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[0]}]

# MC2-6 
set_property PACKAGE_PIN V2 [get_ports {ybusn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[1]}]

# MC2-7 
set_property PACKAGE_PIN V7 [get_ports {ybusp[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[2]}]

# MC2-8 
set_property PACKAGE_PIN R5 [get_ports {ybusp[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[3]}]

# MC2-9 
set_property PACKAGE_PIN V6 [get_ports {ybusn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[2]}]

# MC2-10 
set_property PACKAGE_PIN T4 [get_ports {ybusn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[3]}]

# MC2-11 
set_property PACKAGE_PIN U7 [get_ports {ybusp[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[4]}]

# MC2-12 
set_property PACKAGE_PIN T6 [get_ports {ybusp[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[5]}]

# MC2-13 
set_property PACKAGE_PIN U6 [get_ports {ybusn[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[4]}]

# MC2-14 
set_property PACKAGE_PIN T5 [get_ports {ybusn[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[5]}]

# MC2-15 
set_property PACKAGE_PIN R7 [get_ports {ybusp[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[6]}]

# MC2-16 
set_property PACKAGE_PIN P6 [get_ports {ybusp[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[7]}]

# MC2-17 
set_property PACKAGE_PIN R6 [get_ports {ybusn[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[6]}]

# MC2-18 
set_property PACKAGE_PIN P5 [get_ports {ybusn[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[7]}]

# MC2-23 
set_property PACKAGE_PIN T1 [get_ports {ybusp[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[8]}]

# MC2-24 
set_property PACKAGE_PIN P2 [get_ports {ybusp[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[9]}]

# MC2-25 
set_property PACKAGE_PIN U1 [get_ports {ybusn[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[8]}]

# MC2-26 
set_property PACKAGE_PIN P1 [get_ports {ybusn[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[9]}]

# MC2-27 
set_property PACKAGE_PIN U3 [get_ports {ybusp[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[10]}]

# MC2-28 
set_property PACKAGE_PIN R4 [get_ports {ybusp[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[11]}]

# MC2-29 
set_property PACKAGE_PIN U2 [get_ports {ybusn[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[10]}]

# MC2-30 
set_property PACKAGE_PIN T3 [get_ports {ybusn[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[11]}]

# MC2-31 
set_property PACKAGE_PIN M6 [get_ports {ybusp[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[12]}]

# MC2-32 
set_property PACKAGE_PIN K6 [get_ports {ybusp[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[13]}]

# MC2-33 
set_property PACKAGE_PIN M5 [get_ports {ybusn[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[12]}]

# MC2-34 
set_property PACKAGE_PIN L6 [get_ports {ybusn[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[13]}]

# MC2-35 
set_property PACKAGE_PIN N3 [get_ports {ybusp[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[14]}]

# MC2-36 
set_property PACKAGE_PIN M1 [get_ports {ybusp[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[15]}]

# MC2-37 
set_property PACKAGE_PIN N2 [get_ports {ybusn[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[14]}]

# MC2-38 
set_property PACKAGE_PIN N1 [get_ports {ybusn[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[15]}]

# MC2-43 
set_property PACKAGE_PIN M3 [get_ports {ybusp[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[16]}]

# MC2-44 
set_property PACKAGE_PIN N5 [get_ports {ybusp[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[17]}]

# MC2-45 
set_property PACKAGE_PIN M2 [get_ports {ybusn[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[16]}]

# MC2-46 
set_property PACKAGE_PIN N4 [get_ports {ybusn[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[17]}]

# MC2-47 
set_property PACKAGE_PIN C12 [get_ports {ybusp[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[18]}]

# MC2-48 
set_property PACKAGE_PIN K4 [get_ports {ybusp[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[19]}]

# MC2-49 
set_property PACKAGE_PIN C11 [get_ports {ybusn[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[18]}]

# MC2-50 
set_property PACKAGE_PIN L4 [get_ports {ybusn[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[19]}]

# MC2-51 
set_property PACKAGE_PIN A10 [get_ports {ybusp[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[20]}]

# MC2-52 
set_property PACKAGE_PIN K1 [get_ports {ybusp[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[21]}]

# MC2-53 
set_property PACKAGE_PIN A9 [get_ports {ybusn[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[20]}]

# MC2-54 
set_property PACKAGE_PIN L1 [get_ports {ybusn[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[21]}]

# MC2-55 
set_property PACKAGE_PIN B11 [get_ports {ybusp[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[22]}]

# MC2-56 
set_property PACKAGE_PIN L5 [get_ports {ybusp[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[23]}]

# MC2-57 
set_property PACKAGE_PIN A11 [get_ports {ybusn[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[22]}]

# MC2-58 
set_property PACKAGE_PIN M4 [get_ports {ybusn[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[23]}]

# MC2-61 
set_property PACKAGE_PIN C10 [get_ports {ybusp[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[24]}]

# MC2-62 
set_property PACKAGE_PIN K3 [get_ports {ybusp[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[25]}]

# MC2-63 
set_property PACKAGE_PIN C9 [get_ports {ybusn[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[24]}]

# MC2-64 
set_property PACKAGE_PIN K2 [get_ports {ybusn[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[25]}]

# MC2-65 
set_property PACKAGE_PIN D10 [get_ports {ybusp[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[26]}]

# MC2-66 
set_property PACKAGE_PIN P7 [get_ports {ybusp[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusp[27]}]

# MC2-67 
set_property PACKAGE_PIN D11 [get_ports {ybusn[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[26]}]

# MC2-68 
set_property PACKAGE_PIN J6 [get_ports {ybusn[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ybusn[27]}]

# LEDs #####################################################################
set_property PACKAGE_PIN J5 [get_ports {led[0]}]
set_property PACKAGE_PIN G6 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led[1]}]
set_property PACKAGE_PIN R12 [get_ports {led[2]}]
set_property PACKAGE_PIN L13 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]

