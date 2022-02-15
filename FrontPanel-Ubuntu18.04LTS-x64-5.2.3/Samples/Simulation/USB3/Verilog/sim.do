# This is a Modelsim simulation script.
# To use:
#  + Start Modelsim
#  + At the command-line, CD to the directory where this file is.
#  + Type: "do thisfilename.do"

set PATH ./oksim

# Source files and testfixture
vlib work
vlog +incdir+$PATH sim_tf.v

vlog sim.v

vlog +incdir+$PATH $PATH/glbl.v
vlog +incdir+$PATH $PATH/okHost.v
vlog +incdir+$PATH $PATH/okWireIn.v
vlog +incdir+$PATH $PATH/okWireOut.v
vlog +incdir+$PATH $PATH/okWireOR.v
vlog +incdir+$PATH $PATH/okTriggerIn.v
vlog +incdir+$PATH $PATH/okTriggerOut.v
vlog +incdir+$PATH $PATH/okPipeIn.v
vlog +incdir+$PATH $PATH/okPipeOut.v
vlog +incdir+$PATH $PATH/okRegisterBridge.v

vsim -t ps SIM_TEST -novopt +acc

#Setup waveforms
onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -divider {Wire/Trigger Data}
add wave -format Literal -radix hex /SIM_TEST/ep01value
add wave -format Literal -radix hex /SIM_TEST/ep20value

add wave -divider {Pipe Data}
add wave -format Literal -radix hex /SIM_TEST/pipeIn
add wave -format Literal -radix hex /SIM_TEST/pipeOut

add wave -divider {Hardware Signals}
add wave -format Literal -radix hex /SIM_TEST/dut/lfsr
add wave -format Literal -radix hex /SIM_TEST/dut/led
add wave -format Literal -radix hex /SIM_TEST/dut/regWriteData
add wave -format Literal -radix hex /SIM_TEST/dut/regReadData

TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 261
configure wave -valuecolwidth 58
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0

run -all

update
WaveRestoreZoom 0ns 30us