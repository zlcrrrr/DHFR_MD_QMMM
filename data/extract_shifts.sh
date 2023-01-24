#!/bin/bash
if [ ! -d results ]
then
	mkdir results
else
	rm ./results/*
fi
basename=""
for n in {0..990..10}
do
	if [[ $n -eq 0 ]]
    then
        idx=${n}
    else
        idx=${n}0
    fi
    filename=schrodinger_md_${idx}.pdb
	filename=${filename%.*}
	echo ${idx}
	touch ./results/results_${idx}.txt
	cd ./${idx}
	for i in {1..159}
	do
		if [[ $i -lt 10 ]]
		then
			appendix="00${i}"
		elif [[ $i -lt 100 ]]
		then
			appendix="0${i}"
		elif [[ $i -ge 100 ]]
		then
		    appendix="${i}" 
		fi
		$AFNMRHOME/bin/getshifts-orca-old ref_seg0 ${filename}_${appendix} >> ../results/results_${idx}.txt
	done
	grep -w 'C' ../results/results_${idx}.txt > ../results/C_results_${idx}.txt
	grep -w 'N' ../results/results_${idx}.txt > ../results/N_results_${idx}.txt
	grep -w 'CA' ../results/results_${idx}.txt > ../results/CA_results_${idx}.txt
	cd ..
done
