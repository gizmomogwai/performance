// version by ratchet freak
import std.c.stdio;
import std.stdio;
import std.datetime;
import std.stdio;
import std.c.stdio;
import core.memory;
import std.mmfile;

struct FileReader {

  private File fFile;
  private enum BUFFER_SIZE = 1024;//why not enum?
  private ubyte[BUFFER_SIZE] fBuffer=void;//avoid (costly) initialization to 0
  private ubyte[] buff;

  public this(string fn) {
    fFile = File("/tmp/shop_with_ids.pb", "rb");
  }

  public int read(out ubyte targetBuffer) {
    auto finished = buff.length == 0;
    if (finished) {
      finished = fillBuffer();
      if (finished) {
        return 0;
      }
    }
    targetBuffer = buff[0];
    buff = buff[1..$];
    return 1;
  }

  private bool fillBuffer() {
    if(!fFile.isOpen())return false;
    buff = fFile.rawRead(fBuffer);
    return buff.length == 0;
  }
}

size_t readBytes() {
  size_t count = 0;
  for (int i=0; i<10; i++) {
    auto reader = FileReader("/tmp/shop_with_ids.pb");
    ubyte buffer;
    auto c = reader.read(buffer);
    while (1 == c) {
      ++count;
      c = reader.read(buffer);
    }
  }
  return count;
}

int main(string[] args) {
  auto sw = StopWatch(AutoStart.no);
  sw.start();
  auto count = readBytes();
  sw.stop();
  writeln("<tr><td>d2-6</td><td>", count, "</td><td>", sw.peek().msecs, "</td><td>using std.stdio.File with arrayslicing.</td></tr>");
  return 0;
}
