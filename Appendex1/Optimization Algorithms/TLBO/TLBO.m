function [Best_Population_Fitness, Best_Population_Position, Population_Change_Curve, Best_Fitness_Per_Itr] = TLBO(LB, UB, Dim, Population_no, Max_iter, Cost_Function, Function_Number)

    %% Problem Definition
    VarSize = [1 Dim]; % Unknown Variables Matrix Size

    %% Initialization
    % Empty Structure for Individuals
    empty_individual.Position = [];
    empty_individual.Fitness = [];

    % Initialize Population Array
    Population = repmat(empty_individual, Population_no, 1);

    % Initialize Best Solution
    Best_Population.Fitness = inf;

    % Initialize Population Members
    for i = 1 : Population_no
        Population(i).Position = initialization(LB, UB, Dim);
        Population(i).Fitness = Cost_Function(Population(i).Position',Function_Number);

        if Population(i).Fitness < Best_Population.Fitness
            Best_Population = Population(i);
        end
    end

    % Initialize Best Fitness Record
    Best_Fitness_Per_Itr = inf(Max_iter, 1);

    %% TLBO Main Loop
    for Itr = 1 : Max_iter

        %% Calculate Population Mean
        Mean = 0;
        for i = 1 : Population_no
            Mean = Mean + Population(i).Position;
        end
        Mean = Mean / Population_no;

        %% Select Teacher
        Teacher = Population(1);
        for i = 2 : Population_no
            if Population(i).Fitness < Teacher.Fitness
                Teacher = Population(i);
            end
        end

        %% Teacher Phase
        for i = 1 : Population_no
            % Create Empty Solution
            newsol = empty_individual;

            % Teaching Factor
            % TF = randi([1 2]);
            TF = round(1 + rand());

            % Teaching (moving towards teacher)
            newsol.Position = Population(i).Position + rand(VarSize).*(Teacher.Position - TF*Mean);

            % Clipping
            newsol.Position = max(newsol.Position, LB);
            newsol.Position = min(newsol.Position, UB);

            % Evaluation
            newsol.Fitness = Cost_Function(newsol.Position',Function_Number);

            % Comparision
            if newsol.Fitness<Population(i).Fitness
                Population(i) = newsol;
                if Population(i).Fitness < Best_Population.Fitness
                    Best_Population = Population(i);
                end
            end
        end

        %% Learner Phase
        for i = 1 : Population_no

            A = 1 : Population_no;
            A(i) = [];
            j = A(randi(Population_no - 1));

            Step = Population(i).Position - Population(j).Position;
            if Population(j).Fitness < Population(i).Fitness
                Step = -Step;
            end

            % Create Empty Solution
            newsol = empty_individual;

            % Teaching (moving towards teacher)
            newsol.Position = Population(i).Position + rand(VarSize) .* Step;

            % Clipping
            newsol.Position = max(newsol.Position, LB);
            newsol.Position = min(newsol.Position, UB);

            % Evaluation
            newsol.Fitness = Cost_Function(newsol.Position',Function_Number);

            % Comparision
            if newsol.Fitness < Population(i).Fitness
                Population(i) = newsol;
                if Population(i).Fitness < Best_Population.Fitness
                    Best_Population = Population(i);
                end
            end
        end

        %% Store Record for Current Iteration
        % Best fitness value in each Itr
        Best_Population_Fitness = Best_Population.Fitness;
        Best_Fitness_Per_Itr(Itr, 1) = Best_Population_Fitness;
        if Itr > 1
            if Best_Population_Fitness > Best_Fitness_Per_Itr(Itr - 1, 1)
                Best_Population_Fitness = Best_Fitness_Per_Itr(Itr - 1, 1);
                Best_Fitness_Per_Itr(Itr, 1) = Best_Fitness_Per_Itr(Itr - 1, 1);
            end
            if Best_Population_Fitness < Best_Fitness_Per_Itr(Itr - 1, 1)
                Best_Population_Position = Best_Population.Position;
            end
        else
            Best_Population_Position = Best_Population.Position;
        end

    end
    Population_Change_Curve = Best_Fitness_Per_Itr;
end

function X = initialization(lb, ub, dim)
    Boundary_no = size(ub,2); % numnber of boundaries
    % If the boundaries of all variables are equal and user enter a signle
    % number for both ub and lb
    if Boundary_no == 1
        X = rand(1, dim) .* (ub - lb) + lb;
    end
    % If each variable has a different lb and ub
    if Boundary_no > 1
        for i = 1 : dim
            ub_i = ub(i);
            lb_i = lb(i);
            X(1, i) = rand(1, 1) .* (ub_i - lb_i) + lb_i;
        end
    end
end