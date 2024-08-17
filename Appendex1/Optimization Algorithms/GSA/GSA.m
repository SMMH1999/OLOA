function [Best_Fitness,Best_Position,Best_Change_Curve,Best_Fitness_Per_Itr]= GSA(LB, UB, Dim, Agent_no, Max_iter, Cost_Function, Function_Number)
    % Gravitational Search Algorithm.

    %% Initialize
    Rnorm = 2;
    Rpower = 1;
    ElitistCheck = 1;
    V = zeros(Agent_no, Dim);
    Best_Fitness_Per_Itr = inf(Max_iter, 1);

    % V:   Velocity.
    % a:   Acceleration.
    % M:   Mass.  Ma=Mp=Mi=M;
    % R:   Distance between agents in search space.
    % Rnorm:  Norm in eq.8.
    % Rpower: Power of R in eq.7.

    % random initialization for agents.
    Positions = initialization(Agent_no, Dim, UB, LB);


    %% Main loop
    for Itr = 1 : Max_iter
        % Checking allowable range.
        Positions = space_bound(Positions, UB, LB);

        for i = 1 : Agent_no
            %Evaluation of agents.
            fitness(i) = Cost_Function(Positions(i,:)', Function_Number);
        end


        % Best fitness value in each Itr
        Best_Fitness = min(fitness);
        Best_Fitness_Per_Itr(Itr, 1) = Best_Fitness;
        if Itr > 1
            if Best_Fitness > Best_Fitness_Per_Itr(Itr - 1, 1)
                Best_Fitness = Best_Fitness_Per_Itr(Itr - 1, 1);
                Best_Fitness_Per_Itr(Itr, 1) = Best_Fitness_Per_Itr(Itr - 1, 1);
            end
            if Best_Fitness < Best_Fitness_Per_Itr(Itr - 1, 1)
                Best_Fitness_Index = Best_Fitness == fitness;
                Best_Position = Positions(Best_Fitness_Index, :);
            end
        else
            Best_Fitness_Index = Best_Fitness == fitness;
            Best_Position = Positions(Best_Fitness_Index, :);
        end


        % Calculation of M. eq.14-20
        [M] = massCalculation(fitness, 1);

        % Calculation of Gravitational constant. eq.13.
        G = Gconstant(Itr, Max_iter);

        % Calculation of accelaration in gravitational field. eq.7-10,21.
        a = Gfield(M, Positions, G, Rnorm, Rpower, ElitistCheck, Itr, Max_iter);

        % Agent movement. eq.11-12
        [Positions, V] = move(Positions, a, V);

    end

    Best_Change_Curve = Best_Fitness_Per_Itr;
end
