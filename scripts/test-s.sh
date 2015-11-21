#!/bin/bash
cwd=`dirname $0`
cd $cwd/..
DIR="."

if [ $# -ne 1 ]; then
	exit 1
fi
echo "test " $1
echo "start assembling"
cat ${DIR}/lib/start.s ${DIR}/lib/libmincaml.s ${DIR}/${1}.s > ${DIR}/${1}-run.s
${DIR}/tools/assembler -i ${DIR}/${1}-run.s -o ${DIR}/${1}.t --dump
${DIR}/tools/str2vhd < ${DIR}/${1}.t > ${DIR}/${1}-vhdl.txt
echo "start simulating"
if [ ! -f ${DIR}/${1}-in.txt ]; then
	touch ${DIR}/${1}-in.txt
fi
${DIR}/simulator/sim ${DIR}/${1}.t 100000000 > ${DIR}/${1}-out.txt < ${DIR}/${1}-in.txt
if diff ${DIR}/${1}-ans.txt ${DIR}/${1}-out.txt; then
	echo "ok " $1
else
	echo "fails " $1
fi
