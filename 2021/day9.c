#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char * substr(int start, int length, char * str) {
  char * newstr = malloc(sizeof(char) * (length + 1));

  strncpy(newstr, str + start, length);
  newstr[length] = '\0';

  return newstr;
}

int main() {
  FILE *fptr = fopen("day9_input.txt", "r");
  char * line = NULL;
  size_t len = 0;
  ssize_t read;

  int map[100][100];
  int linenum, low_pts, total_risk;
  linenum = low_pts = total_risk = 0;

  while((read = getline(&line, &len, fptr)) != -1) {
    for(int i = 0; line[i + 1] != '\0'; i++) {
      int height = atoi(substr(i, 1, line));
      map[linenum][i] = height;
    }

    linenum++;
  }

  for(int i = 0; i < 100; i++) {
    for(int j = 0; j < 100; j++) {
      int num = map[i][j];

      // check tl, top, tr, l, r, bl, b, br
      // tl = i-1, j-1
      if(i > 0 && j > 0 && map[i - 1][j - 1] <= num) {
        continue;
      }
      // top = i-1, j
      if(i > 0 && map[i - 1][j] <= num) {
        continue;
      }
      // tr = i-1, j+l
      if(i > 0 && j < 99 && map[i - 1][j + 1] <= num) {
        continue;
      }
      // l = i, j-1
      if(j > 0 && map[i][j - 1] <= num) {
        continue;
      }
      // r = i, j+1
      if(j < 99 && map[i][j + 1] <= num) {
        continue;
      }
      // bl = i+1,j-1
      if(i < 99 && j > 0 && map[i + 1][j - 1] <= num) {
        continue;
      }
      // b = i+1, j
      if(i < 99 && map[i + 1][j] <= num) {
        continue;
      }
      // br = i+1, j+1
      if(i < 99 && j < 99 && map[i + 1][j + 1] <= num) {
        continue;
      }

      printf("found low point: %d\n", map[i][j]);
      low_pts += 1;
      total_risk += (map[i][j] + 1);
    }
  }

  printf("low points: %d\ntotal risk: %d\n", low_pts, total_risk);

  return 0;
}
