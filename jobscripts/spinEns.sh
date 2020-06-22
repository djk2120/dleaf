SCRIPTS_DIR="/glade/work/djk2120/clm5.0.30/cime/scripts/"
PARAMS_DIR=$(realpath ../params/paramfiles)"/"
basecase="spinclm50d30_US-UMB_WOZNIAK"
thisdir=$(pwd)
repcase="spin_dleaf_001"
ninst=10



if [ 1 -eq 1 ]
then
cd $SCRIPTS_DIR
./create_clone --case $repcase --clone $basecase
cd $repcase
./xmlchange MAX_TASKS_PER_NODE=36
./xmlchange MAX_MPITASKS_PER_NODE=36
./xmlchange MPILIB="mpt"
./xmlchange JOB_QUEUE="regular"
./xmlchange NINST_LND=$ninst
./case.setup --reset
fi


#loop through the paramfiles
#   creating a user_nl_clm_00xx for each
cd $PARAMS_DIR
CT=0
for path in spinme/*.nc
do
    CT=$((CT+1))

    # locate and prepare mods to user_nl_clm
    f="$(basename -- $path)"
    printf -v nlnum "%04d" $CT
    nlfile="user_nl_clm_"$nlnum
    pfile=$PARAMS_DIR"spun/"$f
    pfilestr="paramfile = '"$pfile"'"

    # copy and edit user_nl_clm
    cd $SCRIPTS_DIR$repcase
    cp user_nl_clm.base $nlfile
    echo $pfilestr >> $nlfile

    # create a key to map each instance number to its paramfile
    printf $nlnum"\t"${f%.*}"\n" >> $repcase"_key.txt"


done

#move the paramfiles from "spinme" to "spun"
cd $PARAMS_DIR
for path in spinme/*.nc
do
    mv $path spun/
done


