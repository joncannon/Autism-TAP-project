function [snd_total, key]=stim_maker_omission(filename, period, n_events, deviant_rate, params)

params.deviant = zeros(10,1);
[snd_total, key]=stim_maker_deviant(filename, period, n_events, deviant_rate, params);
key.type = 'omission';