#-----------------------------------------------------------------------
# project-ku060.tcl will work with earlier, and later, Vivado versions then 
# the following Vivado version used to generate these commands:
# Vivado v2021.1.1 (64-bit)
# SW Build 3286242 on Wed Jul 28 13:10:47 MDT 2021
# IP Build 3279568 on Wed Jul 28 16:48:48 MDT 2021
# 
# To run:
# 1. Copy project files into a working directory.
# 2. Open Vivado GUI and "cd" to this working directory 
#    using the TCL console.
# 3. Run "source project.tcl"
# 4. Import FrontPanel HDL for your product into the project. These
#    sources are located within the FrontPanel SDK installation.
# 5. Generate Bitstream.
#
# Note: Earlier versions of Vivado may not support the MT40A512M16LY-075
#       memory part. If you receive an error regarding this you must
#       upgrade to a newer version of Vivado.
#-----------------------------------------------------------------------
start_gui
create_project RAMTester Vivado -part xcku060-ffva1517-1-c
add_files -norecurse {ddr4_test.v ramtest.v}
update_compile_order -fileset sources_1
add_files -fileset constrs_1 -norecurse {xem8350.xdc xem8350_ddr4.xdc}
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_w512_128_r64_1024
set_property -dict [list CONFIG.Component_Name {fifo_w512_128_r64_1024} CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} CONFIG.Performance_Options {First_Word_Fall_Through} CONFIG.asymmetric_port_width {true} CONFIG.Input_Data_Width {512} CONFIG.Input_Depth {128} CONFIG.Output_Data_Width {64} CONFIG.Output_Depth {1024} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.Full_Flags_Reset_Value {1} CONFIG.Valid_Flag {true} CONFIG.Data_Count_Width {7} CONFIG.Write_Data_Count {true} CONFIG.Write_Data_Count_Width {7} CONFIG.Read_Data_Count {true} CONFIG.Read_Data_Count_Width {10} CONFIG.Full_Threshold_Assert_Value {125} CONFIG.Full_Threshold_Negate_Value {124} CONFIG.Empty_Threshold_Assert_Value {4} CONFIG.Empty_Threshold_Negate_Value {5} CONFIG.Enable_Safety_Circuit {true}] [get_ips fifo_w512_128_r64_1024]
generate_target {instantiation_template} [get_files Vivado/RAMTester.srcs/sources_1/ip/fifo_w512_128_r64_1024/fifo_w512_128_r64_1024.xci]
update_compile_order -fileset sources_1
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_w64_r32
set_property -dict [list CONFIG.Component_Name {fifo_w64_r32} CONFIG.Fifo_Implementation {Common_Clock_Block_RAM} CONFIG.asymmetric_port_width {true} CONFIG.Input_Data_Width {64} CONFIG.Output_Data_Width {32} CONFIG.Output_Depth {2048} CONFIG.Use_Embedded_Registers {false} CONFIG.Use_Extra_Logic {true} CONFIG.Write_Data_Count_Width {11} CONFIG.Read_Data_Count {true} CONFIG.Read_Data_Count_Width {12} CONFIG.Full_Threshold_Assert_Value {1021} CONFIG.Full_Threshold_Negate_Value {1020}] [get_ips fifo_w64_r32]
generate_target {instantiation_template} [get_files Vivado/RAMTester.srcs/sources_1/ip/fifo_w64_r32/fifo_w64_r32.xci]
update_compile_order -fileset sources_1
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_w64_1024_r512_128
set_property -dict [list CONFIG.Component_Name {fifo_w64_1024_r512_128} CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} CONFIG.asymmetric_port_width {true} CONFIG.Input_Data_Width {64} CONFIG.Output_Data_Width {512} CONFIG.Output_Depth {128} CONFIG.Use_Embedded_Registers {false} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.Full_Flags_Reset_Value {1} CONFIG.Valid_Flag {true} CONFIG.Write_Data_Count {true} CONFIG.Read_Data_Count {true} CONFIG.Read_Data_Count_Width {7} CONFIG.Full_Threshold_Assert_Value {1021} CONFIG.Full_Threshold_Negate_Value {1020} CONFIG.Enable_Safety_Circuit {true}] [get_ips fifo_w64_1024_r512_128]
generate_target {instantiation_template} [get_files Vivado/RAMTester.srcs/sources_1/ip/fifo_w64_1024_r512_128/fifo_w64_1024_r512_128.xci]
update_compile_order -fileset sources_1
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_w32_r64
set_property -dict [list CONFIG.Component_Name {fifo_w32_r64} CONFIG.Performance_Options {First_Word_Fall_Through} CONFIG.asymmetric_port_width {true} CONFIG.Input_Data_Width {32} CONFIG.Output_Data_Width {64} CONFIG.Output_Depth {512} CONFIG.Valid_Flag {true} CONFIG.Read_Data_Count_Width {9} CONFIG.Empty_Threshold_Assert_Value {4} CONFIG.Empty_Threshold_Negate_Value {5}] [get_ips fifo_w32_r64]
generate_target {instantiation_template} [get_files Vivado/RAMTester.srcs/sources_1/ip/fifo_w32_r64/fifo_w32_r64.xci]
update_compile_order -fileset sources_1
create_ip -name ddr4 -vendor xilinx.com -library ip -version 2.2 -module_name ddr4_512_64
set_property -dict [list CONFIG.C0.DDR4_InputClockPeriod {6566} CONFIG.C0.DDR4_MemoryPart {MT40A512M16LY-075} CONFIG.C0.DDR4_DataWidth {72} CONFIG.C0.DDR4_DataMask {NO_DM_NO_DBI} CONFIG.C0.DDR4_Ecc {true} CONFIG.Component_Name {ddr4_512_64} CONFIG.C0.BANK_GROUP_WIDTH {1}] [get_ips ddr4_512_64]
generate_target {instantiation_template} [get_files Vivado/RAMTester.srcs/sources_1/ip/ddr4_512_64/ddr4_512_64.xci]
update_compile_order -fileset sources_1