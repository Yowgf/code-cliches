#include <cstdint>
#include <fstream>
#include <iostream>
#include <iterator>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

using std::cout, std::atoi, std::string, std::ifstream;

class Board {
private:
  uint32_t board_size;
  std::vector<std::vector<uint32_t>> board;

  void check_and_update_board_size(uint32_t new_size) {
    if (new_size == 0) {
      throw std::runtime_error("Empty board line! (size 0)");
    }
    if (board_size == 0) {
      board_size = new_size;
      return;
    }
    if (new_size != board_size) {
      // Inconsistency. There should only ever be one board size for every
      // program execution.
      throw std::runtime_error("Had board size of " + std::to_string(board_size) +
                               " and was asked to update it to a different value: " +
                               std::to_string(new_size) +
                               ". This is not allowed since the board must be square");
    }
  }

  std::vector<uint32_t> parse_line(string line) {
      std::istringstream line_stream(line);
      auto eos = std::istreambuf_iterator<uint32_t>();
      std::vector<uint32_t> nums;
      std::copy(std::istream_iterator<uint32_t>(line_stream),
                std::istream_iterator<uint32_t>(),
                std::back_inserter(nums));
      check_and_update_board_size(nums.size());
      return nums;
  }

public:
  Board(string board_fpath) {
    // Read first line to decide size of the board.
    ifstream f(board_fpath);
    string line;
    while(std::getline(f, line)) {
      board.push_back(parse_line(line));
    }
  }

  string to_string() {
    std::stringstream ss;
    for (auto board_line : board) {
      for (auto board_pos : board_line) {
        ss << board_pos << ' ';
      }
      ss << '\n';
    }
    return ss.str();
  }
};

uint32_t longest_jump(int board_size) {
  uint32_t record = 0;
  return 0;
}

int main(int argc, char** argv) {
  const uint32_t num_args = argc - 1;
  const uint32_t required_num_args = 1;
  if (num_args != required_num_args) {
    cout << "Usage: ./program <board-file-path>\n";
    return 1;
  }
  Board board{string(argv[1])};
  cout << "Longest jump in board\n"
    << board.to_string()
    << "\n"
    << "Is " << longest_jump(std::atoi(argv[1])) << "\n"
    ;
  return 0;
}
