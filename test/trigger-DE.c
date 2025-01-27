/* Copyright © 2022 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

//DMESG traps: trigger-DE[17732] trap divide error ip:56561188 sp:fffb94d8 error:0 in trigger-DE[56561000+1000]

int main(int argc, char **argv)
{
    __asm__(
        "xor %%eax, %%eax\n"
        "div %%eax\n"
        : : : "eax"
    );
}

/* vim:set ts=4 sts=4 sw=4 et:*/
