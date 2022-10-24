tmax = 2e3;

tau_decay =  [10,15,20];
tau_change = [2,3];
gam_change = [1,2,3];
lam_change = [0.9,0.7,0.5];

[tau,dtau,dgam,dlam] = ndgrid(tau_decay,tau_change,gam_change,lam_change);

param_changes = [tau(:),dtau(:),dgam(:),dlam(:)];
param_init = cat(2,tau_decay(:),ones(3,3));
params = [param_init;param_changes];

estimatedTime = size(params,1)*1.426/60;
availableTime = diff(datenum([datetime('now')+5/24;datetime(2022,10,23)+10/24]))*24;

N = floor(availableTime/estimatedTime)

masterPath = 'C:\Users\brake\Documents\temp\parameter_search';
network = network_simulation(fullfile(masterPath,'_template'));
network = network.initialize_postsynaptic_network(N);
network = network.initialize_presynaptic_network(0,tmax);
network.form_connections;

for j = 1:size(params,1)
    name = ['param_combo_' int2str(j)];
    folder = fullfile(masterPath,name);
    network2 = network.copy_network(folder);

    fid = fopen(fullfile(folder,'params.csv'),'w');
    fprintf(fid,'tau,dtau,dgam,dlam\n');
    fprintf(fid,'%d,%d,%d,%.1f',params(j,:));
    fclose(fid);

    propofol = sum(params(j,1:3).*[100,10,1]);
    network2 = network2.addPropofol(propofol);

    rate = params(j,4);
    network2 = network2.setFiringRate(rate,rate/0.15);

    network2 = network2.simulate();
end