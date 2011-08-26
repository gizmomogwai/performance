import java.io.RandomAccessFile;
import java.nio.BufferUnderflowException;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileChannel.MapMode;

public class ReadBytes3 {

  static class MemoryMappedFileReader {
    private FileChannel fc;
    private MappedByteBuffer fBuffer;

    public MemoryMappedFileReader(String name) throws Exception {
      fc = new RandomAccessFile(name, "r").getChannel();
      fBuffer = fc.map(MapMode.READ_ONLY, 0, fc.size());
    }

    int read() throws Exception {
      return fBuffer.get();
    }
  }

  private static int readBytes() throws Exception {
    int count = 0;
    for (int i = 0; i < 10; i++) {
      MemoryMappedFileReader in = new MemoryMappedFileReader("/tmp/shop_with_ids.pb");
      in.read();
      try {
        while (true) {
          ++count;
          in.read();
        }
      } catch (BufferUnderflowException e) {

      }
    }
    return count;
  }

  public static void main(String[] args) throws Exception {
    long start = System.currentTimeMillis();
    int count = readBytes();
    long end = System.currentTimeMillis();
    System.out.println("Time for " + count + " bytes: " + (end - start));
  }

}
