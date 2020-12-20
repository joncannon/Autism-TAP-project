timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/singleshifttrials_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');


params = single_trial_params();

%%

period = .65;

shifts = [-.04, -.02, 0, .02, .04];
shift_names = {'neg_large', 'neg_small', 'zero', 'pos_small', 'pos_large'};

shift_times_list = stim_maker_event_shift_single(strcat(filepath, 'shift'), shifts, shift_names, period);
metro_times_list = stim_maker_metronome_single(strcat(filepath, 'metro'), period, 60, 0);
jitter_times_list = stim_maker_metronome_single(strcat(filepath, 'jitter'), period, 60, .01);

writematrix(metro_times_list, strcat(filepath, 'metro_times_list.csv'))
writematrix(jitter_times_list, strcat(filepath, 'jitter_times_list.csv'))