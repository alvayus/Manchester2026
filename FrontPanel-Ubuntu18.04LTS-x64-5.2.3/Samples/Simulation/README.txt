FrontPanel HDL Simulation Sample
--------------------------------
This sample illustrates the use of the FrontPanel HDL simulation library to
perform behavioral simulation on a design. Note that the simulation library is
a behavioral simulation of the endpoint functionality only. The host interface
portion of the simulation is not representative of the host communication of 
the real device.



Files
-----
   sim.do         - (Altera) Modelsim Simulation do file
   sim_isim.bat   - (Xilinx) Windows batch file to run ISE simulation
   sim_isim.prj   - (Xilinx) ISIM project file
   sim_isim.tcl   - (Xilinx) ISIM script to setup the waveform display
   sim_vivado.bat - (Xilinx) Windows batch file to run Vivado simulation
   sim_vivado.tcl - (Xilinx) Vivado tcl script to setup the waveform display
   sim.v|vhd      - Verilog or VHDL device under test HDL source
   sim_tf.v|vhd   - Verilog or VHDL test fixture HDL source



VHDL Simulation Notes
---------------------
The sim_tf.vhd test fixture includes text from okHostCalls_vhd.txt between the
marks:

--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS START PASTE HERE >>>>>>>>>>>>>>>>>>>>--
--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS END PASTE HERE >>>>>>>>>>>>>>>>>>>>>>--

When writing your own simulation files, you will need to copy the text from
okHostCalls_vhd.txt and paste it into your own test fixture.



Running the Simulation
----------------------
To run this sample, follow the steps below. We suggest copying the files 
from the installation folder ($FRONTPANEL) to a working folder on your
filesystem ($WORK) rather than using them directly in the installation
folder.

Be sure to select the proper sources for your device. For USB 2.0 devices such 
as the XEM3010 or XEM6010, take the sample files from the USB2 folder. For
USB 3.0 devices such as the XEM7350 and ZEM4310, take the sample files from the
USB3 folder.

Make appropriate changes for your simulation environment (Verilog / VHDL)
as well.


1. Copy the simulation model files:

   Copy FROM : $FRONTPANEL/Simulation/USB2/Verilog/*.*
   Copy   TO : $WORK/oksim/


2. Copy the simulation sample and test bench:

   Copy FROM : $FRONTPANEL/Samples/Simulation/USB3/Verilog/*.*
   Copy   TO : $WORK/


3. (XILINX/ISE) Start an "ISE Design Suite Command Prompt". This is located under
   the Xilinx group on your start menu. The Xilinx installation process creates
   this special command prompt with the appropriate environment configured.
   If you don't have this, consult the Xilinx documentation.
   
   cd $WORK         # wherever your work directory is!
   sim_isim.bat     # Run the batch file


3. (ALTERA) Altera currently distributes a version of ModelSim with the Quartus
   software. It can be run separately from Quartus and does not need a Quartus
   project file (.qpf), though it may prompt you to create one.

   A. In the Transcript window, CD to the $WORK or use File->Change Directory... 
   B. Type: "do sim.do" at the Modelsim> prompt in Transcript window to execute
      the simulation script.
   C. In Verilog, stop the simulation to make the waves appear in the wave
      window. The waves will appear automatically in VHDL simulations.

3. (XILINX/VIVADO) Start a normal Windows command prompt by right clicking on
   the start menu and selecting the "Command Prompt" option. 

   cd $WORK                              # The directory you are working out of
   $XILINX/Vivado/$VIVADO_VERSION/settings64.bat # Adjust for your Vivado version
                                                 # and CPU architecture
   sim_vivado.bat                        # Run the simulation batch file