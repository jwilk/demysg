/* Copyright © 2022-2025 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

//CFLAGS -m32

//DMESG traps: trigger-OF[17999] trap overflow ip:565ef18b sp:ff81f118 error:0 in trigger-OF[565ef000+1000]

int main(int argc, char **argv)
{
    __asm__ volatile (
        "mov $-1, %%al\n"
        "mul %%al\n"
        "into\n"
        : : : "ax"
    );
}

/* vim:set ts=4 sts=4 sw=4 et:*/
