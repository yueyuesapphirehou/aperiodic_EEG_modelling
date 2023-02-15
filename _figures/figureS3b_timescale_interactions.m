function figureS3b(dataFolder)

if(nargin<1)
    error('Path to data required as input argument. Data can be downloaded from link in README file.');
end

mResults = load(fullfile(dataFolder,'simulation_avalanches_spectra.mat'));
tauResults = load(fullfile(dataFolder,'simulations_avalanches_tau_spectra.mat'));


delT = tauResults.spectra_m0_tau30./tauResults.spectra_m0_tau10;
delM = mResults.spectra(:,:,5)./mResults.spectra(:,:,1);


fig = figureNB(18.3,6);
axes('Position',[0.07,0.15,0.23,0.75]);
    h(1) = plotwitherror(mResults.f,mResults.spectra(:,:,1),'Q','LineWidth',1);
    hold on;
    h(2) = plotwitherror(mResults.f,mResults.spectra(:,:,5),'Q','LineWidth',1);
    xlim([0.5,100]);
    ylim(10.^[-18,-13])
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    title('Criticality changed (\tau = 10)')
    xlabel('Frequency (Hz)')
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
    L = legend(h,{'m = 0','m = 0.98'}); L.ItemTokenSize = [10,10];
    L.Box = 'off';
axes('Position',[0.4,0.15,0.23,0.75]);
    h(1) = plotwitherror(tauResults.f,tauResults.spectra_m0_tau10,'Q','LineWidth',1);
    hold on;
    h(2) = plotwitherror(tauResults.f,tauResults.spectra_m0_tau30,'Q','LineWidth',1);
    xlim([0.5,100]);
    ylim(10.^[-18,-13])
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    title('Synapses changed (m = 0)')
    xlabel('Frequency (Hz)')
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
    L = legend(h,{'\tau = 10','\tau = 30'}); L.ItemTokenSize = [10,10];
    L.Box = 'off';
axes('Position',[0.73,0.15,0.23,0.75]);
    h(1) = plotwitherror(tauResults.f,tauResults.spectra_m0_tau10,'Q','LineWidth',1);
    h(2) = plotwitherror(tauResults.f,tauResults.spectra_m98_tau30,'Q','LineWidth',1);
    h(3) = plotwitherror(tauResults.f,mResults.spectra(:,:,1).*delM.*delT,'Q','LineWidth',1);
    xlim([0.5,100]);
    ylim(10.^[-18,-13])
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    title('Both changed')
    xlabel('Frequency (Hz)')
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
    L = legend(h,{'m = 0, \tau = 10','m = 0.98, \tau = 30','Prediction from multiplication'}); L.ItemTokenSize = [10,10];
    L.Box = 'off';
gcaformat(gcf)
