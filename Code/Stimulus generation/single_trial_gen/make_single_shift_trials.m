timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/singleshifttrials_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');


params = single_trial_params();

%%

period = .65;

shifts = [-.04, -.02, 0, .02, .04];
shift_names = {'neg_large', 'neg_small', 'zero', 'pos_small', 'pos_large'};

noise = .01

shift_times_list = stim_maker_event_shift_single(strcat(filepath, 'shift'), shifts, shift_names, period);
metro_times_list = stim_maker_metronome_single(strcat(filepath, 'metro'), period, 60, 0,0);
jitter_times_list = stim_maker_metronome_single(strcat(filepath, 'jitter'), period, 60, noise, 0);
drift_times_list = stim_maker_metronome_single(strcat(filepath, 'drift'), period, 60, 0, noise*sqrt(2));

%writematrix(metro_times_list, strcat(filepath, 'metro_times_list.csv'))
%writematrix(jitter_times_list, strcat(filepath, 'jitter_times_list.csv'))
%writematrix(drift_times_list, strcat(filepath, 'drift_times_list.csv'))