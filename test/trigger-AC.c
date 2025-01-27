/* Copyright © 2022-2025 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

//DMESG traps: trigger-AC[17217] trap alignment check ip:565921a0 sp:ff953ce8 error:0 in trigger-AC[56592000+1000]

#include <stdio.h>

int main(int argc, char **argv)
{
    __asm__ volatile (
        "pushf\n"
        "orl $0x40000, (%%esp)\n"
        "popf\n"
        : : : "cc"
    );
    int a[2] = {1, 2};
    return *((int*)(((char *)a + 1)));
}

/* vim:set ts=4 sts=4 sw=4 et:*/
