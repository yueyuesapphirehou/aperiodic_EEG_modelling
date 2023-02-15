function figure3a(dataFolder)

if(nargin<1)
    error('Path to data required as input argument. Data can be downloaded from link in README file.');
end

network = network_simulation_beluga(pwd);
network.branchNo = 0.98;
% N = 30000;
N = 1000;
disp('Neuron count set to 1,000 for faster computation. Figure in paper uses n=30000');
[ids,ts,ei] = network.simulatespikes_critplane(N,5e3);
ts = ts+5e3;

loc = csvread(fullfile(pwd,'presynaptic_network','locations.csv'));

d = vecnorm(loc-[0.55,0.1],2,2);
[I1,I2] = sort(d,'ascend');
for i = 1:length(d)
    I3(i) = find(I2==i);
end
ids2 = I3(ids);

[h,bins] = histcounts(ts,'BinWidth',4); 
h = h/N/4e-3;
t0 = bins(1:end-1)+2;

fig = figureNB(3.5,2.8);
axes('Position',[0.15,0.14,0.8,0.7]);
    raster(ids2,ts,fig);
    ylim(range(ids)*[-0.1,1.2]);
    axis off
    line([9e3,10e3],-0.1*max(ids)*[1,1],'color','k','LineWidth',1)
    text(9500,-0.12*max(ids),'1 s','FontSize',6,'VerticalAlignment','top','HorizontalAlignment','center');
    xlim([5e3,10e3]);
    text(4.9e3,max(ids)/2,{'Presynaptic','neurons'},'Rotation',90,'FontSize',6,'HorizontalAlignment','center','VerticalAlignment','bottom');
axes('Position',[0.15,0.8,0.8,0.15]);
    plot(t0,h,'k');
    xlim([5e3,10e3]);
    ylim([0,5])
    yticklabels([]);
    yticks([0,5]);
    gcaformat;
    set(get(gca,'xaxis'),'visible','off');
    text(4.9e3,2.5,{'Hz',''},'Rotation',90,'FontSize',6,'HorizontalAlignment','center','VerticalAlignment','bottom');
    text(4.9e3,0,'0 ','FontSize',6,'HorizontalAlignment','right','VerticalAlignment','middle');
    text(4.9e3,5,'5 ','FontSize',6,'HorizontalAlignment','right','VerticalAlignment','middle');
