[sa,X] = network_simulation.getHeadModel;
folder = 'E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\dyad_dipole_correlation';

idx = randi(size(X.vertices,1),100,1);

h = waitbar(0);
F = dir(folder);
F = F(3:end);
for i = 1:length(F)
    h = waitbar(i/length(F));
    folder2 = fullfile(folder,F(i).name);
    F2 = dir(folder2);
    F2 = F2(3:end);
    for k = 1:length(F2)
        load(fullfile(folder2,F2(k).name,'data.mat'));
        network = network.importResults;
        for j = 1:length(idx)
            eeg = network_simulation.getEEG(network.results.dipoles,sa,idx(j));
            tempQ = corr(eeg);
            temp(j) =  mean(tempQ(tempQ~=1));
            [Ptemp(:,j),f] = pmtm(detrend(sum(eeg,2)),2,[],1e3*16);
        end
        Cq(i,k) = mean(temp);
        P(:,i,k) = mean(Ptemp,2);
    end
end



