function figure3def(dataFolder)

if(nargin<1)
    error('Path to data required as input argument. Data can be downloaded from link in README file.');
end

load(fullfile(dataFolder,'simulation_avalanches_dipole_correlations.mat'));
clrs = clrsPT.sequential(10); clrs = clrs(5:end,:);

figureNB(10.6,3.4)
axes('Position',[0.09,0.26,0.2,0.67]);
    line([1,100],[0,0],'color',[0.6,0.6,0.6],'LineWidth',1);
    hold on;
    for i = 1:length(m)
        x = 1/(1-m(i));
        y = nanmean(C_s0(i,:));
        y_lo = icdf('normal',0.05,0,1)*stderror(C_s0(i,:)');
        y_hi = icdf('normal',0.95,0,1)*stderror(C_s0(i,:)');
        plot(x,y,'.','color',[0.6,0.6,0.6],'MarkerSize',10,'LineWidth',1)
        line([x,x],[y+y_lo,y+y_hi],'color',[0.6,0.6,0.6],'linewidth',1);
    end
    plot(1./(1-m),nanmean(C_s1,2),'color','k','LineWidth',1);
    for i = 1:length(m)
        x = 1/(1-m(i));
        y = nanmean(C_s1(i,:));
        y_lo = icdf('normal',0.05,0,1)*stderror(C_s1(i,:)');
        y_hi = icdf('normal',0.95,0,1)*stderror(C_s1(i,:)');
        plot(x,y,'.','color',clrs(i,:),'MarkerSize',10,'LineWidth',1)
        line([x,x],[y+y_lo,y+y_hi],'color',clrs(i,:),'linewidth',1);
    end
    set(gca,'xscale','log')
    xlim([1,100]);
    ylim([-0.05,0.6])
    xl = xlabel('Spike prop. index. (1-m)^{-1}');
    xl.Position(2) = -0.18;
    ylabel('Dipole correlation');
    gcaformat
    text(1.5,0.4,{'Optimized','synapses'},'FontSize',6,'VerticalAlignment','top')
    text(100,0.16,{'Random','synapses'},'FontSize',6,'VerticalAlignment','top','HorizontalAlignment','right','color',[0.6,0.6,0.6])

mResults = load(fullfile(dataFolder,'simulation_avalanches_spectra.mat'));
axes('Position',[0.43,0.26,0.2,0.67]);
    m = sort([0.99,0.98,0.95,0.86,0.63,0]);
    h=[];
    for i = 1:length(m)
        y = mResults.spectra(:,:,i);
        h(i) = plotwitherror(mResults.f,y,'CI','color',clrs(i,:),'LineWidth',1);
    end
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
    xlabel('Frequency (Hz)')
    xlim([0.5,100]);
    ylim(10.^[-17,-13])
    yticks(10.^[-16,-14]);
    xticks([1,10,100]);
    xticklabels([1,10,100]);
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    % L = legend(h,num2str(m(:)));
    % L.Title.String = 'm value';
    % L.Box = 'off';
    % L.ItemTokenSize = [5,5];
    % L.Position = [0.59,0.32,0.1,0.63];
    gcaformat;

axes('Position',[0.46,0.73,0.15,0.12]);
    for i = 1:3
        line([0,0.15],[0.8,0.8]-(i-1)*0.2,'LineWidth',1,'color',clrs(i,:))
        if(i>1)
            text(0.175,0.8-(i-1)*0.2,num2str(m(i)),'FontSize',6,'HorizontalAlignment','left','VerticalAlignment','middle','color',clrs(i,:));
        else
            text(0.175,0.8-(i-1)*0.2,'m=0','FontSize',6,'HorizontalAlignment','left','VerticalAlignment','middle','color',clrs(i,:));
        end
    end
    for i = 1:3
        line([0.55,0.7],[0.8,0.8]-(i-1)*0.2,'LineWidth',1,'color',clrs(i+3,:))
        text(0.725,0.8-(i-1)*0.2,num2str(m(i+3)),'FontSize',6,'HorizontalAlignment','left','VerticalAlignment','middle','color',clrs(i+3,:));
    end
    axis off
    % title('m value','FontSize',7,'Position',[0.5,0.9],'FontWeight','normal');


crit_tau = load(fullfile(dataFolder,'simulations_avalanches_tau_spectra.mat'));
axes('Position',[0.77,0.26,0.2,0.67]);
    m = sort([0.99,0.98,0.95,0.86,0.63,0]);
    h=[];
    plotwitherror(crit_tau.f,crit_tau.spectra_m98_tau10,'CI','color',clrs(5,:),'LineWidth',1);
    plotwitherror(crit_tau.f,crit_tau.spectra_m98_tau30,'CI','color',clrsPT.qualitative_CM.blue,'LineWidth',1);
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
    xlabel('Frequency (Hz)')
    xlim([0.5,100]);
    ylim(10.^[-17,-13])
    yticks(10.^[-16,-14]);
    xticks([1,10,100]);
    xticklabels([1,10,100]);
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    gcaformat;
    text(0.6,6e-14,'m = 0.98','FontSize',7)
    text(0.67,2.3e-16,'\tau = 10 ms','FontSize',6,'color',clrs(5,:))
    text(5.4,5e-15,'\tau = 30 ms','FontSize',6,'color',clrsPT.qualitative_CM.blue)