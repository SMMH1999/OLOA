function [alpha, pMutation, sigma] = SBO_parameters(LB, UB)
%Greatest step size
alpha = 0.94;

%Mutation probability
pMutation = 0.05;

%Percent of the difference between the upper and lower limit
Z = 0.02;

%proportion of space width
sigma = Z * (max(UB) - min(LB));
end