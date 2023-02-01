function initialize_all_networks(masterPath,branchNo)
    for i = 1:1
        repPath = fullfile(masterPath,['rep' int2str(i)]);
        initialize_network(repPath,branchNo);
    end
end
