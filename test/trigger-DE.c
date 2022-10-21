/* Copyright © 2022 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

int main(int argc, char **argv)
{
    __asm__(
        "xor %%eax, %%eax\n"
        "div %%eax\n"
        : : : "eax"
    );
}

/* vim:set ts=4 sts=4 sw=4 et:*/
