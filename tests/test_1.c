#include <stdio.h>
#include <e97.h>
#include <stdint.h>
#include <stdbool.h>

static uint8_t test(const uint8_t *a, const uint8_t *b, const uint8_t *c, const uint8_t *d)
{
   return (*a | *b) & ((!*a) | *c) & ((!*b) | (!*c)) & ((!*a) | (!*c) | *d);
}

int main(int argc, char **argv)
{
    uint8_t a = false,
            b = false,
            c = false,
            d = false;

    bool result = func(&a, &b, &c, &d) == test(&a, &b, &c, &d);


    a = false;
    b = false;
    c = false;
    d = true;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = false;
    b = false;
    c = true;
    d = false;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = false;
    b = false;
    c = true;
    d = true;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = false;
    b = true;
    c = false;
    d = false;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = false;
    b = true;
    c = false;
    d = true;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = false;
    b = true;
    c = true;
    d = false;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = false;
    b = true;
    c = true;
    d = true;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = true;
    b = false;
    c = false;
    d = false;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = true;
    b = false;
    c = false;
    d = true;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = true;
    b = false;
    c = true;
    d = false;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = true;
    b = false;
    c = true;
    d = true;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = true;
    b = true;
    c = false;
    d = false;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = true;
    b = true;
    c = false;
    d = true;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = true;
    b = true;
    c = true;
    d = false;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    a = true;
    b = true;
    c = true;
    d = true;
    result = result && (func(&a, &b, &c, &d) == test(&a, &b, &c, &d));

    return !result;
}
