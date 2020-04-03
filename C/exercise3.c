/* 
   DOMACI UKOL 1

   studenti ZP2: za ukol je mozne ziskat 15 bodu. Ukol je nutne odevzdat do
   5. dubna 2020 (vcetne).

   
   studenti YUP2: za ukol je mozne ziskat 15 bodu. Ukol je nutne odevzdat do
   20. srpna 2020 (vcetne).

   Ukol odevzdavejte emailem (osicka@acm.org) s hlavickou ZP2 - domaci ukol 1,
   vyreseny ukol prilozte jako prilohu mailu, do textu mailu napiste sve jmeno.

   --------
  | ZADANI |
   --------
   
   Implementuje funkci 

   char **string_split (char *text, char delimiter, int *size)

   Tato funkce rozdeli vstupni retezec text na casti oddelene znakem
   delimiter. Napriklad retezec

   "ahoj svete" 
   
   rozdeli na dva retezce 
   
   "ahoj" a "svete".

   Funkce vrati pole takto vzniklych NOVE ALOKOVANYCH retezcu a na adresu
   size zapise jejich pocet. Tedy v pripade

   int length = 0;
   char **split = string_split("ahoj svete", ' ', &length);

   funkce ulozi do promenne length hodnotu 2, dale pak
   
   split[0] bude obsahovat retezec "ahoj"
   split[1] bude obsahovat retezec "svete"

   pricemz split[0] a split[1] adresy retezcu, ktere 
   byly alokovany mallocem a jejich obsah tam byl zkopirovan z 
   retezce "ahoj svete".

   Ve funkci je tedy potreba pracovat s dvourozmernym polem alokovanym
   na heapu, podrobnosti k tomuto je nutno nastudovat napriklad
   z tohoto zdroje:
   
   http://jazykc.inf.upol.cz/dynamicka-vicerozmerna-pole/index.htm

   ------------------
  | OKRAJOVE CHOVANI |
   ------------------

   1) pokud je text prazdny retezec, funkce vrati jednoprvkove pole,
      jehoz prvnim prvkem bude prazdny retezec

      Priklad:
      "" -> {""}

   2) pokud je delimiter na zacatku retezce, je prvnim prvkem vraceneho
      pole prazdny retezec.

      Priklad (delimiter a)
      "axxx" -> {"", "xxx"}

   3) pokud je delimiter na konci retezce, je poslednim prvkem vraceneho
      pole prazdny retezec.
      
      Priklad (delimiter a)
      "xxxa" -> {"xxx", ""}

   4) pokud retezec (nebo jeho cast) obsahuje dva delimitery za sebou,
      vede to k pridani prazdneho retezce na prislusne misto ve 
      vyslednem poli.

      Priklad (delimiter a)
      "xxaaaxx" -> {"xx", "", "", "xx"}

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
