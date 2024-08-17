function [Best_Fitness, Best_Position, Fitness_Curve, Best_Fitness_Per_Itr] = OLOA(LB, UB, Dim, lyrebirds_no, Max_iter, Cost_Function, Function_Number)
    % Lyrebird Optimization Algorithm (LOA)
    % Parameters
    % Dim = 5;          % Number of variables
    % lyrebirds_no = 20;         % Number of lyrebirds
    % Max_iter = 100;       % Maximum number of iterations
    crossover_rate = 0.8;       % Crossover rate
    mutation_rate = 0.3;        % Mutation rate
    sigma = 0.9;                % Mutation standard deviation
    % LB = -10;                   % Lower bounds for variables
    % UB = 10;                    % Upper bounds for variables

    %% Initialize lyrebirds
    lyrebirds = rand(lyrebirds_no, Dim) * (UB - LB) + LB;
    Best_Fitness_Per_Itr = inf(Max_iter, 1);
    fitness = zeros(lyrebirds_no, 1);

    %% Main loop
    for Itr = 1:Max_iter
        %% Oppositing Population
        [lyrebirds, ~] = Opposite(LB, UB, lyrebirds, Cost_Function, Function_Number);

        %% Evaluate fitness for each lyrebird
        fitness = Cost_Function(lyrebirds', Function_Number);

        %% Sort lyrebirds based on fitness
        [fitness, sorted_indices] = sort(fitness);
        lyrebirds = lyrebirds(sorted_indices, :);

        %% Selection: keep the top half of lyrebirds
        lyrebirds = lyrebirds(1:lyrebirds_no/2, :);

        %% Crossover
        num_crossovers = round(crossover_rate * lyrebirds_no/2);
        for i = 1:num_crossovers
            % Select two parents randomly
            parent1_index = randi([1, lyrebirds_no/2]);
            parent2_index = randi([1, lyrebirds_no/2]);
            parent1 = lyrebirds(parent1_index, :);
            parent2 = lyrebirds(parent2_index, :);

            % Perform crossover (blend crossover)
            alpha = rand();
            child1 = alpha * parent1 + (1 - alpha) * parent2;
            child2 = (1 - alpha) * parent1 + alpha * parent2;

            % Add children to the population
            lyrebirds = [lyrebirds; child1; child2];
        end

        %% Mutation
        num_mutations = round(mutation_rate * lyrebirds_no);
        for i = 1:num_mutations
            % Select a lyrebird randomly
            lyrebird_index = randi([1, lyrebirds_no]);
            lyrebird = lyrebirds(lyrebird_index, :);

            % Perform mutation (additive Gaussian mutation)
            mutation = sigma * randn(1, Dim);
            lyrebird = lyrebird + mutation;

            % Ensure mutated lyrebird stays within bounds [LB, UB]
            lyrebird = min(max(lyrebird, LB), UB);

            % Replace the old lyrebird with the mutated one
            lyrebirds(lyrebird_index, :) = lyrebird;
        end

        %% Display best solution
        Best_Position = lyrebirds(1, :);
        Best_Fitness = fitness(1);
        Best_Fitness_Per_Itr(Itr) = Best_Fitness;
    end

    %% Final Outputs
    Fitness_Curve = Best_Fitness_Per_Itr;
end

function [Population, Fitness] = Opposite(LB, UB, Population, Cost_Function, Function_Number)
    % Make Opposition Population Based on Opposite Number Definition
    OppositePopulation = LB + UB - Population.* rand();

    % Calculate Fitness for Population and OppositePopulation
    Fitness = Cost_Function(Population', Function_Number);
    OppositeFitness = Cost_Function(OppositePopulation', Function_Number);

    % Change Population loop
    for i = 1:size(Population,1)
        % Change solution i-th of Population with solution i-th of OppositePopulation
        % If OppositeFitness is better than Fitness i-th solution
        if OppositeFitness(i) < Fitness(i)
            Population(i, :) = OppositePopulation(i, :);
            Fitness(i) = OppositeFitness(i);
        end
    end

    % Sort Population based on fitness
    [Fitness, sorted_indices] = sort(Fitness);
    Population = Population(sorted_indices, :);

end