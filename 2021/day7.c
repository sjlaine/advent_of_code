#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

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

int compare(const void* a, const void* b) {
  int int_a = * ( (int*) a );
  int int_b = * ( (int*) b );

  if (int_a == int_b) {
    return 0;
  } else if (int_a < int_b) {
    return -1;
  } else {
    return 1;
  }
}

int find_min(int a, int b, int c) {
  if(a < b) {
    if (a < c) {
      return a;
    } else {
      return c;
    }
  } else {
    if(b < c) {
      return b;
    } else {
      return c;
    }
  }
}

int calculate_fuel_pt1(int * arr, int val, int length) {
  int fuel_total = 0;

  for(int i = 0; i < length; i++) {
    fuel_total += abs(arr[i] - val);
  }

  return fuel_total;
}

int calculate_fuel_pt2(int * arr, int val, int length) {
  int fuel_total = 0;

  for(int i = 0; i < length; i++) {
    int steps = abs(arr[i] - val);
    int cost = 1;

    while(steps > 0) {
      fuel_total += cost;
      cost++;
      steps--;
    }
  }

  return fuel_total;
}

int calculate_average(int * arr, int length) {
  int sum = 0;

  for(int i = 0; i < length; i++) {
    sum += arr[i];
  }

  return floor(sum / length);
}

int main() {
  FILE *fptr = fopen("day7_input.txt", "r");
  char * line = NULL;
  size_t len = 0;

  getline(&line, &len, fptr);

  int current_idx, prev, crab_count;
  current_idx = prev = crab_count = 0;

  int crabs[strlen(line)];

  while(line[current_idx] != '\0') {
    if((line[current_idx] == ',') || (line[current_idx] == '\n')) {
      // push last num into arr
      int pos = atoi(substr(prev, current_idx - prev, line));
      crabs[crab_count] = pos;

      crab_count++;

      current_idx++;
      prev = current_idx;
    } else {
      current_idx++;
    }
  }

  int sorted_crabs[crab_count];

  qsort(crabs, crab_count, sizeof(int), compare);

  // Part 1
  int median = floor(crab_count / 2);

  int f1 = calculate_fuel_pt1(crabs, crabs[median], crab_count);
  int f2 = calculate_fuel_pt1(crabs, crabs[median + 1], crab_count);
  int f3 = calculate_fuel_pt1(crabs, crabs[median - 1], crab_count);

  printf("fuel min part 1: %d\n", find_min(f1, f2, f3));

  // Part 2
  int average_pos = calculate_average(crabs, crab_count);

  int v1 = calculate_fuel_pt2(crabs, average_pos, crab_count);
  int v2 = calculate_fuel_pt2(crabs, average_pos + 1, crab_count);
  int v3 = calculate_fuel_pt2(crabs, average_pos - 1, crab_count);

  printf("fuel part 2: %d\n", find_min(v1, v2, v3));

  return 0;
}
