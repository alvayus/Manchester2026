REM Simulation Sample Batch File (Vivado)

call xelab work.SIM_TEST -prj sim_isim.prj -L unisims_ver -L secureip -s sim_vivado -debug typical
xsim -g -t sim_vivado.tcl -wdb sim_vivado.wdb sim_vivado
