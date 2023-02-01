function initialize_synapse_embedding(m)

addpath('/home/nbrake/aperiodic_EEG_modelling/simulations/functions');

tmax0 = 100e3;
tmax = 2e3;
nrnCount = 2;
N = 32770;

m = str2num(m);

for i = 1:4
    for j = 1:30
        masterPath = ['/lustre04/scratch/nbrake/data/simulations/raw/synapse_embedding/m' num2str(m) '_' int2str(i) '_' int2str(j)];
        network = network_simulation_beluga(masterPath);
        network = network.initialize_postsynaptic_network(nrnCount);
        if(j==1)
            [ids,ts,ei,C] = simulatespikes_det(N,m,tmax0*1e-3);
            file = fullfile(network.preNetwork,'spikeTimesLong.csv');
            network_simulation_beluga.save_presynaptic_network(ids,ts,ei,N,file)
            correlationFile = fullfile(network.preNetwork,'correlation.csv');
        end
        network = network.setCorrelationFile(correlationFile);
        network.tmax = tmax;
        t0 = rand*(tmax0-tmax);
        idcs = find(and(ts>=t0,ts<t0+tmax));
        network = network.setSpikingFile(fullfile(network.preNetwork,['spikeTimes' int2str(j) '.csv']));
        network_simulation_beluga.save_presynaptic_network(ids(idcs),ts(idcs)-t0,ei,N,network.spikingFile)
        network.save();
    end
end
