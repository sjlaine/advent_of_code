#include <stdio.h>
#include <string.h>
#include <stdlib.h>

long long int count_fish(long int fish[9]) {
  long long int count = 0;

  for(int i = 0; i < 9; i++) {
    count += fish[i];
  }

  return count;
}

int main() {
  long int fish[9] = { 0 };

  FILE *fptr = fopen("day6_input.txt", "r");
  char * line = NULL;
  size_t len = 0;

  getline(&line, &len, fptr);

  int idx = 0;
  while(line[idx] != '\0') {
    char * genstr = malloc(sizeof(char) * (2));
    strncpy(genstr, line + idx, 1);
    int gen = atoi(genstr);

    fish[gen] += 1;
    idx += 2;
  }

  // every 8 days, every fish has reproduced, so the total of fish is mult by fish total
  int gen_count = 256;

  while(gen_count > 0) {
    // shift everything once
    long int reproducing = fish[0];
    for(int i = 1; i < 9; i++) {
      fish[i - 1] = fish[i];
    }

    fish[6] += reproducing;
    fish[8] = reproducing;

    gen_count--;
  }

  printf("fish count: %lld\n", count_fish(fish));

  return 0;
}
