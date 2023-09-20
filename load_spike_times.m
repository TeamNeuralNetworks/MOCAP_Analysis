%% Load spike times and their corresponding labels from a file
%  This function reads spike time data and corresponding labels from a given
%  filename. It reads both headers and spike times and also prepares labels
%  for different units.
%
% -------------------------------------------------------------------------
%% Syntax:
%  [spike_times, spike_times_labels] = load_spike_times(spike_filename)
%
% -------------------------------------------------------------------------
%% Inputs:
%  spike_filename(String):
%   	Path to the spike time file. The file is expected to contain headers
%       starting with "Unit_" to signify the labels for different units. 
%
% -------------------------------------------------------------------------
%% Outputs:
%  spike_times(Matrix) Double:
%       A matrix containing spike time data. Each column corresponds to a
%       unit.
%
%  spike_times_labels(Cell Array) String:
%       A cell array containing the corresponding labels for the columns in
%       spike_times.
%
% -------------------------------------------------------------------------
%% Extra Notes:
% 
% * This function reads the spike time file and extracts both the data and
%   the labels (headers) of the units.
% * If the headers in the file contain missing or empty values, they are
%   filtered out.
% * Unit labels in the headers are converted from "Unit_" to "Unit\_".
%
% -------------------------------------------------------------------------
%% Examples:
% * Example 1: Load spike times and labels
%   [spike_times, spike_times_labels] = load_spike_times('spike_times.csv');
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
%   19-09-2023
% -------------------------------------------------------------------------
% See also: 
%   readcell, readmatrix, num2alp
%

function [spike_times, spike_times_labels] = load_spike_times(spike_filename)
    
    %% Extract the headers from the first row
    % The headers include the labels for the different units.
    st_headers = readcell(spike_filename, 'Range', 'A1:ZZ1');
    st_headers(cellfun(@(x) any(ismissing(x)), st_headers)) = {''};
    st_units   = find(cellfun(@(x) contains(x, 'Unit_'), st_headers));
    last_col   = find(cellfun(@(x) ~isempty(x), st_headers), 1, 'last');
    st_headers = st_headers(1:last_col);  % Only keep up to last non-empty column
    
    %% Read the Units columns for spike times (Starting from the second row)
    % This will give us a matrix with the spike time data.
    spike_times = readmatrix(spike_filename, ...
                             'Range', [num2alp(st_units(1)), ':', num2alp(st_units(end))]);
    spike_times = spike_times(2:end, :);  % Remove the header row
    
    %% Prepare column labels for spike time data
    % Convert "Unit_" to "Unit\_" and save these as labels.
    % We also filter out any missing labels.
    st_headers         = cellfun(@(x) strrep(x, 'Unit_', 'Unit\_'), st_headers, 'UniformOutput', false);
    spike_times_labels = st_headers(st_units);    % Columns AO to the end
    spike_times_labels = spike_times_labels(cellfun(@(x) ~any(ismissing(x)), spike_times_labels));
    
end
