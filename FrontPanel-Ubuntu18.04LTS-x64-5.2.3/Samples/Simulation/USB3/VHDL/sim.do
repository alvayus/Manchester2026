# This is a Modelsim simulation script.
# To use:
#  + Start Modelsim
#  + At the command-line, CD to the directory where this file is.
#  + Type: "do thisfilename.do"

set PATH ./oksim

# Source files and testfixture
vlib work
vcom $PATH/mappings.vhd
vcom $PATH/parameters.vhd
vcom $PATH/okLibrary_sim.vhd

vcom sim_tf.vhd

vcom sim.vhd

vcom $PATH/okHost.vhd
vcom $PATH/okWireIn.vhd
vcom $PATH/okWireOut.vhd
vcom $PATH/okWireOR.vhd
vcom $PATH/okTriggerIn.vhd
vcom $PATH/okTriggerOut.vhd
vcom $PATH/okPipeIn.vhd
vcom $PATH/okPipeOut.vhd
vcom $PATH/okRegisterBridge.vhd
vcom $PATH/okLibrary_sim.vhd

vsim -t ps SIM_TEST -novopt +acc

#Setup waveforms
onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -divider {Hardware Signals}
add wave -format Literal -radix hex /SIM_TEST/dut/ep01wire
add wave -format Literal -radix hex /SIM_TEST/dut/ep20wire
add wave -format Literal -radix hex /SIM_TEST/dut/epPipeOut
add wave -format Literal -radix hex /SIM_TEST/dut/epPipeIn
add wave -format Literal -radix hex /SIM_TEST/dut/led

add wave -divider {Counter and LFSR}
add wave -format Literal -radix hex /SIM_TEST/dut/lfsr
add wave -format Literal -radix hex /SIM_TEST/dut/lfsr_mode
add wave -format Literal -radix hex /SIM_TEST/dut/refresh_mode

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

update
WaveRestoreZoom {0 ns} {40 us}

run 40 us
