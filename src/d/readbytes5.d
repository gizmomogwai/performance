import std.c.stdio;
import std.stdio;
import std.datetime;
import std.stdio;
import std.stream;
import std.c.stdio;
import core.memory;
import std.mmfile;

struct MemoryMappedFileReader {
  MmFile fFile;
  size_t fLength;
  ubyte* fEnd;
  ubyte* fBuffer;

  public this(string fn) {
    fFile = new MmFile(fn);
    fLength = fFile.length;
    fBuffer = cast(ubyte*)(fFile[].ptr);
    fEnd = fBuffer + fLength;
  }

  public int read() {
    if (fBuffer >= fEnd) {
      return -1;
    }
    return *fBuffer++;
  }
}

size_t readBytes() {
  size_t count = 0;
  version(SUM_UP) {
    size_t sum = 0;
  }
  for (int i=0; i<10; i++) {
    auto reader = MemoryMappedFileReader("/tmp/shop_with_ids.pb");
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
  writeln("<tr><td>d2-", __VENDOR__, "-5(", dsc, ")</td><td>", count, "</td><td>", sw.peek().msecs, "</td><td>using mmfile and a direct pointer to the slice.</td></tr>");
  return 0;
}
