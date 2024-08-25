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