date
hostname

OMP_NTHREADS=1
module load singularity/2.4.2
NTHREADS=$PBS_NUM_PPN
# cd $PBS_O_WORKDIR

IMAGE="/dartfs-hpc/rc/home/3/f001693/fmriprep-1.3.2.simg"

DSET=life

HOME_DIR=/dartfs/rc/lab/D/DBIC/DBIC/d29262k/singularity_home/life/home/
BIDS_DIR=${HOME}/life

BASE_DIR=/dartfs-hpc/scratch/d29262k
OUT_DIR=${BASE_DIR}/data/fmriprep-like/fmriprep_1.3.2/${DSET}
WORK_DIR=${BASE_DIR}/data/fmriprep-workdir/fmriprep_1.3.2/${DSET}

mkdir -p ${OUT_DIR}/freesurfer
mkdir -p ${WORK_DIR}
ls $WORK_DIR
ls $HOME_DIR
ls $OUT_DIR
ls $BIDS_DIR
echo ${WORK_DIR}
echo ${OUT_DIR}
which singularity

# '${OUT_DIR}/freesurfer/fsaverage'
#ln -s /dartfs-hpc/rc/home/3/f001693/fsaverage ${OUT_DIR}/freesurfer/fsaverage

env -i `which singularity` run -e \
    -H ${HOME_DIR}:/home \
    -B /dartfs-hpc:/dartfs-hpc \
    -B /dartfs:/dartfs \
    ${IMAGE} \
    --skip_bids_validation \
    --output-space T1w template fsnative fsaverage \
    --template-resampling-grid 2mm \
    --medial-surface-nan \
    --use-syn-sdc \
    --notrack \
    --skull-strip-fixed-seed \
    --mem_mb 1000000 --nthreads 40 --omp-nthreads 1 \
    --fs-license-file /home/FS_license.txt -w ${WORK_DIR} ${BIDS_DIR} ${OUT_DIR} participant

