function run_simulations(tau,masterPath,oscillations)
    addpath('/home/nbrake/aperiodic_EEG_modelling/simulations/functions');
    for i = 1:30
        folder = fullfile(masterPath,['dyad_' int2str(i)]);
        local_run(tau,folder,oscillations)
    end
end

%% local_run: function to set up model and run 10 times
function local_run(tau,masterPath,oscillations)
    repCount = 10;
    tmax0 = 40e3;
    tmax = 2e3;
    nrnCount = 2;
    N = 30000;

    network = network_simulation_beluga(masterPath);
    network = network.initialize_postsynaptic_network(nrnCount);
    network.tmax = tmax;
    network.branchNo = 0.98;
    if(oscillations)
        simulatespikes_osc(N,tmax0,network);
    else
        network.simulatespikes_critplane(N,tmax0);
    end

    % Explicit mapping of presynaptic connections onto sphere
    copyfile(fullfile(network.preNetwork,'spikeTimes.csv'),fullfile(network.preNetwork,'spikeTimesLong.csv'));
    x = csvread(fullfile(network.preNetwork,'locations.csv'));
    x1 = 2*pi*x(:,1);
    y1 = asin(2*x(:,2)-1);
    data = [(1:N)',x1(:),y1(:)];
    dlmwrite(fullfile(network.preNetwork,'UMAP_embedding.csv'),data,'precision','%.4f');
    network.save();

    propofol = [tau,1,1]*[100;10;1];
    network = network.addPropofol(propofol);

    [ids,ts,ei] = network.getprenetwork(fullfile(network.preNetwork,'spikeTimesLong.csv'));
    % Sample spike times for each
    for repNo = 1:repCount
        tmax = network.tmax+100;
        tmax0 = max(ts);
        t0 = rand*max(tmax0-tmax,0);
        idcs = find(and(ts>=t0,ts<t0+tmax));
        spikeFile{repNo} = fullfile(network.preNetwork,['spikeTimes' int2str(repNo) '.csv']);
        network_simulation_beluga.save_presynaptic_network(ids(idcs),ts(idcs)-t0,ei,N,spikeFile{repNo})
    end

    % Simulate with optimal connections
    network.form_connections(1);
    for repNo = 1:repCount
        network = network.setSpikingFile(spikeFile{repNo});
        network.savePath = fullfile(masterPath,['LFPy_' int2str(repNo) '_s=1']);
        network = network.simulate();
    end

    % Simulate with random connections
    % network.form_connections(0);
    % for repNo = 1:repCount
    %     network = network.setSpikingFile(spikeFile{repNo});
    %     network.savePath = fullfile(masterPath,['LFPy_' int2str(repNo) '_s=0']);
    %     network = network.simulate();
    % end
end