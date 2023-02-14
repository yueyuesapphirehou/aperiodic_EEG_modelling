function figureS4(dataFolder)

[full_model,synFun,apFun] = fittingmodel('avalanches');
clrs = clrsPT.lines(4);
blue = clrsPT.qualitative_CM.blue;

low = load(fullfile(dataFolder,'simulation_oscillations_fitted_parameters_0.5Hz.mat'));
high = load(fullfile(dataFolder,'simulation_oscillations_fitted_parameters_0.1Hz.mat'));
[coeff,score_low] = pca((low.X-mean(low.X))./std(low.X));
[~,score_high] = pca((high.X-mean(high.X))./std(high.X));

%%%%%%% Realisitic spectra
load(fullfile(dataFolder,'simulations_parameter_changes_0.5Hz.mat'));
asynch_low_res = 1.2*P1(:,:,5);
f_low_res = f;
osc_low_res = (asynch_low_res+P1(:,:,6));
osc_low_res = 0.5*osc_low_res./mean(asynch_low_res(1,:),2);
osc_low_res = mean(osc_low_res.*(1+0.3*randn(size(osc_low_res))),2);
crit_low_res = (asynch_low_res*1.25+0.75*P1(:,:,3));
crit_low_res = 0.5*crit_low_res./mean(asynch_low_res(1,:),2);
crit_low_res = mean(crit_low_res.*(1+0.3*randn(size(crit_low_res))),2);

params3 = [0.012    0.0060   -0.05   -0.6    0.1    8    2.5    0.2    0.9];
params4 = [0.011    0.0060   -0.14   -0.4    0.15    4    3    0.5    0.7];

% High resolution spectra
load(fullfile(dataFolder,'simulations_parameter_changes_0.1Hz.mat'));
f_high_res = f;
asynch_high_res = 2*mean(P(:,:,6),2);
osc_high_res = mean(P(:,:,6)+P(:,:,7),2); osc_high_res = osc_high_res./asynch_high_res(1);
osc_high_res = osc_high_res./osc_high_res(1);
crit_high_res = mean(P(:,:,6)*1.25+0.75*P(:,:,4),2); crit_high_res = crit_high_res./asynch_high_res(1);
crit_high_res = crit_high_res./crit_high_res(1);


params1 = [0.015    0.003   -0.37   -1.2    0.13    9    2    0.0000    0.2500];
params2 = [0.0115    0.003   -0.04   -0.75    0.13    0    2    3    0.24];

figureNB(13,8);

%% High resolution simulations %%%
subplot(2,3,1);
    plot(f_high_res,crit_high_res,'k','LineWidth',1);
    hold on;
    plot(f_high_res,10.^full_model(f_high_res,params1),'color',clrs(2,:),'LineWidth',1);
    plot(f_high_res,10.^apFun(f_high_res,params1),'color',clrs(3,:),'LineWidth',1);
    plot(f_high_res,10.^synFun(f_high_res,params1),'color',clrs(1,:),'LineWidth',1);
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.1,100])
    xticks(10.^[-1:2]);
    xticklabels([0.1,1,10,100]);
    ylim([0.01,10]);
    xlabel('Frequency (Hz)');
    ylabel('log power');
    yticks([]);
    title('+avalanches (m=0.98)','FontSize',7,'color',clrs(3,:),'FontWeight','normal');
    T = text(1.2,2.86,{'Avalanche','timescale'},'FontSize',6);
subplot(2,3,2);
    plot(f_high_res,osc_high_res,'k','LineWidth',1);
    hold on;
    plot(f_high_res,10.^full_model(f_high_res,params2),'color',clrs(2,:),'LineWidth',1);
    plot(f_high_res,10.^apFun(f_high_res,params2),'color',clrs(3,:),'LineWidth',1);
    plot(f_high_res,10.^synFun(f_high_res,params2),'color',clrs(1,:),'LineWidth',1);
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.1,100])
    xticks(10.^[-1:2]);
    xticklabels([0.1,1,10,100]);
    xlabel('Frequency (Hz)');
    ylabel('log power');
    ylim([0.01,10]);
    yticks([]);
    title('+2 Hz oscillation','FontSize',7,'color',clrs(2,:),'FontWeight','normal');
    T = text(12.2,4,{'Peak'},'FontSize',6);
    T = text(0.77,0.11,{'Synaptic','timescale'},'FontSize',6);
subplot(2,3,3);
    for i = 1:4
        idcs = find(high.g==i);
        h(i) = scatter(score_high(idcs,1),score_high(idcs,2),30,clrs(i,:),'filled');
        hold on;
    end
    xlabel('PC1'); ylabel('PC2'); gcaformat;
    T1=text(-4,-2.1,{'Baseline','(m=0)'},'FontSize',6,'color',clrs(1,:));
    T2=text(-4.4,2.8,'+2 Hz oscillation','FontSize',6,'color',clrs(2,:));
    T3=text(-2.5,-4.6,'+avalanches (m=0.98)','FontSize',6,'color',clrs(3,:));
    T4=text(-0.5,4,'High tau (\tau=30 ms)','FontSize',6,'color',clrs(4,:));
    title('Freq. res. = 0.1 Hz','FontWeight','normal');
    ylim([-6,4.75])
    xlim([-5,5]);

subplot(2,3,4);
    plot(f_low_res,crit_low_res,'k','LineWidth',1);
    hold on;
    plot(f_low_res,10.^full_model(f_low_res,params3),'color',clrs(2,:),'LineWidth',1);
    plot(f_low_res,10.^apFun(f_low_res,params3),'color',clrs(3,:),'LineWidth',1);
    plot(f_low_res,10.^synFun(f_low_res,params3),'color',clrs(1,:),'LineWidth',1);
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.5,50])
    xticks([0.5,5,50]);
    xticklabels([0.5,5,50]);
    ylim([0.1,3.25])
    xlabel('Frequency (Hz)');
    ylabel('log power');
    yticks([]);
subplot(2,3,5);
    plot(f_low_res,osc_low_res,'k','LineWidth',1);
    hold on;
    plot(f_low_res,10.^full_model(f_low_res,params4),'color',clrs(2,:),'LineWidth',1);
    plot(f_low_res,10.^apFun(f_low_res,params4),'color',clrs(3,:),'LineWidth',1);
    plot(f_low_res,10.^synFun(f_low_res,params4),'color',clrs(1,:),'LineWidth',1);
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.5,50])
    xticks([0.5,5,50]);
    xticklabels([0.5,5,50]);
    xlabel('Frequency (Hz)');
    ylabel('log power');
    ylim([0.1,3.25])
    yticks([]);
subplot(2,3,6);
    for i = 1:4
        idcs = find(low.g==i);
        h(i) = scatter(score_low(idcs,1),score_low(idcs,2),30,clrs(i,:),'filled');
        hold on;
    end
    xlabel('PC1'); ylabel('PC2'); gcaformat;
    title('Freq. res. = 0.5 Hz','FontWeight','normal');
    ylim([-6,3]);
    xlim([-5,5]);
    % legend(h,{'Baseline (m=0)','+2 Hz oscillations','+avalanches (m=0.98)','\tau = 30 ms'});

gcaformat(gcf);
