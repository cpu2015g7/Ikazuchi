#!/bin/bash
cwd=`dirname $0`
cd $cwd/..
DIR="."

if [ $# -ne 1 ]; then
	exit 1
fi

echo "start compiling"
${DIR}/compiler/min-caml ${DIR}/$1
echo "start assembling"
cat ${DIR}/tools/initialize.s ${DIR}/${1}.s > ${DIR}/${1}-run.s
${DIR}/tools/assembler -i ${DIR}/${1}-run.s -o ${DIR}/${1}.t
${DIR}/tools/str2vhd < ${DIR}/${1}.t > ${DIR}/${1}-vhdl.txt
echo "start simulating"
${DIR}/simulator/sim ${DIR}/${1}.t 1000000000 > ${DIR}/${1}-simulator-out.txt
