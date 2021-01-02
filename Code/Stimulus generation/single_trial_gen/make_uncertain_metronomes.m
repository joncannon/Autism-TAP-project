timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/singleshifttrials_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');


params = single_trial_params();

%%

period = .6;
in_between_options = [4,6,8];

noise = .02

metro_times_list = stim_maker_metronome_single(strcat(filepath, 'metro'), period, 90, 0,0);
[jitter_times_list, jitter_phase_shifts, jitter_time_shifts] = stim_maker_metronome_single(strcat(filepath, 'jitter'), period, 90, noise, 0);
[drift_times_list, drift_phase_shifts, drift_time_shifts] = stim_maker_metronome_single(strcat(filepath, 'drift'), period, 90, 0, noise*sqrt(2));

shift_list = [-.048*ones([1,3]), -.024*ones([1,3]), .024*ones([1,3]), .048*ones([1,3])];

[B,i_shift] = sort(rand(1, length(shift_list)));
shift_list_1 = shift_list(i_shift);

[B,i_shift] = sort(rand(1, length(shift_list)));
shift_list_2 = shift_list(i_shift);



[phase_times_list, phase_shifts] = stim_maker_sporatic(strcat(filepath, 'phase'), period, 2, 'phase', shift_list, in_between_options);
[phase_times_list_2, phase_shifts_2] = stim_maker_sporatic(strcat(filepath, 'phase2'), period, 2, 'phase', shift_list_2, in_between_options);

[event_times_list, event_shifts] = stim_maker_sporatic(strcat(filepath, 'event'), period, 2, 'event', shift_list, in_between_options);
[event_times_list_2, event_shifts_2] = stim_maker_sporatic(strcat(filepath, 'event2'), period, 2, 'event', shift_list_2, in_between_options);

lst2str = @(lst) strcat('[',num2str(lst(1:end-1), '%0.5f, '),num2str(lst(end), '%0.5f'),']');


writecell({'audio_file', 'shift', 'click_times', 'IOI', 'shifts';...
    'metro.wav', 0, lst2str(metro_times_list), lst2str(diff(metro_times_list)), lst2str(zeros(size(metro_times_list)))},...
    strcat(filepath, 'metronome_trials.csv'));

writecell({'audio_file', 'shift', 'click_times', 'IOI', 'shifts';...
    'jitter.wav', 0, lst2str(jitter_times_list), lst2str(diff(jitter_times_list)), lst2str(jitter_time_shifts)},...
    strcat(filepath, 'jitter_trials.csv'));

writecell({'audio_file', 'shift', 'click_times', 'IOI', 'shifts';...
    'drift.wav', 0, lst2str(drift_times_list), lst2str(diff(drift_times_list)), lst2str(drift_phase_shifts)},...
    strcat(filepath, 'drift_trials.csv'));

writecell({'audio_file', 'shift', 'click_times', 'IOI', 'shifts';...
    'phase.wav', 0, lst2str(phase_times_list), lst2str(diff(phase_times_list)), lst2str(phase_shifts);...
    'phase2.wav', 0, lst2str(phase_times_list_2), lst2str(diff(phase_times_list_2)), lst2str(phase_shifts_2)},...
    strcat(filepath, 'phase_trials.csv'));

writecell({'audio_file', 'shift', 'click_times', 'IOI', 'shifts';...
    'event.wav', 0, lst2str(event_times_list), lst2str(diff(event_times_list)), lst2str(event_shifts);...
    'event2.wav', 0, lst2str(event_times_list_2), lst2str(diff(event_times_list_2)), lst2str(event_shifts_2)},...
    strcat(filepath, 'event_trials.csv'));



%writematrix(jitter_times_list, strcat(filepath, 'jitter_times_list.csv'))
%writematrix(drift_times_list, strcat(filepath, 'drift_times_list.csv'))