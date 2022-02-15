Si5338 Register Programming Sample
==================================

This sample will read in Si5338 register settings stored in a csv file then
write them to an Si5338 connected to a FrontPanel device through the Opal Kelly
I2C core.

Building the design
-------------------

This design uses the Opal Kelly I2C Controller core. The source files for the
core (required to build the design) can be downloaded through [github](https://github.com/opalkelly-opensource/I2CController).

With the I2C core added to the project this sample can be built in the same
manner as other Opal Kelly samples.

Running
-------

This sample application runs entirely within FrontPanel, making use of the XFP
Lua scripting functionality added with FrontPanel version 5.1.

To use the sample:

1. Configure the FPGA with the sample bitstream
2. Place si5338_data.csv and si5338_mask.csv in /tmp on your hard drive (this
   is where si5338.lua will look for csv files)
3. Load si5338.xfp
4. Click Setup Si5338 in the XFP window
5. Wait for "Status: Done" to appear
6. The counter running on the LED's should run at a rate appropriate for the new
   clock rate

The Silicon Labs [ClockBuilder Pro](https://www.silabs.com/products/development-tools/software/clockbuilder-pro-software)
software can be used to generate si5338_data.csv files with new settings for
each clock.