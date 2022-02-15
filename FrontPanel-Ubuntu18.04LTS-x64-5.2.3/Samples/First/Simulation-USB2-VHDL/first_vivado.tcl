add_wave_divider "FrontPanel Control"
add_wave /FIRST_TEST/hi_in(0)

add_wave_divider "First"
add_wave -radix hex /FIRST_TEST/dut/ep01wire
add_wave -radix hex /FIRST_TEST/dut/ep02wire
add_wave -radix hex /FIRST_TEST/dut/ep21wire

run 8 us;
