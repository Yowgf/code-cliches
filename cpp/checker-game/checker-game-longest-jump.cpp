#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <iterator>
#include <unordered_set>
#include <sstream>
#include <stack>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

using std::cout, std::cerr, std::atoi, std::string, std::ifstream;

using pos = std::pair<int32_t, int32_t>;

struct PosHash {
    size_t operator()(const pos& p) const {
        return std::hash<uint32_t>()(p.first) ^ std::hash<uint32_t>()(p.second);
    }
};

string position_to_string(pos p) {
  return std::to_string(p.first) + "," + std::to_string(p.second);
}

string positions_to_string(std::vector<pos>& poss) {
  std::stringstream ss;
  for (auto p : poss) {
    ss << position_to_string(p) << " ";
  }
  return ss.str();
}

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
  if (p.first == 0) {
    return p;
  }
  return pos(p.first - 1, p.second);
}

pos right(pos p) {
  return pos(p.first + 1, p.second);
}

pos up(pos p) {
  return pos(p.first, p.second + 1);
}

pos down(pos p) {
  if (p.second == 0) {
    return p;
  }
  return pos(p.first, p.second - 1);
}

pos sum_pos(pos p1, pos p2) {
  return pos(p1.first + p2.first, p1.second + p2.second);
}

bool is_valid_pos(Board& board, pos p) {
  return p.first >= 0 && p.first < board.get_board_size()
    && p.second >= 0 && p.second < board.get_board_size();
}

bool is_valid_move(Board& board, uint32_t player, pos orig, pos dest_pos) {
  auto move_vec = pos((dest_pos.first - orig.first) / 2,
                      (dest_pos.second - orig.second) / 2);
  auto middle_pos = sum_pos(orig, move_vec);
  cerr << "Middle pos: " << position_to_string(middle_pos) << "\n";
  if (!is_valid_pos(board, orig) || !is_valid_pos(board, dest_pos)) {
    return false;
  }
  auto middle_player = board.at(middle_pos);
  auto dest_player = board.at(dest_pos);
  return middle_player != 0 && middle_player != player && dest_player == 0;
}

std::vector<pos> find_landing_positions(Board& board, uint32_t player,
                                        const pos& starting_pos) {
  std::vector<pos> positions{left(left(starting_pos)), right(right(starting_pos)),
                             up(up(starting_pos)), down(down(starting_pos))};
  auto cond = [&](pos p) { return !is_valid_move(board, player, starting_pos, p); };
  positions.erase(std::remove_if(positions.begin(), positions.end(), cond),
                  positions.end());
  return positions;
}

std::pair<uint32_t, std::unordered_set<pos, PosHash>>
longest_jump(Board& board, pos from_where) {
  uint32_t record = 0;
  uint32_t cur_player = board.at(from_where);
  // path is used to track which positions have already been parsed.
  std::unordered_set<pos, PosHash> path{from_where};

  std::stack<std::pair<pos, uint32_t>> positions_to_jump_to;
  auto landing_positions = find_landing_positions(board, cur_player, from_where);
  for (auto p : landing_positions) {
    positions_to_jump_to.push(std::make_pair(p, 0));
  }
  while (!positions_to_jump_to.empty()) {
    auto [p, num_jumps] = positions_to_jump_to.top();
    cerr << "In positions_to_jump_to loop. Position: " << p.first << "," << p.second <<
      " Number of jumps: " << num_jumps << "\n";
    positions_to_jump_to.pop();
    if (num_jumps + 1 > record) {
      record = num_jumps + 1;
    }
    landing_positions = find_landing_positions(board, cur_player, p);
    path.insert(p);
    cerr << "Found landing positions: " << positions_to_string(landing_positions) << '\n';
    for (auto p : landing_positions) {
      if (path.find(p) == path.end()) {
        positions_to_jump_to.push(make_pair(p, record));
      }
    }
  }
  return make_pair(record, path);
}

int main(int argc, char** argv) {
  const uint32_t num_args = argc - 1;
  const uint32_t required_num_args = 3;
  if (num_args != required_num_args) {
    cerr << "Usage: ./program <board-file-path> <start-x> <start-y>\n";
    return 1;
  }
  Board board{string(argv[1])};
  auto from_where = pos(std::atoi(argv[2]), std::atoi(argv[3]));
  auto [num_jumps, path] = longest_jump(board, from_where);
  cout << "Longest jump in board\n"
    << board.to_string()
    << "\n"
    << "Is " << num_jumps << "\n"
    ;
  return 0;
}
