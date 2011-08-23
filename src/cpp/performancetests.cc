#include <iostream>
#include <fstream>
#include <string>
#include "tests/Repeat.pb.h"
#include <google/protobuf/message.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/io/zero_copy_stream_impl.h>
#include <sys/time.h>
#include <cassert>

using namespace std;

/*
void ListPeople(const tutorial::AddressBook& address_book) {
  for (int i = 0; i < address_book.person_size(); i++) {
    const tutorial::Person& person = address_book.person(i);

    cout << "Person ID: " << person.id() << endl;
    cout << "  Name: " << person.name() << endl;
    if (person.has_email()) {
      cout << "  E-mail address: " << person.email() << endl;
    }

    for (int j = 0; j < person.phone_size(); j++) {
      const tutorial::Person::PhoneNumber& phone_number = person.phone(j);

      switch (phone_number.type()) {
        case tutorial::Person::MOBILE:125
          cout << "  Mobile phone #: ";
          break;
        case tutorial::Person::HOME:
          cout << "  Home phone #: ";
          break;
        case tutorial::Person::WORK:
          cout << "  Work phone #: ";
          break;
      }
      cout << phone_number.number() << endl;
    }
  }
}
*/



void testInput1(const size_t s) {
  fstream input("/tmp/input.data", ios::in | ios::binary);
  char* b = new char[s];
  size_t count = 0;
  while (input.good()) {
    input.read(b, s);
    count += input.gcount();
  }
  std::cout << "read bytes " << count << std::endl;
  delete[] b;
}

void testInput2(const size_t s) {
  FILE* input = fopen("/tmp/input.data", "rb");
  char* b = new char[s];
  size_t count = 0;
  size_t read = fread(b, 1, s, input);
  while (read > 0) {
    count += read;
    read = fread(b, 1, s, input);
  }
  std::cout << "read bytes " << count << std::endl;
  delete[] b;
}


size_t testReadBytes() {
  size_t res = 0;
  for (int i=0; i<10; i++) {
    FileReader r("/tmp/shop_with_ids.pb");
    int read = r.read();
    while (read != -1) {
      ++res;
      read = r.read();
    }
  }
  return res;
}

int main(int argc, char* argv[]) {
  StopWatch sw;
  /*
  sw.start();
  testInput1(1);
  std::cout << "testinput1(1) took " << sw.stop() << "ms" << std::endl;

  sw.start();
  testInput1(256);
  std::cout << "testinput1(256) took " << sw.stop() << "ms" << std::endl;

  sw.start();
  testInput1(1024);
  std::cout << "testinput1(1024) took " << sw.stop() << "ms" << std::endl;

  sw.start();
  testInput2(1);
  std::cout << "testinput2(1) took " << sw.stop() << "ms" << std::endl;

  sw.start();
  testInput2(256);
  std::cout << "testinput2(256) took " << sw.stop() << "ms" << std::endl;

  sw.start();
  testInput2(1024);
  std::cout << "testinput2(1024) took " << sw.stop() << "ms" << std::endl;

*/
  sw.start();
  {
    size_t count = testReadBytes();
    std::cout << "reading " << count << " bytes in " << sw.stop() << "ms" << std::endl;
  }

  GOOGLE_PROTOBUF_VERIFY_VERSION;

  tests::Shop shop;

  size_t count = 0;
  sw.start();
  ::google::protobuf::uint32 varint;
  for (int i=0; i<10; i++) {
  fstream input("/tmp/shop_with_ids.pb", ios::in | ios::binary);
  ::google::protobuf::io::IstreamInputStream zero_copy_input(&input);
  ::google::protobuf::io::CodedInputStream cin(&zero_copy_input);
  bool ok = cin.ReadVarint32(&varint);
  while (ok) {
    ++count;
    ok = cin.ReadVarint32(&varint);
  }
  }
  std::cout << "reading " << count << " varints " << sw.stop() << "ms last value: " << varint << std::endl;
  sw.start();

  for (int i=0; i<10; i++)
  {
    fstream input("/tmp/bigshop.pb", ios::in | ios::binary);
    if (!shop.ParseFromIstream(&input)) {
      cerr << "Failed to parse address book." << endl;
      return -1;
    }
  }
  std::cout << "time needed for read " << sw.stop() << std::endl;
  std::cout << "ids in shop" << shop.id_size() << std::endl;
  std::cout << "products in shop" << shop.product_size() << std::endl;

  sw.start();
  for (int i=0; i<10; i++)
  {
    fstream input("/tmp/shop_with_ids.pb", ios::in | ios::binary);
    if (!shop.ParseFromIstream(&input)) {
      cerr << "Failed to parse address book." << endl;
      return -1;
    }
    assert(shop.id_size() == 3000000);
  }
  std::cout << "shop with ids read " << sw.stop() << std::endl;

  google::protobuf::ShutdownProtobufLibrary();

  return 0;
}
