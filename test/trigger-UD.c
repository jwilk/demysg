/* Copyright © 2022-2025 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

//DMESG traps: trigger-UD[17493] trap invalid opcode ip:56642186 sp:ffcb0668 error:0 in trigger-UD[56642000+1000]

#include <stdio.h>

int main(int argc, char **argv)
{
    __asm__("ud2");
}

/* vim:set ts=4 sts=4 sw=4 et:*/

