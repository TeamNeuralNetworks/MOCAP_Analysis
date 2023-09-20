%% Load MoCap Data from File
% 	This function reads motion capture data from a specified file and returns
%   the time axis, observations, predictors, and their labels. The function 
%   reads in a step-wise manner to avoid NaN values and outputs the data in
%   matrices for easy processing.
%
% -------------------------------------------------------------------------
%% Syntax:
% 	[observations, predictors, time_axis, observation_labels, 
%     predictor_labels] = load_mocap_data(data_filename)
%
% -------------------------------------------------------------------------
%% Inputs:
% 	data_filename(CHAR):
%       The file path and name to the motion capture data. The data should be
%       formatted such that the time axis is in column B, and the headers are
%       in the first row.
%
% -------------------------------------------------------------------------
%% Outputs:
% 	observations([N x M] MATRIX) DOUBLE
%       Matrix of observations where N is the number of time points and M 
%       is the number of observation variables.
%
% 	predictors([N x P] MATRIX) DOUBLE
%       Matrix of predictors where N is the number of time points and P 
%       is the number of predictor variables.
%
%   time_axis([N x 1] VECTOR) DOUBLE
%       Vector containing the time axis values.
%
%   observation_labels({1 x M} CELL) CHAR
%       Cell array containing the labels for the observation variables.
%
%   predictor_labels({1 x P} CELL) CHAR
%       Cell array containing the labels for the predictor variables.
%
% -------------------------------------------------------------------------
%% Extra Notes:
%
% * The function uses readmatrix and readcell to read the data from the file.
% * To avoid issues with NaNs, the function reads the time axis in a step-wise
%   manner.
% * The function prints out the sizes of the time axis, observations, and 
%   predictors matrices for quick review.
% -------------------------------------------------------------------------
%% Examples:
% * Load MoCap Data
% 	[obs, preds, time, obs_labels, pred_labels] = 
%   load_mocap_data('mocap_data.csv');
%
% -------------------------------------------------------------------------
%% Author(s):
%   Antoine Valera
%
% -------------------------------------------------------------------------
%                               Notice
%
% Notice content will be added later.
% -------------------------------------------------------------------------
% Revision Date:
% 	19-09-2023
% -------------------------------------------------------------------------
% See also: 
%   readmatrix, readcell, find, fprintf

% TODO : Optional section. Investigate optimization techniques for large
%        datasets and implement parallel processing if necessary.

function [observations, predictors, time_axis, observation_labels, predictor_labels] = load_mocap_data(data_filename)
    %% Initialize time_axis and read it from the file
    %  The time_axis variable is initialized to NaN. It's populated by reading
    %  the first column of the file starting from the second row.
    time_axis = NaN;
    tp_step   = 0;
    while any(isnan(time_axis))
        tp_step   = tp_step + 5000;  % Step size for reading
        time_axis = readmatrix(data_filename, 'Range', ['B2:B', num2str(tp_step)]);
        if ~any(isnan(time_axis))
            time_axis = NaN;
        else
            tp        = find(~isnan(time_axis), 1, 'last');
            time_axis = time_axis(1:tp);
        end
    end

    %% Extract headers and identify units and behaviors
    %  The headers from the first row are read and separated into 'units' and 'beh'
    %  based on certain string matching conditions.
    headers  = readcell(data_filename, 'Range', 'A1:ZZ1');
    headers(cellfun(@(x) any(ismissing(x)), headers)) = {''};
    units    = find(cellfun(@(x) contains(x, 'Unit_'), headers));
    beh      = find(cellfun(@(x) ~isempty(x) && ~contains(x, 'Unit_') && ~contains(x, 'time'), headers));
    last_col = find(cellfun(@(x) ~isempty(x), headers), 1, 'last');
    headers  = headers(1:last_col);

    %% Read observations and predictors from the file
    %  Data is read from specified columns into the 'observations' and 'predictors'
    %  matrices.
    observations = readmatrix(data_filename, 'Range', [num2alp(beh(1)), '2:', num2alp(beh(end)), num2str(tp+1)]);
    predictors   = readmatrix(data_filename, 'Range', [num2alp(units(1)), '2:', num2alp(units(end)), num2str(tp+1)]);

    %% Process header labels for observations and predictors
    %  Special characters in headers are escaped. Missing headers are removed.
    headers           = cellfun(@(x) strrep(x, 'Unit_', 'Unit\_'), headers, 'UniformOutput', false);
    observation_labels = headers(beh);
    predictor_labels   = headers(units);

    observation_labels = observation_labels(cellfun(@(x) ~any(ismissing(x)), observation_labels));
    predictor_labels   = predictor_labels(cellfun(@(x) ~any(ismissing(x)), predictor_labels));

    %% Display summary
    %  Information about the size of time_axis, observations and predictors is printed.
    fprintf('Time axis has %d entries.\n', length(time_axis));
    fprintf('Observations matrix has size [%d, %d].\n', size(observations, 1), size(observations, 2));
    fprintf('Predictors matrix has size [%d, %d].\n', size(predictors, 1), size(predictors, 2));
end
