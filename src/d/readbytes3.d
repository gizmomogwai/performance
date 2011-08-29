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
  public bool read(out ubyte res) {
    auto finished = fBufferPtr == fBufferEnd;
    if (finished) {
      finished = fillBuffer();
      if (finished) {
        return false;
      }
    }
    res = *fBufferPtr++;
    return true;
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
  for (int i=0; i<10; i++) {
    auto reader = FileReader("/tmp/shop_with_ids.pb");
    ubyte res;
    auto b = reader.read(res);
    while (b) {
      ++count;
      b = reader.read(res);
    }
  }
  return count;
}

int main(string[] args) {
  auto sw = StopWatch(AutoStart.no);
  sw.start();
  auto count = readBytes();
  sw.stop();
  writeln("<tr><td>d2-3</td><td>", count, "</td><td>", sw.peek().msecs, "</td><td>using std.c.stdio.fread with buffering (result is false for eof and returnvalue is an out-param).</td></tr>");
  return 0;
}
