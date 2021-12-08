#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

char * substr(int start, int length, char * str) {
  char * newstr = malloc(sizeof(char) * (length + 1));

  strncpy(newstr, str + start, length);
  newstr[length] = '\0';

  return newstr;
}

void mark_board(int board[5][5], int call) {
  for(int i = 0; i < 5; i++) {
    for(int j = 0; j < 5; j++) {
      if(board[i][j] == call) {
        board[i][j] = 100;
      }
    }
  }
}

int sum_board(int board[5][5]) {
  int sum = 0;

  for(int i = 0; i < 5; i++) {
    for(int j = 0; j < 5; j++) {
      if(board[i][j] != 100) {
        sum += board[i][j];
      }
    }
  }

  return sum;
}

bool check_row(int row[5]) {
  for(int i = 0; i < 5; i++) {
    if(row[i] != 100) {
      return false;
    }
  }

  return true;
}

bool check_col(int board[5][5], int col_idx) {
  for(int i = 0; i < 5; i++) {
    if(board[i][col_idx] != 100) {
      return false;
    }
  }

  return true;
}

bool check_win(int board[5][5]) {
  for(int i = 0; i < 5; i++) {
    if (check_row(board[i]) || check_col(board, i)) {
      return true;
    }
  }

  return false;
}

int add_row(char * haystack, int arr[100][5][5], int grid_idx, int row_idx) {
  int i, start, idx;
  char * newstr = malloc(sizeof(char) * (3));
  start = idx = 0;

  for(i = 0; haystack[i] != '\0'; i += 1) {
    if (haystack[i] == ' ' && haystack[i - 1] != ' ') {
      arr[grid_idx][row_idx][idx] = atoi(strncpy(newstr, haystack + start, i));

      start = start + i + 1;
      idx++;
    } else {
      i++;
    }
  }

  return 0;
}

int main() {
  FILE *fptr = fopen("day4_input.txt", "r");
  char * line = NULL;
  size_t len = 0;
  ssize_t read;
  int num_loops = 0;
  // 100 boards, 5x5
  int boards[100][5][5];
  int board_count = -1;
  int rows = 0;
  char **call_nums;
  int call_idx, place;
  call_idx = place = 0;

  while ((read = getline(&line, &len, fptr)) != -1) {
    // fill in call_nums arr
    if(num_loops == 0) {
      call_nums = malloc(strlen(line) * sizeof(char*));

      while(line[place] != '\0') {
        if(line[place + 1] == ',' || line[place + 1] == '\n') {
          char * newstr = malloc(sizeof(char) * (2));

          call_nums[call_idx] = malloc((2) * sizeof(char));
          call_nums[call_idx] = strncpy(newstr, line + place, 1);
          newstr[1] = '\0';

          place += 2;
          call_idx++;
        } else if(line[place + 2] == ',' || line[place + 2] == '\n') {
          char * newstr = substr(place, 2, line);

          call_nums[call_idx] = malloc((3) * sizeof(char));
          call_nums[call_idx] = newstr;

          place += 3;
          call_idx++;
        }
      }

    } else {
      // keep track of bingo boards
      // next board if empty line -> if loops % 6 == 2, new board

      // skip if empty line
      if((num_loops + 1) % 6 == 2) {
        board_count++; // move on to new board
        rows = 0; // start rows at zero
      } else {
        int i, start, col;
        char * newstr = malloc(sizeof(char) * (3));
        start = col = 0;

        for(i = 0; line[i] != '\0'; i += 1) {
          if ((line[i + 1] == ' ' && line[i] != ' ') || line[i + 1] == '\0') {
            int num = atoi(strncpy(newstr, line + start, i + 1));

            boards[board_count][rows][col] = num;

            start = i + 2;
            col++;
          }
        }

        rows++;
      }
    }

    num_loops++;
  }

  for(int i = 0; i < call_idx; i++) {
    for(int j = 0; j < board_count; j++) {
      mark_board(boards[j], atoi(call_nums[i]));

      if(boards[j][0][0] != 200 && check_win(boards[j])) {
        int score = sum_board(boards[j]) * atoi(call_nums[i]);
        boards[j][0][0] = 200;

        printf("found a winner!, score: %d\n", score);
      }
    }
  }

  return 0;
}
