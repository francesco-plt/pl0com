#!/bin/sh

# python3 main.py src/prog2.pl0 -o obj/prog2.s | grep DEBUG


# argument check
if [ "$#" -ne 1 ]; then
    if [ "$2" = "-r" ]; then
        continue
    else
        echo 'usage: compile.sh <SOURCE_FILE>'
        exit 1
    fi
fi

SRCDIR=src
OBJDIR=obj
DSTDIR=bin
SRCFILE=$1
DSTOBJ=${SRCFILE%.*}.s
DSTEXE=${SRCFILE%.*}

clean() {
    rm -f out.s out
}

echo 'cleaning leftovers...'
clean
echo 'generating assembly...'
python3 main.py $SRCDIR/$SRCFILE -o $OBJDIR/$DSTOBJ > /dev/null
if [ $? -ne 0 ]; then
    echo 'error: assembly generation failed'
    exit 1
fi
echo 'done.'

if ! test -f $OBJDIR/$DSTOBJ ; then
    echo 'you have compilation errors. quitting...'
    exit 2
fi

echo 'compiling and linking...'
arm-linux-gnueabi-gcc $OBJDIR/$DSTOBJ runtime.c -g -static -march=armv6 -o $DSTDIR/$DSTEXE
echo 'done.'


echo 'running the binary...'
echo 'what follows is the output of the program:'
echo '------------------------------------------'
qemu-arm -cpu arm1136 $DSTDIR/$DSTEXE
echo '------------------------------------------'
echo 'done.'