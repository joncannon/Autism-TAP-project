timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/adaptive_gap_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

%%
mean_delay = .9;

uniform_rand_delay_gen = @() 2*(mean_delay - .2)*(rand() - .5) + mean_delay;
gen_20p_up_or_down = @() max(-1, min(1, round(randn()*.6)));
near_interval_delay_gen = @() .2*gen_20p_up_or_down() + mean_delay;

uniform_rand_beat_gen = @() rand()+.5;
uniform_rand_init_gen = @() .5*rand()+.5;

valid_rate = .65;

trial_length_after_cue = 3;

gen_random_trial = @(filename, valid) stim_maker_detectgap_alldiffs(filename, all_durations, uniform_rand_init_gen(), 1, uniform_rand_delay_gen(), 0, trial_length_after_cue, valid);
gen_interval_trial = @(filename, valid) stim_maker_detectgap_alldiffs(filename, all_durations, uniform_rand_init_gen(), 1, mean_delay, 0, trial_length_after_cue, valid);
gen_near_interval_trial = @(filename, valid) stim_maker_detectgap_alldiffs(filename, all_durations, uniform_rand_init_gen(), 1, near_interval_delay_gen(), 0, trial_length_after_cue, valid);

gen_beat_trial = @(filename, valid) stim_maker_detectgap_alldiffs(filename, all_durations, uniform_rand_init_gen(), 3, uniform_rand_beat_gen(), 0, trial_length_after_cue, valid)

reps = 2;

all_durations = [.011,.010,.009,.008, .007, .006, .005, .004];



%%


all_blocks = {};
% Actual experiment code starts here

% make Lblock (interval block)

Lblock = struct;
Lblock.type = 'learning'
Lblock.trials = {};
Lblock.info = [];
valid_index = 1;
easier_index = 2;
staircase_index = 3;

for n = 1:10 % Warmup
    filename=strcat(filepath, 'lblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Lblock.info(end+1, valid_index) = valid;
    Lblock.info(end, easier_index) = 0;
    Lblock.info(end, staircase_index) = 0;
    Lblock.trials{end+1} = gen_random_trial(filename, valid);
    Lblock.trials{end}.type = 'warmup';
end

for n = 1:30 % Staircase
    filename=strcat(filepath, 'lblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Lblock.info(end+1, valid_index) = valid;
    Lblock.info(end, easier_index) = 0;
    Lblock.info(end, staircase_index) = 1;
    Lblock.trials{end+1} = gen_random_trial(filename, valid);
    Lblock.trials{end}.type = 'staircase';
end

for n = 1:15 % Exact (learning)
    filename=strcat(filepath, 'lblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Lblock.info(end+1, valid_index) = valid;
    Lblock.info(end, easier_index) = 1;
    Lblock.info(end, staircase_index) = 0;
    Lblock.trials{end+1} = gen_interval_trial(filename, valid);
    Lblock.trials{end}.type = 'learning';
end

for n = 1:60 % Near-interval
    filename=strcat(filepath, 'lblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Lblock.info(end+1, valid_index) = valid;
    Lblock.info(end, easier_index) = 0;
    Lblock.info(end, staircase_index) = 0;
    Lblock.trials{end+1} = gen_near_interval_trial(filename, valid);
    Lblock.trials{end}.type = 'testing';
end
writematrix(Lblock.info, strcat(filepath, 'lblock_info.csv'));
all_blocks{end+1} = Lblock;



% make Iblock (interval block)

Iblock = struct;
Iblock.type = 'intervals'
Iblock.trials = {};
Iblock.info = [];

for n = 1:60
    filename=strcat(filepath, 'iblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Iblock.info(end+1, valid_index) = valid;
    Iblock.info(end, easier_index) = 0;
    Iblock.info(end, staircase_index) = 0;
    Iblock.trials{end+1} = gen_interval_trial(filename, valid);
    Iblock.trials{end}.type = 'testing';
end
writematrix(Iblock.info, strcat(filepath, 'iblock_info.csv'));
all_blocks{end+1} = Iblock;


Rblock = struct;
Rblock.type = 'random'
Rblock.trials = {};
Rblock.info = [];

for n = 1:60
    filename=strcat(filepath, 'rblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Rblock.info(end+1, valid_index) = valid;
    Rblock.info(end, easier_index) = 0;
    Rblock.info(end, staircase_index) = 0;
    Rblock.trials{end+1} = gen_interval_trial(filename, valid);
    Rblock.trials{end}.type = 'testing';
end

all_blocks{end+1} = Rblock;

writematrix(Rblock.info, strcat(filepath, 'rblock_info.csv'));
save(strcat(filepath, 'trial_info.mat'), 'all_blocks', '-v7.3') 
