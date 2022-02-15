Serial Flash Loader Sample
Copyright (c) 2007 Opal Kelly Incorporated
---------------------------------------------------------------------------
This sample is provided for use with Opal Kelly FPGA integration modules
and comes with no guarantees.
---------------------------------------------------------------------------

This sample (FlashLoader) is designed to allow you to program the SPI
flash available on some Opal Kelly FPGA integration modules.  You can use
the code as-is to program a bitfile into the flash for configuration 
booting or you can incorporate this code into your application to provide
more flexible flash programming options.

The provided bitfile has been precompiled for the Opal Kelly modules. 
Source code for this bitfile is not presently available.

A device is only accessible in one application at a time. Ensure the 
FrontPanel application is closed before running the sample.

Running the sample to load your own bitfile is easy enough:
  1. You need to have the following in a single directory:
     + flashloader.exe
     + okFrontPanel.dll
     + flashload.bit
     + Your own bitfile

  2. At the command line, run:
       flashloader.exe mybitfile.bit

