#include "stopwatch.h"
#include <iostream>
#include <stdio.h>


class StdioFileReader {
private:
  FILE* fFile;

public:
  StdioFileReader(std::string s) : fFile(fopen(s.c_str(), "rb")) {
    assert(fFile);
  }
  ~StdioFileReader() {
    fclose(fFile);
  }

  int read() {
    return fgetc(fFile);
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
    while (read != EOF) {
      ++res;
#if VARIANT == 2
      sum += read;
#endif
      read = r.read();
    }
  }
#if VARIANT == 2
  return res + sum;
#else
  return res;
#endif
}

int main(int argc, char** args) {
  StopWatch sw;
  sw.start();
  size_t count = readBytes();
  sw.stop();
  std::cout << "<tr><td>" << V << "-3(" << (VARIANT == 1 ? "count":"sum") << ")</td><td>" << count << "</td><td>" << sw.delta() << "</td><td>using plain fgetc.</td></tr>" << std::endl;
  return 0;
}
