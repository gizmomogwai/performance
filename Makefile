LLVM_COMPILER=llvm-c++ -O2
GCC_COMPILER=g++ -O2
all: gcc llvm d codegen

gcc: target/gcc/readbytes1 target/gcc/readbytes2 target/gcc/readbytes3 target/gcc/readbytes4 target/gcc/readbytes5
	@target/gcc/readbytes1
	@target/gcc/readbytes2
	@target/gcc/readbytes3
	@target/gcc/readbytes4
	@target/gcc/readbytes5

llvm: target/llvm/readbytes1 target/llvm/readbytes2 target/llvm/readbytes3 target/llvm/readbytes4 target/llvm/readbytes5
	@target/llvm/readbytes1
	@target/llvm/readbytes2
	@target/llvm/readbytes3
	@target/llvm/readbytes4
	@target/llvm/readbytes5

d: target/d/readbytes1 target/d/readbytes2 target/d/readbytes3 target/d/readbytes4 target/d/readbytes5 target/d/readbytes6 target/d/readbytes7
	@target/d/readbytes1
	@target/d/readbytes2
	@target/d/readbytes3
	@target/d/readbytes4
	@target/d/readbytes5
	@target/d/readbytes6
	@target/d/readbytes7

target/gcc/readbytes1: src/cpp/readbytes1.cpp | target/gcc
	${GCC_COMPILER} -DV=\"gcc\" -O3 -g $< -o $@
target/gcc/readbytes2: src/cpp/readbytes2.cpp | target/gcc
	${GCC_COMPILER} -DV=\"gcc\" -O3 -g $< -o $@
target/gcc/readbytes3: src/cpp/readbytes3.cpp | target/gcc
	${GCC_COMPILER} -DV=\"gcc\" -O3 -g $< -o $@
target/gcc/readbytes4: src/cpp/readbytes4.cpp | target/gcc
	${GCC_COMPILER} -DV=\"gcc\" -O3 -g $< -o $@
target/gcc/readbytes5: src/cpp/readbytes5.cpp | target/gcc
	${GCC_COMPILER} -DV=\"gcc\" -O3 -g $< -o $@ -ldl

target/llvm/readbytes1: src/cpp/readbytes1.cpp | target/llvm
	${LLVM_COMPILER} -DV=\"llvm\" -O3 -g $< -o $@
target/llvm/readbytes2: src/cpp/readbytes2.cpp | target/llvm
	${LLVM_COMPILER} -DV=\"llvm\" -O3 -g $< -o $@
target/llvm/readbytes3: src/cpp/readbytes3.cpp | target/llvm
	${LLVM_COMPILER} -DV=\"llvm\" -O3 -g $< -o $@
target/llvm/readbytes4: src/cpp/readbytes4.cpp | target/llvm
	${LLVM_COMPILER} -DV=\"llvm\" -O3 -g $< -o $@
target/llvm/readbytes5: src/cpp/readbytes5.cpp | target/llvm
	${LLVM_COMPILER} -DV=\"llvm\" -O3 -g $< -o $@ -ldl


target/d/readbytes1: src/d/readbytes1.d | target/d
	dmd -O -release $< -of$@
target/d/readbytes2: src/d/readbytes2.d | target/d
	dmd -O -release $< -of$@
target/d/readbytes3: src/d/readbytes3.d | target/d
	dmd -O -release $< -of$@
target/d/readbytes4: src/d/readbytes4.d | target/d
	dmd -O -release $< -of$@
target/d/readbytes5: src/d/readbytes5.d | target/d
	dmd -O -release $< -of$@
target/d/readbytes6: src/d/readbytes6.d | target/d
	dmd -O -release $< -of$@
target/d/readbytes7: src/d/readbytes7.d | target/d
	dmd -O -release $< -of$@ -L-ldl


PROTO_HOME=~/Downloads/protobuf-2.4.1
PROTOC=${PROTO_HOME}/src/protoc
codegen: target/gen/java/tests/Repeat.java

target/gen/java/tests/Repeat.java: src/proto/Repeat.proto target/gen/java
	${PROTOC} --java_out=target/gen/java $<

target/d:
	mkdir -p $@
target/gcc:
	mkdir -p $@
target/llvm:
	mkdir -p $@
target/gen/java:
	mkdir -p $@
