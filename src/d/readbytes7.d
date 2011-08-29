import std.c.stdio;
import std.stdio;
import std.datetime;
import std.stdio;
import std.stream;
import std.c.stdio;
import core.memory;
import std.c.linux.linux;

struct FileReader {

  private FILE* fFile;
  private static const BUFFER_SIZE = 1024;
  private ubyte fBuffer[BUFFER_SIZE];
  private ubyte* fBufferPtr;
  private ubyte* fBufferEnd;
  private void* fLibcHandle;
  extern(C) int function(void*, size_t, size_t, FILE*) fRead;

  public this(string s) {
    fLibcHandle = dlopen("/lib/x86_64-linux-gnu/libc.so.6", RTLD_LAZY);
    assert(fLibcHandle != null);
    fRead = cast(int function(void*, size_t, size_t, FILE*))dlsym(fLibcHandle, "fread");
    assert(fRead);
    fFile = std.c.stdio.fopen("/tmp/shop_with_ids.pb", "rb");
    assert(fFile);
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
    auto l = fRead(fBufferPtr, 1, BUFFER_SIZE, fFile);
    fBufferEnd = fBufferPtr + l;
    return l == 0;
  }
}

size_t readBytes() {
  size_t count = 0;
  for (int i=0; i<10; i++) {
    auto reader = FileReader("ignored");
    ubyte buffer[1];
    ubyte* p = buffer.ptr;
    auto c = reader.read(p);
    while (1 == c) {
      ++count;
      c = reader.read(p);
    }
  }
  return count;
}

int main(string[] args) {
  auto sw = StopWatch(AutoStart.no);
  sw.start();
  auto count = readBytes();
  sw.stop();
  writeln("<tr><td>d2-7</td><td>", count, "</td><td>", sw.peek().msecs, "</td><td>using dlopen(\"libc\") and dlsym(\"fread\").</td></tr>");
  return 0;
}
