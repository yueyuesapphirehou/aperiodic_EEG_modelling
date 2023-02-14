function figure3b(dataFolder)

load(fullfile(dataFolder,'simulations_synapse_dipole_orientation.mat'));

dMag = squeeze(max(vecnorm(dipoles,2,2)));
dMag./max(dMag)*3;

dipole_moment = squeeze(nanmedian(dipoles./vecnorm(dipoles,2,2)))';
dipole_moment = [dipole_moment(:,1),dipole_moment(:,3),-dipole_moment(:,2)];
dipole_moment(find(E_or_I==0),:) = -dipole_moment(find(E_or_I==0),:);

clrs = [230, 25, 75;
    60, 180, 75];

[theta0,phi0] = cart2sph(synapse_position(:,1),synapse_position(:,2),synapse_position(:,3));
[theta1,phi1] = cart2sph(dipole_moment(:,1),dipole_moment(:,2),dipole_moment(:,3));
synapse_position_pol = [theta0,phi0];
PD_pol = [theta1,phi1];

% gIdcs = cellfun(@(x)isempty(strfind(x,'E')),{network.neurons.mType});
gIdcs = 1-E_or_I;
clrs = [0,0,1;1,0,0];
clrs = clrs(gIdcs+1,:);

% Remove points close to the corners of the plot (to avoid variation crossing periodic boundary conditions being displayed)
idcs1 = find(~and(PD_pol(:,1)<-0.85*pi,synapse_position_pol(:,1)>0.85*pi));
idcs2 = find(~and(PD_pol(:,2)<-0.85*pi/2,synapse_position_pol(:,2)>0.85*pi/2));
idcs = intersect(idcs1,idcs2);
% Room for label
idcs1 = find(~and(PD_pol(:,1)>0.85*pi,synapse_position_pol(:,1)<0));
idcs2 = find(~and(PD_pol(:,2)>0.75*pi/2,synapse_position_pol(:,2)<0.5));
idcs = intersect(idcs,intersect(idcs1,idcs2));
% Make data sparse for display purposes
idcs = idcs(randperm(size(idcs,1),400));

% fig = figureNB(5,2.75);
fig = figureNB(5.5,3);
ax(1) = axes('Position',[0.16,0.3,0.3,0.55]);
ax(2) = axes('Position',[0.6,0.3,0.3,0.55]);
for i = 1:2
    axes(ax(i));
    scatter(synapse_position_pol(idcs,i),PD_pol(idcs,i),dMag(idcs),'k','filled'); hold on;
    FT = fitlm(synapse_position_pol(idcs,i),PD_pol(idcs,i),'Weights',dMag(idcs))
    % plot([-1,1],FT.predict([-1;1]),'color','k');    R2(i) = FT.Rsquared.Adjusted;
end
axes(ax(1));
    gcaformat;
    % title('Azimuth','FontSize',7);
    ylabel('Dipole moment')
    xlim([-pi,pi]); xticks([-pi,0,pi]);
    ylim([-pi,pi]); yticks([-pi,0,pi]);
    xticklabels({['-' '\pi'],'0',['\pi']});
    yticklabels({['-' '\pi'],'0',['\pi']});
    line([-pi,pi],[-pi,pi],'color','r');
    text(-pi+0.4,pi+0.2,'Azimuth','FontSize',6,'HorizontalAlignment','left','VerticalAlignment','top')
axes(ax(2));
    gcaformat;
    % title('Elevation','FontSize',7);
    xl = xlabel('Synapse location (rel. soma)');
    xl.Position = [-2.2,-2.5,-1];
    xlim([-pi,pi]/2); xticks([-pi/2,0,pi/2]);
    ylim([-pi,pi]/2); yticks([-pi/2,0,pi/2]);
    xticklabels({['-' '\pi' '/2'],'0',['\pi' '/2']})
    yticklabels({['-' '\pi' '/2'],'0',['\pi' '/2']})
    line([-pi,pi]/2,[-pi,pi]/2,'color','r');
    text(-pi/2+0.2,pi/2+0.1,'Elevation','FontSize',6,'HorizontalAlignment','left','VerticalAlignment','top')
gcaformat(fig);