DATASET_NAME=$1
SERVER=$2
ANALYZER=$3


target=/nfs/data${SERVER}/${ANALYZER}/data/${DATASET_NAME}/${DATASET_NAME}_ds_stack_mean.nrrd
# moving=/nfs/data${SERVER}/${ANALYZER}/data/${DATASET_NAME}/${DATASET_NAME}_confocal_rotated.nrrd
moving=/nfs/data${SERVER}/${ANALYZER}/data/${DATASET_NAME}/${DATASET_NAME}_confocal_rotated_flipped.nrrd
output1=/nfs/data${SERVER}/${ANALYZER}/data/${DATASET_NAME}/ants/ants_output1.nrrd
output2=/nfs/data${SERVER}/${ANALYZER}/data/${DATASET_NAME}/ants/ants_output2.nrrd


mkdir -p /nfs/data${SERVER}/${ANALYZER}/data/${DATASET_NAME}/ants/

ANTSPATH="/nfs/data9/lilian/data/ANTs/install/bin"

${ANTSPATH}/antsRegistration -d 3 \
--float 1 \
--verbose 1 \
-o [${output1},${output2}] \
-n BSpline \
--interpolation WelchWindowedSinc \
--use-histogram-matching 0 \
-r [${target},${moving},1] \
-t rigid[0.08] \
-m MI[${target},${moving},1,32,Regular,0.4] \
-c [200x200x200x100,1e-8,15] \
--shrink-factors 12x8x4x2 \
--smoothing-sigmas 4x3x2x1vox \
-t Affine[0.08] \
-m MI[${target},${moving},1,32,Regular,0.4] \
-c [200x200x200x100,1e-8,15] \
--shrink-factors 12x8x4x2 \
--smoothing-sigmas 4x3x2x1 \
-t SyN[0.1,6,0.0] \
-m CC[${target},${moving},1,4] \
-c [200x200x200x200x10,1e-7,10] \
--shrink-factors 12x8x4x2x1 \
--smoothing-sigmas 4x3x2x1x0 
