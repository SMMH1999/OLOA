clear all;clc
% Main function for using GSA algorithm.

%  inputs:
% N:  Number of agents.
% max_it: Maximum number of iterations (T).
% ElitistCheck: If ElitistCheck=1, algorithm runs with eq.21 and if =0, runs with eq.9.
% Rpower: power of 'R' in eq.7.
% F_index: The index of the test function. See tables 1,2,3 of the mentioned article.
%          Insert your own objective function with a new F_index in 'test_functions.m'
%          and 'test_functions_range.m'.

%  outputs:
% Fbest: Best result. 
% Lbest: Best solution. The location of Fbest in search space.
% BestChart: The best so far Chart over iterations. 
% MeanChart: The average fitnesses Chart over iterations.

 N=50; 
 max_it=1000; 
 ElitistCheck = 1;
 Rpower = 1;
 min_flag=1; % 1: minimization, 0: maximization

 F_index = 1;
 [Fbest,Lbest,BestChart,MeanChart]=GSA(F_index,N,max_it,ElitistCheck,min_flag,Rpower);
 Fbest;
