#!/bin/bash
#SBATCH --time=028:00:00
#SBATCH --account=def-akhadra
#SBATCH --mem=8G
#SBATCH --mail-user=niklas.brake@mail.mcgill.ca
#SBATCH --mail-type=FAIL,END

module load python/3.8.10
module load mpi4py
module load scipy-stack
module load matlab/2020a
module load neuron

virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index --upgrade pip --quiet
pip install --no-index -r requirements.txt --quiet
pip install --no-index LFPy --quiet
pip install --no-index umap-learn

masterPath=$1
par1='/home/nbrake/aperiodic_EEG_modelling/simulations/par1'
par2='/home/nbrake/aperiodic_EEG_modelling/simulations/par2'
par3='/home/nbrake/aperiodic_EEG_modelling/simulations/par3'
m=$(sed -n ${SLURM_ARRAY_TASK_ID}p $par1)
tau=$(sed -n ${SLURM_ARRAY_TASK_ID}p $par2)
osc=$(sed -n ${SLURM_ARRAY_TASK_ID}p $par3)
DIR="${masterPath}/m=${SLURM_ARRAY_TASK_ID}"

matlab -nodisplay -r "simulate_changes($tau,$m,'$DIR',$osc)"

