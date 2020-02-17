timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');
Fs = 44100;

filepath = strcat('../../stimulus_sequences/', 'passive_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');
load('stimulus_components/Language/onsets.mat')

params = default_params();

separation_space = zeros(44100*params.intertrial_time, 2);

sync_time = (params.sync_eeg_samples/512);

distract_inst = audioread('stimulus_components/Safari_time.wav');
distract_inst(:,2) = 0;
distract_inst = vertcat(distract_inst, zeros(44100*5, 2));

story_inst = audioread('stimulus_components/Story_time.wav');
story_inst(:,2) = 0;
story_inst = vertcat(story_inst, zeros(44100*5, 2));

SSAEP_inst = audioread('stimulus_components/SSAEP.wav');
SSAEP_inst(:,2) = 0;
SSAEP_inst = vertcat(SSAEP_inst, zeros(44100*5, 2));

mean_delay = .8;
fixed_delay_gen = @(i) mean_delay;
rand_delay_gen = @(i) max(exprnd(mean_delay), sync_time*6);

rand_long_delay_gen = @(i) exprnd(3);
fixed_interval_gen = @(i) 3;



all_blocks= {};

trial_tag = 0;
filename = strcat(filepath, 'storytime_1_', timestamp);
block = stim_maker_storytime(filename, 'stimulus_components/Language/Story_audio1n.wav', part1_onsets, trial_tag, params);
block.filename=filename;
block.instruction_type = 'story';
block.instructions = story_inst;%%%
all_blocks{end+1} = block;

trial_tag = 0;
filename = strcat(filepath, 'storytime_2_', timestamp);
block = stim_maker_storytime(filename, 'stimulus_components/Language/Story_audio2n.wav', part2_onsets, 0, params);
block.filename=filename;
block.instruction_type = 'story';
block.instructions = story_inst;%%%
all_blocks{end+1} = block;


trial_tag = 1+10*params.listen_standard_tag;
filename = strcat(filepath, 'listen_metronome_', timestamp);
block = stim_maker_standard(filename, mean_delay, 120, false, trial_tag, params);
block.filename=filename;
block.instruction_type = 'listen';
block.instructions = distract_inst;
all_blocks{end+1} = block;

trial_tag = 2+10*params.listen_standard_tag;
filename = strcat(filepath, 'listen_random_', timestamp);
block = stim_maker_standard(filename, rand_delay_gen, 120, false, trial_tag, params);
block.filename=filename;
block.instruction_type = 'listen';
block.instructions = [];%rxn_inst;
all_blocks{end+1} = block;


trial_tag = 3+10*params.listen_deviant_tag;
filename = strcat(filepath, 'deviant_', timestamp);
block = stim_maker_deviant(filename, mean_delay, 240, .15, false, trial_tag, params);
block.filename=filename;
block.instruction_type = 'listen';
block.instructions = [];%%%
all_blocks{end+1} = block;

trial_tag = 4+10*params.listen_standard_tag;
filename = strcat(filepath, 'SSAEP_', timestamp);
block = stim_maker_SSAEP(filename, mean_delay, 240, .075, 0, .01, trial_tag, params);
block.filename=filename;
block.instruction_type = 'SSAEP';
block.instructions = SSAEP_inst;%%%
all_blocks{end+1} = block;

fullsound = [];

for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks{i}.instructions, all_blocks{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_passive_', timestamp, '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_passive.mat_', timestamp, '.mat'), 'fullsound', 'all_blocks', 'params');
