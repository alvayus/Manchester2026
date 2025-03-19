add_wave_divider "Wire/Trigger Data"
add_wave -radix hex /SIM_TEST/dut/ep01wire
add_wave -radix hex /SIM_TEST/dut/ep02wire
add_wave -radix hex /SIM_TEST/dut/ep20wire

add_wave_divider "Pipe Data"
add_wave -radix hex /SIM_TEST/dut/epPipeIn
add_wave -radix hex /SIM_TEST/dut/epPipeOut

add_wave_divider "Hardware signals"
add_wave -radix hex /SIM_TEST/dut/lfsr
add_wave -radix hex /SIM_TEST/dut/lfsr_mode
add_wave -radix hex /SIM_TEST/dut/refresh_mode
add_wave -radix hex /SIM_TEST/dut/led

run 70 us;
