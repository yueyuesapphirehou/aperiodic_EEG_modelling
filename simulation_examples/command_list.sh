baseFolders='/home/nbrake/aperiodic_EEG_modelling/simulations/base_folders'
JOBID1=$(sbatch --array=21 --parsable initialize_network.sh $baseFolders)
JOBID2=$(sbatch --array=21 --dependency=afterok:$JOBID1 --parsable compute_pairwise_correlations.sh $baseFolders)
JOBID3=$(sbatch --array=21 --dependency=afterok:$JOBID2 --parsable embed_synapses.sh $baseFolders)
JOBID4=$(sbatch --array=21 --dependency=afterok:$JOBID3 --parsable runSimulationBeluga.sh $baseFolders)

DIR=$(sed -n 21p $baseFolders)
sbatch runSimulationBeluga.sh $DIR


gcc -o compute_correlation_matrix_parallel.exe compute_correlation_matrix_parallel.c -fopenmp -lm
gcc -o ./functions/compute_tiling_correlation.exe ./functions/compute_tiling_correlation.c -fopenmp -lm


#################### ARAY JOBS ####################
baseFolders='/home/nbrake/aperiodic_EEG_modelling/simulations/base_folders'
echo -n "" > $baseFolders
echo '/lustre04/scratch/nbrake/data/simulations/raw/correlation_test_k1' >> $baseFolders
echo '/lustre04/scratch/nbrake/data/simulations/raw/correlation_test_k2' >> $baseFolders
echo '/lustre04/scratch/nbrake/data/simulations/raw/correlation_test_k3' >> $baseFolders
echo '/lustre04/scratch/nbrake/data/simulations/raw/correlation_test_k4' >> $baseFolders

JOBID1=$(sbatch --array=1-4 --parsable initialize_network.sh $baseFolders)
JOBID2=$(sbatch --array=1-4 --dependency=afterok:$JOBID1 --parsable compute_pairwise_correlations.sh $baseFolders)
JOBID3=$(sbatch --array=1-4 --dependency=afterok:$JOBID2 --parsable embed_synapses.sh $baseFolders)
JOBID4=$(sbatch --array=1-4 --dependency=afterok:$JOBID3 --parsable runSimulationBeluga.sh $baseFolders)



masterFolder='/lustre04/scratch/nbrake/data/simulations/raw/correlation_plane'
JOBID1=$(sbatch --array=1-8 --parsable initialize_all_networks.sh $masterFolder)
JOBID2=$(sbatch --array=1-8 --dependency=afterok:$JOBID1 --parsable run_all_simulations.sh $masterFolder)
sbatch --dependency=afterok:$JOBID2 getCorr2.sh $masterFolder


################ INDVIDUAL JOBS #################
testFolder='/lustre04/scratch/nbrake/data/simulations/raw/correlation_test_plane_3/m=0.98'
# testFolder='/lustre04/scratch/nbrake/data/simulations/raw/synapse_embedding_3/m=0.98'
JOBID1=$(sbatch --parsable initialize_network.sh $testFolder)
JOBID2=$(sbatch --dependency=afterok:$JOBID1 --parsable compute_pairwise_correlations.sh $testFolder)
JOBID3=$(sbatch --dependency=afterok:$JOBID2 --parsable embed_synapses.sh $testFolder)
JOBID4=$(sbatch --dependency=afterok:$JOBID3 --parsable run_all_simulations.sh $testFolder)

sbatch compute_pairwise_correlations.sh $testFolder


sbatch sphere_criticality.sh '/lustre04/scratch/nbrake/data/simulations/raw/sphere_test_2'


baseFolders='/lustre04/scratch/nbrake/data/simulations/raw/synapse_embedding'
mValues='/lustre04/scratch/nbrake/data/simulations/raw/synapse_embedding'
initialize_all_networks $baseFolders


testFolder='/lustre04/scratch/nbrake/data/simulations/raw/correlation_test_plane_3/m=0.98_4k'
JOBID1=$(sbatch --parsable initialize_network.sh $testFolder)
JOBID4=$(sbatch --dependency=afterok:$JOBID1 --parsable run_all_simulations.sh $testFolder)



masterPath='/lustre04/scratch/nbrake/data/simulations/raw/correlation_plane/m=0'
sbatch --array=1-10 run_all_simulations.sh $masterPath


masterFolder='/lustre04/scratch/nbrake/data/simulations/raw/correlations'
JOBID1=$(sbatch --array=7 --parsable initialize_all_networks.sh $masterFolder)
JOBID2=$(sbatch --array=7 --dependency=afterok:$JOBID1 --parsable run_all_simulations.sh $masterFolder)
JOBID3=$(sbatch --dependency=afterok:$JOBID2 getPSD.sh "${masterFolder}/m=0")



masterFolder='/lustre04/scratch/nbrake/data/simulations/raw/correlation'
JOBID1=$(sbatch --array=2 --parsable run_all_simulations.sh $masterFolder 0)
sbatch --dependency=afterok:$JOBID1 getPSD.sh $masterFolder



masterFolder='/lustre04/scratch/nbrake/data/simulations/dyads/criticality'
JOBID1=$(sbatch --array=1-6 --parsable run_all_simulations.sh $masterFolder 0)
sbatch --dependency=afterok:$JOBID1 getPSD.sh $masterFolder

masterFolder='/lustre04/scratch/nbrake/data/simulations/dyads/criticality'
sbatch --array=1-6 compute_pairwise_correlations.sh $masterFolder

masterFolder='/lustre04/scratch/nbrake/data/simulations/dyads/tau'
JOBID2=$(sbatch --array=1-6 --parsable run_tauValues.sh $masterFolder 0)
sbatch --dependency=afterok:$JOBID2 getPSD.sh $masterFolder


masterFolder='/lustre04/scratch/nbrake/data/simulations/dyads/criticality_osc'
JOBID1=$(sbatch --array=1-6 --parsable run_all_simulations.sh $masterFolder 1)
sbatch --dependency=afterok:$JOBID1 getPSD.sh $masterFolder


masterFolder='/lustre04/scratch/nbrake/data/simulations/dyads/tau_osc'
JOBID2=$(sbatch --array=1-6 --parsable run_tauValues.sh $masterFolder 1)
sbatch --dependency=afterok:$JOBID2 getPSD.sh $masterFolder

sbatch getPSD.sh '/lustre04/scratch/nbrake/data/simulations/dyads/tau_osc'

masterFolder='/lustre04/scratch/nbrake/data/simulations/dyads/crit_tau'
JOBID1=$(sbatch --array=1,6 --parsable run_tauValues.sh $masterFolder 0)
sbatch --dependency=afterok:$JOBID1 getPSD.sh $masterFolder

masterFolder='/lustre04/scratch/nbrake/data/simulations/dyads/crit_tau_osc'
JOBID2=$(sbatch --array=1,6 --parsable run_tauValues.sh $masterFolder 1)
sbatch --dependency=afterok:$JOBID2 getPSD.sh $masterFolder



masterFolder='/lustre04/scratch/nbrake/data/simulations/ground_truth_changes_2'
JOBID2=$(sbatch --array=10 --parsable run_all_simulations.sh $masterFolder)
sbatch --dependency=afterok:$JOBID2 getPSD.sh $masterFolder



masterFolder='/lustre04/scratch/nbrake/data/simulations/ground_truth_changes_2'
sbatch getPSD.sh $masterFolder

