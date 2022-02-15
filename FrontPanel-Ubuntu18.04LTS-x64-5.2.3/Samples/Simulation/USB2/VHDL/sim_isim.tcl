onerror {resume}

divider add "Hardware signals"
wave add -radix hex SIM_TEST/dut/ep01wire
wave add -radix hex SIM_TEST/dut/ep02wire
wave add -radix hex SIM_TEST/dut/ep20wire
wave add -radix hex SIM_TEST/dut/epPipeOut
wave add -radix hex SIM_TEST/dut/epPipeIn
wave add -radix hex SIM_TEST/dut/LED

divider add "Counter and LFSR"
wave add -radix hex SIM_TEST/dut/lfsr
wave add -radix hex SIM_TEST/dut/lfsr_mode
wave add -radix hex SIM_TEST/dut/refresh_mode

run 70us;