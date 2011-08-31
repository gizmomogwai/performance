#include "stopwatch.h"
#include <iostream>
#include <stdio.h>


class StdioFileReader {
private:
  FILE* fFile;
  static const size_t BUFFER_SIZE = 1024;
  unsigned char fBuffer[BUFFER_SIZE];
  unsigned char* fBufferPtr;
  unsigned char* fBufferEnd;

public:
  StdioFileReader(std::string s) : fFile(fopen(s.c_str(), "rb")), fBufferPtr(fBuffer), fBufferEnd(fBuffer) {
    assert(fFile);
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
    size_t l = fread_unlocked(fBuffer, 1, BUFFER_SIZE, fFile);
    fBufferPtr = fBuffer;
    fBufferEnd = fBufferPtr+l;
    return l == 0;
  }
};

size_t readBytes() {
  size_t res = 0;
#if VARIANT == 2
  size_t sum = 0;
#endif
  for (int i=0; i<10; i++) {
    StdioFileReader r("/tmp/shop_with_ids.pb");
    int read = r.read();
    while (read != -1) {
#if VARIANT == 2
      sum += read;
#endif
      ++res;
      read = r.read();
    }
  }
#if VARIANT == 2
  return sum + res;
#else
  return res;
#endif
}

int main(int argc, char** args) {
  StopWatch sw;
  sw.start();
  size_t count = readBytes();
  sw.stop();
  std::cout << "<tr><td>" << V << "-1(" << (VARIANT == 1 ? "count":"sum") << ")</td><td>" << count << "</td><td>" << sw.delta() << "</td><td>straight forward implementation using fread with buffering.</td></tr>" << std::endl;
  return 0;
}
