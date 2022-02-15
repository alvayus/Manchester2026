############################################################################
# XEM7320 - Xilinx constraints file
#
# Pin mappings for the XEM7320.  Use this as a template and comment out 
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2017 Opal Kelly Incorporated
############################################################################

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

############################################################################
## FrontPanel Host Interface
############################################################################
set_property PACKAGE_PIN Y19 [get_ports {okHU[0]}]
set_property PACKAGE_PIN R18 [get_ports {okHU[1]}]
set_property PACKAGE_PIN R16 [get_ports {okHU[2]}]
set_property PACKAGE_PIN P14 [get_ports {okHU[3]}]
set_property SLEW FAST [get_ports {okHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okHU[*]}]

set_property PACKAGE_PIN W19 [get_ports {okUH[0]}]
set_property PACKAGE_PIN V18 [get_ports {okUH[1]}]
set_property PACKAGE_PIN U17 [get_ports {okUH[2]}]
set_property PACKAGE_PIN W17 [get_ports {okUH[3]}]
set_property PACKAGE_PIN T19 [get_ports {okUH[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUH[*]}]

set_property PACKAGE_PIN AB22 [get_ports {okUHU[0]}]
set_property PACKAGE_PIN AB21 [get_ports {okUHU[1]}]
set_property PACKAGE_PIN Y22 [get_ports {okUHU[2]}]
set_property PACKAGE_PIN AA21 [get_ports {okUHU[3]}]
set_property PACKAGE_PIN AA20 [get_ports {okUHU[4]}]
set_property PACKAGE_PIN W22 [get_ports {okUHU[5]}]
set_property PACKAGE_PIN W21 [get_ports {okUHU[6]}]
set_property PACKAGE_PIN T20 [get_ports {okUHU[7]}]
set_property PACKAGE_PIN R19 [get_ports {okUHU[8]}]
set_property PACKAGE_PIN P19 [get_ports {okUHU[9]}]
set_property PACKAGE_PIN U21 [get_ports {okUHU[10]}]
set_property PACKAGE_PIN T21 [get_ports {okUHU[11]}]
set_property PACKAGE_PIN R21 [get_ports {okUHU[12]}]
set_property PACKAGE_PIN P21 [get_ports {okUHU[13]}]
set_property PACKAGE_PIN R22 [get_ports {okUHU[14]}]
set_property PACKAGE_PIN P22 [get_ports {okUHU[15]}]
set_property PACKAGE_PIN R14 [get_ports {okUHU[16]}]
set_property PACKAGE_PIN W20 [get_ports {okUHU[17]}]
set_property PACKAGE_PIN Y21 [get_ports {okUHU[18]}]
set_property PACKAGE_PIN P17 [get_ports {okUHU[19]}]
set_property PACKAGE_PIN U20 [get_ports {okUHU[20]}]
set_property PACKAGE_PIN N17 [get_ports {okUHU[21]}]
set_property PACKAGE_PIN N14 [get_ports {okUHU[22]}]
set_property PACKAGE_PIN V20 [get_ports {okUHU[23]}]
set_property PACKAGE_PIN P16 [get_ports {okUHU[24]}]
set_property PACKAGE_PIN T18 [get_ports {okUHU[25]}]
set_property PACKAGE_PIN V19 [get_ports {okUHU[26]}]
set_property PACKAGE_PIN AB20 [get_ports {okUHU[27]}]
set_property PACKAGE_PIN P15 [get_ports {okUHU[28]}]
set_property PACKAGE_PIN V22 [get_ports {okUHU[29]}]
set_property PACKAGE_PIN U18 [get_ports {okUHU[30]}]
set_property PACKAGE_PIN AB18 [get_ports {okUHU[31]}]
set_property SLEW FAST [get_ports {okUHU[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okUHU[*]}]

set_property PACKAGE_PIN AA19 [get_ports {okRSVD[0]}]
set_property PACKAGE_PIN V17 [get_ports {okRSVD[1]}]
set_property PACKAGE_PIN AA18 [get_ports {okRSVD[2]}]
set_property PACKAGE_PIN R17 [get_ports {okRSVD[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {okRSVD[*]}]

set_property PACKAGE_PIN N13 [get_ports {okAA}]
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
set_property PACKAGE_PIN D17 [get_ports {sys_clkp}]

set_property IOSTANDARD LVDS_25 [get_ports {sys_clkn}]
set_property PACKAGE_PIN C17 [get_ports {sys_clkn}]

create_clock -name sys_clk -period 5 [get_ports sys_clkp]
set_clock_groups -asynchronous -group [get_clocks {sys_clk}] -group [get_clocks {mmcm0_clk0 okUH0}]

# PORTA-5 
set_property PACKAGE_PIN AA10 [get_ports {porta[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[0]}]

# PORTA-6 
set_property PACKAGE_PIN AA9 [get_ports {porta[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[1]}]

# PORTA-7 
set_property PACKAGE_PIN AA11 [get_ports {porta[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[2]}]

# PORTA-8 
set_property PACKAGE_PIN AB10 [get_ports {porta[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[3]}]

# PORTA-9 
set_property PACKAGE_PIN Y11 [get_ports {porta[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[4]}]

# PORTA-10 
set_property PACKAGE_PIN AA13 [get_ports {porta[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[5]}]

# PORTA-11 
set_property PACKAGE_PIN Y12 [get_ports {porta[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[6]}]

# PORTA-12 
set_property PACKAGE_PIN AB13 [get_ports {porta[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[7]}]

# PORTA-13 
set_property PACKAGE_PIN AB16 [get_ports {porta[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[8]}]

# PORTA-14 
set_property PACKAGE_PIN V10 [get_ports {porta[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[9]}]

# PORTA-15 
set_property PACKAGE_PIN AB17 [get_ports {porta[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[10]}]

# PORTA-16 
set_property PACKAGE_PIN W10 [get_ports {porta[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[11]}]

# PORTA-17 
set_property PACKAGE_PIN AB11 [get_ports {porta[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[12]}]

# PORTA-18 
set_property PACKAGE_PIN Y16 [get_ports {porta[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[13]}]

# PORTA-19 
set_property PACKAGE_PIN AB12 [get_ports {porta[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[14]}]

# PORTA-20 
set_property PACKAGE_PIN AA16 [get_ports {porta[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[15]}]

# PORTA-21 
set_property PACKAGE_PIN Y14 [get_ports {porta[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[16]}]

# PORTA-22 
set_property PACKAGE_PIN W14 [get_ports {porta[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[17]}]

# PORTA-23 
set_property PACKAGE_PIN AA15 [get_ports {porta[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[18]}]

# PORTA-24 
set_property PACKAGE_PIN V13 [get_ports {porta[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[19]}]

# PORTA-25 
set_property PACKAGE_PIN U15 [get_ports {porta[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[20]}]

# PORTA-26 
set_property PACKAGE_PIN V14 [get_ports {porta[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[21]}]

# PORTA-27 
set_property PACKAGE_PIN AB15 [get_ports {porta[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[22]}]

# PORTA-28 
set_property PACKAGE_PIN V15 [get_ports {porta[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[23]}]

# PORTA-29 
set_property PACKAGE_PIN AA14 [get_ports {porta[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[24]}]

# PORTA-30 
set_property PACKAGE_PIN T14 [get_ports {porta[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[25]}]

# PORTA-31 
set_property PACKAGE_PIN Y13 [get_ports {porta[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[26]}]

# PORTA-32 
set_property PACKAGE_PIN T15 [get_ports {porta[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[27]}]

# PORTA-33 
set_property PACKAGE_PIN W11 [get_ports {porta[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[28]}]

# PORTA-34 
set_property PACKAGE_PIN W15 [get_ports {porta[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[29]}]

# PORTA-35 
set_property PACKAGE_PIN W12 [get_ports {porta[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[30]}]

# PORTA-36 
set_property PACKAGE_PIN W16 [get_ports {porta[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {porta[31]}]

# PORTB-5 
set_property PACKAGE_PIN W1 [get_ports {portb[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[0]}]

# PORTB-6 
set_property PACKAGE_PIN U3 [get_ports {portb[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[1]}]

# PORTB-7 
set_property PACKAGE_PIN Y1 [get_ports {portb[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[2]}]

# PORTB-8 
set_property PACKAGE_PIN V3 [get_ports {portb[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[3]}]

# PORTB-9 
set_property PACKAGE_PIN U6 [get_ports {portb[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[4]}]

# PORTB-10 
set_property PACKAGE_PIN W6 [get_ports {portb[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[5]}]

# PORTB-11 
set_property PACKAGE_PIN V5 [get_ports {portb[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[6]}]

# PORTB-12 
set_property PACKAGE_PIN W5 [get_ports {portb[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[7]}]

# PORTB-13 
set_property PACKAGE_PIN U2 [get_ports {portb[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[8]}]

# PORTB-14 
set_property PACKAGE_PIN AA1 [get_ports {portb[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[9]}]

# PORTB-15 
set_property PACKAGE_PIN V2 [get_ports {portb[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[10]}]

# PORTB-16 
set_property PACKAGE_PIN AB1 [get_ports {portb[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[11]}]

# PORTB-17 
set_property PACKAGE_PIN W2 [get_ports {portb[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[12]}]

# PORTB-18 
set_property PACKAGE_PIN Y3 [get_ports {portb[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[13]}]

# PORTB-19 
set_property PACKAGE_PIN Y2 [get_ports {portb[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[14]}]

# PORTB-20 
set_property PACKAGE_PIN AA3 [get_ports {portb[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[15]}]

# PORTB-21 
set_property PACKAGE_PIN AB3 [get_ports {portb[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[16]}]

# PORTB-22 
set_property PACKAGE_PIN AB2 [get_ports {portb[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[17]}]

# PORTB-23 
set_property PACKAGE_PIN AA5 [get_ports {portb[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[18]}]

# PORTB-24 
set_property PACKAGE_PIN AA4 [get_ports {portb[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[19]}]

# PORTB-25 
set_property PACKAGE_PIN Y7 [get_ports {portb[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[20]}]

# PORTB-26 
set_property PACKAGE_PIN Y6 [get_ports {portb[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[21]}]

# PORTB-27 
set_property PACKAGE_PIN AB5 [get_ports {portb[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[22]}]

# PORTB-28 
set_property PACKAGE_PIN U5 [get_ports {portb[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[23]}]

# PORTB-29 
set_property PACKAGE_PIN AB6 [get_ports {portb[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[24]}]

# PORTB-30 
set_property PACKAGE_PIN AB7 [get_ports {portb[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[25]}]

# PORTB-31 
set_property PACKAGE_PIN AA6 [get_ports {portb[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[26]}]

# PORTB-32 
set_property PACKAGE_PIN Y4 [get_ports {portb[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[27]}]

# PORTB-33 
set_property PACKAGE_PIN V4 [get_ports {portb[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[28]}]

# PORTB-34 
set_property PACKAGE_PIN AA8 [get_ports {portb[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[29]}]

# PORTB-35 
set_property PACKAGE_PIN W4 [get_ports {portb[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[30]}]

# PORTB-36 
set_property PACKAGE_PIN AB8 [get_ports {portb[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portb[31]}]

# PORTC-14 
set_property PACKAGE_PIN F3 [get_ports {portc[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[0]}]

# PORTC-16 
set_property PACKAGE_PIN J5 [get_ports {portc[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[1]}]

# PORTC-17 
set_property PACKAGE_PIN E2 [get_ports {portc[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[2]}]

# PORTC-18 
set_property PACKAGE_PIN E3 [get_ports {portc[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[3]}]

# PORTC-19 
set_property PACKAGE_PIN G3 [get_ports {portc[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[4]}]

# PORTC-20 
set_property PACKAGE_PIN H3 [get_ports {portc[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[5]}]

# PORTC-21 
set_property PACKAGE_PIN D2 [get_ports {portc[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[6]}]

# PORTC-22 
set_property PACKAGE_PIN H2 [get_ports {portc[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[7]}]

# PORTC-23 
set_property PACKAGE_PIN G2 [get_ports {portc[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[8]}]

# PORTC-24 
set_property PACKAGE_PIN H5 [get_ports {portc[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[9]}]

# PORTC-25 
set_property PACKAGE_PIN C2 [get_ports {portc[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[10]}]

# PORTC-26 
set_property PACKAGE_PIN B2 [get_ports {portc[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[11]}]

# PORTC-27 
set_property PACKAGE_PIN G1 [get_ports {portc[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[12]}]

# PORTC-28 
set_property PACKAGE_PIN J2 [get_ports {portc[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[13]}]

# PORTC-29 
set_property PACKAGE_PIN A1 [get_ports {portc[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[14]}]

# PORTC-30 
set_property PACKAGE_PIN B1 [get_ports {portc[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[15]}]

# PORTC-31 
set_property PACKAGE_PIN F1 [get_ports {portc[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[16]}]

# PORTC-32 
set_property PACKAGE_PIN J1 [get_ports {portc[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[17]}]

# PORTC-33 
set_property PACKAGE_PIN H4 [get_ports {portc[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[18]}]

# PORTC-34 
set_property PACKAGE_PIN E1 [get_ports {portc[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[19]}]

# PORTC-35 
set_property PACKAGE_PIN G4 [get_ports {portc[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[20]}]

# PORTC-36 
set_property PACKAGE_PIN D1 [get_ports {portc[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {portc[21]}]

# LEDs #####################################################################
set_property PACKAGE_PIN A13 [get_ports {led[0]}]
set_property PACKAGE_PIN B13 [get_ports {led[1]}]
set_property PACKAGE_PIN A14 [get_ports {led[2]}]
set_property PACKAGE_PIN A15 [get_ports {led[3]}]
set_property PACKAGE_PIN B15 [get_ports {led[4]}]
set_property PACKAGE_PIN A16 [get_ports {led[5]}]
set_property PACKAGE_PIN B16 [get_ports {led[6]}]
set_property PACKAGE_PIN B17 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led[*]}]

