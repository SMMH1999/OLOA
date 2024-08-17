function [Elite_Antlion_Fitness, Elite_Antlion_position, Antlion_Change_Curve, Elite_Antlion_Fitness_Per_Itr] = ALO(LB, UB, Dim, Antlion_no, Max_iter, Cost_Function, Function_Number)

    %% Initialize the positions of Antlions and Ants
    Antlion_position = initialization(Antlion_no, Dim, UB, LB);
    Ant_position = initialization(Antlion_no, Dim, UB, LB);

    %% Initialize variables
    Sorted_Antlions = zeros(Antlion_no, Dim);
    Elite_Antlion_position = zeros(1, Dim);
    Elite_Antlion_Fitness = inf;
    Elite_Antlion_Fitness_Per_Itr = zeros(Max_iter, 1);
    Antlions_Fitness = inf(Antlion_no);
    Ants_Fitness = inf(Antlion_no);

    %% Calculate the Fitness of initial Antlions and sort them
    for i = 1 : size(Antlion_position, 1)
        Antlions_Fitness(i) = Cost_Function(Antlion_position(i,:));
    end

    [sorted_Antlion_Fitness, sorted_indexes] = sort(Antlions_Fitness);

    for newindex = 1 : Antlion_no
        Sorted_Antlions(newindex, :) = Antlion_position(sorted_indexes(newindex), :);
    end

    Elite_Antlion_position = Sorted_Antlions(1, :);
    Elite_Antlion_Fitness = sorted_Antlion_Fitness(1);

    Elite_Antlion_Fitness_Per_Itr(1, 1) = Elite_Antlion_Fitness;

    %% Main loop start from the second iteration since the first iteration
    % was dedicated to calculating the Fitness of Antlions
    Itr = 2;
    while Itr < Max_iter + 1

        %% This for loop simulate random walks
        for i = 1 : size(Ant_position, 1)
            % Select Ant lions based on their Fitness (the better anlion the higher chance of catching Ant)
            Rolette_index = RouletteWheelSelection(1 ./ sorted_Antlion_Fitness);
            if Rolette_index == -1
                Rolette_index = 1;
            end

            % RA is the random walk around the selected Antlion by rolette wheel
            RA = Random_walk_around_Antlion(Dim, Max_iter, LB, UB, Sorted_Antlions(Rolette_index, :), Itr);

            % RA is the random walk around the elite (best Antlion so far)
            [RE] = Random_walk_around_Antlion(Dim, Max_iter, LB, UB, Elite_Antlion_position(1, :), Itr);

            Ant_position(i, :) = (RA(Itr, :) + RE(Itr, :)) / 2; % Equation (2.13) in the paper
        end

        for i = 1 : size(Ant_position, 1)

            % Boundar checking (bring back the Antlions of Ants inside search
            % space if they go beyoud the boundaries
            Flag4ub = Ant_position(i, :) > UB;
            Flag4lb = Ant_position(i, :) < LB;
            Ant_position(i, :) = (Ant_position(i, :) .* (~(Flag4ub + Flag4lb))) + UB .* Flag4ub + LB .* Flag4lb;

            Ants_Fitness(i) = Cost_Function(Ant_position(i, :));

        end

        %% Update Antlion positions and Fitnesses based of the Ants (if an Ant
        % becomes fitter than an Antlion we assume it was cought by the Antlion
        % and the Antlion update goes to its position to build the trap)
        double_population = [Sorted_Antlions; Ant_position];
        double_Fitness = [sorted_Antlion_Fitness Ants_Fitness];

        [double_Fitness_sorted I] = sort(double_Fitness);
        double_sorted_population = double_population(I, :);

        Antlions_Fitness = double_Fitness_sorted(1 : Antlion_no);
        Sorted_Antlions = double_sorted_population(1 : Antlion_no, :);

        %% Update the position of elite if any Antlinons becomes fitter than it
        if Antlions_Fitness(1) < Elite_Antlion_Fitness
            Elite_Antlion_position = Sorted_Antlions(1, :);
            Elite_Antlion_Fitness = Antlions_Fitness(1);
        end

        %% Keep the elite in the population
        Sorted_Antlions(1, :) = Elite_Antlion_position;
        Antlions_Fitness(1) = Elite_Antlion_Fitness;

        %% Update the convergence curve
        Elite_Antlion_Fitness_Per_Itr(Itr, 1) = Elite_Antlion_Fitness;
        if Itr > 1
            if Elite_Antlion_Fitness > Elite_Antlion_Fitness_Per_Itr(Itr - 1, 1)
                Elite_Antlion_Fitness_Per_Itr(Itr, 1) = Elite_Antlion_Fitness_Per_Itr(Itr - 1, 1);
            end
        end

        Itr = Itr + 1;
    end
    Antlion_Change_Curve = Elite_Antlion_Fitness_Per_Itr;
end