#include <stdio.h>
#include <stdlib.h>

char **string_split (char *text, char delimiter, int *size) {
  int i = 0;

  while(text[i])
  {
    if(text[i] == delimiter)
      (*size)++;
    i++;
  }
  (*size)++;

  char** splits = calloc(*size, sizeof(char*));

  char* text_start;
  char* text_current;
  int word_length;
  int j;

  // middle word(s):
  for(text_current = text, text_start = text, word_length = 0, i = 0; *text_current; text_current++)
  {
    if(*text_current == delimiter)
    {
      splits[i] = malloc(++word_length * sizeof(char)); // could use calloc and skip the following for loop
      for(j = 0; j <= word_length; j++)
      {
        splits[i][j] = 0;
      }

      // copy the word:
      for(j = 0; j < (word_length - 1); j++)
      {
        splits[i][j] = text_start[j];
      }

      // for the next loop:
      i++;
      text_start += word_length;
      word_length = 0;
    }
    else
    {
      word_length++;
    }
  }

  // last word:
  splits[i] = malloc(++word_length * sizeof(char));
  for(j = 0; j <= word_length; j++)
  {
    splits[i][j] = 0;
  }

  // copy the word:
  for(j = 0; j < (word_length - 1); j++)
  {
    splits[i][j] = text_start[j];
  }

  return splits;

}

void _print_splits (char** splits, int l) {

  printf("{");
  for (int i = 0; i < l; i += 1) {
    printf("\"%s\"", splits[i]);
    if(i != l-1)
      printf(", ");
  }
  printf("}\n");
}

void
_test_and_report (char *text, char delim) {

  int length = 0;
  char **result = string_split(text, delim, &length);
  _print_splits(result, length);

  for(int i = 0; i<length; i+=1) {
    free(result[i]);
  }

  free(result);
}

int main () {

  printf("TEST 1\n");
  printf(" Ma byt: {\"zakladni\", \"test\", \"funkcnosti\"}\nDostanu: ");
  _test_and_report("zakladni test funkcnosti", ' ');

  printf("\nTEST 2 - prazdny vstupni retezec\n");
  printf(" Ma byt: {\"\"}\nDostanu: ");
  _test_and_report("", ' ');

  printf("\nTEST 3 - delimiter neni v retezci\n");
  printf(" Ma byt: {\"nerozdeleny text\"}\nDostanu: ");
  _test_and_report("nerozdeleny text", 'k');

  printf("\nTEST 4 - delimiter na konci retezce \n");
  printf(" Ma byt: {\"xxxx\", \"\"} \nDostanu: ");
  _test_and_report("xxxxa", 'a');

  printf("\nTEST 5 - delimiter na zacatku retezce \n");
  printf(" Ma byt: {\"\", \"xxxx\"} \nDostanu: ");
  _test_and_report("axxxx", 'a');

  printf("\nTEST 6 - vice delimiteru za sebou \n");
  printf(" Ma byt: {\"xx\", \"\", \"\", \"xx\"} \nDostanu: ");
  _test_and_report("xxaaaxx", 'a');

  return 0;
}
