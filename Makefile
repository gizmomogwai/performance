all: cpp d codegen

cpp: target/cpp/readbytes1 target/cpp/readbytes2 target/cpp/readbytes3 target/cpp/readbytes4 target/cpp/readbytes5
	@target/cpp/readbytes1
	@target/cpp/readbytes2
	@target/cpp/readbytes3
	@target/cpp/readbytes4
	@target/cpp/readbytes5

d: target/d/readbytes1 target/d/readbytes2 target/d/readbytes3 target/d/readbytes4 target/d/readbytes5 target/d/readbytes6 target/d/readbytes7
	@target/d/readbytes1
	@target/d/readbytes2
	@target/d/readbytes3
	@target/d/readbytes4
	@target/d/readbytes5
	@target/d/readbytes6
	@target/d/readbytes7

target/cpp/readbytes1: src/cpp/readbytes1.cpp | target/cpp
	g++ -O3 -g $< -o $@
target/cpp/readbytes2: src/cpp/readbytes2.cpp | target/cpp
	g++ -O3 -g $< -o $@
target/cpp/readbytes3: src/cpp/readbytes3.cpp | target/cpp
	g++ -O3 -g $< -o $@
target/cpp/readbytes4: src/cpp/readbytes4.cpp | target/cpp
	g++ -O3 -g $< -o $@
target/cpp/readbytes5: src/cpp/readbytes5.cpp | target/cpp
	g++ -O3 -g $< -o $@ -ldl


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
target/cpp:
	mkdir -p $@
target/gen/java:
	mkdir -p $@
