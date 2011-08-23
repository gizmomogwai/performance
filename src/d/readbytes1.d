import std.c.stdio;
import std.stdio;
import std.datetime;
import std.stdio;
import std.stream;
import std.c.stdio;
import core.memory;

size_t readBytes() {
  size_t count = 0;
  for (int i=0; i<10; i++) {
    scope reader = new BufferedFile("/tmp/shop_with_ids.pb");
    ubyte buffer[1];
    scope c = reader.read(buffer);
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
  writeln("Time for ", count, " bytes: ", sw.peek().msecs);
  return 0;
}
