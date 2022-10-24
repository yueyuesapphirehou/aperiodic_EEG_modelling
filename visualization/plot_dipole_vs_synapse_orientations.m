
masterPath = 'E:\Research_Projects\004_Propofol\data\simulations\raw\synapse_orientations';
load(fullfile(masterPath,'data.mat'));
load(fullfile(masterPath,'synapse_compartments.mat'));

for i = 1:length(network.neurons)
    [~,nrnID] = fileparts(network.neurons(i).sim);
    network.neurons(i).sim = fullfile(masterPath,'LFPy',[nrnID ,'.csv']);
end
network.outputPath = masterPath;
network.postNetwork = fullfile(masterPath,'postsynaptic_network');
network.preNetwork = fullfile(masterPath,'presynaptic_network');
network = network.importResults;
d = network.results.dipoles;


[ids,ts,EI] = network.getprenetwork;
dMag = squeeze(max(vecnorm(d,2,2)));
dMag./max(dMag)*3

PD = squeeze(nanmedian(d./vecnorm(d,2,2)))';
PD = [PD(:,1),PD(:,3),-PD(:,2)];
PD(find(EI==0),:) = -PD(find(EI==0),:);

clrs = [230, 25, 75;
    60, 180, 75];

[theta0,phi0] = cart2sph(SD(:,1),SD(:,2),SD(:,3));
[theta1,phi1] = cart2sph(PD(:,1),PD(:,2),PD(:,3));
SD_pol = [theta0,phi0];
PD_pol = [theta1,phi1];

% gIdcs = cellfun(@(x)isempty(strfind(x,'E')),{network.neurons.mType});
gIdcs = 1-EI;
clrs = [1,0,0;0,0,1];
clrs = clrs(gIdcs+1,:);

fig = figureNB(5,2.75);
ax(1) = axes('Position',[0.16,0.3,0.3,0.55]);
ax(2) = axes('Position',[0.6,0.3,0.3,0.55]);
for i = 1:2
    axes(ax(i));
    scatter(SD_pol(:,i),PD_pol(:,i),2*dMag,clrs,'filled'); hold on;
    FT = fitlm(SD_pol(:,i),PD_pol(:,i),'Weights',dMag);
    % plot([-1,1],FT.predict([-1;1]),'color','k');    R2(i) = FT.Rsquared.Adjusted;
end
axes(ax(1));
    gcaformat;
    title('Azimuth','FontSize',7);
    ylabel('Dipole orientation')
    xlim([-pi,pi]); xticks([-pi,0,pi]); xticklabels({'-\pi','0','\pi'});
    ylim([-pi,pi]); yticks([-pi,0,pi]); yticklabels({'-\pi','0','\pi'});
    line([-pi,pi],[-pi,pi]);
    % text(pi,-pi,sprintf('R^2=%.2f',R2(1)),'FontSize',6,'HorizontalAlignment','right','VerticalAlignment','bottom')
axes(ax(2));
    gcaformat;
    title('Elevation','FontSize',7);
    xlabel('Synapse orientation')
    xlim([-pi,pi]/2); xticks([-pi/2,0,pi/2]); xticklabels({'-\pi/2','0','\pi/2'})
    ylim([-pi,pi]/2); yticks([-pi/2,0,pi/2]); yticklabels({'-\pi/2','0','\pi/2'})
    line([-pi,pi]/2,[-pi,pi]/2);
    % text(pi/2,-pi/2,sprintf('R^2=%.2f',R2(2)),'FontSize',6,'HorizontalAlignment','right','VerticalAlignment','bottom')
gcaformat(fig);



mTypes = {network.neurons.mType};
mType = unique(mTypes);
mTypes = findgroups(mTypes);

xh = 0.175;
yh = 0.2;
dx = (0.95-xh-0.05)/3;
dy = (0.95-yh-0.1)/2;

fig = figureNB(18.3,8);
for i = 1:11
    j = find(mTypes==i);
    y = 2-floor((i-1)/4);
    x = mod(i-1,4);
    % subplot(4,6,2*(i-1)+1);
    axes('Position',[0.08+x*dx,0.1+dy*y,0.35*xh,0.9*yh]);
        scatter(SD_pol(j,1),PD_pol(j,1),5*dMag(j),clrs(j,:),'filled');
        xlim([-pi,pi]); ylim([-pi,pi]);
        xticks([-pi,0,pi]); yticks([-pi,0,pi]);
        xticklabels({'-\pi','0','\pi'});
        yticklabels({'-\pi','0','\pi'});
        line([-pi,pi],[-pi,pi],'color','k');
    axes('Position',[0.08+x*dx+0.6*xh,0.1+dy*y,0.35*xh,0.9*yh]);
        scatter(SD_pol(j,2),PD_pol(j,2),5*dMag(j),clrs(j,:),'filled');
        xlim([-pi/2,pi/2]); ylim([-pi/2,pi/2]);
        xticks([-pi/2,0,pi/2]); yticks([-pi/2,0,pi/2]);
        xticklabels({'-\pi/2','0','\pi/2'});
        yticklabels({'-\pi/2','0','\pi/2'});
        line([-pi,pi]/2,[-pi,pi]/2,'color','k');
        tlt = title(mType{i},'interpret','latex');
        tlt.Position(1) = -pi*0.85;
        tlt.Position(2) = pi*0.6;
end
gcaformat(fig);