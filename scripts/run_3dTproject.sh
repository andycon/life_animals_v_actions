#!/usr/bin/bash


cd ../
outdir=`pwd`



outdir=${outdir}/data
#mkdir ${outdir}




stdir=/dartfs-hpc/scratch/d29262k/data/fmriprep-like/fmriprep_1.3.2/life/fmriprep/

cd ${stdir}
subs=`ls -d sub*/`

for s in $subs
do
    echo ${s}

    subdir=${outdir}/${s}
    #mkdir ${subdir}
    cd ${s}func
    for i in $(seq 1 4)
    do
        func=`ls *preproc_bold.nii.gz | grep run-0${i}`
        #echo ${func}
        output=${outdir}/${s}run-0${i}_bold_3dTproj.nii.gz
        if [ ! -f $output ]; then

        3dTproject \
            -input ${func} \
            -prefix ${output} \
            -polort 2 \
            -ort run-0${i}_confounds.csv \
            -passband 0.00667 0.1 \
            -norm  &
        
        else
            echo ${output} already exists.
        
        fi

    done
    
    cd ${stdir}

done
