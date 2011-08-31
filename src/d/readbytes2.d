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
  public int read(ubyte* targetBuffer) {
    auto finished = fBufferPtr == fBufferEnd;
    if (finished) {
      finished = fillBuffer();
      if (finished) {
        return 0;
      }
    }
    *targetBuffer = *fBufferPtr++;
    return 1;
  }
  private bool fillBuffer() {
    fBufferPtr = fBuffer.ptr;
    auto l = std.c.stdio.fread(fBufferPtr, 1, BUFFER_SIZE, fFile);
    fBufferEnd = fBufferPtr + l;
    return l == 0;
  }
}

size_t readBytes() {
  size_t count = 0;
  version(SUM_UP) {
    size_t sum = 0;
  }
  for (int i=0; i<10; i++) {
    auto reader = FileReader("/tmp/shop_with_ids.pb");
    ubyte buffer[1];
    ubyte* p = buffer.ptr;
    auto c = reader.read(p);
    while (1 == c) {
      ++count;
      version(SUM_UP) {
        sum += *p;
      }
      c = reader.read(p);
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
  writeln("<tr><td>d2-", __VENDOR__, "-2(", dsc, ")</td><td>", count, "</td><td>", sw.peek().msecs, "</td><td>using std.c.stdio.fread with buffering (returning nr of bytes and taking a naked ptr for the result).</td></tr>");
  return 0;
}
