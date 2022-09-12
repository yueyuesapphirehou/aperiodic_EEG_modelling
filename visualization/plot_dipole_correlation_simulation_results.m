[sa,X] = network_simulation.getHeadModel;
% masterPath = 'E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\compare_network_dynamics\m=0.250';
masterPath = 'E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\compare_network_dynamics\m=0.980';
F = dir(masterPath); F = F(3:end);

for i = 1:length(F)
    temp = load(fullfile(masterPath,F(i).name,'data.mat'));
    network(i) = temp.network.importResults;
end

C0 = zeros(10*9/2,11);
K = 10;
idcs = randi(size(X.vertices,1),K);
h = waitbar(0);
for i = 1:K
    waitbar(i/K);
    for j = 1:11
        eeg = network_simulation.getEEG(network(j).results.dipoles,sa,idcs(i));
        eeg = eeg(network(j).results.t<1e3,:);
        temp = triu(corr(eeg),1);
        C0(:,j) = C0(:,j) + temp(temp~=0);
    end
end
C0 = C0/K;
delete(h)

figureNB(3.6,3.6);
axes('position',[0.36,0.17,0.55,0.75]);
    errorbar(11:-1:1,mean(C0),stderror(C0),'k','LineWidth',1);
    gcaformat
    ylim([-0.1,0.5])
    yticks([0,0.25,0.5])
    ylabel('Dipole correlation')
    set(gca,'XAxisLocation','origin')
    xlim([0,12]);
    xticks([1,6,11]);
    xticklabels([0,0.5,1]);
    xlabel('Syn. config. optimality','Position',[13,-0.2]);

figureNB(3,3);
axes('position',[0.36,0.17,0.55,0.75]);
    plot(randn(45,11)*0.2+[11:-1:1],C0,'.k','MarkerSize',3);
    gcaformat
    ylim([-0.1,0.5])
    yticks([0,0.25,0.5])
    ylabel('Dipole correlation')
    set(gca,'XAxisLocation','origin')
    xlim([0,12]);
    xticks([1,6,11]);
    xticklabels([0,0.5,1]);
    xlabel('Syn. coord. index','Position',[13,-0.2]);


C1 = zeros(10,10,10);
for j = 1:10
    eeg = network(j).results.Vmem;
    C1(:,:,j) = corr(eeg);
end

clrs = clrsPT.iridescent(15);
clrs = clrs(3:end,:);
C = {};
for i = 1:10
    temp = C0(:,:,i);
    C{i} = temp(temp~=1);
end

CV = {};
for i = 1:10
    temp = C1(:,:,i);
    CV{i} = temp(temp~=1);
end

t = flip(linspace(0,1,10));
figureNB;
    m = cellfun(@(x)mean(x),CV);
    s = cellfun(@(x)std(x),CV);
    errorbar(t,m,s,'LineWidth',1);
    gcaformat
    ylim([-0.2,0.6])
    line([0,1],[0,0],'color','k')
    line([0,1],[0.1,0.1],'color','r')
    xlabel('Synapse coordination')
    ylabel('Pairwise dipole correlation')
    xlim([0,1]);
    xticks([0,0.5,1]);
