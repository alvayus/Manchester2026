REM Simulation Sample Batch File
REM $Rev: 2 $ $Date: 2014-11-21 10:35 -0700 (Fri, 21 Nov 2014) $

REM Edit path for settings32/64, depending on architecture
call %XILINX%\..\settings64.bat

fuse -intstyle ise ^
     -incremental ^
     -lib unisims_ver ^
     -lib unimacro_ver ^
     -lib xilinxcorelib_ver ^
     -i ./oksim ^
     -o sim_isim.exe ^
     -prj sim_isim.prj ^
     work.SIM_TEST work.glbl
sim_isim.exe -gui -tclbatch sim_isim.tcl -wdb sim_isim.wdb