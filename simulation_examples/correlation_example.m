wd = mfilename('fullpath');
addpath(fullfile(fileparts(fileparts(wd)),'simulation_code'));

% Initialize network
network = network_simulation_beluga(wd);

% Initialize post network
nPostNeurons = 2;
network = network.initialize_postsynaptic_network(nPostNeurons);

% Presyanptic network parameters
nPreNeurons = 30000;
network.tmax = 2e3; % 2 seconds
network.branchNo = 0.98;
network.simulatespikes_critplane(nPreNeurons,network.tmax);

% Compute presynaptic correlations
network.compute_presynaptic_correlations;

% Perform UMAP
network.embed_presyanptic_neurons;

% Place syanpse optimally
network.form_connections(1);

% Simulate dipoles
network = network.simulate();
[time,V,dipoles] = network.importSimulationResults;

% Compute EEG signal
[sa,X] = network_simulation_beluga.getHeadModel;
location = randi(size(sa.cortex75K.vc,1)); % Random location
eeg = network_simulation_beluga.getEEG(dipoles,sa,location);