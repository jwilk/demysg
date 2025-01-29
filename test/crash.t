#!/usr/bin/env python3
# encoding=UTF-8

# Copyright © 2025 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

import argparse
import glob
import os.path
import re
import signal
import subprocess
import sys
import textwrap

lambda x, /: x  # Python >= 3.8 is required

for stdio in {sys.stdout, sys.stderr}:
    stdio.reconfigure(line_buffering=True)

here = os.path.dirname(__file__)
here = os.path.relpath(here or '.')

def get_all_paths():
    for path in glob.iglob(f'{here}/trigger-*.c'):
        path = path[:-2]
        if path[:2] == './':
            path = path[2:]
        yield path

timeout = 2 # seconds

def SIGALRM_handler(signo, frame):
    raise TimeoutError

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('paths', metavar='EXECUTABLE', nargs='*')
    opts = ap.parse_args()
    with open('/proc/sys/kernel/printk_ratelimit', 'rt', encoding='ASCII') as fp:
        ratelimit = int(fp.read())
    if ratelimit > 0:
        prog = ap.prog
        msg = textwrap.dedent(
            '''
            WARNING: Kernel message rate limiting is enabled.
            This may interfere with crash testing.
            To disable rate limiting, run "sysctl kernel.printk_ratelimit=0" as root.
            '''
        ).lstrip()
        for line in msg.splitlines():
            print(f'demysg/test/{prog}: {line}', file=sys.stderr)
    paths = opts.paths or list(get_all_paths())
    signal.signal(signal.SIGALRM, SIGALRM_handler)
    dmesg_proc = subprocess.Popen([
            'sudo', '-S',
            # TODO: use sudo only when requested by user
            'dmesg',
            '--since=-2s',
            # TODO: use --since only if available
            # FIXME? Why doesn't "-1" do the trick here?
            '--time-format=iso',
            '--follow'
        ],
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        encoding='ASCII', errors='replace',
    )
    def kill_dmesg():
        # We'd normally just call dmesg_proc.terminate(),
        # but on Ubuntu 20.04:
        # - you can't kill(2) a sudo process as a regular user;
        # - attempts to kill(2) a sudo process
        #   from the same process group are apparently ignored.
        subprocess.check_call([
                'setsid', '-w',
                'sudo', '-S',
                # TODO: use sudo only when requested by user
                'kill', str(dmesg_proc.pid)
            ],
            stdin=subprocess.DEVNULL,
        )
    try:
        n = len(paths) * 5
        print(f'1..{n}')
        for path in paths:
            test_one(dmesg_proc.stdout, path)
    finally:
        kill_dmesg()
    while True:
        try:
            dmesg_proc.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            prog = ap.prog
            pid = dmesg_proc.pid
            print(f'demysg/test/{prog}: warning: sudo[{pid}] is still alive', file=sys.stderr)
            kill_dmesg()
        else:
            break

def test_one(dmesg_fp, path):
    prog = os.path.basename(path)
    def ok(test_name, *, when=True):
        msg = f'ok - {prog} {test_name}'
        if not when:
            msg = f'not {msg}'
        print(msg)
    def not_ok(test_name):
        ok(test_name, when=False)
    def skip(n):
        for i in range(n):
            print('ok # skip')
    xpath = path
    if '/' not in xpath:
        xpath = f'./{xpath}'
    print('# checking', xpath, flush=True)
    proc = subprocess.Popen([xpath])
    try:
        proc.wait(timeout=timeout)
    except subprocess.TimeoutExpired:
        print(f'# {prog} timed out')
        not_ok('crash')
        skip(4)
        return
    rc = proc.returncode
    if rc < 0:
        signame = signal.Signals(-rc).name
        print(f'# {prog} killed by {signame}')
        ok('crash')
    else:
        print(f'# {prog} exited with status {rc}')
        not_ok('crash')
        skip(4)
        return
    pid = proc.pid
    match = None
    while not match:
        signal.alarm(timeout)
        try:
            line = dmesg_fp.readline()
        except TimeoutError:
            not_ok('dmesg')
            skip(3)
            return
        finally:
            signal.alarm(0)
        if not line:
            raise RuntimeError('unexpected EOF from dmesg(1)')
        match = re.search(fr'\btraps: {prog}\[{pid}\] .*', line)
    text = match.group()
    print('# dmesg output:')
    print('#  ', text)
    ok('dmesg')
    proc = subprocess.run(
        [f'{here}/../demysg', '-e', xpath],
        input=text,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding='ASCII', errors='replace',
    )
    print(f'# demysg rc: {proc.returncode}')
    ok('rc', when=(proc.returncode == 0))
    stdout = proc.stdout.splitlines()
    if stdout:
        print('# demysg stdout:')
        for line in stdout:
            print(f'#   {line}')
    else:
        print('# demysg stdout: (empty)')
    ok('stdout', when=re.search('\nSource:\n  # .*\n  main at ', proc.stdout))
    stderr = proc.stderr.splitlines()
    if stderr:
        print('# demysg stderr:')
        for line in stderr:
            print(f'### {line}')
    ok('stderr', when=(not proc.stderr))

if __name__ == '__main__':
    main()

# vim:ts=4 sts=4 sw=4 et ft=python
