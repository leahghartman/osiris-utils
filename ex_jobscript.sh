#!/bin/bash

# The interpreter used to execute the script

#“#SBATCH” directives that convey submission options:

#SBATCH --job-name casc-test
#SBATCH --nodes=1
#SBATCH --tasks-per-node=5
#SBATCH --mem-per-cpu=1g
#SBATCH --time=1:00:00
#SBATCH --account=engin1
#SBATCH --export=ALL
#SBATCH --partition=standard

#SBATCH --mail-user=qqbruce@umich.edu
#SBATCH --mail-type=BEGIN,END

# The application(s) to execute along with its input arguments and options:

#############################################################################################
# EDIT BELOW HERE 
#############################################################################################

# select code version here (1D, 2D etc.)
export DIMS=2D
export INPUTFILE=test-2d

## OPTIONAL - CAN BE BLANK, no space
export RUNTITLE=test

export ROOT_DIR=~/osiris
export DATA_DIR=/scratch/engin_root/engin/qqbruce/Osiris_Result


#############################################################################################

export EXEC=osiris-${DIMS}.e
export DIR_NAME=os4.0_${DIMS}_${RUNTITLE}_${SLURM_JOB_ID%.nyx.engin.umich.edu}

mkdir ${DATA_DIR}/${DIR_NAME}
cp -f ${ROOT_DIR}/bin/${EXEC} ${DATA_DIR}/${DIR_NAME}/.
cp -f ${ROOT_DIR}/decks/${INPUTFILE} ${DATA_DIR}/${DIR_NAME}/os-stdin

# Create root directory
cd ${DATA_DIR}/${DIR_NAME}

# Add text notes
touch notes
echo run did not finish >> notes

# Run code
mpirun ${EXEC}
 
# remove executable
rm -f ${EXEC} notes
