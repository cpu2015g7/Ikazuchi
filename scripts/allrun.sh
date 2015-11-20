#!/bin/bash
cwd=`dirname $0`
cd $cwd/..
DIR="."

if [ $# -ne 1 ]; then
	exit 1
fi

for f in $(find ${DIR}/$1 -name "*.ml")
do
	echo "run ${f}"
	${DIR}/scripts/run.sh ${f%.ml}
	sleep 1
done
