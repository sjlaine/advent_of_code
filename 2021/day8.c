#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char * substr(int start, int length, char * str) {
  char * newstr = malloc(sizeof(char) * (length + 1));

  strncpy(newstr, str + start, length);
  newstr[length] = '\0';

  return newstr;
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

char * strdiff(str1, str2, length) {
  char * diff = malloc(sizeof(char*) * (length + 1));

  for(int i = 0; i < strlen(str1); i++) {
    int found = 0;

    for(int j = 0; j < strlen(str2), j++) {
      if(str2[j] == str1[i]) {
        found = 1;
      }
    }

    if(found == 0) {
      strncat(diff, str1[i], 1);
    }
  }
}

int main() {
  // Part 1
  // only count after the "|"
  // count segments with length 2, 3, 4, 7
  FILE *fptr = fopen("day8_input.txt", "r");
  char * line = NULL;
  size_t len = 0;
  ssize_t read;

  int segment_count = 0;
  int segment_counts[10] = { 0 };
  char ** segments = malloc(sizeof(char*) * 70);

  while((read = getline(&line, &len, fptr)) != -1) {
    // Part 2:
    int idx, start;
    idx = start = 0;
    // fill in array of segments
    while(line[idx] != '|') {
      if(line[idx] == ' ' || line[idx] == '\n') {
        int length = idx - start;
        char * str = substr(start, length, line);

        segments[length] = malloc(sizeof(char) * (length + 1));
        segments[length] = str;

        start = idx + 1;
      }

      idx++;
    }

    // Part 1:
    start = find_idx('|', line) + 2;
    idx = start;

    while(line[idx] != '\0') {
      if(line[idx] == ' ' || line[idx] == '\n') {
        int length = idx - start;

        segment_counts[length] += 1;

        start = idx + 1;
      }

      idx++;
    }

    break;
  }

  // Part 1:
  int sum = 0;

  for(int i = 0; i < 10; i++) {
    if(i == 2 || i == 3 || i == 4 || i == 7) {
      sum += segment_counts[i];
    }
  }

  printf("segment_count: %d\n", sum);

  // Part 2:
  for(int i = 2; i < 8; i++) {
    printf("segment len %d: %s\n", i, segments[i]);
  }

  char * topright,
         bottomright,
         middle,
         top,
         bottom,
         topleft,
         bottomleft;

  topright = segments[2];
  bottomright = segments[2];
  top = strdiff(segments[3], segments[2], 1);

  return 0;
}
