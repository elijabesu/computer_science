 #include <stdio.h>

 int compute(char src[], char result[], int n){
        int src_length = 0, space = 0, i, j, k;

        // length of the original array
        while(src[src_length])
            src_length++;

        // space = index of the space
        while(src[space] != ' ')
            space++;

        // split into two arrays; 0 in ASCII equals to 48
        i = space - 1;
        j = src_length - space;
        int number1[i], number2[j];
        for(i = 0; i < space; i++) // i will be the length of the first array
            number1[i] = src[i] - 48;
        for(k = space + 1, j = 0; k < src_length; k++, j++) // j will be the length of the first array
            number2[j] = src[k] - 48;

        // turn the arrays around so I could start adding them with the index 0
        int x, y;
        int reversed1[i], reversed2[j];
        for (x = i - 1, y = 0; x >= 0; x--, y++)
            reversed1[y] = number1[x];
        for (x = j - 1, y = 0; x >= 0; x--, y++)
            reversed2[y] = number2[x];

        // fill up the arrays with 0 so they're the equal length
        while(i < j)
        {
            reversed1[i] = 0;
            i++;
        }
        while(i > j)
        {
            reversed2[j] = 0;
            j++;
        }

        // adding
        int temp_number, extra = 0;
        int temp_array[i];
        for(k = 0; k < i; k++)
        {
            temp_number = reversed1[k] + reversed2[k];
            if(extra != 0)
            {
                temp_number += extra;
                extra = 0;
            }
            if(temp_number <= 9)
            {
                temp_array[k] = temp_number;
            } 
            else 
            {
                temp_array[k] = temp_number % 10;
                extra = temp_number / 10;
            }
        }
        if(extra != 0)
        {
            y = k + 1;
            int new_array[y];
            for(x = 0; x < y; x++)
                new_array[x] = temp_array[x];
            new_array[x-1] = extra;
            int z;
            for(z = x - 1, y = 0; z >= 0; z--, y++)
                result[y] = new_array[z] + 48;
        } else {
            for(x = k - 1, y = 0; x >= 0; x--, y++)
                result[y] = temp_array[x] + 48;
        }
        if(y >= n)
        { // = has to be there because d is bigger by 1 because of d++ before
            return 0;
        } 
        else 
        {
            result[y] = 0;
            return 1;
        }
 }

 int main() {

   /* PRIKLADY POUZITI FUNKCE compute */

   char r[5];
   int v;

   /* nasledujici vede k vypsani: 30 */

   v = compute("10 20", r, 5);
   if (v) {
     printf("%s\n", r);
   } else {
     printf("vysledek je moc velky\n");
   }


   /* nasledujici vede k vypsani: 1098 */
   v = compute("99 999", r, 5);
   if (v) {
     printf("%s\n", r);
   } else {
     printf("vysledek je moc velky\n");
   }

   /* vede k vypsani: 2000 */
   v = compute("1000 1000", r, 5);
   if (v) {
     printf("%s\n", r);
   } else {
     printf("vysledek je moc velky\n");
   }


   /* nasledujici vede k vypsani: vysledek je moc velky   */
   v = compute("1234567891011134 1201341341", r, 5);
   if (v) {
     printf("%s\n", r);
   } else {
     printf("vysledek je moc velky\n");
   }


   /* vede k vypsani: vysledek je moc velky */
   v = compute("9000 1000", r, 5);
   if (v) {
     printf("%s\n", r);
   } else {
     printf("vysledek je moc velky\n");
   }


   return 0;
 }
