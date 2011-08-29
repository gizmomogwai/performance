#include "stopwatch.h"
#include <iostream>
#include <stdio.h>
#include <dlfcn.h>


class StdioFileReader {
private:
  FILE* fFile;
  static const size_t BUFFER_SIZE = 1024;
  unsigned char fBuffer[BUFFER_SIZE];
  unsigned char* fBufferPtr;
  unsigned char* fBufferEnd;
  void* fLibc;
  int (*fRead)(void*, size_t, size_t, FILE*);
public:
  StdioFileReader(std::string s) : fFile(fopen(s.c_str(), "rb")), fBufferPtr(fBuffer), fBufferEnd(fBuffer) {
    assert(fFile);
    fLibc = dlopen("/lib/x86_64-linux-gnu/libc.so.6", RTLD_LAZY);
    assert(fLibc);
    fRead = (int (*)(void*, size_t, size_t, FILE*))(dlsym(fLibc, "fread"));
    assert(fRead);
  }
  ~StdioFileReader() {
    fclose(fFile);
  }

  int read() {
    bool finished = fBufferPtr == fBufferEnd;
    if (finished) {
      finished = fillBuffer();
      if (finished) {
	return -1;
      }
    }
    return *fBufferPtr++;
  }

private:
  bool fillBuffer() {
    size_t l = fRead(fBuffer, 1, BUFFER_SIZE, fFile);
    fBufferPtr = fBuffer;
    fBufferEnd = fBufferPtr+l;
    return l == 0;
  }
};

size_t readBytes() {
  size_t res = 0;
  for (int i=0; i<10; i++) {
    StdioFileReader r("/tmp/shop_with_ids.pb");
    int read = r.read();
    while (read != -1) {
      ++res;
      read = r.read();
    }
  }
  return res;
}

int main(int argc, char** args) {
  StopWatch sw;
  sw.start();
  size_t count = readBytes();
  sw.stop();
  std::cout << "<tr><td>cpp-5</td><td>" << count << "</td><td>" << sw.delta() << "</td><td>using dlopen(\"libc.so.6\") and dlsym(\"fread\").</td></tr>" << std::endl;
  return 0;
}
