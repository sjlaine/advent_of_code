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

int main() {
  FILE *fptr = fopen("day2_input.txt", "r");
  char * line = NULL;
  size_t len = 0;
  ssize_t read;

  int horiz = 0;
  int depth = 0;

  while ((read = getline(&line, &len, fptr)) != -1) {
    int space_idx = find_idx(' ', line);
    char direction = * substr(0, 1, line);
    int value = atoi(substr(space_idx + 1, 1, line));

    switch(direction) {
      case 102:
        horiz += value;
        break;
      case 117:
        depth -= value;
        break;
      case 100:
        depth += value;
        break;
      default:
        printf("unrecognized direction!!!\n");
        break;
    }
  }

  printf("horizontal pos: %d, depth: %d\n", horiz, depth);
  printf("product: %d\n", horiz * depth);

  return 0;
}
