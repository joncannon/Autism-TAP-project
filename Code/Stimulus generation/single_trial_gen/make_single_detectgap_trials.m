timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/singletrials_gap_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

%%
mean_delay = .9;

uniform_rand_delay_gen = @() 2*(mean_delay - .2)*(rand() - .5) + mean_delay;
uniform_rand_beat_gen = @() rand()+.5;
uniform_rand_init_gen = @() .5*rand()+.5;

interval_likelihood = 0.75;
trial_length_after_cue = 3;

get_rand_pitch = @() exp(rand() + 6);

gen_random_trial = @(filename, duration) stim_maker_detectgap_single(filename, duration, uniform_rand_init_gen(), 1, uniform_rand_delay_gen(), trial_length_after_cue)
gen_interval_trial = @(filename, duration) stim_maker_detectgap_single(filename, duration, uniform_rand_init_gen(), 1, mean_delay, trial_length_after_cue)
gen_beat_trial = @(filename, duration) stim_maker_detectgap_single(filename, duration, uniform_rand_init_gen(), 3, uniform_rand_beat_gen(), trial_length_after_cue)

reps = 2;

all_durations = [0, .005, .01];

%%
all_beat_trials = {};%struct(2, length(all_t_seps), reps);
all_int_trials = {};%struct(2, length(all_t_seps), reps);
all_rand_trials = {};%struct(2, length(all_t_seps), reps);


    for dur = 1:length(all_durations)
        duration = all_durations(dur);
        for i = 1:reps
            suffix = strcat(num2str(dur), '_', num2str(i));
            all_beat_trials{dur, i} = gen_random_trial(strcat(filepath, 'rand_cue_', suffix), duration);
            all_int_trials{dur, i} = gen_interval_trial(strcat(filepath, 'int_cue_', suffix), duration);
            all_rand_trials{dur, i} = gen_beat_trial(strcat(filepath, 'beat_cue_', suffix), duration);
        end
    end

save(strcat(filepath, '_trial_info.mat'), 'all_beat_trials', 'all_int_trials', 'all_rand_trials') 
