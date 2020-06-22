#!/bin/bash
SCRIPTS_DIR="/glade/work/djk2120/clm5.0.30/cime/scripts/"
SPINDIR="/glade/scratch/djk2120/dleaf_ens/"
SCRATCH="/glade/scratch/djk2120/"
cd $SCRIPTS_DIR
for i in $(seq -f "%03g" 1 1)
do
    p="spin_dleaf_"$i
    echo $p
    cd $p
    keyfile=$p"_key.txt"
    d=$SCRATCH$p"/run/"

    while read -r line; do 
	tmp=(${line///}) 
	paramkey=${tmp[1]} 
	instkey=${tmp[0]}

	oldfile=$d$p".clm2_"$instkey".r.*"
	newfile=$SPINDIR$paramkey"_restart.nc"


	cp $oldfile $newfile
    done < $keyfile
    cd ..
done
