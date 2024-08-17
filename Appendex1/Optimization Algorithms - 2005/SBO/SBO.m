function [Elite_Fitness, Elite_Position, Bower_Change_Curve, Elite_Fitness_Per_Itr] = SBO(LB, UB, Dim, Bower_no, Max_iter, Cost_Function, Function_Number)
    % SBO Parameters and Initialization
    [alpha, pMutation, sigma] = SBO_parameters(LB, UB);
    [Populations, Elite_Position] = Initialization(Bower_no, LB, UB, Dim, Cost_Function, Function_Number);
    Elite_Fitness_Per_Itr = inf(Max_iter, 1);

    % SBO Main Loop
    for Itr = 1 : Max_iter
        newPopulations = Populations;

        % Calculating the Fitness of each bower
        F = zeros(Bower_no, 1);
        for i = 1 : Bower_no
            if Populations(i).Fitness >= 0
                F(i) = 1 / (1 + Populations(i).Fitness);
            else
                F(i) = 1 + abs(Populations(i).Fitness);
            end
        end

        % Calculating the probability of each bower
        P = F / sum(F);

        % Changes at any bower
        for i = 1 : Bower_no
            for k = 1 : Dim
                % Select target bower
                j = RouletteWheelSelection(P);

                % Calculating Step Size
                lambda = alpha / (1 + P(j));
                newPopulations(i).Position(k) = Populations(i).Position(k) + lambda * (((Populations(j).Position(k) + Elite_Position(k)) / 2) - Populations(i).Position(k));

                % Mutation
                if rand <= pMutation
                    newPopulations(i).Position(k) = newPopulations(i).Position(k) + (sigma * randn);
                end
            end

            % Evaluation
            newPopulations(i).Fitness = Cost_Function(newPopulations(i).Position);
        end

        Populations = [Populations newPopulations]; %#ok

        % Sort Population
        [~, SortOrder] = sort([Populations.Fitness]);
        Populations = Populations(SortOrder);
        Populations = Populations(1 : Bower_no);

        % Update Best Solution Ever Found
        Best_Solution = Populations(1);
        Elite_Position = Best_Solution.Position;

        % Store Best Fitness Ever Found
        Elite_Fitness_Per_Itr(Itr) = Best_Solution.Fitness;
        if Itr > 1
            if Best_Solution.Fitness > Elite_Fitness_Per_Itr(Itr - 1, 1)
                Elite_Fitness_Per_Itr(Itr, 1) = Elite_Fitness_Per_Itr(Itr - 1, 1);
            end
        end
    end
    Elite_Fitness = Elite_Fitness_Per_Itr(Max_iter, 1);
    Bower_Change_Curve = Elite_Fitness_Per_Itr;
end