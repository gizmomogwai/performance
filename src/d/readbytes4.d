import std.c.stdio;
import std.stdio;
import std.datetime;
import std.stdio;
import std.stream;
import std.c.stdio;
import core.memory;


struct FileReader {
  private FILE* fFile;
  private static const BUFFER_SIZE = 1024;
  private ubyte fBuffer[BUFFER_SIZE];
  private ubyte* fBufferPtr;
  private ubyte* fBufferEnd;

  public this(string fn) {
    fFile = std.c.stdio.fopen("/tmp/shop_with_ids.pb", "rb");
    fBufferPtr = fBuffer.ptr;
    fBufferEnd = fBuffer.ptr;
  }

  public int read() {
    auto finished = fBufferPtr == fBufferEnd;
    if (finished) {
      auto f = fillBuffer();
      if (0 == f) {
        return -1;
      }
    }
    return *fBufferPtr++;
  }

  private size_t fillBuffer() {
    fBufferPtr = fBuffer.ptr;
    auto l = std.c.stdio.fread(fBufferPtr, 1, BUFFER_SIZE, fFile);
    fBufferEnd = fBufferPtr + l;
    return l;
  }
}

size_t readBytes() {
  size_t count = 0;
  version(SUM_UP) {
    size_t sum = 0;
  }
  for (int i=0; i<10; i++) {
    auto reader = FileReader("/tmp/shop_with_ids.pb");
    auto b = reader.read();
    while (-1 != b) {
      ++count;
      version(SUM_UP) {
        sum += b;
      }
      b = reader.read();
    }
  }
  version(SUM_UP) {
    return count + sum;
  } else {
    return count;
  }
}

int main(string[] args) {
  auto sw = StopWatch(AutoStart.no);
  sw.start();
  auto count = readBytes();
  sw.stop();
  version(SUM_UP) {
    auto dsc = "sum";
  } else {
    auto dsc = "count";
  }
  writeln("<tr><td>d2-", __VENDOR__, "-4(", dsc, ")</td><td>", count, "</td><td>", sw.peek().msecs, "</td><td>using std.c.stdio.fread with a semantic like java (return -1 for eof).</td></tr>");
  return 0;
}
