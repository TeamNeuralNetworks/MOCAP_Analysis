%% TO REVIEW OR DELETE
% 
% 
% sub_beh = observation_labels(subset);
% sm_pred = smoothdata(predictors, 'gaussian', 100);
% for beh_idx = 1:numel(sub_beh)
%     sub_beh{beh_idx} = strrep(sub_beh{beh_idx}, '_', '\_');
%     score = [];
%     for el = 1:ml_params.N_iter
%         %score(el, :) = results{el}.model{(beh_idx*2-1)}.Beta;    
%         
%         % Train a TreeBagger model
%         mdl = TreeBagger(100, X, Y, 'Method', 'regression');
% 
%         % Get the feature importance scores
%         importance = mdl.OOBPermutedVarDeltaError;
% 
%         % Plot the feature importance scores
%         bar(importance);
%         xlabel('Feature');
%         ylabel('Scores');
%         title('Feature Importance Scores');
%         
%         
%         % Assume mdl is your trained RegressionEnsemble model
%         importance = oobPermutedPredictorImportance(results{el}.model{(beh_idx*2-1)});
% 
%         % Display the importance scores
%         disp('Feature Importance Scores:');
%         disp(importance);
% 
%         % To plot the feature importance
%         figure;
%         bar(importance);
%         xlabel('Predictor Index');
%         ylabel('Importance Score');
%         title('Predictor Importance Estimates');
%         
%         
%     end
%     m_score = nanmean(score);
% %     figure();plot(score', 'Color', [0.8,0.8,0.8]); hold on;plot(m_score,'k', 'LineWidth', 2);
% %     sgtitle(sub_beh{beh_idx});
% 
%     good_plus = find(m_score > (max(m_score(m_score > 0)) / 2))
%     [~, best_plus] = max(m_score);
%     good_minus = find(m_score < (min(m_score(m_score < 0)) / 2))
%     [~, best_minus] = min(m_score);
% 
% %     figure(); hold on;set(gcf, 'color', 'w')
% %     subplot(311); plot(mean(normalize(predictors(:,good_plus)),2),'g');
% %     subplot(312); plot(normalize(norm_obs(:, subset(beh_idx))),'k')
% %     subplot(313); plot(mean(normalize(predictors(:,good_minus)),2),'r'); hold on;
% %     sgtitle(sub_beh{beh_idx});
% %     
%     figure(); hold on;set(gcf, 'color', 'w')
%     axes = [];
%     ax1 = subplot(311); plot(mean(predictors(:,good_plus),2),'g');
%     ax2 = subplot(312); plot(normalize(observations(:, subset(beh_idx))),'k')
%     ax3 = subplot(313); plot(mean(predictors(:,good_minus),2),'r'); hold on;
%     sgtitle(['average of best predictor cell for ',sub_beh{beh_idx}]);
%     linkaxes([ax1, ax2, ax3], 'x')
% 
% %     figure(); hold on;set(gcf, 'color', 'w')
% %     axes = [];
% %     ax1 = subplot(311); plot(mean(sm_pred(:,good_plus),2),'g');
% %     ax2 = subplot(312); plot(normalize(norm_obs(:, subset(beh_idx))),'k')
% %     ax3 = subplot(313); plot(mean(sm_pred(:,good_minus),2),'r'); hold on;
% %     sgtitle(['average of best predictor cell for ',sub_beh{beh_idx}]);
% %     linkaxes([ax1, ax2, ax3], 'x')
%     
%     figure(); hold on;set(gcf, 'color', 'w')
%     ax1 = subplot(311); plot(predictors(:,best_plus),'g');title(predictor_labels(best_plus)); hold on;
%     ax2 = subplot(312); plot(normalize(observations(:, subset(beh_idx))),'k'); hold on;
%     ax3 = subplot(313); plot(predictors(:,best_minus),'r'); title(predictor_labels(best_minus)); hold on;
%     sgtitle(['best cell for ',sub_beh{beh_idx}]);   
%     linkaxes([ax1, ax2, ax3], 'x')
%     
%     % Create the figure
%     figure();
% 
%     % First subplot
%     subplot(1, 2, 1);
% 
%     % Scatter plot
%     scatter(observations(:, subset(beh_idx)), mean(predictors(:, good_plus), 2), 'g', 'filled', 'MarkerFaceAlpha', 0.1);
%     ylabel('firing rate (norm)');
%     xlabel(sub_beh{beh_idx});
%     set(gcf, 'color', 'w');
%     set(gca, 'box', 'off');
% 
%     % Perform linear fit and plot it
%     coefficients = polyfit(observations(:, subset(beh_idx)), mean(predictors(:, good_plus), 2), 1);
%     x_fit = linspace(min(observations(:, subset(beh_idx))), max(observations(:, subset(beh_idx))), 100);
%     y_fit = polyval(coefficients, x_fit);
%     hold on;
%     plot(x_fit, y_fit, 'b--'); % b-- means blue dashed line
%     hold off;
% 
%     % Second subplot
%     subplot(1, 2, 2);
% 
%     % Scatter plot
%     scatter(observations(:, subset(beh_idx)), mean(predictors(:, good_minus), 2), 'r', 'filled', 'MarkerFaceAlpha', 0.1);
%     ylabel('firing rate (norm)');
%     xlabel(sub_beh{beh_idx});
%     set(gcf, 'color', 'w');
%     set(gca, 'box', 'off');
% 
%     % Perform linear fit and plot it
%     coefficients = polyfit(observations(:, subset(beh_idx)), mean(predictors(:, good_minus), 2), 1);
%     x_fit = linspace(min(observations(:, subset(beh_idx))), max(observations(:, subset(beh_idx))), 100);
%     y_fit = polyval(coefficients, x_fit);
%     hold on;
%     plot(x_fit, y_fit, 'b--'); % b-- means blue dashed line
%     hold off;
% 
%     % Super title
%     sgtitle(sub_beh{beh_idx});
% end
% 
% 
