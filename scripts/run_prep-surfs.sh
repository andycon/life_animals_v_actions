#!/usr/bin/bash 

sub=$1
life=data/fmriprep-like/fmriprep_1.3.2/life/
fspath=${scratch}/${life}/freesurfer
anat=${scratch}/${life}/fmriprep/${sub}/anat/${sub}_desc-preproc_T1w.nii.gz
refdir=${data}/life/${sub}/ref

: << COMMENT

@SUMA_Make_Spec_FS \
    -fspath ${fspath}/${sub}/surf \
    -sid ${sub} \
    -NIFTI \
    -inflate 50 \
    -inflate 100 \
    -inflate 150 \
    -inflate 200 \
    -ld 32 \
    -ld 64 \
    -ld 128 

cd ${fspath}/${sub}/surf/SUMA



3dAllineate \
    -base ${sub}_SurfVol.nii \
    -source ${anat} \
    -prefix anat_SurfVol_alnd \
    -1Dmatrix_save T1w_2_SurfVol_xmat.1D \
    -warp shift_rotate



COMMENT

mkdir ${refdir}

mv ${fspath}/${sub}/surf/SUMA/* ${refdir}
cd ${refir}

for run in $(seq 1 4)
do

    3drefit -space ORIG ${data}/life/${sub}/run-0${run}_bold_3dTproj.nii.gz

    cd ${refdir}

    3dAllineate \
        -1Dmatrix_apply T1w_2_SurfVol_xmat.1D \
        -newgrid 3 \
        -prefix run-0${run}_alnd.nii.gz \
        -master anat_SurfVol_alnd+orig \
        -source ../run-0${run}_bold_3dTproj.nii.gz

done
