% Compute expected EEG variance of 16 billion passive neurons
load('anatomy_cortical_pairwise_distance_distribution.mat')
signed_area = A;
total_area = B;
N = 16e9;
dMids = 0.5*(rValues(2:end)+rValues(1:end-1));
nrnCount = mean(diff(signed_area),2)*200000;
nrnCount(end) = N-sum(nrnCount(1:end-1));
corr_kernel = @(d) exp(-d.^2/10);
rho_bar = sum(corr_kernel(dMids).*nrnCount)/sum(nrnCount');
SIG_N = @(rho) N+N*(N-1)*rho;

% Get simulated passive spectrum
load('simulation_passive_spectra.mat')
asynchUnitarySpec = mean(mean(P(:,:,:),3),2);
SIG0 = sum(asynchUnitarySpec*mean(diff(f)));
% P0 = interp1(f,asynchUnitarySpec,freq);

folder = 'E:\Research_Projects\004_Propofol\data\simulations\raw\correlations';
F = dir(folder); F = F(3:end);
for i=  1:length(F)
    data{i} = csvread(fullfile(folder,F(i).name));
end
m = cellfun(@(x)str2num(x(3:end-4)),{F(:).name});
[m,I] =sort(m);
fr = cellfun(@(x)length(x),data)/(30000^2)*100;
fr = fr(I);

figureNB(9,5);
axes('Position',[0.12,0.19,0.18,0.73]);
    tt = [];
    dscale = 10.^linspace(-2,1,1e3);
    for i = 1:length(dscale)
        corr_kernel2 = @(d) exp(-d.^2/dscale(i));
        rho_bar = sum(corr_kernel2(dMids').*nrnCount)/sum(nrnCount');
        tt(i) = SIG0*SIG_N(rho_bar);
    end
    plot(dscale,tt,'k','LineWidth',1)
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    line(get(gca,'xlim'),[50,50],'color','r');
    line(get(gca,'xlim'),[200,200],'color','r');
    xlabel('\sigma^2 (mm)');
    ylabel(['Total EEG power (' char(956) 'V^2)'])
    xlim([dscale(1),dscale(end)]);
    ylim([1e-2,1e4]);
    title('\rho_{max} = 1','FontSize',7,'FontWeight','normal');
    gcaformat
axes('Position',[0.4,0.19,0.18,0.73]);
    dscale = 4;
    t = 10.^linspace(-2,log10(1),1e3);
    corr_kernel2 = @(d) exp(-d.^2/dscale);
    rho_bar = sum(corr_kernel2(dMids').*nrnCount)/sum(nrnCount');
    tt = SIG0*SIG_N(t*rho_bar);
    plot(t,tt,'k','LineWidth',1)
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    line(get(gca,'xlim'),[50,50],'color','r');
    line(get(gca,'xlim'),[200,200],'color','r');
    title(sprintf('%.2f',interp1(tt,t,200)),'FontSize',7,'FontWeight','normal');
    xlabel('\rho_{max}')
    ylim([1e-2,1e4]);
    title('\sigma^2 = 4 mm','FontSize',7,'FontWeight','normal');
    gcaformat
axes('Position',[0.76,0.19,0.21,0.73]);
    plot(1./(1-m(:)),fr(:),'.-k','MarkerSize',15,'LineWidth',1)
    ylabel('Correlated synapse pairs (STTC>0.25)')
    xlabel('1/(1-m)')
    set(gca,'xscale','log')
    ylim([0,1])
    yticks([0,0.5,1])
    yticklabels({'0%','0.1%','1%'})
    gcaformat

labelpanel(0.0075,0.94,'a',true);
labelpanel(0.6,0.94,'b',true);