timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/singleshifttrials_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');


params = single_trial_params();

%%

period = .65;

shifts = [-.04, 0, .04];
shift_names = {'neg', 'zero', 'pos'};

stim_maker_event_shift_single(strcat(filepath, 'shift'), shifts, shift_names, period);
stim_maker_metronome_single(strcat(filepath, 'metro'), period, 20);



