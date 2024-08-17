function [Best_Fitness, Best_Position, Fitness_Curve, Best_Fitness_Per_Itr] = DE(LB, UB, Dim, Pop_size, Max_iter, Cost_Function, Function_Number)
    % Differential Evolution (DE) Algorithm

    %% Initialization
    Best_Fitness_Per_Itr = inf(Max_iter, 1);
    Population = LB + (UB - LB) .* rand(Pop_size, Dim);
    Fitness = inf(Pop_size, 1);
    for i = 1:Pop_size
        Fitness(i) = Cost_Function(Population(i, :));
    end

    %% DE Parameters
    F = 0.5; % Mutation factor
    CR = 0.9; % Crossover rate

    %% Main Loop
    for Itr = 1:Max_iter
        for i = 1:Pop_size
            % Mutation
            idxs = randperm(Pop_size, 3);
            while any(idxs == i)
                idxs = randperm(Pop_size, 3);
            end
            mutant = Population(idxs(1), :) + F * (Population(idxs(2), :) - Population(idxs(3), :));
            mutant = max(mutant, LB);
            mutant = min(mutant, UB);

            % Crossover
            trial = Population(i, :);
            j_rand = randi(Dim);
            for j = 1:Dim
                if rand <= CR || j == j_rand
                    trial(j) = mutant(j);
                end
            end

            % Selection
            trial_fitness = Cost_Function(trial);
            if trial_fitness < Fitness(i)
                Population(i, :) = trial;
                Fitness(i) = trial_fitness;
            end
        end

        % Record Best Fitness
        [Best_Fitness, best_idx] = min(Fitness);
        Best_Fitness_Per_Itr(Itr) = Best_Fitness;
    end

    %% Final Outputs
    Best_Position = Population(best_idx, :);
    Fitness_Curve = Best_Fitness_Per_Itr;
end
