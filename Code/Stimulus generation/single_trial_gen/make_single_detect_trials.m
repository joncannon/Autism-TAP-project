timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/singletrials_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

params = single_trial_params();
%%
mean_delay = .9;

uniform_rand_delay_gen = @() 2*(mean_delay - .2)*(rand() - .5) + mean_delay;

uniform_rand_init_gen = @() rand()+.5;

interval_likelihood = 0.75;
omission_rate = 0.2;
trial_length_after_cue = 1.8;

gen_random_delay_trial = @(filename, pitch, volume, params) stim_maker_detect_single(filename, volume, pitch, uniform_rand_init_gen(), uniform_rand_delay_gen(), trial_length_after_cue, params)
gen_interval_delay_trial = @(filename, pitch, volume, params) stim_maker_detect_single(filename, volume, pitch, uniform_rand_init_gen(), mean_delay, trial_length_after_cue, params)

all_blocks= {};


%%

% Actual experiment code starts here

% make Lblock (learning block)

Lblock = struct;
Lblock.type = 'learning'
Lblock.trials = {};
Lblock.volumes = [];
Lblock.pitches = [];
Lblock.random = [];
Lblock.audible = [];
Lblock.training = [];

for n = 1:2%0
    filename=strcat(filepath, 'Lblock_setup_', num2str(n));
    if rand()<omission_rate
        volume = params.silent_volume;
        Lblock.audible(end+1) = false;
    else
        volume = randsample(params.difficult_volumes, 1);
        Lblock.audible(end+1) = true;
    end
    pitch = randi(params.n_detect_pitches);
    Lblock.trials{end+1} = gen_random_delay_trial(filename, pitch, volume, params);
    Lblock.volumes(end+1) = volume;
    Lblock.pitches(end+1) = pitch;
    Lblock.training(end+1) = false;
    Lblock.random(end+1) = true;
end

for n = 1:3%0
    filename=strcat(filepath, 'Lblock_learning_', num2str(n));
    
    if rand()<omission_rate
        volume = params.silent_volume;
        Lblock.audible(end+1) = false;
    else
        volume = params.easy_volume;
        Lblock.audible(end+1) = true;
    end
    pitch = randi(params.n_detect_pitches);
    
    if rand()<interval_likelihood
        Lblock.trials{end+1} = gen_interval_delay_trial(filename, pitch, volume, params);
        Lblock.random(end+1) = false;
    else
        Lblock.trials{end+1} = gen_random_delay_trial(filename, pitch, volume, params);
        Lblock.random(end+1) = true;
    end
    Lblock.volumes(end+1) = volume;
    Lblock.pitches(end+1) = pitch;
    Lblock.training(end+1) = true;
end

for n = 1:3%0
    filename=strcat(filepath, 'Lblock_testing_', num2str(n));
    
    if rand()<omission_rate
        volume = params.silent_volume;
        Lblock.audible(end+1) = false;
    else
        volume = randsample(params.difficult_volumes, 1);
        Lblock.audible(end+1) = true;
    end
    pitch = randi(params.n_detect_pitches);
    
    if rand()<interval_likelihood
        Lblock.trials{end+1} = gen_interval_delay_trial(filename, pitch, volume, params);
        Lblock.random(end+1) = false;
    else
        Lblock.trials{end+1} = gen_random_delay_trial(filename, pitch, volume, params);
        Lblock.random(end+1) = true;
    end
    
    Lblock.volumes(end+1) = volume;
    Lblock.pitches(end+1) = pitch;
    Lblock.training(end+1) = true;
end

all_blocks{end+1} = Lblock;

% make Iblock (interval block)
Iblock = struct;
Iblock.type = 'intervals'
Iblock.trials = {};
Iblock.volumes = [];
Iblock.pitches = [];
Iblock.audible = [];

for n = 1:3%0
    filename=strcat(filepath, 'Iblock_', num2str(n));
    if rand()<omission_rate
        volume = params.silent_volume;
        Iblock.audible(end+1) = false;
    else
        volume = randsample(params.difficult_volumes, 1);
        Iblock.audible(end+1) = true;
    end
    pitch = randi(params.n_detect_pitches);
    Iblock.trials{end+1} = gen_interval_delay_trial(filename, pitch, volume, params);
    Iblock.volumes(end+1) = volume;
    Iblock.pitches(end+1) = pitch;
end

all_blocks{end+1} = Iblock;

% make Rblock (random block)
Rblock = struct;
Rblock.trials = {};
Rblock.type = 'random';
Rblock.volumes = [];
Rblock.pitches = [];
Rblock.audible = [];

for n = 1:3%0
    filename=strcat(filepath, 'Lblock_rand_', num2str(n));
    if rand()<omission_rate
        volume = params.silent_volume;
    else
        volume = randsample(params.difficult_volumes, 1);
    end
    pitch = randi(params.n_detect_pitches);
    Rblock.trials{end+1} = gen_interval_delay_trial(filename, pitch, volume, params);
    Rblock.volumes(end+1) = volume;
    Rblock.pitches(end+1) = pitch;
end

all_blocks{end+1} = Rblock;
