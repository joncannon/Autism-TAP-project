function [snd_total, key]=stim_maker_omission(filename, period, n_events, deviant_rate, params)

params.deviant = zeros(10,1);
params.deviant_code = params.omission_code;
[snd_total, key]=stim_maker_deviant(filename, period, n_events, deviant_rate, params);
key.type = 'omission';
key.period = period;