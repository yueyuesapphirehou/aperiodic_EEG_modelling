
M = 2;
T = 500;
N = 500;
drivers = randn(T,M);
k = randi(M,N,1);
X = zeros(T,N);
rho = 0.4;
for i = 1:N
    if(k(i)==1)
        w(1) = betarnd(5,2);
        w(2) = 1-w(1);
        w = w*rho;
    else
        w(1) = betarnd(2,5);
        w(2) = 1-w(1);
        w = w*rho;
    end
    X(:,i) = sum(w.*drivers,2)+sqrt(1-rho^2)*randn(T,1);
    W(i) = w(1)/rho;
end
dist_mat = 1-abs(corr(X));

flat_dist_mat = squareform(dist_mat);
res_linkage = linkage(flat_dist_mat);
res_order = seriation(res_linkage,N,2*N-1);
seriated_dist = dist_mat;
seriated_dist = seriated_dist(res_order,:);
seriated_dist = seriated_dist(:,res_order);

figureNB(5,2.75);
    imagesc((1-seriated_dist).*(1-eye(N)));
    set(gca,'CLim',[0,0.25])
    axis square;
    colormap(clrsPT.sequential(1e3))
    C = colorbar;
    C.Label.String = 'Pairwise correlation'
    C.Color = 'k'
    xlabel('Neuron count')
    ylabel('Neuron count')
    gcaformat;
    xlim([0,N])
    ylim([0,N])
    axis xy

dist_list = zeros(N*N,3);
l=1;
for i = 1:N
    for j = 1:N
        dist_list(l,:) = [i,j,dist_mat(i,j)];
        l = l+1;
    end
end
file = 'C:\Users\brake\Desktop\file.csv';
csvwrite(file,dist_list);
umapFile = 'C:\Users\brake\Desktop\umap.csv';
pyFun = 'E:\Research_Projects\004_Propofol\code\simulations\functions\embed_data.py';
[err,prints] = system(['python "' pyFun '" ' file ' ' umapFile]);
data = csvread(umapFile);
x = cos(data(:,2)).*sin(data(:,3));
y = sin(data(:,2)).*sin(data(:,3));
z = cos(data(:,3));
umap = [x(:),y(:),z(:)];
clrs0 = clrsPT.lines(2);
clrs = clrs0(1,:).*(k==1) + clrs0(2,:).*(k==2);

figureNB
    [xs,ys,zs] = sphere(25);
    ms = mesh(xs,ys,zs); hold on;
    ms.LineStyle = ':'
    ms.EdgeColor = 1-[1,1,1]*0.6;
    ms.FaceColor = 1-[1,1,1]*0.1;
    ms.FaceAlpha = 0.5;
    scatter3(umap(:,1),umap(:,2),umap(:,3),10,clrs,'filled');
    set(gca,'DataAspectRatio',[1,1,1]);
    axis off;



load('E:\Research_Projects\004_Propofol\data\resources\cortical_column_Hagen\segment_areas.mat');
mData = nrnSegs.L23E_oi24rpy1;
% mData = nrnSegs.L5E_j4a;
pos = [mean(mData.x,2),mean(mData.y,2),mean(mData.z,2)];

sa = mData.area;
X = pos(:,1);
Y = pos(:,2);
Z = pos(:,3);
theta = atan2(X,Y);
phi = -acos(Z);
dendriteEmbedding = [theta(:),phi(:)];
synapseEmbedding = data(:,2:3);
saCDF = cumsum(sa)/sum(sa);
% iSegs = interp1(saCDF,1:length(saCDF),rand(N,1),'next','extrap');
iSegs = randi(length(saCDF),N,1);
syn = zeros(size(iSegs));
remainingSyns = true(N,1);
for i = 1:N
    D = 1-network_simulation.haversine_distance2(dendriteEmbedding(iSegs(i),:),synapseEmbedding);
    [~,syn(i)] = max(D.*remainingSyns);
    remainingSyns(syn(i)) = false;
end

figureNB
    scatter3(pos(iSegs,1)+5*randn(size(iSegs)),pos(iSegs,2)+5*randn(size(iSegs)),pos(iSegs,3)+5*randn(size(iSegs)),5,clrs(3-k(syn),:),'filled');
    line(mData.x',mData.y',mData.z','color','k','LineWidth',0.5);
    set(gca,'DataAspectRatio',[1,1,1]);
    axis off;
