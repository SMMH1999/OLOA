function Comparetor3(CEC_Index, populationNo, maxRun, maxItr, CECsDim)
    %% Benchmark Function
    % Getting the CECs detail from CEC_Benchmarks
    CECNames = ["2005","2014","2017","2019","2020","2022"];
    [costFunction, costFunctionDetails, nFunction] = CEC_Benchmarks(CEC_Index);

    %%
    algorithmFileAddress = "D:\Work\Research\Project-002\Appendex1\AlgorithmsName.txt";
    [algorithmsName, algorithms] = Get_algorithm(algorithmFileAddress);

    for index = 1 : size(CECsDim,2)
        dim = [];
        benchmarkResults = cell(size(algorithms, 1),nFunction);

        for functionNo = 1 : nFunction
            %% Error handling
            % Error handling for CEC 2017
            if eq(func2str(costFunctionDetails), 'CEC_2017_Function')
                if functionNo == 2
                    continue;
                end
            end

            functionName = ['F' num2str(functionNo)];
            if eq(func2str(costFunctionDetails), 'CEC_2005_Function')
                [LB, UB, Dim, costFunction] = costFunctionDetails(functionNo);
            else
                [LB, UB, Dim] = costFunctionDetails(functionNo);
            end

            if class(CECsDim) == "double"
                dim = CECsDim(index);
                Dim = CECsDim(index);
            else
                dim = CECsDim{index};
            end


            for algorithmNo = 1 : size(algorithms, 1)

                algorithm = algorithms{algorithmNo};
                algorithmName = algorithmsName(algorithmNo);

                algoritmResults = ones(maxItr,maxRun) * -1;
                bestResults = zeros(maxRun,1);
                timeExecute = zeros(maxRun,1);

                % for run = 1 : maxRun
                parfor run = 1 : maxRun
                    clc;
                    information = strcat("CEC: ", CECNames(CEC_Index), " Dim: ", num2str(Dim) , " Function: ", functionName," Algorithm: ", algorithmName," Run: ", num2str(run));
                    disp(information);
                    timer = cputime;
                    [bestResults(run), ~, ~, algoritmResults(:,run)] = algorithm(LB, UB, Dim, populationNo, maxItr, costFunction, functionNo);
                    timeExecute(run) = cputime - timer;

                end

                algoritmResults(maxItr,:) = bestResults;
                algoritmResults(maxItr + 1,:) = timeExecute;

                [~, algoritmResults(:,maxRun + 1), ~, algoritmResults(:,maxRun + 2)] = Results_Toolkit(algoritmResults);
                benchmarkResults{algorithmNo,functionNo} = algoritmResults;
                clear [algoritmResults,bestResults,timeExecute];
            end
        end

        Conclusion(benchmarkResults, maxItr, maxRun, algorithmFileAddress, nFunction, CEC_Index, dim);
        Ploting(benchmarkResults, maxItr, maxRun, algorithmFileAddress, CEC_Index, dim);
    end
end

function [algorithmsName, algorithms] = Get_algorithm(algorithmFileAddress)
    % Reading the names of algorithms from the file
    % algorithmsName = readlines("D:\Work\Research\Project-002\Appendex1\AlgorithmsName.txt");
    algorithmsName = readlines(algorithmFileAddress);

    % Converting the algorithm names from string to function
    algorithms = cell(size(algorithmsName, 1), 1);
    for i = 1 : size(algorithmsName, 1)
        algorithms{i} = str2func(algorithmsName(i));
    end
end

function [] = Conclusion(benchmarkResults, maxItr, maxRun, algorithmFileAddress, nFunction, cecName, dim)
    cecNames = ["2005","2014","2017","2019","2020","2022"];

    [algorithmsName, algorithms] = Get_algorithm(algorithmFileAddress);

    tableConclusion = cell(nFunction + 2, size(algorithms, 1) + 2);

    for index = 1 : size(algorithmsName,1)
        tableConclusion{1,index + 2} = algorithmsName(index);
    end

    for index = 1 : nFunction
        tableConclusion{(index - 1) * 3 + 1 + 1, 1} = strcat(['F' num2str(index)]);
        tableConclusion{(index - 1) * 3 + 2 + 1, 1} = strcat(['F' num2str(index)]);
        tableConclusion{(index - 1) * 3 + 3 + 1, 1} = strcat(['F' num2str(index)]);
    end
    clear index;

    for functions = 1: size(benchmarkResults, 1)
        tableResult = {benchmarkResults{functions, :}};

        for algorithm = 1: size(benchmarkResults, 2)
            results = tableResult{1, algorithm};

            %% Error handling
            % Error handling for CEC 2017
            if cecName == 3
                if algorithm == 2
                    continue;
                end
            end

            meanResult = results(maxItr, maxRun + 1);
            stdResult = results(maxItr, maxRun + 2);
            cpuTimeResult = results(maxItr + 1, maxRun + 1);

            tableConclusion{((algorithm - 1) * 3 + 1 + 1), 2} = "Mean";
            tableConclusion{((algorithm - 1) * 3 + 2 + 1), 2} = "Std";
            tableConclusion{((algorithm - 1) * 3 + 3 + 1), 2} = "CPU";

            tableConclusion{((algorithm - 1) * 3 + 1 + 1),functions + 2} = meanResult;
            tableConclusion{((algorithm - 1) * 3 + 2 + 1),functions + 2} = stdResult;
            tableConclusion{((algorithm - 1) * 3 + 3 + 1),functions + 2} = cpuTimeResult;

            clear results;
        end
        clear tableResult;
    end

    %% T-test
    [pValue, hValue] = Ttest(benchmarkResults, maxItr, maxRun, cecName);

    %% Save Comparing algorithm results in file
    if class(dim) == "double"
        dim = num2str(dim);
    end
    filename = strcat('D:\Work\Research\Project-002\Results\CEC', cecNames(cecName), '\', dim, 'Dim.xlsx');
    mkdir(strcat('D:\Work\Research\Project-002\Results\CEC', cecNames(cecName)));

    % Saving Conclusions results in file
    writecell(tableConclusion, filename, 'Sheet', 'Conclusions');

    % Saving T-test results in file
    writematrix(pValue, filename, 'Sheet', 'P-Value');
    writematrix(hValue, filename, 'Sheet', 'null Hypothesis');

    clear [tableConclusion, algorithmsName, algorithms, cecNames, filename]
end

function [] = Ploting(benchmarkResults, maxItr, maxRun, algorithmFileAddress, cecName, dim)
    %% Initialization
    cecNames = ["2005","2014","2017","2019","2020","2022"];
    [algorithmsName, ~] = Get_algorithm(algorithmFileAddress);

    if class(dim) == "double"
        dim = num2str(dim);
    end

    path = strcat('D:\Work\Research\Project-002\Results\CEC', cecNames(cecName), '\Plot_', dim, '\');

    if ~exist(path, 'dir')
        mkdir(path);
    end

    % Subplot grid
    subplotRows = 2;
    subplotCols = 4;
    plotsPerFigure = subplotRows * subplotCols;
    figureCounter = 1;

    % % Preallocate arrays for plot handles and legend entries
    plotHandles = [];
    legendEntries = algorithmsName;

    %% Plotting Loop
    for functions = 1: size(benchmarkResults, 2)
        tableResult = benchmarkResults(:, functions);

        % Error handling for CEC 2017
        if cecName == 3
            if functions == 2
                continue;
            end
        end

        % Create new figure if needed
        if mod(functions - 1, plotsPerFigure) == 0
            if functions > 1
                finalizeFigure(path, figureCounter, cecNames(cecName), plotHandles, legendEntries);
                figureCounter = figureCounter + 1;
            end
            figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
            plotHandles = [];
        end

        % Subplot for each function
        subplot(subplotRows, subplotCols, mod(functions-1, plotsPerFigure) + 1);
        hold on;

        for algorithm = 1: size(benchmarkResults, 1)
            results = tableResult{algorithm};
            meanResult = results(1 : maxItr, maxRun + 1);

            % Plot in grouped figure
            h = semilogy(1:maxItr, meanResult, 'LineWidth', 2);
            if functions == 1
                plotHandles = [plotHandles, h];
            end

        end

        title(['F' num2str(functions)]);
        xlabel('Iteration');
        ylabel('Fitness');
        hold off;

    end

    % Finalize last figure
    finalizeFigure(path, figureCounter, cecNames(cecName), plotHandles, legendEntries);
end

function [] = finalizeFigure(path, figureCounter, cecName, plotHandles, legendEntries)
    hL = legend(plotHandles, legendEntries, 'Orientation', 'horizontal', 'Location', 'southoutside');
    set(hL, 'Position', [0.175, 0.015, 0.68, 0.03], 'Units', 'normalized');
    sgtitle(['CEC Benchmark ' cecName]);
    saveas(gcf, fullfile(path, strcat("CEC_Plots", num2str(figureCounter), '.svg')));
    saveas(gcf, fullfile(path, strcat("CEC_Plots", num2str(figureCounter), '.jpg')));
    close;
end

function [pValue, hValue] = Ttest(benchmarkResults, maxItr, maxRun, cecName)
    benchmarkResults = benchmarkResults';
    % P-Value matrix
    pValue = zeros(size(benchmarkResults, 1), size(benchmarkResults, 2) - 1);
    hValue = zeros(size(benchmarkResults, 1), size(benchmarkResults, 2) - 1);

    for functions = 1: size(benchmarkResults, 1)
        tableResult = {benchmarkResults{functions, :}};

        % Error handling for CEC 2017
        if cecName == 3
            if functions == 2
                continue;
            end
        end


        for algorithm = 1: size(benchmarkResults, 2) - 1
            results1 = tableResult{1, 1};
            results2 = tableResult{1, algorithm + 1};
            firstAlgorithm = results1(maxItr, 1 : maxRun)';
            secondAlgorithm = results2(maxItr, 1 : maxRun)';

            [h,p] = ttest2(firstAlgorithm, secondAlgorithm);

            pValue(functions, algorithm) = p;
            hValue(functions, algorithm) = h;
        end
    end
end

