Performance Microbenchmarks (CPP vs. D)
=======================================

Background
----------
While testing my protobuf binding for d I observed massive performance degradiation compared to the java protobuf binding, and
when I compared with the C++ protobuf binding I run away screaming. It was many times slower than java (not to speak of cpp).
I improved the d performance a lot by adjusting my code generator, but after a while I was still too slow.
So I wrote some small examples, which do stress the basics of protobuf processing.

Makefile
--------
The Makefile generates the protobuf java sources, needed for the testdata.

CreateDataFiles
---------------
This small java programm creates the datafiles in /tmp that are used by the cpp and d implementations.


ReadBytes
---------
This set of implementations tries to read a file from /tmp as fast as possible under the constraint, that
the data is pushed to the application byte by byte. This is done 10 times.

<table>
  <tr>
    <th>Solution</th>
    <th>bytes read (should be 128863360)</th>
    <th>Time in ms for a file of size 12886336</th>
    <th>Description</th>
  </tr>
  <tr><td>cpp-1</td><td>128863360</td><td>115</td><td>straight forward implementation using fread with buffering.</td></tr>
  <tr><td>cpp-2</td><td>128863360</td><td>86</td><td>straight forward implementation using mmap.</td></tr>
  <tr><td>cpp-3</td><td>128863360</td><td>963</td><td>using plain fgetc.</td></tr>
  <tr><td>cpp-3</td><td>128863360</td><td>275</td><td>using plain fgetc_unlocked.</td></tr>
  <tr><td>cpp-5</td><td>128863360</td><td>114</td><td>using dlopen("libc.so.6") and dlsym("fread").</td></tr>
  <tr><td>d2-1</td><td>128863360</td><td>1691</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-2</td><td>128863360</td><td>525</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-3</td><td>128863360</td><td>525</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-4</td><td>128863360</td><td>442</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-5</td><td>128863360</td><td>359</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-6</td><td>128863360</td><td>607</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-7</td><td>128863360</td><td>491</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>java-1</td><td>128863360</td><td>3025</td><td>using BufferedInputStream.read().</td></tr>
  <tr><td>java-2</td><td>128863360</td><td>339</td><td>using a read into a buffer[1] with buffering.</td></tr>
  <tr><td>java-3</td><td>128863360</td><td>261</td><td>using nio and terminating with BufferUnderflowException.</td></tr>
</table>

Outlook
-------
As you can see, the d solution is not as good as the java solution and far worse than the cpp solution. Please help me improve it!!!!
