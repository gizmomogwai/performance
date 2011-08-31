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
  <tr><td>g++-1</td><td>128863360</td><td>115</td><td>straight forward implementation using fread with buffering.</td></tr>
  <tr><td>g++-2</td><td>128863360</td><td>87</td><td>straight forward implementation using mmap.</td></tr>
  <tr><td>g++-3</td><td>128863360</td><td>954</td><td>using plain fgetc.</td></tr>
  <tr><td>g++-3</td><td>128863360</td><td>277</td><td>using plain fgetc_unlocked.</td></tr>
  <tr><td>g++-5</td><td>128863360</td><td>115</td><td>using dlopen("libc.so.6") and dlsym("fread").</td></tr>
  <tr><td>llvm-c++-1</td><td>128863360</td><td>161</td><td>straight forward implementation using fread with buffering.</td></tr>
  <tr><td>llvm-c++-2</td><td>128863360</td><td>154</td><td>straight forward implementation using mmap.</td></tr>
  <tr><td>llvm-c++-3</td><td>128863360</td><td>954</td><td>using plain fgetc.</td></tr>
  <tr><td>llvm-c++-3</td><td>128863360</td><td>404</td><td>using plain fgetc_unlocked.</td></tr>
  <tr><td>llvm-c++-5</td><td>128863360</td><td>158</td><td>using dlopen("libc.so.6") and dlsym("fread").</td></tr>
  <tr><td>d2-Digital Mars D-1</td><td>128863360</td><td>1762</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-Digital Mars D-2</td><td>128863360</td><td>546</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-Digital Mars D-3</td><td>128863360</td><td>550</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-Digital Mars D-4</td><td>128863360</td><td>497</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-Digital Mars D-5</td><td>128863360</td><td>361</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-Digital Mars D-6</td><td>128863360</td><td>594</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-Digital Mars D-7</td><td>128863360</td><td>733</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>d2-LDC-1</td><td>128863360</td><td>12732</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-LDC-2</td><td>128863360</td><td>115</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-LDC-3</td><td>128863360</td><td>114</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-LDC-4</td><td>128863360</td><td>327</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-LDC-5</td><td>128863360</td><td>149</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-LDC-6</td><td>128863360</td><td>335</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-LDC-7</td><td>128863360</td><td>115</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>d2-GDC-1</td><td>128863360</td><td>1531</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-GDC-2</td><td>128863360</td><td>121</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-GDC-3</td><td>128863360</td><td>116</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-GDC-4</td><td>128863360</td><td>116</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-GDC-5</td><td>128863360</td><td>84</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-GDC-6</td><td>128863360</td><td>160</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-GDC-7</td><td>128863360</td><td>117</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>java-1</td><td>128863360</td><td>3025</td><td>using BufferedInputStream.read().</td></tr>
  <tr><td>java-2</td><td>128863360</td><td>339</td><td>using a read into a buffer[1] with buffering.</td></tr>
  <tr><td>java-3</td><td>128863360</td><td>261</td><td>using nio and terminating with BufferUnderflowException.</td></tr>
</table>

Outlook
-------
As you can see, the d solution is not as good as the java solution and far worse than the cpp solution. Please help me improve it!!!!
