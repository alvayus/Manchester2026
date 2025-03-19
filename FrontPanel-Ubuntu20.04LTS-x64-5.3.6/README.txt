Linux Installation
------------------
The following is performed by the install.sh script. Simply run:
	sudo ./install.sh
to copy the necessary files to the appropriate location as well as make
Opal Kelly devices user accessible.

An uninstall script is included as well, which deletes everything the install
script copied into the various system directories. To run it:
	sudo ./uninstall.sh



Opal Kelly USB udev Rule
------------------------
The Linux installation requires the addition of one file to the directory:

	60-opalkelly.rules ----->  /etc/udev/rules.d/

This file includes a generic udev rule to set the permissions on all
attached Opal Kelly USB devices to allow user access.  Once this file is
in place, you will need to reload the rules by either rebooting or using
the following commands:

	udevadm control --reload-rules
	udevadm trigger

With these files in place, the Linux device system should automatically
provide write permissions to Opal Kelly devices attached to the USB.



Dependencies
------------
libokFrontPanel.so now requires libm.so, you may need to add `-lm` to the
linker flags if you don't link with libm already.

Distributions of FrontPanel for Ubuntu require libsdl2 and liblua5.3. These can
be installed with the following command:

sudo apt install libsdl2-2.0-0 liblua5.3-0

Distributions for Rocky Linux 8 require SDL and pcre2-utf32. These can be
installed with the following command:

sudo dnf install SDL pcre2-utf32

Distributions for Rocky Linux 9 require SDL2. This can be installed with the
following command:

sudo dnf install SDL2



Starting FrontPanel GUI
-----------------------
FrontPanel GUI can be started in a few ways: 
By running the "FrontPanel" script in the install folder. This is a short
	script that configures the environment and then starts the FrontPanel binary.
If /usr/local/bin is in your PATH, you can simply run the command:
	FrontPanel
Or, by searching for FrontPanel in your distribution's application search.

Note: FrontPanel GUI is not available in Jetson or Raspberry Pi distributions.

To make use of sound and flashloader bitfile assets, they must be copied to
/usr/local/share/FrontPanel. This is handled automatically by the install
script. These assets are available in the share/FrontPanel folder.

Note: The Firmware Update Wizard is not available in the Linux version of
FrontPanel.



Additional Documentation
------------------------
Additional documentation can be found at:
	https://docs.opalkelly.com/




Python API
----------
_ok.so
ok.py

By placing these files into a directory and starting Python from that
directory, you can "import ok" and have access to the Python API.  From 
there, you can run commands like:

	import ok
	xem = ok.FrontPanelDevices().Open()
	self.devInfo = ok.okTDeviceInfo()
	print("Product: " + self.devInfo.productName)
	print("Serial Number: %s" % self.devInfo.serialNumber)
	print("Device ID: %s" % self.devInfo.deviceID)
	xem.ConfigureFPGA('<path to bitfile>')



Java API
--------
okjFrontPanel.dll   (Windows)
libokjFrontPanel.so (Linux)
okjFrontPanel.jar   (Common)

libokjFrontPanel.so needs to be copied to the java.library.path or specified when invoking Java by using:
	-Djava.library.path="<path containing libokjFrontPanel.so>"
	Otherwise, you can check which paths java.library.path checks by running:
	java -XshowSettings:properties
	
okjFrontPanel.jar should be added to your CLASSPATH or by using -classpath to point to it.
	It can either be uncompressed or referred to directly on the javac/java command lines as shown below.
	
To build and run DESTester.java:
	javac -classpath okjFrontPanel.jar DESTester.java
	java -Djava.library.path=. -classpath .:okjFrontPanel.jar DESTester e inputfile outputfile
