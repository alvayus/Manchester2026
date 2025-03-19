onerror {resume}

divider add "First"
wave add -radix hex /FIRST_TEST/dut/ep01wire
wave add -radix hex /FIRST_TEST/dut/ep02wire
wave add -radix hex /FIRST_TEST/dut/ep21wire

run 8us;
