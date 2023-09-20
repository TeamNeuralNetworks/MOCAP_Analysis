%% Computes Reference Phase of Step Cycle
%  This function computes the reference phase for a given step cycle based on
%  observations and predictors. The function allows the selection of a phase 
%  reference and produces a plot of the computed phase.
%
% -------------------------------------------------------------------------
%% Syntax:
%  reference_phase = get_step_cycle_phase_ref(observations, predictors, 
%                                             observation_labels, phase_ref)
%
% -------------------------------------------------------------------------
%% Inputs:
%  observations(MATRIX):
%    Matrix containing observations, where each column corresponds to a
%    different observation variable and each row to a sample.
%
%  predictors(MATRIX):
%    Matrix containing predictors, where each column corresponds to a
%    different predictor variable and each row to a sample.
%
%  observation_labels(CELL):
%    Cell array containing the labels corresponding to each column in the
%    observations matrix.
%
%  phase_ref(CHAR) - Optional:
%    Character array specifying which label to use as the reference for the
%    phase. If not provided or empty, defaults to 'right_foot_x_norm'.
%
% -------------------------------------------------------------------------
%% Outputs:
%  reference_phase(VECTOR) DOUBLE
%    A vector containing the computed phase based on the selected phase
%    reference. 
%
% -------------------------------------------------------------------------
%% Extra Notes:
%
% * This function uses an internal function `plot_phase_of_reponse` to 
%   compute the reference phase. 
% * A plot will be produced showing the reference phase against the sample
%   index.
% -------------------------------------------------------------------------
%% Examples:
% * Basic Usage
%   reference_phase = get_step_cycle_phase_ref(obs, preds, labels);
%
% * Specifying Phase Reference
%   reference_phase = get_step_cycle_phase_ref(obs, preds, labels, 'left_foot_y');
%
% -------------------------------------------------------------------------
%% Author(s):
%   Antoine Valera
%
% -------------------------------------------------------------------------
%                               Notice
%
% -------------------------------------------------------------------------
% Revision Date:
%   19-09-2023
% -------------------------------------------------------------------------
% See also: 
%  plot_phase_of_reponse

% TODO: Optional section. For future developments consider adding more 
%       options for plotting styles.


function reference_phase = get_step_cycle_phase_ref(observations, predictors, observation_labels, phase_ref)
    
    %% Check for input arguments and set default phase reference
    if nargin < 4 || isempty(phase_ref)
        phase_ref = 'right_foot_x_norm' ;
    end
    
    %% Find the phase reference label in observation labels
    phase_ref_idx = find(contains(observation_labels, phase_ref)) ;

    %% Compute and plot phase of response
    [~, ~, reference_phase] = plot_phase_of_reponse(observations(:, phase_ref_idx), ...
                                                    predictors(:, 1), '', false) ;
    figure(658) ;  % Initialize the figure
    clf()       ;  % Clear the figure
    plot(reference_phase) ;

end

