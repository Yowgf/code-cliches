import sys
import random

def main():
    board_sidelen = int(sys.argv[1])
    if len(sys.argv) >= 3:
        output_fpath = sys.argv[2]
    else:
        output_fpath = f"board-{board_sidelen}x{board_sidelen}.txt"
    with open(output_fpath, "w") as f:
        for i in range(board_sidelen):
            line = ""
            for j in range(board_sidelen):
                num = random.randint(0, 2)
                if j == board_sidelen - 1:
                    line += str(num)
                else:
                    line += str(num) + " "
            line += "\n"
            f.write(line)

if __name__ == "__main__":
    main()
