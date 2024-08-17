function [Populations, Elite_Position] = Initialization(Population_no, LB, UB, Dim, Fitness_Function, Function_Number)
% Empty bower
bower.Position = [];
bower.Fitness = [];

% Create bowers Array
Populations = repmat(bower, Population_no, 1);

% Initialize bowers
for i = 1 : Population_no
    Populations(i).Position = rand(1, Dim) .* (UB - LB) + LB;
    Populations(i).Fitness = Fitness_Function(Populations(i).Position', Function_Number);
end

% Sort Population
[~, SortOrder]=sort([Populations.Fitness]);
Populations = Populations(SortOrder);

% Best Solution
BestSol = Populations(1);
Elite_Position = BestSol.Position;
end