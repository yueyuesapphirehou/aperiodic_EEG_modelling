function figureS1(dataFolder)

if(nargin<1)
    error('Path to data required as input argument. Data can be downloaded from link in README file.');
end

load(fullfile(dataFolder,'simulation_prenetwork_correlations.mat'));

figureNB(5,5);
    plot(1./(1-m(:)),fr(:),'.-k','MarkerSize',15,'LineWidth',1)
    ylabel('Correlated synapse pairs (STTC>0.25)')
    xlabel('1/(1-m)')
    set(gca,'xscale','log')
    ylim([0,1])
    yticks([0,0.5,1])
    yticklabels({'0%','0.1%','1%'})
    gcaformat