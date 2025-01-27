# Copyright © 2025 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

CC = gcc
CFLAGS = -g
CFLAGS += -Wall

c-files = $(wildcard *.c)
x-files = $(c-files:.c=)

.PHONY: all
all: $(x-files)

%: %.c
	$(CC) $(CFLAGS) $(filter-out //CFLAGS, $(shell grep ^//CFLAGS $(<))) $(<) -o $(@)

.PHONY: clean
clean:
	rm -f $(x-files)

# vim:ts=4 sts=4 sw=4 noet
