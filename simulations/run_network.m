
masterPath = 'E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\dyad_dipole_correlation\run0';
cons = csvread('E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\dyads0\t=100\presynaptic_network\preConnections.csv');
load('E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\dyads\s=0\data.mat');
i = 0;
for m = [0.25,0.5,0.75,0.9,0.95,0.98,0.99,0.999];
    for k = 0:9
        newRunPath = ['E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\dyad_network_criticality\m=' num2str(m,3) '\run' int2str(k)];
        fdr2 = ['s=' num2str(i,2)];
        masterPath3 = fullfile(newRunPath,fdr2);
        load(fullfile(masterPath,'s=0','data.mat'));
        network2 = network.copy_network(masterPath3);
        N = network.getsynapsecount;
        [ids,ts,ei] = simulatespikes_det(N,m,network.tmax*1e-3,cons);
        network_simulation.save_presynaptic_network(ids,ts,ei,N,fullfile(network2.preNetwork,'spikeTimes.csv'))
        network2.form_connections(i);
        network2.simulate();
    end
end


function main(N,tmax,corr_idx,sim_dir)
    network0 = network_simulation;
    network0.postNetwork = sim_dir;
    network0 = network0.initialize_postsyanptic_network(N,corr_idx);

    % network1 = network0;
    % network1.postNetwork = sim_dir;
    % network1.preNetwork = fullfile(sim_dir,'asynch','spiking.csv');
    % network1.outputPath = fullfile(sim_dir,'asynch');
    % network1 = network1.initialize_presyanptic_network(0,tmax);
    % network1 = network1.simulate();
    % network1.save();

    network2 = network0;
    network2.postNetwork = sim_dir;
    network2.preNetwork = fullfile(sim_dir,'reverb','spiking.csv');
    network2.outputPath = fullfile(sim_dir,'reverb');
    network2 = network2.initialize_presyanptic_network(0.98,tmax);
    network2 = network2.simulate();
    network2.save();

    network3 = network0;
    network3.postNetwork = sim_dir;
    network3.preNetwork = fullfile(sim_dir,'crit','spiking.csv');
    network3.outputPath = fullfile(sim_dir,'crit');
    network3 = network3.initialize_presyanptic_network(0.999,tmax);
    network3 = network3.simulate();
    network3.save();
end


function run_correlation(m)
    sim_dir = ['E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\pairwise_correlation\m' num2str(m,2)];

    tmax = 2e3;
    N = 10;
    network0 = network_simulation;
    network0.postNetwork = sim_dir;
    network0 = network0.initialize_postsyanptic_network(2*N,0.98);
    network0.preNetwork = fullfile(sim_dir,'spiking.csv');
    network0.outputPath = fullfile(sim_dir);
    network0 = network0.initialize_presyanptic_network(m,tmax);


    pair_corr = linspace(0,1,11);
    for i = 1:length(pair_corr)
        pc = pair_corr(i)
        network = network0;
        network.postNetwork = fullfile(sim_dir,['pc' num2str(pc,2)]);
        network.outputPath = fullfile(sim_dir,['pc' num2str(pc,2)]);
        network = network.initialize_postsyanptic_network(N,pc);
        network = network.simulate();
        network.save();
    end
end

function run_conductances()
    sim_dir = 'E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\compare_conductances\active';

    tmax = 6e3;
    network = network_simulation;
    network.postNetwork = sim_dir;
    network = network.initialize_postsyanptic_network(100,0);
    network.preNetwork = fullfile(sim_dir,'spiking.csv');
    network.outputPath = fullfile(sim_dir);
    network = network.initialize_presyanptic_network(0,tmax);
    network = network.addActiveChannels;
    network = network.simulate();
    network.save();
end