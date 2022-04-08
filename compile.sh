#!/bin/sh

if [ $# -ne 1 ]; then
    echo 'usage: compile.sh <SOURCE_FILE>'
    exit 1
fi

export SRC=$1

echo 'generating assembly...'
python3 main.py $SRC -o out.s > /dev/null
echo 'done. compiling and linking...'
arm-linux-gnueabi-gcc out.s runtime.c -g -static -march=armv6 -o out
echo 'done. running the binary...'
echo 'what follows is output from the executable:\n'
qemu-arm -cpu arm1136 out