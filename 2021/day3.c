#include <stdio.h>
#include <string.h>

int main() {
  FILE *fptr = fopen("day3_input.txt", "r");
  char * line = NULL;
  size_t len = 0;
  ssize_t read;

  int digit_counts[12][2] = { 0 };
  int loop_count = 0;

  while ((read = getline(&line, &len, fptr)) != -1) {
    for(int i = 0; i < 12; i += 1) {
      if(line[i] == '0') {
        digit_counts[i][0] += 1;
      } else {
        digit_counts[i][1] += 1;
      }
    }

    loop_count += 1;
  }

  int gamma_rate_dec = 0;
  int epsilon_rate_dec = 0;
  int digit_in_dec = 1;

  for (int i = 11; i >= 0; i -= 1) {
    if(digit_counts[i][1] > digit_counts[i][0]) {
      gamma_rate_dec += digit_in_dec;
    } else {
      epsilon_rate_dec += digit_in_dec;
    }

    digit_in_dec *= 2;
  }

  printf("gamma_rate: %d, epsilon_rate: %d\n", gamma_rate_dec, epsilon_rate_dec);
  printf("power consumption: %d\n", gamma_rate_dec * epsilon_rate_dec);

  return 0;
}

