# Makefile fragment containing common definitions for Opal Kelly makefiles.

# This is just the directory containing this make fragment.
# Notice the ugly workaround for the absence of $(lastword) in the (still
# supported, notably because it's used under macOS) GNU make 3.80: when we
# drop support for it, we should use $(lastword $(MAKEFILE_LIST)) instead.
okFP_ROOT := $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

# The location of the FrontPanel SDK can be overridden by defining okFP_SDK on
# make command line, e.g. "make okFP_SDK=/some/path/FrontPanelSDK".
okFP_SDK ?= $(okFP_ROOT)../API

# The architectures to build for, used only under macOS. By default, we build
# for the native architecture only, but this can be set on make command to
# e.g. "arm64,x86_64" to build universal binaries for both ARM and Intel.
ARCHS ?=

# C++ dialect to use: we require at least C++11, but later versions can be
# used too.
CXX_STD := -std=c++11

# Nothing below this line should be changed, if you need to pass any other
# flags to the makefiles, set the standard CPPFLAGS, CXXFLAGS, LDFLAGS or LIBS
# variables on make command line instead of changing this makefile.
okFP_CXXFLAGS := $(CXX_STD) -I$(okFP_SDK)
okFP_LDFLAGS := $(CXX_STD) -L$(okFP_SDK) -Wl,-rpath -Wl,$(okFP_SDK)
okFP_LIBS := -lokFrontPanel

# Define WX_LIBS before including this file to enable definition of
# wxWidgets-related variables such as WX_CONFIG, WX_CXXFLAGS etc.
ifdef WX_LIBS
WX_CONFIG ?= wx-config

okWX_CXXFLAGS := $(shell $(WX_CONFIG) --cxxflags)

ifeq ($(okWX_CXXFLAGS),)
    $(error Please make sure $(WX_CONFIG) is in path or set WX_CONFIG)
endif

okFP_CXXFLAGS += $(okWX_CXXFLAGS)
okFP_LIBS += $(shell $(WX_CONFIG) --libs $(WX_LIBS))
endif

PLATFORM := $(shell uname)

ifeq ($(PLATFORM),Darwin)
# Use more familiar name for this platform.
PLATFORM := Mac

# Helpers for the substitution of commas with spaces in ARCHS below.
empty :=
space := $(empty) $(empty)
comma := ,

# Unlike ARCHS above, ARCHFLAGS is used in the makefiles rules themselves,
# it's not supposed to be defined by user.
ARCHFLAGS := $(foreach arch,$(subst $(comma),$(space),$(ARCHS)),-arch $(arch))

okFP_CXXFLAGS += $(ARCHFLAGS)
okFP_LDFLAGS += $(ARCHFLAGS)
okFP_LIBS += -framework Carbon -framework IOKit

else # Not Darwin, assume Linux
okFP_LIBS += -ldl
endif

.SUFFIXES: .o .cpp

.PHONY: all clean
