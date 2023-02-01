function run_all_simulations(masterPath)
    addpath('/home/nbrake/aperiodic_EEG_modelling/simulations/functions');
    for i = 1:30
        data=load(fullfile(masterPath,['rep' int2str(i)],'data.mat'));
        % data=load(fullfile(masterPath,'data.mat'));
        for repNo = 1:11
            run_simulation(data.network,repNo);
        end
    end
end

function run_simulation(network,repNo)

    network.spikingFile = fullfile(network.preNetwork,['spikeTimes.csv']);
    if(repNo==1)
        [ids,ts,ei] = network.getprenetwork(fullfile(fileparts(network.getCorrelationFile),'spikeTimesLong.csv'));
        tmax = network.tmax;
        tmax0 = max(ts);
        t0 = rand*max(tmax0-tmax,0);
        idcs = find(and(ts>=t0,ts<t0+tmax));
        N = network.getsynapsecount;
        network_simulation_beluga.save_presynaptic_network(ids(idcs),ts(idcs)-t0,ei,N,network.spikingFile)
    end

    m = linspace(0,1,11);
    network.form_connections(m(repNo));
    network.savePath = [network.savePath '_ef=' num2str(m(repNo))];
    network = network.simulate();
end