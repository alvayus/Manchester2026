onerror {resume}

divider add "Wire/Trigger Data"
wave add -radix hex /SIM_TEST/ep01value
wave add -radix hex /SIM_TEST/ep20value

divider add "Pipe Data"
wave add -radix hex /SIM_TEST/pipeIn
wave add -radix hex /SIM_TEST/pipeOut

divider add "Hardware signals"
wave add -radix hex /SIM_TEST/dut/lfsr
wave add -radix hex /SIM_TEST/dut/led
wave add -radix hex /SIM_TEST/dut/regWriteData
wave add -radix hex /SIM_TEST/dut/regReadData

run 30us;