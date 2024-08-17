function [Best_Chromosome_Fitness, Best_Chromosome_Position, Chromosome_Change_Curve, Best_Chromosome_Fitness_Per_Itr] = GA(LB, UB, Dim, Chromosome_no, Max_iter, Cost_Function, Function_Number)

    % Parameters
    crossover_prob = 0.8;
    mutation_prob = 0.01;
    fitness = inf(Chromosome_no, 1);
    Best_Chromosome_Fitness_Per_Itr = inf(Max_iter,1);

    % Initialize population
    population = LB + (UB - LB) * rand(Chromosome_no, Dim);

    % Main loop
    for Itr = 1:Max_iter
        % Evaluate fitness
        for i = 1 : Chromosome_no
            fitness(i) = Cost_Function(population(i,:));
        end

        % Selection
        selected_population = selection(population, fitness);

        % Crossover
        offspring_population = crossover(selected_population, crossover_prob);

        % Mutation
        mutated_population = mutation(offspring_population, mutation_prob, LB, UB);

        % Create new population
        population = mutated_population;

        % Best fitness value in each Itr
        Best_Chromosome_Fitness = min(fitness);
        Best_Chromosome_Fitness_Per_Itr(Itr, 1) = Best_Chromosome_Fitness;
        if Itr > 1
            if Best_Chromosome_Fitness > Best_Chromosome_Fitness_Per_Itr(Itr - 1, 1)
                Best_Chromosome_Fitness = Best_Chromosome_Fitness_Per_Itr(Itr - 1, 1);
                Best_Chromosome_Fitness_Per_Itr(Itr, 1) = Best_Chromosome_Fitness_Per_Itr(Itr - 1, 1);
            end
            if Best_Chromosome_Fitness < Best_Chromosome_Fitness_Per_Itr(Itr - 1, 1)
                Best_Chromosome_Index = Best_Chromosome_Fitness == fitness;
                Best_Chromosome_Position = population(Best_Chromosome_Index, :);
            end
        else
            Best_Chromosome_Index = Best_Chromosome_Fitness == fitness;
            Best_Chromosome_Position = population(Best_Chromosome_Index, :);
        end
    end

    % Display the best solution found
    % [Best_Chromosome_Fitness, Best_Chromosome_Index] = min(fitness);
    % Best_Chromosome_Position  = population(Best_Chromosome_Index, :);
    Chromosome_Change_Curve = Best_Chromosome_Fitness_Per_Itr;
end

function selected_population = selection(population, fitness)
    % Roulette wheel selection
    total_fitness = sum(fitness);
    probabilities = fitness / total_fitness;
    cumulative_probabilities = cumsum(probabilities);
    selected_population = zeros(size(population));
    for i = 1:size(population, 1)
        r = rand;
        selected_index = find(cumulative_probabilities >= r, 1, 'first');
        selected_population(i, :) = population(selected_index, :);
    end
end

function offspring_population = crossover(population, crossover_prob)
    num_individuals = size(population, 1);
    offspring_population = population;
    for i = 1:2:num_individuals
        if rand < crossover_prob
            crossover_point = randi([1, size(population, 2) - 1]);
            offspring_population(i, crossover_point:end) = population(i + 1, crossover_point:end);
            offspring_population(i + 1, crossover_point:end) = population(i, crossover_point:end);
        end
    end
end

function mutated_population = mutation(population, mutation_prob, LB, UB)
    num_individuals = size(population, 1);
    num_genes = size(population, 2);
    mutated_population = population;
    for i = 1:num_individuals
        for j = 1:num_genes
            if rand < mutation_prob
                mutated_population(i, j) = LB + (UB - LB) * rand;
            end
        end
    end
end
