add_wave_divider "Wire/Trigger Data"
add_wave -radix hex /SIM_TEST/ep01value
add_wave -radix hex /SIM_TEST/ep20value
add_wave -radix hex /SIM_TEST/ep01value_s 
add_wave -radix hex /SIM_TEST/ep20value_s

add_wave_divider "Pipe Data"
add_wave -radix hex /SIM_TEST/pipeIn
add_wave -radix hex /SIM_TEST/pipeOut
add_wave -radix hex /SIM_TEST/pipeIn_s
add_wave -radix hex /SIM_TEST/pipeOut_s

add_wave_divider "Hardware signals"
add_wave -radix hex /SIM_TEST/dut/lfsr
add_wave -radix hex /SIM_TEST/dut/led
add_wave -radix hex /SIM_TEST/dut/regWriteData
add_wave -radix hex /SIM_TEST/dut/regReadData
add_wave -radix hex /SIM_TEST/dut/lfsr_s
add_wave -radix hex /SIM_TEST/dut/regWriteData_s
add_wave -radix hex /SIM_TEST/dut/regReadData_s

run 30 us;
