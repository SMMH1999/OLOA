function [Alpha_Fitness, Alpha_Position, Wolf_Change_Curve, Alpha_Fitness_Per_Itr] = GWO(LB, UB, Dim, Wolf_no, Max_iter, Cost_Function, Function_Number)
    % الگوریتم گرگ خاکستری

    %% تنظیمات الگوریتم
    Alpha_Fitness_Per_Itr = inf(Max_iter,1);

    %% مقداردهی اولیه
    Positions = LB + (UB - LB) .* rand(Wolf_no, Dim);
    Alpha_Position = zeros(1, Dim);
    Alpha_Fitness = inf;
    Beta_Position = zeros(1, Dim);
    Beta_Fitness = inf;
    Delta_Position = zeros(1, Dim);
    Delta_Fitness = inf;

    %% حلقه اصلی الگوریتم
    for Itr = 1:Max_iter
        for i = 1:Wolf_no
            %% محدودسازی موقعیت‌ها
            Positions(i,:) = max(Positions(i,:), LB);
            Positions(i,:) = min(Positions(i,:), UB);

            %% ارزیابی تابع هدف
            fitness = Cost_Function(Positions(i,:)', Function_Number);

            %% بروزرسانی موقعیت‌ها
            if fitness < Alpha_Fitness
                Alpha_Fitness = fitness;
                Alpha_Position = Positions(i,:);
            elseif fitness < Beta_Fitness
                Beta_Fitness = fitness;
                Beta_Position = Positions(i,:);
            elseif fitness < Delta_Fitness
                Delta_Fitness = fitness;
                Delta_Position = Positions(i,:);
            end
        end

        Alpha_Fitness_Per_Itr(Itr, 1) = Alpha_Fitness;
        if Itr > 1
            if Alpha_Fitness > Alpha_Fitness_Per_Itr(Itr - 1, 1)
                Alpha_Fitness_Per_Itr(Itr, 1) = Alpha_Fitness_Per_Itr(Itr - 1, 1);
            end
        end

        %% بروزرسانی موقعیت گرگ‌ها
        a = 2 - Itr * (2 / Max_iter);
        for i = 1:Wolf_no
            for j = 1:Dim
                r1 = rand();
                r2 = rand();
                A1 = 2 * a * r1 - a;
                C1 = 2 * r2;
                D_alpha = abs(C1 * Alpha_Position(j) - Positions(i,j));
                X1 = Alpha_Position(j) - A1 * D_alpha;

                r1 = rand();
                r2 = rand();
                A2 = 2 * a * r1 - a;
                C2 = 2 * r2;
                D_beta = abs(C2 * Beta_Position(j) - Positions(i,j));
                X2 = Beta_Position(j) - A2 * D_beta;

                r1 = rand();
                r2 = rand();
                A3 = 2 * a * r1 - a;
                C3 = 2 * r2;
                D_delta = abs(C3 * Delta_Position(j) - Positions(i,j));
                X3 = Delta_Position(j) - A3 * D_delta;

                Positions(i,j) = (X1 + X2 + X3) / 3;
            end
        end

    end
    % نمایش نتیجه نهایی
    Wolf_Change_Curve = Alpha_Fitness_Per_Itr;
end
