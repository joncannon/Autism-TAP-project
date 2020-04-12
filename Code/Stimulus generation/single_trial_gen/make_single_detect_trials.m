timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/detect_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

params = default_params();

%%
mean_delay = .9;
uniform_rand_delay_gen = @() 2*(mean_delay - .2)*(rand() - .5) + mean_delay;

uniform_rand_init_gen = @() rand()+.5;

noise_dB = 20;
interval_likelihood = 0.75;

trial_length_after_cue = 1.8;

gen_random_delay_trial = @(filename, params) stim_maker_detect_single(filename, floor(rand()*params.n_detect_difficulties)+1, floor(rand()*params.n_detect_pitches)+1, noise_dB, uniform_rand_init_gen(), uniform_rand_delay_gen(), trial_length_after_cue, params)
gen_interval_delay_trial = @(filename, params) stim_maker_detect_single(filename, floor(rand()*params.n_detect_difficulties)+1, floor(rand()*params.n_detect_pitches)+1, noise_dB, uniform_rand_init_gen(), mean_delay, trial_length_after_cue, params)

%fix this
gen_either_delay_trial = @(filename, params) if rand()<interval_likelihood, gen_interval_delay_trial(filename,params), else gen_random_delay_trial(filename,params), end


all_blocks= {};


%%

% Actual experiment code starts here

% contingency block

block = struct{};
block.trials = {};

for n = 1:20
    filename=strcat(filepath, 'contingency_rand_', num2str(n));
    block.trials{end+1} = gen_random_delay_trial(filename, params);
end

for n = 1:30
    filename=strcat(filepath, 'contingency_either_learning_', num2str(n));
    block.trials{end+1} = gen_either_delay_trial(filename, params);
end

for n = 1:30
    filename=strcat(filepath, 'contingency_either_testing_', num2str(n));
    block.trials{end+1} = gen_either_delay_trial(filename, params);
end

all_blocks{end+1} = block;

%% Go on...