gcc -o compute_tiling_correlation.exe compute_tiling_correlation.c -fopenmp -lm


baseFolders='/home/nbrake/aperiodic_EEG_modelling/simulations/base_folders'
JOBID1=$(sbatch --array=21 --parsable initialize_network.sh $baseFolders)
JOBID2=$(sbatch --array=21 --dependency=afterok:$JOBID1 --parsable compute_pairwise_correlations.sh $baseFolders)
JOBID3=$(sbatch --array=21 --dependency=afterok:$JOBID2 --parsable embed_synapses.sh $baseFolders)
JOBID4=$(sbatch --array=21 --dependency=afterok:$JOBID3 --parsable runSimulationBeluga.sh $baseFolders)
