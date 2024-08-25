clear;
clc;
close all;
% delete(gcp('nocreate'));

if isempty(gcp)
    parpool;
end

for index = 1 : 6
    cd('D:\Work\Research\Project-002');
    addpath(genpath('D:\Work\Research\Project-002'));
    
    % Setting some variables
    CECsDim = cell([{"fix"}, [30, 100], [30, 100], {"fix"}, [10, 20], [10, 20]]);
    populationNo = 30;
    maxRun = 30;
    maxItr = 500;

    % if index ~= 1
    % if index ~= 2
    % if index ~= 3
    % if index ~= 4
    % if index ~= 5
    % if index ~= 6
    % if index ~= 1 && index ~= 5
    % if index ~= 1 && index ~= 6
    % if index ~= 4 && index ~= 5
    % if index ~= 5 && index ~= 6
    if index ~= 1 && index ~= 3 && index ~= 6
    % 
        continue;
    end
    
    Comparetor3(index, populationNo, maxRun, maxItr, CECsDim{index});
    rmpath(genpath('D:\Work\Research\Project-002'));

end
delete(gcp('nocreate'));