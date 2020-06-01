timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/adaptive_crunch_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

%%
components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/';
tick = audioread(strcat(components_path, 'wood_tick.wav'));
tick = 0.4*tick(:,1);
crunch = audioread(strcat(components_path, 'crunch.wav'));
crunch = crunch(:,1);

%%
mean_delay = .9;

uniform_rand_delay_gen = @() 2*(mean_delay - .2)*(rand() - .5) + mean_delay;
gen_up_or_down = @(p) (rand()<2*p)*((rand()<.5)*2 - 1);
perturbation = @() .2*gen_up_or_down(.2);

uniform_rand_beat_gen = @() rand()+.5;
uniform_rand_init_gen = @() .5*rand()+.5;

valid_rate = .7;

trial_length_after_cue = 3;

all_volumes = .4*exp(0:-.5:-.5*7);%[.012,.0105,.009,.0075, .006, .0045, .003, .0015];

gen_random_trial = @(filename, valid) stim_maker_detectsound_alldiffs(filename, all_volumes, uniform_rand_init_gen(), 1, uniform_rand_delay_gen(), 0, trial_length_after_cue, valid);
gen_interval_trial = @(filename, valid) stim_maker_detectsound_alldiffs(filename, all_volumes, uniform_rand_init_gen(), 1, mean_delay, 0, trial_length_after_cue, valid);
gen_near_interval_trial = @(filename, valid) stim_maker_detectsound_alldiffs(filename, all_volumes, uniform_rand_init_gen(), 1, mean_delay, perturbation(), trial_length_after_cue, valid);

gen_beat_trial = @(filename, valid) stim_maker_detectsound_alldiffs(filename, all_volumes, uniform_rand_init_gen(), 3, uniform_rand_beat_gen(), 0, trial_length_after_cue, valid)
gen_near_beat_trial = @(filename, valid) stim_maker_detectsound_alldiffs(filename, all_volumes, uniform_rand_init_gen(), 3, uniform_rand_beat_gen(), perturbation(), trial_length_after_cue, valid)



%%

% valid_index = 1;
% easier_index = 2;
% staircase_index = 3;
% delay_index = 4;

empty_info_table = table([],[],[],[],'VariableNames', {'valid', 'easier', 'staircase', 'delay'});

all_blocks = {};
% Actual experiment code starts here

% make Wblock (warmup and adaptive block)
Wblock = struct;
Wblock.type = 'warmup'
Wblock.trials = {};
Wblock.info = empty_info_table;

for n = 1:3%1:10 % Warmup
    filename=strcat(filepath, 'wblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Wblock.info.valid(n) = valid;
    Wblock.info.easier(n) = 0;
    Wblock.info.staircase(n) = 0;
    Wblock.trials{end+1} = gen_random_trial(filename, valid);
    Wblock.trials{end}.type = 'warmup';
    Wblock.info.delay(n) = sum(Wblock.trials{end}.intervals(1:end-1));
end

for n = 4:10%11:41 % Staircase
    filename=strcat(filepath, 'wblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Wblock.info.valid(n) = valid;
    Wblock.info.easier(n) = 0;
    Wblock.info.staircase(n) = 1;
    Wblock.trials{end+1} = gen_random_trial(filename, valid);
    Wblock.trials{end}.type = 'staircase';
    Wblock.info.delay(n) = sum(Wblock.trials{end}.intervals(1:end-1));
end
writetable(Wblock.info, strcat(filepath, 'wblock_info.csv'));
all_blocks{end+1} = Wblock;

% make Lblock (interval learning block)

Lblock = struct;
Lblock.type = 'learning'
Lblock.trials = {};
Lblock.info = empty_info_table;

for n = 1:3%15 % Exact (learning)
    filename=strcat(filepath, 'lblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Lblock.info.valid(n) = valid;
    Lblock.info.easier(n) = 1;
    Lblock.info.staircase(n) = 0;
    Lblock.trials{end+1} = gen_interval_trial(filename, valid);
    Lblock.trials{end}.type = 'learning';
    Lblock.info.delay(n) = sum(Lblock.trials{end}.intervals(1:end-1));
end

for n = 4:10%16:75 % Near-interval
    filename=strcat(filepath, 'lblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Lblock.info.valid(n) = valid;
    Lblock.info.easier(n) = 0;
    Lblock.info.staircase(n) = 0;
    Lblock.trials{end+1} = gen_near_interval_trial(filename, valid);
    Lblock.trials{end}.type = 'testing';
    Lblock.info.delay(n) = sum(Lblock.trials{end}.intervals(1:end-1));
end
writetable(Lblock.info, strcat(filepath, 'lblock_info.csv'));
all_blocks{end+1} = Lblock;


% make Bblock (beat block)

Bblock = struct;
Bblock.type = 'beat'
Bblock.trials = {};
Bblock.info = empty_info_table;

for n = 1:6%0
    filename=strcat(filepath, 'bblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Bblock.info.valid(n) = valid;
    Bblock.info.easier(n) = 0;
    Bblock.info.staircase(n) = 0;
    Bblock.trials{end+1} = gen_near_beat_trial(filename, valid);
    Bblock.trials{end}.type = 'testing';
    Bblock.info.delay(n) = sum(Bblock.trials{end}.intervals(1:end-1));
end
writetable(Bblock.info, strcat(filepath, 'bblock_info.csv'));
all_blocks{end+1} = Bblock;


% make Iblock (interval block)

Iblock = struct;
Iblock.type = 'intervals'
Iblock.trials = {};
Iblock.info = empty_info_table;

for n = 1:6%0
    filename=strcat(filepath, 'iblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Iblock.info.valid(n) = valid;
    Iblock.info.easier(n) = 0;
    Iblock.info.staircase(n) = 0;
    Iblock.trials{end+1} = gen_near_interval_trial(filename, valid);
    Iblock.trials{end}.type = 'testing';
    Iblock.info.delay(n) = sum(Iblock.trials{end}.intervals(1:end-1));
end
writetable(Iblock.info, strcat(filepath, 'iblock_info.csv'));
all_blocks{end+1} = Iblock;

% Make R block (random)

Rblock = struct;
Rblock.type = 'random'
Rblock.trials = {};
Rblock.info = empty_info_table;

for n = 1:6%0
    filename=strcat(filepath, 'rblock_trial', num2str(n));
    valid = (rand()<valid_rate);
    Rblock.info.valid(n) = valid;
    Rblock.info.easier(n) = 0;
    Rblock.info.staircase(n) = 0;
    Rblock.trials{end+1} = gen_random_trial(filename, valid);
    Rblock.trials{end}.type = 'testing';
    Rblock.info.delay(n) = sum(Rblock.trials{end}.intervals(1:end-1));
end

all_blocks{end+1} = Rblock;

writetable(Rblock.info, strcat(filepath, 'rblock_info.csv'));

save(strcat(filepath, 'trial_info.mat'), 'all_blocks', '-v7.3') 

audiowrite(strcat(filepath, 'crunch.wav'),crunch,Fs);
audiowrite(strcat(filepath, 'tick.wav'),tick,Fs);