import java.io.FileInputStream;
import java.io.InputStream;

public class ReadBytes2 {

  static class FileReader {
    private InputStream fInput;
    private byte[] fBuffer = new byte[8192];
    private int fPos = 0;
    private int fAvailable = 0;

    public FileReader(InputStream input) throws Exception {
      fInput = input;
    }

    int read(byte[] target) throws Exception {
      if (fPos == fAvailable) {
        fAvailable = fillBuffer();
        if (-1 == fAvailable) {
          return 0;
        }
      }
      target[0] = fBuffer[fPos++];
      return 1;
    }

    private int fillBuffer() throws Exception {
      fPos = 0;
      return fInput.read(fBuffer);
    }
  }
  
  private static int readBytes() throws Exception {
    int count = 0;
    for (int i = 0; i < 10; i++) {
      FileReader in = new FileReader(new FileInputStream("/tmp/shop_with_ids.pb"));
      byte[] buffer = new byte[1];
      int c = in.read(buffer);
      while (c == 1) {
        ++count;
        c = in.read(buffer);
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
