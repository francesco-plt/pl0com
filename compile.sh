#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo 'usage: compile.sh <SOURCE_FILE>'
    exit 1
fi

clean() {
    rm -f out.s out
}

export SRC=$1
echo 'cleaning leftovers...'
clean
echo 'generating assembly...'
python3 main.py $SRC -o out.s > /dev/null
echo 'done.'

if ! test -f "out.s"; then
    echo 'you have compilation errors. quitting...'
    exit 2
fi

echo 'compiling and linking...'
arm-linux-gnueabi-gcc out.s runtime.c -g -static -march=armv6 -o out
echo 'done. running the binary...'
echo 'what follows is output from the executable:'
qemu-arm -cpu arm1136 out