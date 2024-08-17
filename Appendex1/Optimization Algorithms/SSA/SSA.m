function [Best_Salp_Fitness, Best_Salp_Position, Salp_Change_Curve, Salp_Fitness_Per_Itr] = SSA(LB, UB, Dim, Salp_no, Max_Itr, Cost_Function, Function_Number)

    % Initialize the salps
    Positions = rand(Salp_no, Dim) .* (UB - LB) + LB;
    Salp_Fitness_Per_Itr = inf(Max_Itr,1);

    Fitness = inf(Salp_no,1);
    for i = 1 : Salp_no
        Fitness(i) = Cost_Function(Positions(i,:)', Function_Number);
    end

    % Initialize the leader (best solution found so far)
    [Best_Salp_Fitness, Best_Salp_Index] = min(Fitness);
    Best_Salp_Position = Positions(Best_Salp_Index, :);

    % Main loop of SSA
    for Itr = 1 : Max_Itr
        c1 = 2 * exp(-(4 * Itr / Max_Itr)^2);

        for i = 1 : Salp_no
            if i == 1
                % Update the leader
                for j = 1 : Dim
                    c2 = rand();
                    c3 = rand();
                    if c3 < 0.5
                        Positions(i, j) = Best_Salp_Position(j) + c1 * ((UB - LB) * c2 + LB);
                    else
                        Positions(i, j) = Best_Salp_Position(j) - c1 * ((UB - LB) * c2 + LB);
                    end
                end
            else
                % Update the followers
                Positions(i, :) = (Positions(i, :) + Positions(i - 1, :)) / 2;
            end

            % Bound check
            Positions(i, :) = max(min(Positions(i, :), UB), LB);

            % Calculate fitness
            Fitness(i) = Cost_Function(Positions(i,:)', Function_Number);

            % Update the leader if a better solution is found
            if Fitness(i) < Best_Salp_Fitness
                Best_Salp_Fitness = Fitness(i);
                Best_Salp_Position = Positions(i, :);
            end
        end

        Salp_Fitness_Per_Itr(Itr, 1) = Best_Salp_Fitness;
        if Itr > 1
            if Best_Salp_Fitness > Salp_Fitness_Per_Itr(Itr - 1, 1)
                Salp_Fitness_Per_Itr(Itr, 1) = Salp_Fitness_Per_Itr(Itr - 1, 1);
            end
        end
    end
    Salp_Change_Curve = Salp_Fitness_Per_Itr;
end
