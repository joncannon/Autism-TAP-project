timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/singletrials_', timestamp);
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


gen_random_trial = @(filename, t_sep, direction) stim_maker_discrim_single(filename, t_sep, get_rand_pitch(), direction, uniform_rand_init_gen(), 1, uniform_rand_delay_gen(), trial_length_after_cue)
gen_interval_trial = @(filename, t_sep, direction) stim_maker_discrim_single(filename, t_sep, get_rand_pitch(), direction, uniform_rand_init_gen(), 1, mean_delay, trial_length_after_cue)
gen_beat_trial = @(filename, t_sep, direction) stim_maker_discrim_single(filename, t_sep, get_rand_pitch(), direction, uniform_rand_init_gen(), 3, uniform_rand_beat_gen(), trial_length_after_cue)


all_t_seps = [.01, .05];
reps = 2;

%%
all_beat_trials = {};%struct(2, length(all_t_seps), reps);
all_int_trials = {};%struct(2, length(all_t_seps), reps);
all_rand_trials = {};%struct(2, length(all_t_seps), reps);

for direction = 1:2
    for diff = 1:length(all_t_seps)
        t_sep = all_t_seps(diff);
        for i = 1:reps
            suffix = strcat(num2str(diff), '_', num2str(i), '_', num2str(direction));
            all_beat_trials{direction, diff, i} = gen_random_trial(strcat(filepath, 'rand_cue_', suffix), t_sep, direction);
            all_int_trials{direction, diff, i} = gen_interval_trial(strcat(filepath, 'int_cue_', suffix), t_sep, direction);
            all_rand_trials{direction, diff, i} = gen_beat_trial(strcat(filepath, 'beat_cue_', suffix), t_sep, direction);
        end
    end
end

save(strcat(filepath, '_trial_info.mat'), 'all_beat_trials', 'all_int_trials', 'all_rand_trials') 
