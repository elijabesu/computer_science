#include <stdio.h>

int delete_missing(char src[], char words[])
{
    int src_length = 0, words_length = 0, i, j, src_words;

    if(src[0] == 0)
    {
        return 0;
    }
    
    // length of src[]
    while(src[src_length])
        src_length++;
    // length of words[]
    while(words[words_length])
        words_length++;

    // make an array that stores space indexes
    int src_spaces[src_length];
    for(i = 0, j = 0; i < src_length; i++)
    {
        if (src[i] == ' ')
        {
            src_spaces[j] = i;
            j++;
        }
    }
    src_spaces[j] = src_length; // == src_end_index
    src_words = ++j;

    int current_space, previous_space = 0, current_word_length, space_index, deleted = src_words, search_index = 0, temp_index = 0;
    char temp_src[src_length], temp_word[src_length];

    for(space_index = 0; space_index < src_words; space_index++)
    {
        if(space_index > 0)
            previous_space = src_spaces[space_index - 1];
        current_space = src_spaces[space_index]; // -1 = current_word_end
        if(space_index > 0)
            ++previous_space; // = current_word_start
        current_word_length = current_space - previous_space;

        for(i = previous_space, j = 0; i < current_space; i++, j++)
            temp_word[j] = src[i];
        temp_word[j] = 0;

        // finding words in words[]
        for (j = 0; j < words_length; j++)
        {
            if(words[j] == temp_word[search_index])
            {
                search_index++;
                if(search_index == current_word_length)
                {
                    for(i = previous_space, temp_index; i < current_space; i++, temp_index++)
                        temp_src[temp_index] = src[i];
                    temp_src[temp_index] = ' ';
                    temp_src[++temp_index] = 0;
                    deleted--;
                }
            }
            else
            {
                j -= search_index;
                search_index = 0;
            }
        }
    }

    // delete the last space
    if(temp_src[temp_index - 1] == ' ')
        temp_src[--temp_index] = 0;
    // delete src[]
    for(i = 0; i < src_length; i++)
        src[i] = 0;
    // put temp_src[] into src[]
    for(i = 0; i < temp_index; i++)
        src[i] = temp_src[i];

    return deleted;
}

int main()
{
    char s[] = "aa bb cc nejaka slova uprostred dd";
    char w[] = "bb cc dd ahoj priklad slov";

    int pocet = delete_missing(s, w);

    printf("smazano: %i\nnovy retez: %s", pocet, s);

    /*
        predchozi printf vytiskne:

        smazano: 4
        novy retez: bb cc dd
    */

    return 0;
}
