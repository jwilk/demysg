/* Copyright © 2025 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

//DMESG traps: trigger-GP[20551] general protection fault ip:56641186 sp:ffb531b8 error:12a in trigger-GP[56641000+1000]

int main(int argc, char **argv)
{
    __asm__ volatile ("int $37");
}

/* vim:set ts=4 sts=4 sw=4 et:*/
