#include <iostream>
#include <sstream>
#include <cstdint>

using std::cout, std::string, std::stringstream;

int main(int argc, char** argv) {
  uint32_t n = 100;
  if (n == 0) {
    return 0;
  }
  cout << "0\n";

  stringstream output;
  for (uint32_t i = 1; i < n; i++) {
    output.str("");
    if (i % 3 == 0) {
      output << "Fizz";
    }
    if (i % 5 == 0) {
      output << "Buzz";
    }
    if (output.str().empty()) {
      output << i;
    }
    cout << output.str() << '\n';
  }

  return 0;
}
