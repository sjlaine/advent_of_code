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

int find_idx(char needle, char * haystack) {
  int i;

  for(i = 0; haystack[i] != '\0'; i += 1) {
    if (haystack[i] == needle) {
      return i;
    }
  }

  return -1;
}

// bool test_rule(char * rule_set, int idx, char * message) {
//   // rule is either "a" or "b" or we need to jump to two rules

//   // 115: 95 114 | 104 17
//   // test_rule(rules, 95, message) + test_rule(rules, 114, message) ||
// }

bool test_char(char letter_idx, char * str, int rule_idx, char * rule_set[135][2]) {
  if(rule_set[rule_idx][0][0] == '"') {
    if(rule_set[rule_idx][0][1] == str[letter_idx]) {
      return true;
    } else {
      return false;
    }
  }

  // parse conditions 1 & 2
  // split on space, call test_char on both conditions if they exist
  // condition1 = [a, b]
  // condition2 = [c, d]

  char * condition1str = rule_set[rule_idx][0];
  int space_idx = find_idx(' ', condition1str);
  char * condition_1a = substr(0, space_idx + 1, condition1str);
  char * condition_1b = substr(space_idx + 1, strlen(condition1str) - space_idx, condition1str);

  int rule1a = atoi(condition_1a);
  int rule1b = atoi(condition_1b);

  if(rule_set[rule_idx][1] != NULL) {
    char * condition2str = rule_set[rule_idx][0];
    int space_idx = find_idx(' ', condition2str);
    char * condition_2a = substr(0, space_idx + 1, condition2str);
    char * condition_2b = substr(space_idx + 1, strlen(condition2str) - space_idx, condition2str);

    int rule2a = atoi(condition_2a);
    int rule2b = atoi(condition_2b);

    return (test_char(letter_idx, str, rule1a, rule_set) &&
            test_char(letter_idx + 1, str, rule1b, rule_set)) ||
              (test_char(letter_idx, str, rule2a, rule_set) &&
               test_char(letter_idx + 1, str, rule2b, rule_set));
  }

  // (a && b) || (c && d)
  // test_char() && test_char()
  return (test_char(letter_idx, str, rule1a, rule_set) &&
          test_char(letter_idx + 1, str, rule1b, rule_set));

}

int main() {
  FILE *fptr = fopen("day19input.txt", "r");
  char * line = NULL;
  size_t len = 0;
  ssize_t read;

  char * rules[135][2];

  while ((read = getline(&line, &len, fptr)) != -1) {
    if (strlen(line) == 1) {
      break;
    }

    printf("Retrieved line of length %zu:\n", read);
    printf("%s", line);

    int colon_idx = find_idx(':', line);

    char * rule_num = substr(0, colon_idx, line);
    char * rule_body = substr(colon_idx + 2, read - colon_idx, line);

    int pipe_idx = find_idx('|', rule_body);
    int body_len = strlen(rule_body);
    char * condition1;
    char * condition2;

    if (pipe_idx != -1) {
      condition1 = substr(0, pipe_idx - 1, rule_body);
      condition2 = substr(pipe_idx + 2, body_len - pipe_idx, rule_body);
    } else {
      condition1 = rule_body;
      condition2 = NULL;
    }

    printf("condition1: %s, condition2: %s\n", condition1, condition2);

    int rule_idx = atoi(rule_num);
    rules[rule_idx][0] = condition1;
    rules[rule_idx][1] = condition2;
  }

  // for(int i = 0; i < 135; i += 1) {
  //   printf("rule num: %d, rule 1: %s, rule 2: %s\n", i, rules[i][0], rules[i][1]);
  // }

  int count_passing = 0;
  while ((read = getline(&line, &len, fptr)) != -1) {
    printf("next line after empty line: %s", line);
     // test_char(char letter_idx, char * str, int rule_idx, char * rule_set)
    if (test_char(0, line, 0, rules)) {
      count_passing++;
    }

    break;
  }

  printf("count of passing rules: %d", count_passing);

  return 0;
}
