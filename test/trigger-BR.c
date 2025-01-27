/* Copyright © 2022 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

//DMESG traps: trigger-BR[21058] trap bounds ip:565911a0 sp:ff95ecc4 error:0 in trigger-BR[56591000+1000]

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
