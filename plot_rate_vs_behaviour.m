%% Plot Rate vs Behaviour
%  This function generates a figure with two subplots that display scatter 
%  plots of normalized firing rates against behavior observations. 
%  The function also includes a linear fit for each subplot.
%
% -------------------------------------------------------------------------
%% Syntax:
% 	plot_rate_vs_behaviour(observations, subset, beh_idx, behaviour_subset, 
%                           predictors, good_plus, good_minus)
%
% -------------------------------------------------------------------------
%% Inputs:
% 	observations(Matrix):
%   	Matrix containing behavior observations. Each row corresponds to an
%   	observation and each column to a behavior type.
%
%   subset(Vector):
%       Index vector specifying the columns of 'observations' to consider.
%
%   beh_idx(Integer):
%       Index within 'subset' to choose the behavior type for plotting.
%
%   behaviour_subset(Cell array of strings):
%       List of behavior types matching the indices in 'subset'.
%
%   predictors(Matrix):
%       Matrix containing firing rates. Each row corresponds to an 
%       observation and each column to a neuron.
%
%   good_plus(Vector):
%       Index vector specifying the "good" neurons for the first subplot.
%
%   good_minus(Vector):
%       Index vector specifying the "good" neurons for the second subplot.
%
% -------------------------------------------------------------------------
%% Outputs:
%   None. The function generates a figure with two subplots.
%
% -------------------------------------------------------------------------
%% Extra Notes:
%
% * The function does not return any value but generates a figure.
% * The linear fit is computed and plotted as a dashed line in each subplot.
% 
% -------------------------------------------------------------------------
%% Examples:
% * Basic use case
%   plot_rate_vs_behaviour(observations, [1, 2, 3], 2, {'type1', 'type2', 
%   'type3'}, predictors, [1, 5, 7], [2, 4, 6]);
%
% -------------------------------------------------------------------------
%% Author(s):
%   Antoine Valera
%
% -------------------------------------------------------------------------
%                               Notice
%
% Notice content will be added later. Leave a blank line here
% -------------------------------------------------------------------------
% Revision Date:
%   20-09-2023
% -------------------------------------------------------------------------
% See also: 
%   scatter, polyfit, sgtitle

function plot_rate_vs_behaviour(observations, subset, beh_idx, behaviour_subset, predictors, good_plus, good_minus)
    %% Initialize figure
    figure(662); clf();

    %% First subplot and its configurations
    % This block focuses on setting up the first subplot and plotting the 
    % scatter plot using 'good_plus' indices.
    subplot(1, 2, 1);  % First subplot

    % Scatter plot
    scatter(observations(:, subset(beh_idx)), mean(predictors(:, good_plus), 2), ...
            'g', 'filled', 'MarkerFaceAlpha', 0.1);
    ylabel('firing rate (norm)');     % Y-axis label
    xlabel(behaviour_subset{beh_idx}); % X-axis label
    set(gcf, 'color', 'w');            % Background color
    set(gca, 'box', 'off');            % Box property

    % Linear fit and plotting
    coefficients = polyfit(observations(:, subset(beh_idx)), ...
                           mean(predictors(:, good_plus), 2), 1);
    x_fit = linspace(min(observations(:, subset(beh_idx))), ...
                     max(observations(:, subset(beh_idx))), 100);
    y_fit = polyval(coefficients, x_fit);
    hold on;
    plot(x_fit, y_fit, 'b--'); % Blue dashed line
    hold off;

    %% Second subplot and its configurations
    % Similar to the first block but this time uses 'good_minus' indices.
    subplot(1, 2, 2);  % Second subplot

    % Scatter plot
    scatter(observations(:, subset(beh_idx)), mean(predictors(:, good_minus), 2), ...
            'r', 'filled', 'MarkerFaceAlpha', 0.1);
    ylabel('firing rate (norm)');     % Y-axis label
    xlabel(behaviour_subset{beh_idx}); % X-axis label
    set(gcf, 'color', 'w');            % Background color
    set(gca, 'box', 'off');            % Box property

    % Linear fit and plotting
    coefficients = polyfit(observations(:, subset(beh_idx)), ...
                           mean(predictors(:, good_minus), 2), 1);
    x_fit = linspace(min(observations(:, subset(beh_idx))), ...
                     max(observations(:, subset(beh_idx))), 100);
    y_fit = polyval(coefficients, x_fit);
    hold on;
    plot(x_fit, y_fit, 'b--'); % Blue dashed line
    hold off;

    %% Add Super Title to the figure
    % Adds a title that spans both subplots
    sgtitle(behaviour_subset{beh_idx});
end
