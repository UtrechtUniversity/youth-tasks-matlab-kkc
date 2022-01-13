
log_file = [logpath logtag '.mat'];
mf_log = matfile(log_file, 'Writable', true);

mf_log.cbalance = cbalance;
mf_log.en_diode = en_diode;
mf_log.trials = [];
mf_log.events = [];
