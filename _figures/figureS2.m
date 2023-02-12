warning('off','MATLAB:handle_graphics:exceptions:SceneNode')

load('simulations_synapse_dipole_orientation.mat');
mType = unique(mTypes);
mTypes = findgroups(mTypes);

dMag = squeeze(max(vecnorm(dipoles,2,2)));
dMag./max(dMag)*3;

dipole_moment = squeeze(nanmedian(dipoles./vecnorm(dipoles,2,2)))';
dipole_moment = [dipole_moment(:,1),dipole_moment(:,3),-dipole_moment(:,2)];
dipole_moment(find(E_or_I==0),:) = -dipole_moment(find(E_or_I==0),:);

clrs = [230, 25, 75;
    60, 180, 75];

[theta0,phi0] = cart2sph(synapse_position(:,1),synapse_position(:,2),synapse_position(:,3));
[theta1,phi1] = cart2sph(dipole_moment(:,1),dipole_moment(:,2),dipole_moment(:,3));
SD_pol = [theta0,phi0];
PD_pol = [theta1,phi1];

% gIdcs = cellfun(@(x)isempty(strfind(x,'E')),{network.neurons.mType});
gIdcs = 1-E_or_I;
clrs = [0,0,1;1,0,0];
clrs = clrs(gIdcs+1,:);

% Remove points close to the corners of the plot (to avoid variation crossing periodic boundary conditions being displayed)
idcs1 = find(~and(PD_pol(:,1)<-0.85*pi,SD_pol(:,1)>0.85*pi));
idcs2 = find(~and(PD_pol(:,2)<-0.85*pi/2,SD_pol(:,2)>0.85*pi/2));
idcs = intersect(idcs1,idcs2);
% Room for label
idcs1 = find(~and(PD_pol(:,1)>0.85*pi,SD_pol(:,1)<0));
idcs2 = find(~and(PD_pol(:,2)>0.75*pi/2,SD_pol(:,2)<0.5));
idcs = intersect(idcs,intersect(idcs1,idcs2));
% Make data sparse for display purposes
idcs = idcs(randperm(size(idcs,1),400));

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
        scatter(SD_pol(j,1),PD_pol(j,1),2*dMag(j),clrs(j,:),'filled');
        xlim([-pi,pi]); ylim([-pi,pi]);
        xticks([-pi,0,pi]); yticks([-pi,0,pi]);
        xticklabels({'-\pi','0','\pi'});
        yticklabels({'-\pi','0','\pi'});
        line([-pi,pi],[-pi,pi],'color','k');
    axes('Position',[0.08+x*dx+0.6*xh,0.1+dy*y,0.35*xh,0.9*yh]);
        scatter(SD_pol(j,2),PD_pol(j,2),2*dMag(j),clrs(j,:),'filled');
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