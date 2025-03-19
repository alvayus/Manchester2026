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
create_project RAMTester Vivado -part xcku11p-ffva1156-1-e
add_files -norecurse {\
ddr4_test.v \
ramtest.v\
}

add_files -fileset constrs_1 -norecurse xem8370.xdc

create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name fifo_w32_1024_r256_128
set_property -dict [list CONFIG.Component_Name {fifo_w32_1024_r256_128}\
CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}\
CONFIG.asymmetric_port_width {true} CONFIG.Input_Data_Width {32}\
CONFIG.Output_Data_Width {256} CONFIG.Output_Depth {128}\
CONFIG.Use_Embedded_Registers {false}\
CONFIG.Reset_Type {Asynchronous_Reset}\
CONFIG.Full_Flags_Reset_Value {1}\
CONFIG.Valid_Flag {true} CONFIG.Write_Data_Count {true}\
CONFIG.Read_Data_Count {true} CONFIG.Read_Data_Count_Width {7}\
CONFIG.Full_Threshold_Assert_Value {1021}\
CONFIG.Full_Threshold_Negate_Value {1020}\
CONFIG.Enable_Safety_Circuit {true}] [get_ips fifo_w32_1024_r256_128]

create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name fifo_w256_128_r32_1024
set_property -dict [list CONFIG.Component_Name {fifo_w256_128_r32_1024}\
CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM}\
CONFIG.asymmetric_port_width {true} CONFIG.Input_Data_Width {256}\
CONFIG.Input_Depth {128}\
CONFIG.Output_Data_Width {32}\
CONFIG.Output_Depth {1024}\
CONFIG.Use_Embedded_Registers {false}\
CONFIG.Reset_Type {Asynchronous_Reset}\
CONFIG.Full_Flags_Reset_Value {1}\
CONFIG.Valid_Flag {true} CONFIG.Data_Count_Width {7}\
CONFIG.Write_Data_Count {true}\
CONFIG.Write_Data_Count_Width {7}\
CONFIG.Read_Data_Count {true}\
CONFIG.Read_Data_Count_Width {10}\
CONFIG.Enable_Safety_Circuit {true}] [get_ips fifo_w256_128_r32_1024]

create_ip -name ddr4 -vendor xilinx.com -library ip -module_name ddr4_0
set_property -dict [list \
CONFIG.C0.DDR4_InputClockPeriod {9996} \
CONFIG.C0.DDR4_TimePeriod {833} \
CONFIG.C0.DDR4_MemoryPart {MT40A1G16RC-062E} \
CONFIG.C0.DDR4_DataWidth {32} \
] [get_ips ddr4_0]

update_compile_order -fileset sources_1
