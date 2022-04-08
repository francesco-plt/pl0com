#!/bin/env sh

if [[$# -ne 2]]
then
    echo 'usage: compile.sh <SOURCE_FILE>'
    exit 0
fi

export SRC=$1

echo 'generating assembly...'
python3 main.py $SRC
echo 'done. compiling and linking...'
arm-linux-gnueabi-gcc out.s runtime.c -g -static -march=armv6 -o out
echo 'done. running the binary...'
qemu-arm -cpu arm1136 out