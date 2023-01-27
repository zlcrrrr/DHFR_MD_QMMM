intervel=1
$SCHRODINGER/run trj2mae.py -s 0:-1:${intervel} -extract-asl "all" -align-asl "protein" -out-format PDB -separate dhfr_md_1000ns-out.cms schrodinger_md_trj schrodinger_md
