
log_file = [logpath logtag '.mat'];
mf_log = matfile(log_file, 'Writable', true);

mf_log.pract_trials = [];
mf_log.pract_coin_count = [];
mf_log.pract_params = [];
mf_log.pract_names = [];

mf_log.task_trials = [];
mf_log.task_coin_count = [];
mf_log.task_params = [];
mf_log.task_names = [];
