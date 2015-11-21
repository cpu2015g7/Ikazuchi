#!/bin/bash
cwd=`dirname $0`
cd $cwd/..
DIR="."

if [ $# -ne 1 ]; then
	exit 1
fi

for f in $(find ${DIR}/$1 -name "*.ml")
do
	${DIR}/scripts/run.sh ${f%.ml}
done
