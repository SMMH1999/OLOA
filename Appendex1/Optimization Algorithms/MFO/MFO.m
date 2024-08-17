function [Best_flame_Fitness,Best_flame_Position,Moth_Change_Curve,Flame_Fitness_Per_Itr]= MFO(LB, UB, Dim, Moth_no, Max_iter, Cost_Function, Function_Number)

    %% Initialize the positions of moths
    Moth_Positions = initialization(Moth_no, Dim, UB, LB);
    Flame_Fitness_Per_Itr = inf(Max_iter, 1);

    %% Main loop
    for Itr = 1 : Max_iter
        %% Number of flames Eq. (3.14) in the paper
        Flame_no = round(Moth_no - Itr * ((Moth_no - 1) / Max_iter));
        for i = 1 : size(Moth_Positions, 1)
            % Check if moths go out of the search spaceand bring it back
            Flag4ub = Moth_Positions(i, :) > UB;
            Flag4lb = Moth_Positions(i, :) < LB;
            Moth_Positions(i, :) = (Moth_Positions(i, :) .* (~(Flag4ub + Flag4lb))) + UB .* Flag4ub + LB .* Flag4lb;

            % Calculate the fitness of moths
            Moth_Fitness(1,i) = Cost_Function(Moth_Positions(i, :));
        end

        if Itr == 1
            % Sort the first population of moths
            [fitness_sorted, I] = sort(Moth_Fitness);
            sorted_population = Moth_Positions(I, :);

            % Update the flames
            best_flames = sorted_population;
            best_flame_fitness = fitness_sorted;
        else

            % Sort the moths
            double_population = [previous_population; best_flames];
            double_fitness = [previous_fitness best_flame_fitness];

            [double_fitness_sorted, I] = sort(double_fitness);
            double_sorted_population = double_population(I, :);

            fitness_sorted = double_fitness_sorted(1 : Moth_no);
            sorted_population = double_sorted_population(1 : Moth_no, :);

            % Update the flames
            best_flames = sorted_population;
            best_flame_fitness = fitness_sorted;
        end

        %% Update the position best flame obtained so far
        Best_flame_Fitness = fitness_sorted(1);
        Best_flame_Position = sorted_population(1,:);

        previous_population = Moth_Positions;
        previous_fitness = Moth_Fitness;

        %% a linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
        a = -1 + Itr * ((-1) / Max_iter);
        for i = 1 : size(Moth_Positions, 1)
            for j = 1 : size(Moth_Positions, 2)
                if i <= Flame_no % Update the position of the moth with respect to its corresponsing flame
                    % D in Eq. (3.13)
                    distance_to_flame = abs(sorted_population(i, j) - Moth_Positions(i, j));
                    b = 1;
                    t = (a - 1) * rand + 1;
                    % Eq. (3.12)
                    Moth_Positions(i, j) = distance_to_flame * exp(b .* t) .* cos(t .* 2 * pi) + sorted_population(i, j);
                end

                if i > Flame_no % Upaate the position of the moth with respct to one flame
                    % Eq. (3.13)
                    distance_to_flame = abs(sorted_population(i, j) - Moth_Positions(i, j));
                    b = 1 ;
                    t = (a - 1) * rand + 1;
                    % Eq. (3.12)
                    Moth_Positions(i, j) = distance_to_flame * exp(b .* t) .* cos(t .* 2 * pi) + sorted_population(Flame_no, j);
                end
            end
        end

        Flame_Fitness_Per_Itr(Itr) = Best_flame_Fitness;
        if Itr > 1
            if Best_flame_Fitness > Flame_Fitness_Per_Itr(Itr - 1, 1)
                Flame_Fitness_Per_Itr(Itr, 1) = Flame_Fitness_Per_Itr(Itr - 1, 1);
            end
        end

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

    Moth_Change_Curve = Flame_Fitness_Per_Itr;
end

function X=initialization(SearchAgents_no,dim,ub,lb)
    Boundary_no= size(ub,2); % numnber of boundaries
    % If the boundaries of all variables are equal and user enter a signle
    % number for both ub and lb
    if Boundary_no==1
        X=rand(SearchAgents_no,dim).*(ub-lb)+lb;
    end
    % If each variable has a different lb and ub
    if Boundary_no>1
        for i=1:dim
            ub_i=ub(i);
            lb_i=lb(i);
            X(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
        end
    end
end