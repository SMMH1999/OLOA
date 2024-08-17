function [BestHawk_Fitness, BestHawk_Position, Hawk_Change_Curve, BestHawk_Fitness_Per_Itr] = HHO(LB, UB, Dim, Hawk_no, Max_iter, Cost_Function, Function_Number)


    % تعریف مشخصات مسئله
    BestHawk_Fitness_Per_Itr = inf(Max_iter,1);

    % مقداردهی اولیه به موقعیت موجودیت‌ها
    Positions = randn(Hawk_no, Dim) * (UB - LB) + LB;

    % محاسبه ارزش تابع هدف برای هر موجودیت
    fitness = zeros(Hawk_no, 1);
    for i = 1:Hawk_no
        fitness(i) = Cost_Function(Positions(i,:)', Function_Number);
    end

    % مرتب سازی موجودیت‌ها بر اساس ارزش تابع هدف
    [fitness, fitnessIndex] = sort(fitness);
    Positions = Positions(fitnessIndex, :);

    % بهینه‌سازی
    for Itr = 1:Max_iter

        % محاسبه ارزش انطباق برای هر موجودیت
        fitness = zeros(Hawk_no, 1);
        for i = 1:Hawk_no
            fitness(i) = Cost_Function(Positions(i,:)', Function_Number);
        end

        % به روزرسانی موقعیت شکارگرها و شاهین‌ها
        Positions_new = Positions;
        for i = 1:Hawk_no
            if rand() < 0.5
                % محاسبه موقعیت شکارگر
                Positions_new(i,:) = Positions(i,:) + rand() * (Positions(randi([1 Hawk_no]),:) - Positions(randi([1 Hawk_no]),:));
            else
                % محاسبه موقعیت شاهین
                Positions_new(i,:) = Positions(i,:) - rand() * (Positions(randi([1 Hawk_no]),:) - Positions(randi([1 Hawk_no]),:)) + rand() * (Positions(randi([1 Hawk_no]),:) - Positions(randi([1 Hawk_no]),:));
            end

            % محدود کردن موقعیت به محدوده مجاز
            Positions_new(i,:) = max(Positions_new(i,:), LB);
            Positions_new(i,:) = min(Positions_new(i,:), UB);
        end

        % به روزرسانی موقعیت‌ها و ارزش تابع هدف
        for i = 1:Hawk_no
            if Cost_Function(Positions_new(i,:)', Function_Number) < fitness(i)
                Positions(i,:) = Positions_new(i,:);
            end
        end

        % نمایش بهترین نتیجه تا کنون
        BestHawk_Position = Positions(1,:);
        BestHawk_Fitness = Cost_Function(BestHawk_Position', Function_Number);

        BestHawk_Fitness_Per_Itr(Itr, 1) = BestHawk_Fitness;
        if Itr > 1
            if BestHawk_Fitness > BestHawk_Fitness_Per_Itr(Itr - 1, 1)
                BestHawk_Fitness_Per_Itr(Itr, 1) = BestHawk_Fitness_Per_Itr(Itr - 1, 1);
            end
        end
        % disp(['Iteration ' num2str(Itr) ': Best Fitness = ' num2str(BestFitness)]);
    end
    Hawk_Change_Curve = BestHawk_Fitness_Per_Itr;
end
