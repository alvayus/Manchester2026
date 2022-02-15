PipeTest Sample
---------------
This basic command line sample is designed to test the throughput of FrontPanel
pipes to and from the XEM.

1. You need to have the following in a single directory:
     + PipeTest.exe
     + okFrontPanel.dll
     + PipeTest bitfile as appropriate for XEM model

2. At the command line, run:
    PipeTest.exe for usage information.

    Usage: PipeTest.exe bitfile [lfsr|sequential|walking1|walking0|hammer|neighbor]
                        [stress] [check] [bench] [blocksize B] [segmentsize S]
                        [read N] [write N]
      bitfile        - Configuration file to download.
      lfsr           - [Default] Selects LFSR Pseudorandom pattern generator.
      sequential     - Selects Counter pattern generator.
      walking1       - Selects Walking 1's pattern generator. (USB 3.0 only)
      walking0       - Selects Walking 0's pattern generator. (USB 3.0 only)
      hammer         - Selects Hammer pattern generator. (USB 3.0 only)
      neighbor       - Selects Neighbor pattern generator. (USB 3.0 only)
      throttlein     - Specifies a 32-bit hex throttle vector (writes).
      throttleout    - Specifies a 32-bit hex throttle vector (reads).
      stress         - Performs a transfer stress test (validity checks on).
      bench          - Runs a preset benchmark script and prints results.
      blocksize B    - Sets the block size to B (for BTPipes).
      segmentsize S  - Sets the segment size to S.
      check          - Turns on validity checks.
      inject         - Injects an error during data generation.
      read N         - Performs a read of N bytes and optionally checks for validity.
      write N        - Performs a write of N bytes and optionally checks for validity.
      
3. To run benchmarks for an XEM6001 (for example) run:
    PipeTest.exe PipeTest-xem6001.bit bench
   
   To run the stress test on an XEM6310 run:
    PipeTest.exe PipeTest-xem6310-lx45.bit stress
   
   To run a 10MB read/write test with walking 1's pattern:
    PipeTest.exe PipeTest-xem6310-lx45.bit walking1 read 10485760 write 10485760


Performance is deteriorated by including validity checks.

A device is only accessible in one application at a time. Ensure the 
FrontPanel application is closed before running the sample.
