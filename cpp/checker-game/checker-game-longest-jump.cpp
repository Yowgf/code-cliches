#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <iterator>
#include <sstream>
#include <stack>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

using std::cout, std::atoi, std::string, std::ifstream;

using pos = std::pair<uint32_t, uint32_t>;

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

  uint32_t at(pos p) {
    return board[p.first][p.second];
  }

  uint32_t get_board_size() {
    return board_size;
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

pos left(pos p) {
  return pos(p.first - 1, p.second);
}

pos right(pos p) {
  return pos(p.first + 1, p.second);
}

pos up(pos p) {
  return pos(p.first, p.second + 1);
}

pos down(pos p) {
  return pos(p.first, p.second - 1);
}

pos sum_pos(pos p1, pos p2) {
  return pos(p1.first + p2.first, p1.second + p2.second);
}

bool is_valid_pos(Board& board, pos p) {
  return p.first >= 0 && p.first < board.get_board_size()
    && p.second >= 0 && p.second < board.get_board_size();
}

bool is_valid_move(Board& board, uint32_t player, pos orig, pos move_vec) {
  auto dest_pos = sum_pos(orig, sum_pos(move_vec, move_vec));
  auto middle_pos = sum_pos(orig, move_vec);
  if (!is_valid_pos(board, orig) || !is_valid_pos(board, dest_pos)) {
    return false;
  }
  auto middle_player = board.at(middle_pos);
  auto dest_player = board.at(dest_pos);
  return middle_player != 0 && middle_player != player && dest_player == 0;
}

std::vector<pos> find_landing_positions(Board& board, uint32_t player,
                                        const pos& starting_pos) {
  std::vector<pos> positions{left(starting_pos), right(starting_pos),
                             up(starting_pos), down(starting_pos)};
  auto cond = [&](pos p) { return is_valid_move(board, player, starting_pos, p); };
  positions.erase(std::remove_if(positions.begin(), positions.end(), cond),
                  positions.end());
  return positions;
}

uint32_t longest_jump(Board& board, pos from_where) {
  uint32_t record = 0;
  uint32_t cur_player = board.at(from_where);
  std::stack<pos> track;
  auto landing_positions = find_landing_positions(board, cur_player, from_where);
  for (auto p : landing_positions) {
    track.push(p);
  }
  while (!landing_positions.empty()) {}
  return record;
}

int main(int argc, char** argv) {
  const uint32_t num_args = argc - 1;
  const uint32_t required_num_args = 3;
  if (num_args != required_num_args) {
    cout << "Usage: ./program <board-file-path> <start-x> <start-y>\n";
    return 1;
  }
  Board board{string(argv[1])};
  auto from_where = pos(std::atoi(argv[2]), std::atoi(argv[3]));
  cout << "Longest jump in board\n"
    << board.to_string()
    << "\n"
    << "Is " << longest_jump(board, from_where) << "\n"
    ;
  return 0;
}
