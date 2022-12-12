function [ids,ts,ei,C,m0] = simulatespikes_det(NE,branchNo,tmax,C,phase)

dt = 4e-3;

% Look up table for node indices
for i = 1:NE
    CLUT{i} = find(C(:,1)==i);
end

% tmax = 10;
t = 0:dt:tmax;
tN = length(t);
X = zeros(NE,tN);

% Initialize
ids = -ones(ceil(2*NE*tmax),1);
ts = -ones(ceil(2*NE*tmax),1);
lamE = 1;
lamI = 2;

% Random external input
nTrans = poissrnd(lamE*dt*NE);
ids(1:nTrans) = randperm(NE,nTrans);
post = ids(1:nTrans);
k = nTrans;
ts(1:nTrans) = t(1)*ones(nTrans,1);
count = nTrans;
m0 = zeros(tN-1,1);
m0(1) = branchNo;

exN = poissrnd(lamE*dt*NE*(1-branchNo),tN,1);
lamE = 1+0.9*sin(2*pi*t*10+pi*phase);

for i = 2:tN-1
    % Get spiking cells at previous time point
    % preI = unique(ids(count-nTrans+1:count));
    preI = ids(count-nTrans+1:count);
    jj = cat(1,CLUT{preI});

    % For each spiking cell, find neighbours...
    postI = C(jj,2);
    % ... and start flipping coins
    iTrans = find(rand(length(jj),1)<C(jj,3));
    postI = postI(iTrans);
    nTrans = length(postI);

    % Correct for redundent spike propogations
    % postI = unique(postI(iTrans));
    if(length(preI)>0)
        % m0 = m0 + (min(nTrans/length(preI),branchNo)-m0)/i;
        m0(i) = nTrans/length(preI);
    end
    exN(i) = poissrnd(lamE(i)*dt*NE*(1-branchNo));

    % Add propogated spikes
    ids(count+1:count+nTrans) = postI;
    ts(count+1:count+nTrans) = t(i)+dt*rand(nTrans,1);;
    count = count+nTrans;

    % Add external noise
    ids(count+1:count+exN(i)) = randperm(NE,exN(i));
    ts(count+1:count+exN(i)) = t(i)+dt*rand(exN(i),1);
    count = count+exN(i);
    nTrans = nTrans + exN(i);
end
ts(count:end) = [];
ids(count:end) = [];


B = (lamI/mean(lamE)-1)*histcounts(ts,t)/NE/dt;
B = 2+0*B;

ts = repmat(ts,[5,1]);
ids = repmat(ids,[5,1]);
NI = floor(0.25*NE);
for i = 1:tN-1
    nTrans = poissrnd(B(i)*dt*NI,1,1);
    ids(count+1:count+nTrans) = randperm(NI,nTrans)+NE;
    ts(count+1:count+nTrans) = t(i)+dt*rand(nTrans,1);
    count = count+nTrans;
end
ts(count+1:end) = [];
ids(count+1:end) = [];
ei = [zeros(1,NE),ones(1,NI)];


ts = ts*1e3;