WX_LIBS := base,core

include ../okdefs.make

PROGRAM := DeviceChange

OBJECTS := \
	DeviceChange.o

ifeq ($(PLATFORM),Mac)
BUNDLE := $(PROGRAM).app
BUNDLED_LIB := $(BUNDLE)/Contents/SharedSupport/libokFrontPanel.dylib
PROGRAM_BIN := $(BUNDLE)/Contents/MacOS/$(PROGRAM)
else
PROGRAM_BIN := $(PROGRAM)
endif

all: $(PROGRAM_BIN)

$(OBJECTS): %.o:%.cpp
	$(CXX) $(CPPFLAGS) $(okFP_CXXFLAGS) $(CXXFLAGS) -o $@ -c $<

$(PROGRAM_BIN): $(OBJECTS) $(BUNDLED_LIB)
	$(CXX) $(okFP_LDFLAGS) $(LDFLAGS) -o $(PROGRAM_BIN) $(OBJECTS) $(okFP_LIBS) $(LIBS)
ifeq ($(PLATFORM),Mac)
	install_name_tool -id "@executable_path/../SharedSupport/libokFrontPanel.dylib" $(BUNDLED_LIB)
	install_name_tool -change "@rpath/libokFrontPanel.dylib" "@executable_path/../SharedSupport/libokFrontPanel.dylib" $(PROGRAM_BIN)

$(BUNDLED_LIB):
	mkdir -p $(BUNDLE)/Contents
	mkdir -p $(BUNDLE)/Contents/MacOS
	mkdir -p $(BUNDLE)/Contents/Resources
	mkdir -p $(BUNDLE)/Contents/SharedSupport
	cp $(okFP_SDK)/libokFrontPanel.dylib $(BUNDLE)/Contents/SharedSupport
endif

clean:
	rm -f $(OBJECTS) $(PROGRAM_BIN)
ifeq ($(PLATFORM),Mac)
	rm -rf $(BUNDLE)
endif
