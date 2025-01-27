/* Copyright © 2025 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

//CFLAGS -m64

//DMESG traps: trigger-SS[21331] trap stack segment ip:560c8ecd713e sp:1111111111111111 error:0 in trigger-SS[560c8ecd7000+1000]

int main(int argc, char **argv)
{
    __asm__ volatile (
        "mov $0x1111111111111111, %rsp\n"
        "push %rsp\n"
    );
}

/* vim:set ts=4 sts=4 sw=4 et:*/
