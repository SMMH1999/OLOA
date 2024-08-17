function [CostFunction, CostFunctionDetails, functionNo] = CEC_Benchmarks(Index)
%% This function return all informations we need about CEC

if Index == 1
    addpath(genpath('D:\Work\Research\Project-002\Appendex1\Optimization Algorithms - 2005'));
    rmpath(genpath('D:\Work\Research\Project-002\Appendex1\Optimization Algorithms'));
else
    rmpath(genpath('D:\Work\Research\Project-002\Appendex1\Optimization Algorithms - 2005'));
    addpath(genpath('D:\Work\Research\Project-002\Appendex1\Optimization Algorithms'));
end

% Address of CECs file
addressFile = readlines("D:\Work\Research\Project-002\Appendex1\Details\Address.txt");
address = addressFile(Index);
cd(address);

% Load CostFunctions
CostFunctions = readlines("D:\Work\Research\Project-002\Appendex1\Details\CostFunctions.txt");
CostFunction = str2func(CostFunctions(Index));

% Load CostFunctions informations like UperBound and etc
CostFunctionsDetails = readlines("D:\Work\Research\Project-002\Appendex1\Details\CostFunctionsDetails.txt");
CostFunctionDetails = str2func(CostFunctionsDetails(Index));

% Load and set functionNumber for each CECs
functionsNumber = readlines("D:\Work\Research\Project-002\Appendex1\Details\functionsNumber.txt");
functionNo = str2double(functionsNumber(Index));

end