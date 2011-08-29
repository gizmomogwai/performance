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
    return fgetc_unlocked(fFile);
  }

};

size_t readBytes() {
  size_t res = 0;
  for (int i=0; i<10; i++) {
    StdioFileReader r("/tmp/shop_with_ids.pb");
    int read = r.read();
    while (read != EOF) {
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
  std::cout << "<tr><td>cpp-3</td><td>" << count << "</td><td>" << sw.delta() << "</td><td>using plain fgetc_unlocked.</td></tr>" << std::endl;
  return 0;
}
