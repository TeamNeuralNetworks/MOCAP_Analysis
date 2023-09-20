%% Remove bad timepoints and corresponding spike times
%  This function trims observations, predictors, time_axis, and spike_times
%  to exclude missing data points and corresponding spike times. The function
%  is particularly useful for preparing time series data for analysis.
%
% -------------------------------------------------------------------------
%% Syntax:
% 	[observations, predictors, time_axis, spike_times] = ...
%       trim_variables_for_missing_datapoints(observations, predictors, time_axis, spike_times)
%
% -------------------------------------------------------------------------
%% Inputs:
% 	observations(MATRIX):
%   	2D matrix where each row represents a time point and each column
%   	represents a variable. Rows containing NaNs will be removed.
%
% 	predictors(MATRIX):
%   	2D matrix with the same number of rows as 'observations'. Each row
%   	represents a time point and each column represents a predictor
%   	variable.
%
% 	time_axis(VECTOR):
%   	Vector representing the time axis. Length must correspond to the 
%   	number of rows in 'observations' and 'predictors'.
%
%   spike_times(MATRIX):
%   	2D matrix where each row represents a spike time and each column
%   	represents a channel. Spike times falling within 'bad timepoints'
%   	will be removed.
%
% -------------------------------------------------------------------------
%% Outputs:
% 	observations(MATRIX):
%   	2D matrix after removal of rows with missing data.
%
% 	predictors(MATRIX):
%   	2D matrix after removal of rows corresponding to 'bad timepoints'.
%
% 	time_axis(VECTOR):
%   	Vector after removal of 'bad timepoints'.
%
%   spike_times(MATRIX):
%   	2D matrix after removal of spike times corresponding to 'bad timepoints'.
%
% -------------------------------------------------------------------------
%% Extra Notes:
%
% * The function identifies 'bad timepoints' in 'observations' by checking
%   for NaN values. It then removes these 'bad timepoints' from all input 
%   matrices.
% * 'Bad timepoints' in the 'spike_times' matrix are also identified based 
%   on their correspondence with the 'time_axis' and are removed.
% -------------------------------------------------------------------------
%% Examples:
% * Example 1
%   [observations, predictors, time_axis, spike_times] = ...
%       trim_variables_for_missing_datapoints(obs, pred, time, spike);
%
% -------------------------------------------------------------------------
%% Author(s):
%   Antoine Valera
%
% -------------------------------------------------------------------------
%                               Notice
%
% Notice Content will be added later. Leave a blank line here
% -------------------------------------------------------------------------
% Revision Date:
% 	19-09-2023
% -------------------------------------------------------------------------
% See also: 

function [observations, predictors, time_axis, spike_times] = ...
         trim_variables_for_missing_datapoints(observations, predictors, time_axis, spike_times)

    %% Remove bad timepoints from observations and time axis
    % Generate the good_tp Boolean array before modifying the time_axis.
    % It identifies which timepoints have missing data in the observations.
    good_tp = ~any(isnan(observations), 2);

    %% Remove spike times corresponding to bad timepoints
    % This block identifies the starts and stops of gaps (bad timepoints) in 
    % the data and then removes the corresponding spike_times.
    gaps_starts = find(diff([1; good_tp; 1]) == -1)	;
    gaps_stops  = find(diff([1; good_tp; 1]) ==  1) - 1	;
    
    for col = 1:size(spike_times, 2)
        for i = 1:numel(gaps_starts)
            % Identify the spike times that fall within the gaps
            bad_tp = spike_times(:, col) > time_axis(gaps_starts(i)) & ...
                     spike_times(:, col) < time_axis(gaps_stops(i))   ;
            spike_times(bad_tp, col) = NaN                          ;
        end
    end

    %% Trim bad timepoints from observations and predictors
    % Now that we've dealt with the spike_times, we remove the bad timepoints
    % from observations, predictors, and time_axis.
    observations = observations(good_tp, :)	;
    time_axis    = time_axis(good_tp)		;
    predictors   = predictors(good_tp, :)	;
end
