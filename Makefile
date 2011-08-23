all: cpp d codegen

cpp: target/cpp/readbytes

d: target/d/readbytes1 target/d/readbytes2 target/d/readbytes3 target/d/readbytes4


target/cpp/readbytes: src/cpp/readbytes.cpp target/cpp
	g++ -O3 -g $< -o $@


target/d/readbytes1: src/d/readbytes1.d | target/d
	dmd -O -release $< -of$@
target/d/readbytes2: src/d/readbytes2.d | target/d
	dmd -O -release $< -of$@
target/d/readbytes3: src/d/readbytes3.d | target/d
	dmd -O -release $< -of$@
target/d/readbytes4: src/d/readbytes4.d | target/d
	dmd -O -release $< -of$@


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
