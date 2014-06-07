n-body-benchmark
================

N-body benchmark for ['The Computer Language Benchmarks Game'](http://benchmarksgame.alioth.debian.org/).

Building
========
There are three raw scripts for dmd, gdc and ldc2 compilers.

Also you can build via dub (ldc2 building seems to be broken):
```
dub build --compiler=dmd --build=release
dub build --compiler=gdc --build=release
```

Rough measurement
=================
`bench.sh` script uses `time` utility:
```
$ ./bench.sh
-0.169075164
-0.169059907
        Command being timed: "./nbody 50000000"
        User time (seconds): 11.23
        System time (seconds): 0.00
        Percent of CPU this job got: 98%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:11.44
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 1644
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 2
        Minor (reclaiming a frame) page faults: 458
        Voluntary context switches: 3
        Involuntary context switches: 1760
        Swaps: 0
        File system inputs: 232
        File system outputs: 0
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0
```
