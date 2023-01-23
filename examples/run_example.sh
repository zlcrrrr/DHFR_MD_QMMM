#!/bin/bash

# activate AmberTools22 conda env
source ~/anaconda3/etc/profile.d/conda.sh
conda activate AmberTools22

filename="schrodinger_md_0"

# fix residue naming issue for Amber
sed -ie 's/T3P/WAT/g' ${filename}.pdb
sed -i '/EPW/d' ${filename}.pdb

# clean up the pdb file using pdb4amber
pdb4amber -i ${filename}.pdb -o ${filename}_.pdb

# run AFNMR
$AFNMRHOME/bin/afnmr -nomin -orca -list "1" -offlib ../lib/SO4.lib -offlib ../lib/TMP.lib -frcmod ../lib/SO4.frcmod -frcmod ../lib/TMP.frcmod ${filename}_

# run QM/MM using ORCA
inputfile="schrodinger_md_0_001.orcainp"
outputfile="schrodinger_md_0_001.out"
orca $inputfile > $outputfile

# extract shifts
cp ../scripts/getshifts-orca-old $AFNMRHOME/bin/
$AFNMRHOME/bin/getshifts-orca-old ref_seg0 schrodinger_md_0_001 > results.txt