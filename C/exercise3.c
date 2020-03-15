/* 
   Soubor s testy k prvni domaci uloze ze ZP2 a YUP2
*/

void _print_splits (char **splits, int l) {

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

  printf("\nTEST 4 - vice delimiteru za sebou \n");
  printf(" Ma byt: {\"xx\", \"\", \"\", \"xx\"} \nDostanu: ");
  _test_and_report("xxaaaxx", 'a');
  
  return 0;
}
