/* Copyright © 2022 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

int main(int argc, char **argv)
{
    __asm__(
        "mov $-1, %%al\n"
        "mul %%al\n"
        "into\n"
        : : : "ax"
    );
}

/* vim:set ts=4 sts=4 sw=4 et:*/
