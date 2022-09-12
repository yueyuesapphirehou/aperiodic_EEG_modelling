

fig = figureNB(8.5,4);
load('E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\summary_data\network_criticality_spectra_(s=1).mat')
subplot(1,2,1);
    idcs = and(f>0,f<=100);
    clrs = clrsPT.sequential(length(Cq)+5);
    clrs = clrs(5:end,:);
    for i = 1:8
        % h(i) = plotwitherror(f(idcs),squeeze(P(idcs,:,i)),'M','LineWidth',1,'color',clrs(i,:)); hold on;
        h(i) = plot(f(idcs),mean(squeeze(P(idcs,i,:)),2),'LineWidth',1,'color',clrs(i,:)); hold on;
    end
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlim([0.5,100]);
    xticks([1,10,100]);
    xlabel('Frequency (Hz)')
    ylabel(['PSD (' char(956) 'V^2/Hz)'])
    gcaformat;
    ylim([5e-17,2e-14]);
load('E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\summary_data\network_criticality_spectra_(s=0.7).mat')
subplot(1,2,2);
    idcs = and(f>0,f<=100);
    clrs = clrsPT.sequential(length(Cq)+5);
    clrs = clrs(5:end,:);
    for i = 1:8
        % h(i) = plotwitherror(f(idcs),squeeze(P(idcs,:,i)),'M','LineWidth',1,'color',clrs(i,:)); hold on;
        h(i) = plot(f(idcs),mean(squeeze(P(idcs,i,:)),2),'LineWidth',1,'color',clrs(i,:)); hold on;
    end
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlim([0.5,100]);
    xticks([1,10,100]);
    xlabel('Frequency (Hz)')
    ylabel(['PSD (' char(956) 'V^2/Hz)'])
    gcaformat;
    ylim([5e-17,2e-14]);

L = legend(h,strcat(repmat('m = ',[length(m),1]),num2str(m(:))));
L.ItemTokenSize = [10,5]
gcaformat;