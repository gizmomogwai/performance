import java.io.FileOutputStream;

public class CreateDataFiles {
  public static void main(String[] args) throws Exception {
    tests.Repeat.Shop.Builder shopWithIds = tests.Repeat.Shop.newBuilder();
    for (int i = 0; i < 3000000; i++) {
      shopWithIds.addId(i);
    }
    shopWithIds.build().writeTo(new FileOutputStream("/tmp/shop_with_ids.pb"));
  }
}
