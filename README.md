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

  <tr><td>g++-1(count)</td><td>128863360</td><td>117</td><td>straight forward implementation using fread with buffering.</td></tr>
  <tr><td>g++-2(count)</td><td>128863360</td><td>85</td><td>straight forward implementation using mmap.</td></tr>
  <tr><td>g++-3(count)</td><td>128863360</td><td>1010</td><td>using plain fgetc.</td></tr>
  <tr><td>g++-3(count)</td><td>128863360</td><td>279</td><td>using plain fgetc_unlocked.</td></tr>
  <tr><td>g++-5(count)</td><td>128863360</td><td>117</td><td>using dlopen("libc.so.6") and dlsym("fread").</td></tr>
  <tr><td>llvm-c++-1(count)</td><td>128863360</td><td>185</td><td>straight forward implementation using fread with buffering.</td></tr>
  <tr><td>llvm-c++-2(count)</td><td>128863360</td><td>152</td><td>straight forward implementation using mmap.</td></tr>
  <tr><td>llvm-c++-3(count)</td><td>128863360</td><td>968</td><td>using plain fgetc.</td></tr>
  <tr><td>llvm-c++-3(count)</td><td>128863360</td><td>413</td><td>using plain fgetc_unlocked.</td></tr>
  <tr><td>llvm-c++-5(count)</td><td>128863360</td><td>160</td><td>using dlopen("libc.so.6") and dlsym("fread").</td></tr>
  <tr><td>g++-1(sum)</td><td>14577336640</td><td>160</td><td>straight forward implementation using fread with buffering.</td></tr>
  <tr><td>g++-2(sum)</td><td>14577336640</td><td>153</td><td>straight forward implementation using mmap.</td></tr>
  <tr><td>g++-3(sum)</td><td>14577336640</td><td>992</td><td>using plain fgetc.</td></tr>
  <tr><td>g++-3(sum)</td><td>14577336640</td><td>285</td><td>using plain fgetc_unlocked.</td></tr>
  <tr><td>g++-5(sum)</td><td>14577336640</td><td>160</td><td>using dlopen("libc.so.6") and dlsym("fread").</td></tr>
  <tr><td>llvm-c++-1(sum)</td><td>14577336640</td><td>236</td><td>straight forward implementation using fread with buffering.</td></tr>
  <tr><td>llvm-c++-2(sum)</td><td>14577336640</td><td>154</td><td>straight forward implementation using mmap.</td></tr>
  <tr><td>llvm-c++-3(sum)</td><td>14577336640</td><td>954</td><td>using plain fgetc.</td></tr>
  <tr><td>llvm-c++-3(sum)</td><td>14577336640</td><td>616</td><td>using plain fgetc_unlocked.</td></tr>
  <tr><td>llvm-c++-5(sum)</td><td>14577336640</td><td>210</td><td>using dlopen("libc.so.6") and dlsym("fread").</td></tr>
  <tr><td>d2-Digital Mars D-1(count)</td><td>128863360</td><td>1804</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-Digital Mars D-2(count)</td><td>128863360</td><td>559</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-Digital Mars D-3(count)</td><td>128863360</td><td>499</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-Digital Mars D-4(count)</td><td>128863360</td><td>505</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-Digital Mars D-5(count)</td><td>128863360</td><td>486</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-Digital Mars D-6(count)</td><td>128863360</td><td>588</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-Digital Mars D-7(count)</td><td>128863360</td><td>732</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>d2-LDC-1(count)</td><td>128863360</td><td>12529</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-LDC-2(count)</td><td>128863360</td><td>157</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-LDC-3(count)</td><td>128863360</td><td>116</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-LDC-4(count)</td><td>128863360</td><td>327</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-LDC-5(count)</td><td>128863360</td><td>148</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-LDC-6(count)</td><td>128863360</td><td>330</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-LDC-7(count)</td><td>128863360</td><td>115</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>d2-GDC-1(count)</td><td>128863360</td><td>1504</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-GDC-2(count)</td><td>128863360</td><td>117</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-GDC-3(count)</td><td>128863360</td><td>115</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-GDC-4(count)</td><td>128863360</td><td>114</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-GDC-5(count)</td><td>128863360</td><td>84</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-GDC-6(count)</td><td>128863360</td><td>161</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-GDC-7(count)</td><td>128863360</td><td>114</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>d2-Digital Mars D-1(sum)</td><td>14577336640</td><td>1782</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-Digital Mars D-2(sum)</td><td>14577336640</td><td>711</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-Digital Mars D-3(sum)</td><td>14577336640</td><td>749</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-Digital Mars D-4(sum)</td><td>14577336640</td><td>472</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-Digital Mars D-5(sum)</td><td>14577336640</td><td>450</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-Digital Mars D-6(sum)</td><td>14577336640</td><td>678</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-Digital Mars D-7(sum)</td><td>14577336640</td><td>730</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>d2-LDC-1(sum)</td><td>14577336640</td><td>12255</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-LDC-2(sum)</td><td>14577336640</td><td>161</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-LDC-3(sum)</td><td>14577336640</td><td>171</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-LDC-4(sum)</td><td>14577336640</td><td>265</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-LDC-5(sum)</td><td>14577336640</td><td>194</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-LDC-6(sum)</td><td>14577336640</td><td>331</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-LDC-7(sum)</td><td>14577336640</td><td>161</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>d2-GDC-1(sum)</td><td>14577336640</td><td>1549</td><td>using std.stream.BufferedFile with ubyte[1].</td></tr>
  <tr><td>d2-GDC-2(sum)</td><td>14577336640</td><td>161</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>
  <tr><td>d2-GDC-3(sum)</td><td>14577336640</td><td>158</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>
  <tr><td>d2-GDC-4(sum)</td><td>14577336640</td><td>158</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>
  <tr><td>d2-GDC-5(sum)</td><td>14577336640</td><td>108</td><td>using mmfile and a direct pointer to the slice.</td></tr>
  <tr><td>d2-GDC-6(sum)</td><td>14577336640</td><td>202</td><td>using std.stdio.File with arrayslicing.</td></tr>
  <tr><td>d2-GDC-7(sum)</td><td>14577336640</td><td>158</td><td>using dlopen("libc") and dlsym("fread").</td></tr>
  <tr><td>java-1</td><td>128863360</td><td>3025</td><td>using BufferedInputStream.read().</td></tr>
  <tr><td>java-2</td><td>128863360</td><td>339</td><td>using a read into a buffer[1] with buffering.</td></tr>
  <tr><td>java-3</td><td>128863360</td><td>261</td><td>using nio and terminating with BufferUnderflowException.</td></tr>
</table>

Outlook
-------
As you can see, most of the d solutions are slower than java or c++. Only if you choose the right implementation for the right compiler similar results to g++ can be expected. Please help me improve / enhance the solutions.
