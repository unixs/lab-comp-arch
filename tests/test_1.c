#include <stdio.h>
#include <e97.h>
#include <stdint.h>
#include <stdbool.h>

int main(int argc, char **argv)
{
    uint8_t a = 1,
            b = 2,
            c = 3,
            d = 4;

    uint8_t result = func(&a, &b, &c, &d);

    printf("RESULT: %u\n", result);

    return result;
}
