#!/bin/bash

# The interpreter used to execute the script

#“#SBATCH” directives that convey submission options:

#SBATCH --job-name casc-test
#SBATCH --nodes=2
#SBATCH --tasks-per-node=20
#SBATCH --mem-per-cpu=1g
#SBATCH --time=1:00:00
#SBATCH --account=agrt98
#SBATCH --export=ALL
#SBATCH --partition=standard

#SBATCH --mail-user=lghart@umich.edu
#SBATCH --mail-type=BEGIN,END

# The application(s) to execute along with its input arguments and options:

#############################################################################################
# EDIT BELOW HERE 
#############################################################################################

# select code version here (1D, 2D etc.)
export DIMS=2D
export INPUTFILE=~/osutils/decks/bellaexp

## OPTIONAL - CAN BE BLANK, no space
export RUNTITLE=test

export ROOT_DIR=~/osiris
export DATA_DIR=/scratch/agrt_root/agrt98/lghart/osresults


#############################################################################################

export EXEC=osiris-${DIMS}.e
export DIR_NAME=os4.0_${DIMS}_${RUNTITLE}_${SLURM_JOB_ID}%.nyx.engin.umich.edu

mkdir ${DATA_DIR}/${DIR_NAME}
cp -f ${ROOT_DIR}/bin/${EXEC} ${DATA_DIR}/${DIR_NAME}
cp -f ${INPUTFILE} ${DATA_DIR}/${DIR_NAME}/os-stdin

# Create root directory
cd ${DATA_DIR}/${DIR_NAME}

# Add text notes
touch notes
echo run did not finish >> notes

# Run code
mpirun ${EXEC}
 
# remove executable
rm -f ${EXEC} notes
