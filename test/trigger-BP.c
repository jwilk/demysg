/* Copyright © 2022-2025 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

//DMESG traps: trigger-BP[20546] trap int3 ip:565b0187 sp:ff9b53f8 error:0 in trigger-BP[565b0000+1000]

int main(int argc, char **argv)
{
    __asm__("int3");
}

/* vim:set ts=4 sts=4 sw=4 et:*/
