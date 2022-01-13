
% save trial to log file
cur_log = [ trial, curInd, QDelays(curInd), choice, flip_btn, varAmount, fixAmount, QConverged, qOLL, qILL, qIUL, qOUL, faketrial, TClick, QResults];
trial_log(trial,:) = cur_log;
fprintf(fileID, '%d\t', [ trial, curInd, QDelays(curInd), choice, flip_btn ]);
fprintf(fileID, '%0.2f\t', [ varAmount, fixAmount ]);
fprintf(fileID, '%d\t', [ QConverged ]);
fprintf(fileID, '%0.2f\t', [ qOLL, qILL, qIUL, qOUL ]);
fprintf(fileID, '%0.2f\t', [ QResults ]);
fprintf(fileID, '%0.3f\t', [ TClick ]);
fprintf(fileID, '%d\r\n', faketrial);

