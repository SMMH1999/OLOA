
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

