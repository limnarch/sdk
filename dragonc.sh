#!/bin/bash

path=$(dirname $0)

${path}/lua.sh ${path}/dragonfruit/dragonc.lua $1 `dirname $1`/._out.s
${path}/asm.sh `dirname $1`/._out.s $2
${path}/link.sh link $2 $2 ${path}/dragonfruit/runtime/object/lib.o

rm `dirname $1`/._out.s
