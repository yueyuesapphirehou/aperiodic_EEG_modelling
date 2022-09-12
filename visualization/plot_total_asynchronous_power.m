% function plot_total_asynchronous_power

dThresh = 10.^(linspace(-1,log10(20),60));
load('E:\Research_Projects\004_Propofol\data\resources\head_models\surface_area_calculations.mat')
% Neuron count within a radius is the surface area times
% 100,000 neurons/mmm^2
N = 25e9;
dMids = 0.5*(dThresh(2:end)+dThresh(1:end-1));
nrnCount = mean(diff(Ar),2)*100000;
nrnCount(end) = N-sum(nrnCount(1:end-1));
corr_kernel = @(d) exp(-d.^2/10);

figureNB;
    plot(corr_kernel(dMids'),nrnCount/N,'LineWidth',1);
    set(gca,'yscale','log')
    ylabel('% neurons')
    xlabel('Pairwise correlation')
    gcaformat;

% Average pairwise correlation based on the :
%   - distribution of neuron densities within a certain radius of %     each point in cortex
%   - coupling kernel as a function of radius (normalized, so that
%     the correlation of nearby neurons is 1)
corr_kernel = @(d) exp(-d.^2/10);
rho_bar = sum(corr_kernel(dMids').*nrnCount)/sum(nrnCount')



load('E:\Research_Projects\004_Propofol\data\simulations\analyzed\asynch_untiary_spectrum.mat');
% load('E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\summary_data\asynch_untiary_spectrum_APs.mat')
load('E:\Research_Projects\004_Propofol\data\experiments\scalp_EEG\model_fits\pre.mat');
% asynchUnitarySpec = P;

SIG0 = mean(sum(asynchUnitarySpec*mean(diff(f))));
P0 = interp1(f,asynchUnitarySpec,freq);

SIG_N = @(rho) N+N*(N-1)*rho;

t = 10.^linspace(-20,0,1e3);
figureNB;
    plot(t,SIG0*SIG_N(t));
    set(gca,'xscale','log')
    set(gca,'yscale','log')


figureNB;
    plotwitherror(freq,P0*SIG_N(0.1*rho_bar),'Q','color','r');
    % plotwitherror(freq,pre,'Q','color',[0.6,0.6,0.6],'LineWidth',1);
    plot(freq,median(pre,2),'k')
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    % xlim([1,300]);
    % xticks([1,10,100]);
    % xticklabels([1,10,100]);
    xlim([0.5,50]);
    xticks([0.5,5,50])
    xticklabels([0.5,5,50])
    xlabel('Frequency (Hz)');
    ylabel(['PSD (' char(956) 'V^2/Hz)'])
    % ylim([1e-2,1e2])
gcaformat(gcf);



t = 10.^linspace(-10,0,1e3);
fig = figureNB(6.5,2.75);
subplot(1,2,1);
    plot(t,SIG0*SIG_N(t*rho_bar),'k'); hold on;
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xlabel('\rho_{max}')
    ylabel(['Total EEG power (' char(956) 'V^2)'])
    ylim([1e-4,1e4]);
    yticks([1e-4,1,1e4])
    gcaformat;
    t0 = interp1(SIG0*SIG_N(t*rho_bar),t,1);
    t1 = interp1(SIG0*SIG_N(t*rho_bar),t,100);
    fill([t0,t1,t1,t0],[1e-4,1e-4,100,1],'r','LineStyle','none','FaceAlpha',0.2);
    idcs = find(and(t>t0,t<t1));
    plot(t(idcs),SIG0*SIG_N(t(idcs)*rho_bar),'r','LineWidth',1);
subplot(1,2,2);
    plotwitherror(freq,P0*SIG_N(0.1*rho_bar),'Q','color','r');
    plotwitherror(freq,pre,'Q','color',[0.6,0.6,0.6]);
    % plot(freq,median(pre,2),'k')
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    % xlim([1,300]);
    % xticks([1,10,100]);
    % xticklabels([1,10,100]);
    xlim([0.5,50]);
    xticks([0.5,5,50])
    xticklabels([0.5,5,50])
    xlabel('Frequency (Hz)');
    ylim([1e-2,2e2])
    yticks([1e-2,1,1e2])
    ylabel(['PSD (' char(956) 'V^2/Hz)'])
    % ylim([1e-2,1e2])
gcaformat(gcf);
