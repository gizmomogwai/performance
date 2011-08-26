#include "stopwatch.h"
#include <iostream>
#include <sys/mman.h>
#include <sys/stat.h>
#include <stdio.h>
       #include <fcntl.h>

class MemoryMappedFileReader {
private:
  int fFile;
  unsigned char* fBuffer;
  size_t fLength;
  size_t fPos;

public:
  MemoryMappedFileReader(std::string s) : fFile(open(s.c_str(), O_RDONLY)) {
    assert(fFile != -1);
    struct stat stats;
    fstat(fFile, &stats);
    fLength = stats.st_size;
    fBuffer = static_cast<unsigned char*>(mmap(0, fLength, PROT_READ, MAP_PRIVATE, (int)fFile, 0));
    fPos = 0;
  }

  ~MemoryMappedFileReader() {
    munmap(fBuffer, fLength);
    close(fFile);
  }

  int read() {
    if (fPos >= fLength) {
      return -1;
    }
    return fBuffer[fPos++];
  }
};

size_t readBytes() {
  size_t res = 0;
  for (int i=0; i<10; i++) {
    MemoryMappedFileReader r("/tmp/shop_with_ids.pb");
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
  std::cout << "<tr><td>cpp-1</td><td>" << count << "</td><td>" << sw.delta() << "</td><td>straight forward implementation using mmap.</td></tr>" << std::endl;
  return 0;
}
