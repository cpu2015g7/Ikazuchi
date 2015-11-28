#!/bin/bash

for f in $(find . -name "*.sld")
do
	echo $f
	../simulator/sim min-rt_g.t 10000000000 <$f >${f%.sld}.ppm
done
