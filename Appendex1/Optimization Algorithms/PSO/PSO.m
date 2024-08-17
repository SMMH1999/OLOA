function [globalBest_Fitness, globalBest_Position, PSO_Change_Curve, globalBest_Fitness_Per_Itr] = PSO(LB, UB, Dim, Particles_no, Max_iter, Cost_Function, Function_Number)

    %% Parameters
    w = 1;  % Inertia weight
    c1 = 2;  % Cognitive (personal) acceleration coefficient
    c2 = 2;  % Social (global) acceleration coefficient
    globalBest_Fitness_Per_Itr = inf(Max_iter,1);
    fitness = inf(Particles_no,1);


    %% Initialize the particles
    Positions = rand(Particles_no, Dim) * (UB - LB) + LB;  % Random Positions within bounds
    velocities = zeros(Particles_no, Dim);  % Initial velocities
    personalBest_Positions = Positions;  % Best Positions of each particle
    personalBest_Fitnesss = inf(Particles_no, 1);  % Best fitness of each particle
    globalBest_Fitness = inf;  % Best score of the swarm
    globalBest_Position = zeros(1, Dim);  % Best position of the swarm

    %% Main loop
    for Itr = 1 : Max_iter

        for i = 1 : Particles_no
            % Evaluate the objective function
            % fitness = Cost_Function(Positions(i,:)', Function_Number);
            fitness(i) = Cost_Function(Positions(i,:)', Function_Number);
        end

        %% Update personal best Positions and fitness
        betterIndices = fitness < personalBest_Fitnesss;
        personalBest_Fitnesss(betterIndices) = fitness(betterIndices);
        personalBest_Positions(betterIndices, :) = Positions(betterIndices, :);

        %% Update global best position and score
        [minFitness, minIndex] = min(fitness);
        if minFitness < globalBest_Fitness
            globalBest_Fitness = minFitness;
            globalBest_Position = Positions(minIndex, :);
        end

        globalBest_Fitness_Per_Itr(Itr, 1) = globalBest_Fitness;
        if Itr > 1
            if globalBest_Fitness > globalBest_Fitness_Per_Itr(Itr - 1, 1)
                globalBest_Fitness_Per_Itr(Itr, 1) = globalBest_Fitness_Per_Itr(Itr - 1, 1);
            end
        end

        %% Update velocities and Positions
        for i = 1:Particles_no
            r1 = rand(1, Dim);
            r2 = rand(1, Dim);
            cognitiveComponent = c1 * r1 .* (personalBest_Positions(i, :) - Positions(i, :));
            socialComponent = c2 * r2 .* (globalBest_Position - Positions(i, :));
            velocities(i, :) = w * velocities(i, :) + cognitiveComponent + socialComponent;
            Positions(i, :) = Positions(i, :) + velocities(i, :);

            % Apply the bounds to the Positions
            Positions(i, :) = max(min(Positions(i, :), UB), LB);
        end
    end

    PSO_Change_Curve = globalBest_Fitness_Per_Itr;
end
