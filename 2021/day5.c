#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char * substr(int start, int length, char * str) {
  char * newstr = malloc(sizeof(char) * (length + 1));

  strncpy(newstr, str + start, length);
  newstr[length] = '\0';

  return newstr;
}

void print_field(int field[1000][1000]) {
  for(int i = 0; i < 1000; i++) {
    for(int j = 0; j < 1000; j++) {
      printf("%d ", field[i][j]);
    }
    printf("\n");
  }
}

int find_idx(char needle, char * haystack) {
  int i;

  for(i = 0; haystack[i] != '\0'; i += 1) {
    if (haystack[i] == needle) {
      return i;
    }
  }

  return -1;
}

void mark_vertical(int field[1000][1000], int y1, int y2, int x) {
  for(int i = y1; i <= y2; i++) {
    field[i][x] += 1;
  }
}

void mark_horizontal(int field[1000][1000], int x1, int x2, int y) {
  for(int i = x1; i <= x2; i++) {
    field[y][i] += 1;
  }
}

void mark_ur_diagonal(int field[1000][1000], int x1, int x2, int y1, int y2) {
  // x is incrementing, y is decrementing
  int y = y2;

  for(int i = x1; i <= x2; i++) {
    field[y][i] += 1;
    y--;

    if (y < y1) {
      break;
    }
  }
}

void mark_dr_diagonal(int field[1000][1000], int x1, int x2, int y1, int y2) {
  // x is incrementing, y is incrementing
  int x = x1;

  for(int i = y1; i <= y2; i++) {
    field[i][x] += 1;
    x++;

    if (x > x2) {
      break;
    }
  }
}

int main() {
  FILE *fptr = fopen("day5_input.txt", "r");
  char * line = NULL;
  size_t len = 0;
  ssize_t read;
  int field[1000][1000] = { 0 };

  while ((read = getline(&line, &len, fptr)) != -1) {
    // split on arrow
    // split on commas
    // throw away if x1 != x2 and y1 != y2
    int x1, y1, x2, y2;
    int arrowidx = find_idx('-', line);

    char * set1 = substr(0, arrowidx - 1, line);
    char * set2 = substr(arrowidx + 3, strlen(line) - (arrowidx + 2), line);

    int comma1 = find_idx(',', set1);
    x1 = atoi(substr(0, comma1, set1));
    y1 = atoi(substr(comma1 + 1, strlen(set1) - (comma1), set1));

    int comma2 = find_idx(',', set2);
    x2 = atoi(substr(0, comma2, set2));
    y2 = atoi(substr(comma2 + 1, strlen(set2) - (comma2), set2));

    if(x1 == x2) {
      int smally, bigy;

      if(y1 < y2) {
        smally = y1;
        bigy = y2;
      } else {
        smally = y2;
        bigy = y1;
      }

      mark_vertical(field, smally, bigy, x1);
    } else if(y1 == y2) {
      int smallx, bigx;

      if(x1 < x2) {
        smallx = x1;
        bigx = x2;
      } else {
        smallx = x2;
        bigx = x1;
      }

      mark_horizontal(field, smallx, bigx, y1);
    } else {
      int smallx, bigx, smally, bigy;

      if(x1 < x2) {
        smallx = x1;
        bigx = x2;
      } else {
        smallx = x2;
        bigx = x1;
      }

      if(y1 < y2) {
        smally = y1;
        bigy = y2;
      } else {
        smally = y2;
        bigy = y1;
      }

      // ur diag: x inc, y dec
      // dr diag: x inc, y inc

      // if x1 > x2, det. direction from y1 < y2 else dir y2 < y1
      if(x1 < x2) {
        if(y1 < y2) {
          // up right
          mark_dr_diagonal(field, smallx, bigx, smally, bigy);
        } else {
          // down right
          mark_ur_diagonal(field, smallx, bigx, smally, bigy);
        }
      } else {
        if(y2 < y1) {
          // down right
          mark_dr_diagonal(field, smallx, bigx, smally, bigy);
        } else {
          // up right
          mark_ur_diagonal(field, smallx, bigx, smally, bigy);
        }
      }
    }
  }

  int count = 0;

  for(int i = 0; i < 1000; i++) {
    for(int j = 0; j < 1000; j++) {
      if(field[i][j] > 1) {
        count += 1;
      }
    }
  }

  printf("danger points: %d\n", count);

  return 0;
}
