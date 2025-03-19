include ../../okdefs.make

PROGRAM := flashloader

OBJECTS := \
	flashloader.o

all: $(PROGRAM)

$(OBJECTS): %.o:%.cpp
	$(CXX) $(CPPFLAGS) $(okFP_CXXFLAGS) $(CXXFLAGS) -o $@ -c $<

$(PROGRAM): $(OBJECTS)
	$(CXX) $(okFP_LDFLAGS) $(LDFLAGS) -o $(PROGRAM) $(OBJECTS) $(okFP_LIBS) $(LIBS)

clean:
	rm -f *.o $(PROGRAM)
