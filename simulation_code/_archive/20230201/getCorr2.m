function getCorr2(masterPath)
load('/home/nbrake/data/resources/head_models/sa_nyhead.mat');
idcs = sa.cortex2K.in_from_cortex75K;

% masterPath = '/lustre04/scratch/nbrake/data/simulations/raw/synapse_embedding_2';
F = dir(masterPath); tempIdcs = find([F(:).isdir]);
F = F(tempIdcs(3:end));
folder = masterPath;

% m = sort([0.999,0.997,0.99,0.98,0.95,0.86,0.63,0]);
m = sort([0.99,0.98,0.95,0.86,0.63,0]);

C = zeros(length(F),30);
P = zeros(2e3,10,length(F));
for i = 1:length(m)
    folder3 = fullfile(masterPath,['m=' num2str(m(i))]);
    % F2 = dir(folder); tempIdcs = find([F2(:).isdir]);
    % F2 = F2(tempIdcs(3:end));
    % for j = 1:length(F2)
    %     folder3 = fullfile(folder,F2(j).name);
        F3 = dir(folder3);
        % idcs = find(cellfun(@(x) ~isempty(x),strfind({F3(:).name},'LFPy_ef')));
        idcs2 = find(cellfun(@(x) ~isempty(x),strfind({F3(:).name},'rep')));
        F3 = F3(idcs2);
        M0 = length(F3);
        for rep = 1:M0
            % folder2 = fullfile(folder,F2(j).name,['LFPy_' int2str(rep)]);
            % folder2 = fullfile(folder3,F3(rep).name);
            folder2 = fullfile(folder3,F3(rep).name,'LFPy_ef=0');
            load(fullfile(folder2,'simulation_data.mat'));
            for k = 1:length(idcs)
                eeg = getEEG(dipoles,sa,idcs(k));
                C(i,rep) = C(i,rep) + corr(eeg(:,1),eeg(:,2));
            end
            C(i,rep) = C(i,rep)/length(idcs);
        end
        % C(i,j) = C(i,j)/M0/length(idcs);
    % end
end

save(fullfile(masterPath,'correlations.mat'),'C');
end
function W = getEEG(Q,sa,idx)
    % Lead field for Cz recording
    L0 = squeeze(sa.cortex75K.V_fem(49,idx,:))'; % czIDX = 49

    % Orient dipole "up" direction to be normal to cortical surface
    vz = sa.cortex75K.normals(idx,:);
    [vx,vy] = getOrthBasis(vz);
    q = (Q(:,1,:).*vx+Q(:,2,:).*vy+Q(:,3,:).*vz)*1e-12; % nAum -> mAm

    W = squeeze(sum(L0.*q,2)*1e6); % V -> uV
end
function [x1,x2] = getOrthBasis(x0)
    if(prod(size(x0))==3)
        if(x0>0.9)
            x1 = [0,1,0];
        else
            x1 = [1,0,0];
        end
        x1 = x1-x0*sum(x1.*x0);
        x1 = x1/norm(x1,2);
        x2 = cross(x1,x0);
    else
        idcs = x0(:,1)>0.9;
        x1 = zeros(size(x0));
        x1(idcs,2) = 1;
        x1(~idcs,1) = 1;

        x1 = x1-x0.*sum(x1.*x0,2);
        x1 = x1./vecnorm(x1,2,2);
        x2 = cross(x1,x0);
    end
end