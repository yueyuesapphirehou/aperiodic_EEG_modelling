mValues = [0.5,0.75,0.9,0.95,0.98,0.99,0.999];
j=1;
fid = fopen('/home/nbrake/aperiodic_EEG_modelling/simulations/spikefiles','at')
for m = mValues
    for i = 1:4
        masterPath = ['/lustre04/scratch/nbrake/data/simulations/raw/synapse_embedding/m' num2str(m) '_' int2str(i) '_' int2str(j)];
        fprintf(fid,"%s\n",masterPath);
    end
end
fclose(fid);