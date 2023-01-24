

load('C:\Users\brake\Documents\temp\analzye_simulations_10.mat')
P1(:,:,7:10) = nan;
P_baseline = P1(:,:,5);
P_tau = P1(:,:,7);
P_crit = P1(:,:,3);
P_tau_crit = P1(:,:,10);
P_baseline_osc = P1(:,:,6);
P_tau_osc = P1(:,:,8);
P_crit_osc = P1(:,:,9);

figureNB(11.5,6);
axes('Position',[0.12,0.63,0.18,0.3]); % Crit on oscillation
    plot(f,mean(P_baseline_osc,2),'LineWidth',1,'color','k')
    hold on;
    plot(f,mean(P_crit_osc,2),'LineWidth',1,'color','r')
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.1,100])
    ylim(10.^[-17,-14]);
    xticks(10.^[-1:2]);
    xticklabels([0.1,1,10,100]);
    xlabel('Frequency (Hz)');
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
axes('Position',[0.45,0.63,0.18,0.3]); % Mixed, crit on oscillation (additive)
    plot(f,mean(P_baseline_osc+P_baseline_osc,2),'LineWidth',1,'color','k')
    hold on;
    plot(f,mean(P_baseline_osc+P_crit_osc,2),'LineWidth',1,'color','r')
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.1,100])
    ylim(10.^[-17,-14]);
    xticks(10.^[-1:2]);
    xticklabels([0.1,1,10,100]);
    xlabel('Frequency (Hz)');
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
axes('Position',[0.78,0.63,0.18,0.3]); % Mixed, tau on oscillation (mutli)
    plot(f,mean(P_crit+P_baseline_osc,2),'LineWidth',1,'color','k')
    hold on;
    plot(f,mean(P_tau_crit+P_tau_osc,2),'LineWidth',1,'color','r')
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.1,100])
    ylim(10.^[-17,-14]);
    xticks(10.^[-1:2]);
    xticklabels([0.1,1,10,100]);
    xlabel('Frequency (Hz)');
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
axes('Position',[0.12,0.16,0.18,0.3]);
    plot(f,mean((P_baseline+P_baseline).*(1+0.3*randn(size(P_baseline))),2),'LineWidth',1,'color','k')
    hold on;
    plot(f,mean((P_baseline*1.25+0.75*P_crit).*(1+0.3*randn(size(P_baseline))),2),'LineWidth',1,'color','r')
    plot(f,mean((P_baseline+P_baseline_osc).*(1+0.3*randn(size(P_baseline))),2),'LineWidth',1,'color','b')
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.1,100])
    ylim(10.^[-17,-14]);
    xticks(10.^[-1:2]);
    xticklabels([0.1,1,10,100]);
    xlabel('Frequency (Hz)');
    ylabel(['PSD (' char(956) 'V^2/Hz)']);

load('C:\Users\brake\Documents\temp\analzye_simulations_2.mat');
P1(:,:,7:10) = nan;
P_baseline = P1(:,:,5);
P_tau = P1(:,:,7);
P_crit = P1(:,:,3);
P_tau_crit = P1(:,:,10);
P_baseline_osc = P1(:,:,6);
P_tau_osc = P1(:,:,8);
P_crit_osc = P1(:,:,9);
axes('Position',[0.45,0.16,0.18,0.3]);
    plot(f,mean((P_baseline+P_baseline).*(1+0.3*randn(size(P_baseline))),2),'LineWidth',1,'color','k')
    hold on;
    plot(f,mean((P_baseline*1.25+0.75*P_crit).*(1+0.3*randn(size(P_baseline))),2),'LineWidth',1,'color','r')
    plot(f,mean((P_baseline+P_baseline_osc).*(1+0.3*randn(size(P_baseline))),2),'LineWidth',1,'color','b')
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.1,100])
    ylim(10.^[-17,-14]);
    xticks(10.^[-1:2]);
    xticklabels([0.1,1,10,100]);
    xlabel('Frequency (Hz)');
    ylabel(['PSD (' char(956) 'V^2/Hz)']);
axes('Position',[0.78,0.16,0.18,0.3]);
    plot(f,mean((P_baseline+P_baseline).*(1+0.3*randn(size(P_baseline))),2),'LineWidth',1,'color','k')
    hold on;
    plot(f,mean((P_baseline*1.25+0.75*P_tau).*(1+0.3*randn(size(P_baseline))),2),'LineWidth',1,'color','r')
    plot(f,mean((P_baseline+P_baseline_osc).*(1+0.3*randn(size(P_baseline))),2),'LineWidth',1,'color','b')
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlim([0.1,100])
    ylim(10.^[-17,-14]);
    xticks(10.^[-1:2]);
    xticklabels([0.1,1,10,100]);
    xlabel('Frequency (Hz)');
    ylabel(['PSD (' char(956) 'V^2/Hz)']);

gcaformat(gcf)