/* Copyright © 2022 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

#include <stdint.h>

int main(int argc, char **argv)
{
    uint32_t b[2] = {0, 0};
    __asm__(
        "mov $42, %%ebx\n"
        "boundl %%ebx, (%0)\n"
        : : "r"(b) : "ebx"
    );
}

/* vim:set ts=4 sts=4 sw=4 et:*/
