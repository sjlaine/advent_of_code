#include <stdio.h>
#include <stdlib.h>

int sum_arr(int nums[3]) {
  int sum = 0;

  for(int i = 0; i < 3; i += 1) {
    sum += nums[i];
  }

  return sum;
}

int main() {
  FILE *fptr = fopen("day1_input.txt", "r");
  char * line = NULL;
  size_t len = 0;
  ssize_t read;
  int num, prev;
  int linenum = 0;
  int part1_count = 0;
  int part2_count = 0;

  int numsA[3];
  int numsB[3];
  int numsC[3];
  int numsD[3];

  prev = -1;

  while ((read = getline(&line, &len, fptr)) != -1) {
    num = atoi(line);

    if (prev != -1) {
      if(num > prev) {
        part1_count += 1;
      }
    }

    // 0 199  A
    // 1 200  A B
    // 2 208  A B C
    // 3 210    B C D mod == 3
    // 4 200  E   C D mod == 0
    // 5 207  E F   D mod == 1
    // 6 240  E F G   mod == 2
    // 7 269    F G H mod == 3
    // 8 260      G H mod == 0
    // 9 263        H mod == 1

    if (linenum == 0) {
      numsA[0] = num;
    }

    if (linenum == 1) {
      numsA[1] = num;
      numsB[0] = num;
    }

    if (linenum == 2) {
      numsA[2] = num;
      numsB[1] = num;
      numsC[0] = num;
    }

    if (linenum > 2) {
      if (linenum % 4 == 0) {
        // push into C, D, A
        numsC[2] = num;
        numsD[1] = num;
        numsA[0] = num;
        // compare C & B
        int sumB = sum_arr(numsB);
        int sumC = sum_arr(numsC);

        if(sumC > sumB) {
          part2_count += 1;
        }
      }

      if (linenum % 4 == 1) {
        // push into D, A, B
        numsD[2] = num;
        numsA[1] = num;
        numsB[0] = num;
        // compare D & C
        int sumC = sum_arr(numsC);
        int sumD = sum_arr(numsD);

        if(sumD > sumC) {
          part2_count += 1;
        }
      }

      if (linenum % 4 == 2) {
        // push into A, B, C
        numsA[2] = num;
        numsB[1] = num;
        numsC[0] = num;
        // compare A & D
        int sumD = sum_arr(numsD);
        int sumA = sum_arr(numsA);

        if(sumA > sumD) {
          part2_count += 1;
        }
      }

      if (linenum % 4 == 3) {
        // push into B, C, D
        numsB[2] = num;
        numsC[1] = num;
        numsD[0] = num;
        // compare B & A
        int sumA = sum_arr(numsA);
        int sumB = sum_arr(numsB);

        if (sumB > sumA) {
          part2_count += 1;
        }
      }
    }


    prev = atoi(line);
    linenum += 1;
  }

  printf("part1_count: %d\n", part1_count);
  printf("part2_count: %d\n", part2_count);
  return 0;
}
