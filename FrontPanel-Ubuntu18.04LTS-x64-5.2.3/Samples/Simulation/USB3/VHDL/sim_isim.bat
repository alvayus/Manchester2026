REM First Simulation Batch File
REM $Rev: 2 $ $Date: 2014-05-02 08:39:50 -0700 (Fri, 02 May 2014) $

REM Edit path for settings32/64, depending on architecture
call %XILINX%\..\settings64.bat

fuse -intstyle ise ^
     -incremental ^
     -lib unisims ^
     -lib unimacro ^
     -lib xilinxcorelib ^
     -lib frontpanel ^
     -o sim_isim.exe ^
     -prj sim_isim.prj ^
     work.SIM_TEST
sim_isim.exe -gui -tclbatch sim_isim.tcl -wdb sim_isim.wdb