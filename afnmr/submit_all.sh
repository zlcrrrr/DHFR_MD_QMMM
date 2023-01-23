#!/bin/bash

# Remainder jobs
for k in {0..990..10}
do
    if [[ $k -eq 0 ]]
    then
        idx=${k}
    else
        idx=${k}0
    fi
	echo $idx
    sbatch ./${idx}/submit_${idx}.sh
done
