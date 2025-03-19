#----------------------------------------------------------------------
# To run:
# 1. Copy project files into a working directory.
# 2. Open Vivado GUI and "cd" to this working directory
#    using the TCL console.
# 3. Run "source project.tcl"
# 4. Import FrontPanel HDL for your product into the project. These
#    sources are located within the FrontPanel SDK installation.
# 5. Generate Bitstream.
#--------------------------------------------------------------------
start_gui
create_project flashloader Vivado -part xcau15p-ffvb676-1-e
add_files -norecurse {xem8305.v flash_b.v flash_a.v FlashLoader-USB3.v}
add_files -fileset constrs_1 -norecurse xem8305.xdc
update_compile_order -fileset sources_1
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_w8_r32
set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}\
CONFIG.Use_Embedded_Registers {false}\
CONFIG.asymmetric_port_width {true}\
CONFIG.Input_Data_Width {8}\
CONFIG.Input_Depth {2048}\
CONFIG.Output_Data_Width {32}\
CONFIG.Output_Depth {512}\
CONFIG.Reset_Type {Asynchronous_Reset}\
CONFIG.Full_Flags_Reset_Value {1}\
CONFIG.Data_Count_Width {11}\
CONFIG.Write_Data_Count {true}\
CONFIG.Write_Data_Count_Width {11}\
CONFIG.Read_Data_Count {true}\
CONFIG.Read_Data_Count_Width {9}\
CONFIG.Enable_Safety_Circuit {true}] [get_ips fifo_w8_r32]
generate_target {instantiation_template} [get_files Vivado/flashloader.srcs/sources_1/ip/fifo_w8_r32/fifo_w8_r32.xci]
update_compile_order -fileset sources_1
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_w32_r8
set_property -dict [list CONFIG.Component_Name {fifo_w32_r8}\
CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}\
CONFIG.Use_Embedded_Registers {false}\
CONFIG.asymmetric_port_width {true} CONFIG.Input_Data_Width {32}\
CONFIG.Input_Depth {2048}\
CONFIG.Output_Data_Width {8}\
CONFIG.Output_Depth {8192}\
CONFIG.Reset_Type {Asynchronous_Reset}\
CONFIG.Full_Flags_Reset_Value {1}\
CONFIG.Data_Count_Width {11}\
CONFIG.Write_Data_Count {true}\
CONFIG.Write_Data_Count_Width {11}\
CONFIG.Read_Data_Count {true}\
CONFIG.Read_Data_Count_Width {13}\
CONFIG.Enable_Safety_Circuit {true}] [get_ips fifo_w32_r8]
generate_target {instantiation_template} [get_files Vivado/flashloader.srcs/sources_1/ip/fifo_w32_r8/fifo_w32_r8.xci]
update_compile_order -fileset sources_1
