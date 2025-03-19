#----------------------------------------------------------------------
# project.tcl will work with earlier, and later, Vivado versions then 
# the following Vivado version used to generate these commands:
# Vivado v2022.1 (64-bit)
# SW Build 3526262 on Mon Apr 18 15:48:16 MDT 2022
# IP Build 3524634 on Mon Apr 18 20:55:01 MDT 2022
# 
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
create_project RAMTester Vivado -part xcau25p-ffvb676-2-e
add_files -norecurse {\
ramtest.v \
ddr4_test.v\
}

add_files -fileset constrs_1 -norecurse xem8320.xdc

create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name fifo_w32_1024_r128_256
set_property -dict [list \
CONFIG.Component_Name {fifo_w32_1024_r128_256} \
CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
CONFIG.asymmetric_port_width {true} \
CONFIG.Input_Data_Width {32} \
CONFIG.Output_Data_Width {128} \
CONFIG.Output_Depth {256} \
CONFIG.Use_Embedded_Registers {false} \
CONFIG.Reset_Type {Asynchronous_Reset} \
CONFIG.Full_Flags_Reset_Value {1} \
CONFIG.Valid_Flag {true} \
CONFIG.Write_Data_Count {true} \
CONFIG.Read_Data_Count {true} \
CONFIG.Read_Data_Count_Width {8} \
CONFIG.Full_Threshold_Assert_Value {1021} \
CONFIG.Full_Threshold_Negate_Value {1020} \
CONFIG.Empty_Threshold_Assert_Value {2} \
CONFIG.Empty_Threshold_Negate_Value {3} \
CONFIG.Enable_Safety_Circuit {true}\
] [get_ips fifo_w32_1024_r128_256]

create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name fifo_w128_256_r32_1024
set_property -dict [list \
CONFIG.Component_Name {fifo_w128_256_r32_1024} \
CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
CONFIG.asymmetric_port_width {true} \
CONFIG.Input_Data_Width {128} \
CONFIG.Input_Depth {256} \
CONFIG.Output_Data_Width {32} \
CONFIG.Output_Depth {1024} \
CONFIG.Use_Embedded_Registers {false} \
CONFIG.Reset_Type {Asynchronous_Reset} \
CONFIG.Full_Flags_Reset_Value {1} \
CONFIG.Valid_Flag {true} \
CONFIG.Data_Count_Width {8} \
CONFIG.Write_Data_Count {true} \
CONFIG.Write_Data_Count_Width {8} \
CONFIG.Read_Data_Count {true} \
CONFIG.Read_Data_Count_Width {10} \
CONFIG.Full_Threshold_Assert_Value {253} \
CONFIG.Full_Threshold_Negate_Value {252} \
CONFIG.Enable_Safety_Circuit {true}\
] [get_ips fifo_w128_256_r32_1024]

create_ip -name ddr4 -vendor xilinx.com -library ip -module_name ddr4_0
set_property -dict [list \
CONFIG.C0.DDR4_InputClockPeriod {9996} \
CONFIG.C0.DDR4_TimePeriod {833} \
CONFIG.C0.DDR4_CasLatency {17} \
CONFIG.C0.DDR4_CasWriteLatency {12} \
CONFIG.C0.DDR4_MemoryPart {MT40A512M16LY-075} \
CONFIG.C0.DDR4_DataWidth {16} \
CONFIG.C0.BANK_GROUP_WIDTH {1}\
] [get_ips ddr4_0]

update_compile_order -fileset sources_1