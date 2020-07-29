#include <stdio.h>
#include <e97.h>
#include <stdint.h>
#include <stdbool.h>

int main(int argc, char **argv)
{
    uint8_t result = 0;

    uint8_t abcd = build_arg(0, 1, 0, 1);

    func(abcd, &result);

    printf("RESULT: %u\n", result);

    return result;
}
