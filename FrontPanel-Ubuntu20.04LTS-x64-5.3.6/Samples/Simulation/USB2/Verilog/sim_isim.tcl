onerror {resume}

divider add "Wire/Trigger Data"
wave add -radix hex /SIM_TEST/ep01value
wave add -radix hex /SIM_TEST/ep20value

divider add "Pipe Data"
wave add -radix hex /SIM_TEST/pipeIn
wave add -radix hex /SIM_TEST/dut/epPipeIn
wave add -radix hex /SIM_TEST/pipeOut
wave add -radix hex /SIM_TEST/dut/epPipeOut

divider add "Hardware signals"
wave add -radix hex /SIM_TEST/dut/lfsr
wave add -radix hex /SIM_TEST/dut/led

run 60us;