wd = mfilename('fullpath');
addpath(fullfile(fileparts(fileparts(wd)),'simulation_code'));

% Initialize network
network = network_simulation_beluga(wd);

% Initialize post network
nPostNeurons = 1;
network = network.initialize_postsynaptic_network(nPostNeurons);

% Presyanptic network parameters
nPreNeurons = 30000;
network.tmax = 2e3; % 2 seconds
network.branchNo = 0;
network.simulatespikes_critplane(nPreNeurons,network.tmax);

% Connect presyantpic network randomly
network.form_connections(0);

% Simulate dipoles
network = network.simulate();
[time,V,dipoles] = network.importSimulationResults;


savePath1 = [network.savePath '_tau=10'];
savePath2 = [network.savePath '_tau=30'];

% Change tau_decay of GABA recpetors
inChanges = [10,1,1];
network = network.changeInhibitorySynapseParams(inChanges);
network.savePath = savePath1;
network = network.simulate();

% Change tau_decay of GABA recpetors
inChanges = [30,1,1];
network = network.changeInhibitorySynapseParams(inChanges);
network.savePath = savePath2;
network = network.simulate();

% Compute EEG signal
data10 = load(fullfile(savePath1,'simulation_data.mat'));
data30 = load(fullfile(savePath2,'simulation_data.mat'));
[sa,X] = network_simulation_beluga.getHeadModel;
location = randi(size(sa.cortex75K.vc,1)); % Random location
eeg10 = network_simulation_beluga.getEEG(data10.dipoles(2:end,:),sa,location);
eeg30 = network_simulation_beluga.getEEG(data30.dipoles(2:end,:),sa,location);