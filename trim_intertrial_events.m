%% Remove intertrial and out-of-bounds spikes from spike_times
%  This function is designed to clean up any spikes that occur outside of the time 
%  range specified by the time_axis, as well as those that occur during gaps between 
%  trials.
%
% -------------------------------------------------------------------------
%% Syntax:
%   spike_times = trim_intertrial_events(time_axis, spike_times)
%
% -------------------------------------------------------------------------
%% Inputs:
%   time_axis(Vector) DOUBLE:
%       Time axis vector specifying the valid time range for the spikes. It is assumed
%       that the time values are monotonically increasing.
%
%   spike_times(Matrix) DOUBLE:
%       A matrix where each column corresponds to spike times for a different neuron.
%
% -------------------------------------------------------------------------
%% Outputs:
%   spike_times(Matrix) DOUBLE:
%       The cleaned spike times matrix, with out-of-bounds and inter-trial spikes set to 
%       NaN.
%
% -------------------------------------------------------------------------
%% Extra Notes:
%
% * This function identifies gaps in the time_axis to determine inter-trial intervals.
% * It loops over each neuron (column in spike_times) to perform the cleanup.
%
% -------------------------------------------------------------------------
%% Examples:
% * Single neuron case
%   cleaned_spikes = trim_intertrial_events([0:0.1:10], [0.5, 2.5, 9.5]);
%
% * Multiple neuron case
%   cleaned_spikes = trim_intertrial_events([0:0.1:10], [0.5, 2.5, 9.5; 0.6, 2.6, 9.6]);
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


function spike_times = trim_intertrial_events(time_axis, spike_times)

    %% Remove intertrial data from spike_times and data exceeding end of recording
    % This block is designed to clean up any spikes that occur outside of the time range
    % specified by the time_axis, as well as those that occur during gaps between trials.
    
    % Identify gaps in the time axis where no recording was made
    gaps = find(diff(time_axis) > median(diff(time_axis)) * 2);  
    
    % Loop over each neuron (column) to remove spikes outside valid time intervals
    for col = 1:size(spike_times, 2)
        
        % Remove spikes that occur before the start of the recording
        spike_times(spike_times(:, col) < time_axis(1), col) = NaN;  
        
        % Remove spikes that occur after the end of the recording
        spike_times(spike_times(:, col) > time_axis(end), col) = NaN;
        
        %% Remove spikes occurring during inter-trial gaps
        % Loop through each gap and set spike times during the gap to NaN
        for gap = gaps'  
            % Identify spikes that fall within each gap and set them to NaN
            bad_tp = (spike_times(:, col) > time_axis(gap)) & ...
                     (spike_times(:, col) < time_axis(gap + 1));
            spike_times(bad_tp, col) = NaN;
        end
    end
end
