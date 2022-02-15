add_wave_divider "Wire/Trigger Data"
add_wave -radix hex /SIM_TEST/ep01value
add_wave -radix hex /SIM_TEST/ep20value

add_wave_divider "Pipe Data"
add_wave -radix hex /SIM_TEST/pipeIn
add_wave -radix hex /SIM_TEST/pipeOut

add_wave_divider "Hardware signals"
add_wave -radix hex /SIM_TEST/dut/lfsr
add_wave -radix hex /SIM_TEST/dut/led
add_wave -radix hex /SIM_TEST/dut/regWriteData
add_wave -radix hex /SIM_TEST/dut/regReadData

run 30 us;
