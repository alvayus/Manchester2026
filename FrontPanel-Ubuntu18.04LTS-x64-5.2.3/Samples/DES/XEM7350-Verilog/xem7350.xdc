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


###########################################################################
# System Clock
###########################################################################
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

## Flash ####################################################################
#set_property PACKAGE_PIN N17 [get_ports {spi_dq0}]
#set_property PACKAGE_PIN N16 [get_ports {spi_c}]
#set_property PACKAGE_PIN R16 [get_ports {spi_s}]
#set_property PACKAGE_PIN U17 [get_ports {spi_dq1}]
#set_property PACKAGE_PIN U16 [get_ports {spi_w_dq2}]
#set_property PACKAGE_PIN T17 [get_ports {spi_hold_dq3}]
#set_property IOSTANDARD LVCMOS33 [get_ports {spi_dq0}}]
#set_property IOSTANDARD LVCMOS33 [get_ports {spi_c}]
#set_property IOSTANDARD LVCMOS33 [get_ports {spi_s}]
#set_property IOSTANDARD LVCMOS33 [get_ports {spi_dq1}]
#set_property IOSTANDARD LVCMOS33 [get_ports {spi_w_dq2}]
#set_property IOSTANDARD LVCMOS33 [get_ports {spi_hold_dq3}]

## DRAM #####################################################################
#set_property PACKAGE_PIN AD1 [get_ports {ddr3_dq[0]}]
#set_property PACKAGE_PIN AE1 [get_ports {ddr3_dq[1]}]
#set_property PACKAGE_PIN AE3 [get_ports {ddr3_dq[2]}]
#set_property PACKAGE_PIN AE2 [get_ports {ddr3_dq[3]}]
#set_property PACKAGE_PIN AE6 [get_ports {ddr3_dq[4]}]
#set_property PACKAGE_PIN AE5 [get_ports {ddr3_dq[5]}]
#set_property PACKAGE_PIN AF3 [get_ports {ddr3_dq[6]}]
#set_property PACKAGE_PIN AF2 [get_ports {ddr3_dq[7]}]
#set_property PACKAGE_PIN W11 [get_ports {ddr3_dq[8]}]
#set_property PACKAGE_PIN V8  [get_ports {ddr3_dq[9]}]
#set_property PACKAGE_PIN V7  [get_ports {ddr3_dq[10]}]
#set_property PACKAGE_PIN Y8 [get_ports {ddr3_dq[11]}]
#set_property PACKAGE_PIN Y7 [get_ports {ddr3_dq[12]}]
#set_property PACKAGE_PIN Y11 [get_ports {ddr3_dq[13]}]
#set_property PACKAGE_PIN Y10 [get_ports {ddr3_dq[14]}]
#set_property PACKAGE_PIN V9 [get_ports {ddr3_dq[15]}]
#set_property SLEW FAST [get_ports {ddr3_dq[*]}]
#set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[*]}]

#set_property PACKAGE_PIN AC1 [get_ports {ddr3_addr[0]}]
#set_property PACKAGE_PIN AB1 [get_ports {ddr3_addr[1]}]
#set_property PACKAGE_PIN V1 [get_ports {ddr3_addr[2]}]
#set_property PACKAGE_PIN V2 [get_ports {ddr3_addr[3]}]
#set_property PACKAGE_PIN Y2 [get_ports {ddr3_addr[4]}]
#set_property PACKAGE_PIN Y3 [get_ports {ddr3_addr[5]}]
#set_property PACKAGE_PIN V4 [get_ports {ddr3_addr[6]}]
#set_property PACKAGE_PIN V6 [get_ports {ddr3_addr[7]}]
#set_property PACKAGE_PIN U7 [get_ports {ddr3_addr[8]}]
#set_property PACKAGE_PIN W3 [get_ports {ddr3_addr[9]}]
#set_property PACKAGE_PIN V3 [get_ports {ddr3_addr[10]}]
#set_property PACKAGE_PIN U1 [get_ports {ddr3_addr[11]}]
#set_property PACKAGE_PIN U2 [get_ports {ddr3_addr[12]}]
#set_property PACKAGE_PIN U5 [get_ports {ddr3_addr[13]}]
#set_property PACKAGE_PIN U6 [get_ports {ddr3_addr[14]}]
#set_property SLEW FAST [get_ports {ddr3_addr[*]}]
#set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[*]}]

#set_property PACKAGE_PIN AB2 [get_ports {ddr3_ba[0]}]
#set_property PACKAGE_PIN Y1 [get_ports {ddr3_ba[1]}]
#set_property PACKAGE_PIN W1 [get_ports {ddr3_ba[2]}]
#set_property SLEW FAST [get_ports {ddr3_ba[*]}]
#set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[*]}]

#set_property PACKAGE_PIN AC2 [get_ports {ddr3_ras_n}]
#set_property SLEW FAST [get_ports {ddr3_ras_n}]
#set_property IOSTANDARD SSTL15 [get_ports {ddr3_ras_n}]

#set_property PACKAGE_PIN AA3 [get_ports {ddr3_cas_n}]
#set_property SLEW FAST [get_ports {ddr3_cas_n}]
#set_property IOSTANDARD SSTL15 [get_ports {ddr3_cas_n}]

#set_property PACKAGE_PIN AA2 [get_ports {ddr3_we_n}]
#set_property SLEW FAST [get_ports {ddr3_we_n}]
#set_property IOSTANDARD SSTL15 [get_ports {ddr3_we_n}]

#set_property PACKAGE_PIN AA4 [get_ports {ddr3_reset_n}]
#set_property SLEW FAST [get_ports {ddr3_reset_n}]
#set_property IOSTANDARD LVCMOS15 [get_ports {ddr3_reset_n}]

#set_property PACKAGE_PIN AB5 [get_ports {ddr3_cke[0]}]
#set_property SLEW FAST [get_ports {ddr3_cke[0]}]
#set_property IOSTANDARD SSTL15 [get_ports {ddr3_cke[0]}]

#set_property PACKAGE_PIN AB6 [get_ports {ddr3_odt[0]}]
#set_property SLEW FAST [get_ports {ddr3_odt[0]}]
#set_property IOSTANDARD SSTL15 [get_ports {ddr3_odt[0]}]

#set_property PACKAGE_PIN AA5 [get_ports {ddr3_cs_n[0]}]
#set_property SLEW FAST [get_ports {ddr3_cs_n[0]}]
#set_property IOSTANDARD SSTL15 [get_ports {ddr3_cs_n[0]}]

#set_property PACKAGE_PIN AD4 [get_ports {ddr3_dm[0]}]
#set_property PACKAGE_PIN V11 [get_ports {ddr3_dm[1]}]
#set_property SLEW FAST [get_ports {ddr3_dm[*]}]
#set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[*]}]

#set_property PACKAGE_PIN AF5 [get_ports {ddr3_dqs_p[0]}]
#set_property PACKAGE_PIN AF4 [get_ports {ddr3_dqs_n[0]}]
#set_property PACKAGE_PIN W10 [get_ports {ddr3_dqs_p[1]}]
#set_property PACKAGE_PIN W9 [get_ports {ddr3_dqs_n[1]}]
#set_property SLEW FAST [get_ports {ddr3_dqs*}]
#set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs*}]

#set_property PACKAGE_PIN W6 [get_ports {ddr3_ck_p[0]}]
#set_property PACKAGE_PIN W5 [get_ports {ddr3_ck_n[0]}]
#set_property SLEW FAST [get_ports {ddr3_ck*}]
#set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_ck_*}]
