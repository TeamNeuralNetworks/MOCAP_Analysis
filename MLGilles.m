% %% Load Excel file with behaviours and spike rates
% data_filename = 'C:\Users\Antoine.Valera\Desktop\Gilles\0022_01_08_concatenated_mocap_better_rates_catwalk_sans_trous.xlsx';
% [observations, predictors, time_axis, observation_labels, predictor_labels] = load_mocap_data(data_filename);
% 
% %% Load Excel file with spike times
% spike_filename = 'C:\Users\Antoine.Valera\Desktop\Gilles\0022_01_08_spike_times.xlsx';
% [spike_times, spike_times_labels] = load_spike_times(spike_filename);
% 
% %% Quick Check for data integrity
% if (numel(spike_times_labels) ~= numel(predictor_labels)) || ~all(ismember(spike_times_labels, predictor_labels))
%     error('Unit list in spike times and spike rates do not match')
% end
% 
% 
% %% Interpolate data for small gaps based on gap duration
% % small_gap_size_ms = 0.5;
% % small_gap_size_tp = ceil(small_gap_size_ms / median(diff(time_axis)));
% % for col = 1:size(observations,2)
% %     observations(:, col) = fillmissing(observations(:, col),'pchip','EndValues', 'none','MaxGap',small_gap_size_tp);
% % end
% 
% %% Remove spikes that outside the recorded behavioural data range
% spike_times = trim_intertrial_events(time_axis, spike_times);
% 
% 
% %% Fill observations gaps that span < 1/2 median step size
% % QQ should be adjusted to compute a dynamic step size and fill gaps if
% % less than 1/2 the current step size
% [observations] = interpolate_gaps(observations, observation_labels, predictors, 'right_foot_x', 'back1_x');
% 
% %% Remove bad timepoints from observations and time axis
% [observations, predictors, time_axis, spike_times] = ...
%          trim_variables_for_missing_datapoints(observations, predictors, time_axis, spike_times);
%      
%    
% %% Standardize data before machine learning
% norm_obs = smoothdata(normalize(observations),'gaussian', 100);
% norm_pred = smoothdata(normalize(predictors),'gaussian', 100);
% 
% [results, mean_score, stats, ind_scores, subset, ml_params] = run_ml_mocap(norm_pred, norm_obs, time_axis, observation_labels, '_foot_');
% 
% %% Get reference step cycle
% reference_phase = get_step_cycle_phase_ref(observations, predictors, observation_labels, 'right_foot_x_norm');
% 
% 
% Figure 659: Plots the scores calculated from the model's coefficients, highlighting the mean score in black. Used for tuning assessment.
% Figure 663: Shows the mean of the predictors and observations for positively correlated neurons.
% Figure 664: Plots the predictors from the best positively and negatively correlated neurons.
% Figure 662: Shows scatter plots and linear fits for the mean firing rates of positively and negatively tuned neurons against the observed behavior.
% Figure 668: Histograms of mean angles and mean lengths.
% Figure 669: Shows the best-tuned cell based on the phase locking.
% Figure 777: KDE plots for each unit showing their firing behavior across positions.

%% Get phase of firing
behaviour_subset = observation_labels(subset);
sm_pred = smoothdata(predictors, 'gaussian', 100);
for beh_idx = 1:numel(behaviour_subset)
    if contains(behaviour_subset{beh_idx}, '')
        behaviour_subset{beh_idx} = strrep(behaviour_subset{beh_idx}, '_', '\_');
        score = [];
        for el = 1:ml_params.N_iter
            score(el, :) = results{el}.model{(beh_idx*2-1)}.Beta;
        end
        
        [good_plus, best_plus, good_minus, best_minus, mean_score] = plot_score_figure(score, behaviour_subset, beh_idx, 50);

        plot_best_predictors(predictors, good_plus, good_minus, best_plus, best_minus, observations, subset, beh_idx, behaviour_subset);
        plot_rate_vs_behaviour(observations, subset, beh_idx, behaviour_subset, predictors, good_plus, good_minus);
        
        
        single_unit_rendering = true;
        [mean_angle, mean_magnitudes, n_events] = deal([]);        
        for unit = 1:size(predictors, 2)
            [mean_angle(unit), mean_magnitudes(unit), ~, n_events(unit)] = plot_phase_of_reponse(observations(:, subset(beh_idx)), spike_times(:,unit), ['tuning for ',spike_times_labels{unit}], single_unit_rendering, reference_phase, time_axis);
        end
        
        min_n_event = 25;
        plot_cell_phase_locking(mean_angle, mean_magnitudes, n_events, min_n_event, predictors, observations, subset, beh_idx, behaviour_subset, predictor_labels);
    end
end

%% Get reference step cycle
mouse_x = observations(:, find(contains(observation_labels, 'back1_x')));
mouse_y = observations(:, find(contains(observation_labels, 'back1_y')));        
plot_firing_location(spike_times, time_axis, mouse_x, mouse_y, observation_labels, spike_times_labels, 0.5);
