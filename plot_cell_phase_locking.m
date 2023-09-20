%% Plot Phase Locking in Cell Activities
%  This function visualizes the phase-locking activities in neural cells by
%  plotting various metrics such as mean angles, mean magnitudes, and event
%  counts. Additionally, it filters cells based on a minimum event count
%  threshold and identifies the most phase-locked cell based on these metrics.
%
% -------------------------------------------------------------------------
%% Syntax:
%   plot_cell_phase_locking(mean_angles, mean_magnitudes, n_events, 
%       min_n_events, predictors, observations, subset, beh_idx,
%       behaviour_subset, predictor_labels)
%
% -------------------------------------------------------------------------
%% Inputs:
%   mean_angles(1xN DOUBLE):
%       Vector containing the mean angles for the phase-locking measurement 
%       of each cell.
%
%   mean_magnitudes(1xN DOUBLE):
%       Vector containing the mean magnitudes of the phase-locking 
%       measurement of each cell.
%
%   n_events(1xN DOUBLE):
%       Vector containing the number of events for each cell.
%
%   min_n_events(DOUBLE):
%       Minimum number of events required for a cell to be considered in
%       phase-locking analysis.
%
%   predictors(MxN DOUBLE):
%       Matrix of predictor variables for each cell.
%
%   observations(MxP DOUBLE):
%       Matrix of observed responses.
%
%   subset(INTEGER):
%       Indices for selecting a subset of observations.
%
%   beh_idx(INTEGER):
%       Index for selecting a specific behavior from behaviour_subset.
%
%   behaviour_subset{CELL ARRAY OF STRINGS}:
%       List of behavior types. E.g., {'back1_', '_foot_x', ...}
%
%   predictor_labels{CELL ARRAY OF STRINGS}:
%       Labels for the predictors corresponding to each cell.
%
% -------------------------------------------------------------------------
%% Outputs:
%   This function generates plots and does not return any variables.
% 
% -------------------------------------------------------------------------
%% Extra Notes:
%   * This function produces two figures:
%       1. The first figure contains histograms of mean_angles and
%          mean_magnitudes.
%       2. The second figure contains time series plots of predictors and
%          observations for the most phase-locked cell.
%
% -------------------------------------------------------------------------
%% Examples:
%   * Example 1: Basic Usage
%     plot_cell_phase_locking(mean_angles, mean_magnitudes, n_events, min_n_events, predictors, observations, subset, beh_idx, behaviour_subset, predictor_labels);
%
% -------------------------------------------------------------------------
%% Author(s):
%   Antoine Valera
% 
% -------------------------------------------------------------------------
%                               Notice
%
%  Notice Content will be added later. Leave a blank line here
% -------------------------------------------------------------------------
% Revision Date:
%   20-09-2023
% -------------------------------------------------------------------------
% See also:


function plot_cell_phase_locking(mean_angles, mean_magnitudes, n_events, min_n_events, predictors, observations, subset, beh_idx, behaviour_subset, predictor_labels)
    
    %% Initialize figures and subplots for histograms
    % Create a figure with white background and plot the histograms of mean_angles 
    % and mean_magnitudes in separate subplots
    figure(668); clf(); set(gcf, 'color', 'w')                   ;
    subplot(1, 2, 1); histogram(mean_angles, -180:45:180)        ; set(gca, 'box', 'off');
    subplot(1, 2, 2); histogram(mean_magnitudes, 0:0.1:1)        ; set(gca, 'box', 'off');
    
    %% Filter mean magnitudes by event count and identify the most phase-locked cell
    % Filter out mean_magnitudes that are associated with a low number of events
    % Identify the cell with the strongest phase-locking
    filtered_mean_length                  = mean_magnitudes                      ;
    filtered_mean_length(n_events < min_n_events) = 0                             ;
    [~, most_phase_locked]                = max(filtered_mean_length)            ;
    
    %% Plot time series of predictors and observations for the most phase-locked cell
    % Create another figure and plot the time series of the predictors and the observations.
    % Link the x-axes of the two subplots for easier comparison.
    figure(669); clf(); hold on; set(gcf, 'color', 'w')                         ;
    ax1 = subplot(211); plot(predictors(:, most_phase_locked), 'g')             ; 
    title(predictor_labels(most_phase_locked)); hold on; set(gca, 'box', 'off') ;
    ax2 = subplot(212); plot(normalize(observations(:, subset(beh_idx))), 'k')  ; 
    hold on; set(gca, 'box', 'off')                                             ;
    
    %% Set the title for the entire figure
    % Use sgtitle to set a title spanning the entire figure window
    sgtitle(['Cell with strongest tuning for ', behaviour_subset{beh_idx}])    ;
    
    %% Link the x-axes of the subplots for consistent navigation
    linkaxes([ax1, ax2], 'x')                                                   ;
    
end
