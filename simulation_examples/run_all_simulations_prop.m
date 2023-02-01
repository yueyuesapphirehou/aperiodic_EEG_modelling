function run_all_simulations(masterPath)
    addpath('/home/nbrake/aperiodic_EEG_modelling/simulations/functions');
    for i = 1:1
        data=load(fullfile(masterPath,['rep' int2str(i)],'data.mat'));
        % data=load(fullfile(masterPath,'data.mat'));
        for repNo = 1:10
            run_simulation(data.network,repNo);
        end
    end
end

function run_simulation(network,repNo)

    if(repNo==1)
        network.form_connections(1);
    end

    [ids,ts,ei] = network.getprenetwork(fullfile(fileparts(network.getCorrelationFile),'spikeTimesLong.csv'));
    tmax = network.tmax;
    tmax0 = max(ts);
    t0 = rand*max(tmax0-tmax,0);
    idcs = find(and(ts>=t0,ts<t0+tmax));
    N = network.getsynapsecount;

    network_simulation_beluga.save_presynaptic_network(ids(idcs),ts(idcs)-t0,ei,N,network.spikingFile)
    network.savePath = [network.savePath '_' int2str(repNo)];

    P = [10,1,0.5]*[100;10;1];
    network = network.addPropofol(P);
    network = network.simulate();
    % return;

    network.savePath = [network.savePath '_prop'];
    P = [10,3,1.5]*[100;10;1];
    network = network.addPropofol(P);
    network = network.simulate();
end