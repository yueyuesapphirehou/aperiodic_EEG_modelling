function initialize_network(masterPath,branchNo)
% masterPath = '/lustre04/scratch/nbrake/data/simulations/raw/correlation_test';
addpath('/home/nbrake/aperiodic_EEG_modelling/simulations/functions');

tmax0 = 20e3;
tmax = 2e3;
nrnCount = 4;

network = network_simulation_beluga(masterPath);
network = network.initialize_postsynaptic_network(nrnCount);
network.tmax = tmax;
N = network.getsynapsecount;

% [ids,ts,ei,C,elevation,azimuth] = simulatespikes_critplane(N,branchNo,tmax0*1e-3);
[ids,ts,ei,C,elevation,azimuth] = simulatespikes_critplane_multisynapse(N,branchNo,tmax0*1e-3);

file = fullfile(network.preNetwork,'spikeTimesLong.csv');
network_simulation_beluga.save_presynaptic_network(ids,ts,ei,N,file)

correlationFile = fullfile(network.preNetwork,'correlations.csv');
network = network.setCorrelationFile(correlationFile);

csvwrite(fullfile(network.preNetwork,'connections.csv'),C);
csvwrite(fullfile(network.preNetwork,'locations.csv'),[elevation(:),azimuth(:)]);
csvwrite(correlationFile,'');


x1 = 2*pi*azimuth;
y1 = asin(2*elevation-1);
data = uint32([(1:N)',x1(:),y1(:)]);
dlmwrite(fullfile(network.preNetwork,'UMAP_embedding.csv'),data,'precision',ceil(log10(N)));

network.save();