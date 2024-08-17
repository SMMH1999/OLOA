function [Leader_Fitness, Leader_Position, Whale_Change_Curve, Leader_Fitness_Per_Itr] = WOA(LB, UB, Dim, Whale_no, Max_iter, Cost_Function, Function_Number)

    % پارامترهای اولیه
    Leader_Fitness_Per_Itr = inf(Max_iter,1);

    % مقداردهی اولیه
    [Leader_Fitness, Leader_Position, Positions] = Initialization(Whale_no, Dim, UB, LB);

    % حلقه اصلی الگوریتم WOA
    for Itr = 1 : Max_iter
        for i = 1 : size(Positions, 1)

            % محدودیت‌ها را اعمال کنید
            Flag4ub = Positions(i, :) > UB;
            Flag4lb = Positions(i, :) < LB;
            Positions(i, :) = (Positions(i, :) .* (~(Flag4ub + Flag4lb))) + UB .* Flag4ub + LB.*Flag4lb;

            % ارزیابی تابع هدف
            fitness = Cost_Function(Positions(i,:)',Function_Number);

            % به‌روز رسانی بهترین موقعیت و امتیاز
            if fitness < Leader_Fitness
                Leader_Fitness = fitness;
                Leader_Position = Positions(i, :);
            end
        end

        Leader_Fitness_Per_Itr(Itr, 1) = Leader_Fitness;
        if Itr > 1
            if Leader_Fitness > Leader_Fitness_Per_Itr(Itr - 1, 1)
                Leader_Fitness_Per_Itr(Itr, 1) = Leader_Fitness_Per_Itr(Itr - 1, 1);
            end
        end

        a = 2 - Itr * ((2) / Max_iter); % پارامتر a کاهش می‌یابد از 2 به 0

        % به‌روز رسانی موقعیت هر عامل جستجو
        for i = 1 : size(Positions, 1)
            r1 = rand(); % مقدار تصادفی بین [0,1]
            r2 = rand(); % مقدار تصادفی بین [0,1]

            A = 2 * a * r1 - a; % بردار A
            C = 2 * r2; % بردار C

            b = 1; % ثابت
            l = -1 + rand() * 2; % مقدار تصادفی بین [-1,1]

            p = rand(); % مقدار تصادفی بین [0,1]

            for j = 1 : Dim
                if p < 0.5
                    if abs(A) >= 1
                        rand_leader_index = floor(Whale_no * rand() + 1);
                        X_rand = Positions(rand_leader_index, :);
                        D_X_rand = abs(C * X_rand(j) - Positions(i, j));
                        Positions(i, j) = X_rand(j) - A * D_X_rand;
                    elseif abs(A) < 1
                        D_Leader = abs(C * Leader_Position(j) - Positions(i, j));
                        Positions(i, j) = Leader_Position(j) - A * D_Leader;
                    end
                elseif p >= 0.5
                    distance2Leader = abs(Leader_Position(j) - Positions(i, j));
                    Positions(i, j) = distance2Leader * exp(b .*l ) .* cos(l .* 2 * pi) + Leader_Position(j);
                end
            end
        end

        % نمایش بهترین نتیجه در هر تکرار
        % disp(['Iteration ' num2str(Itr) ': Best fitness = ' num2str(Leader_Fitness)]);
    end

    Whale_Change_Curve = Leader_Fitness_Per_Itr;
end

% تابع مقداردهی اولیه
function [Leader_Fitness,Leader_Position,Positions] = Initialization(Whale_no, Dim, UB, LB)

    Boundary_no = size(UB, 2); % تعداد مرزها

    % اگر فقط یک مرز داده شده باشد، فرض کنید که همه متغیرها دارای همان مرز هستند
    if Boundary_no == 1
        Positions = rand(Whale_no, Dim) .* (UB - LB) + LB;
    end

    % اگر مرزهای مختلف برای هر متغیر وجود دارد، فرض کنید که هر متغیر دارای مرزهای متفاوت است
    if Boundary_no > 1
        for i = 1 : Dim
            ub_i = UB(i);
            lb_i = LB(i);
            Positions(:, i) = rand(Whale_no, 1) .* (ub_i - lb_i) + lb_i;
        end
    end

    Leader_Position=zeros(1,Dim);
    Leader_Fitness=inf; % به عنوان کمینه مقداردهی اولیه کنید

end

