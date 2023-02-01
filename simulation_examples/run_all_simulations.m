function run_all_simulations(masterPath,propo)
    addpath('/home/nbrake/aperiodic_EEG_modelling/simulations/functions');
    for i = 1:1
        data=load(fullfile(masterPath,['rep' int2str(i)],'data.mat'));
        % data=load(fullfile(masterPath,'data.mat'));
        for repNo = 1:1
            run_simulation(data.network,repNo,propo);
        end
    end
end

function run_simulation(network,repNo,propo)
    % network.spikingFile = fullfile(network.preNetwork,['spikeTimes_' int2str(repNo) '.csv']);
    network.spikingFile = fullfile(network.preNetwork,'spikeTimesLong.csv');
    network.savePath = fullfile(network.outputPath,'LFPy');
    network.form_connections(1);
    network = network.simulate();
    return;


    if(~isempty(propo) && propo>0)
        network.savePath = [network.savePath '_' int2str(repNo) '_prop'];
        network = network.addPropofol(propo);
    else
        [ids,ts,ei] = network.getprenetwork(fullfile(fileparts(network.getCorrelationFile),'spikeTimesLong.csv'));
        tmax = network.tmax;
        tmax0 = max(ts);
        t0 = rand*max(tmax0-tmax,0);
        idcs = find(and(ts>=t0,ts<t0+tmax));
        N = network.getsynapsecount;
        network_simulation_beluga.save_presynaptic_network(ids(idcs),ts(idcs)-t0,ei,N,network.spikingFile)
        network.savePath = [network.savePath '_' int2str(repNo)];
    end
    if(repNo==1)
        network.form_connections(1);
    end

    network = network.simulate();
end