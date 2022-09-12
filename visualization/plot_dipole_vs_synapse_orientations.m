
masterPath = 'E:\Research_Projects\004_Propofol\Modelling\neuron_simulations\data\simulations\dipole_orientation';
load(fullfile(masterPath,'data.mat'));
load(fullfile(masterPath,'synapse_compartments.mat'));

network = network.importResults;
d = network.results.dipoles;

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

gIdcs = cellfun(@(x)isempty(strfind(x,'E')),{network.neurons.mType});
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