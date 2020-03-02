timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');
Fs = 44100;

filepath = strcat('../../stimulus_sequences/', 'passive_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');
load('stimulus_components/Language/onsets.mat')

params = default_params();

%%%
mean_delay = .7;
fixed_delay_gen = @(i) mean_delay;
rand_delay_gen = @(i) exprnd(mean_delay) + .1;
uniform_delay_gen = @(i) (rand()*.6 -.3) + mean_delay;

rand_long_delay_gen = @(i) exprnd(3)+.1;
fixed_interval_gen = @(i) 3;
variable_interval_gen = @(i) 2+2*rand();
%%%


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


detect_instruction = audioread('stimulus_components/Detect/Whether_beeps.wav');

start_w_click_instruction = audioread('stimulus_components/Detect/Begin_with_a_woodblock.wav');
start_w_three_clicks_instruction = audioread('stimulus_components/Detect/Three_clicks.wav');

after_rand_instruction = audioread('stimulus_components/Detect/After_block.wav');
after_beats_instruction = audioread('stimulus_components/Detect/Short_beat_detect.wav');

bell_instruction = audioread('stimulus_components/Detect/End_bell.wav');
response_instruction = audioread('stimulus_components/Detect/After_bell.wav');



some_examples_instruction = audioread('stimulus_components/detect/Some_examples.wav');
will_last_instruction = audioread('stimulus_components/detect/Will_last.wav');
lets_start_instruction = audioread('stimulus_components/detect/Lets_get_started.wav');


rand_example_1 =zeros((.7+3+3)*44100, 1);
rand_example_1(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
rand_example_1(.7*44100+1:.7*44100+length(params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)})) = params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)};
rand_example_1((.7+3)*44100+1:(.7+3)*44100+length(params.sound_list{params.bell_index})) = params.sound_list{params.bell_index};

rand_example_2 =zeros((.4+3+3)*44100, 1);
rand_example_2(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
rand_example_2(.4*44100+1:.4*44100+length(params.sound_list{params.get_detect_id(1,1)})) = params.sound_list{params.get_detect_id(1,1)};
rand_example_2((.4+3)*44100+1:(.4+3)*44100+length(params.sound_list{params.bell_index})) = params.sound_list{params.bell_index};

rand_example_3 =zeros((1.5+3+3)*44100, 1);
rand_example_3(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
rand_example_3(1.5*44100+1:1.5*44100+length(params.sound_list{params.get_detect_id(3,params.n_detect_difficulties-1)})) = params.sound_list{params.get_detect_id(3,params.n_detect_difficulties-1)};
rand_example_3((1.5+3)*44100+1:(1.5+3)*44100+length(params.sound_list{params.bell_index})) = params.sound_list{params.bell_index};

some_rand_examples = vertcat(rand_example_1, rand_example_2, rand_example_3);

random_detect_instruction = vertcat(detect_instruction, start_w_click_instruction, params.sound_list{params.standard_index}, after_rand_instruction, bell_instruction, params.sound_list{params.bell_index}, response_instruction, some_examples_instruction, some_rand_examples, will_last_instruction, lets_start_instruction);
random_detect_instruction(:,2) = 0;




beat_example =zeros(floor((3*fixed_delay_gen())*44100), 1);
beat_example(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
beat_example(fixed_delay_gen()*44100+1:fixed_delay_gen()*44100+length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
beat_example(2*fixed_delay_gen()*44100+1:2*fixed_delay_gen()*44100+length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};

beat_example_1 =zeros(floor((3*fixed_delay_gen()+6)*44100), 1);
beat_example_1(1:length(beat_example)) = beat_example;
beat_example_1(floor((3*fixed_delay_gen()+3)*44100)+1:floor((3*fixed_delay_gen()+3)*44100)+length(params.sound_list{params.bell_index})) = params.sound_list{params.bell_index};
beat_example_2 = beat_example_1;
beat_example_3 = beat_example_1;

beat_example_1(3*fixed_delay_gen()*44100+1:3*fixed_delay_gen()*44100+length(params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)})) = params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)};
beat_example_2(3*fixed_delay_gen()*44100+1:3*fixed_delay_gen()*44100+length(params.sound_list{params.get_detect_id(1,1)})) = params.sound_list{params.get_detect_id(1,1)};
beat_example_3(3*fixed_delay_gen()*44100+1:3*fixed_delay_gen()*44100+length(params.sound_list{params.get_detect_id(1,params.n_detect_difficulties-1)})) = params.sound_list{params.get_detect_id(1,params.n_detect_difficulties-1)};

some_beat_examples = vertcat(beat_example_1, beat_example_2, beat_example_3);

beat_cued_detect_instruction = vertcat(detect_instruction, start_w_three_clicks_instruction, beat_example, after_beats_instruction, bell_instruction, params.sound_list{params.bell_index}, response_instruction, some_examples_instruction, some_beat_examples, will_last_instruction, lets_start_instruction);
beat_cued_detect_instruction(:,2) = 0;


all_blocks= {};

trial_tag = 0;
filename = strcat(filepath, 'storytime_1_', timestamp);
block = stim_maker_storytime(filename, 'stimulus_components/Language/Story_audio1n.wav', part1_onsets, false, trial_tag, params);
block.filename=filename;
block.instruction_type = 'story';
block.instructions = story_inst;%%%
all_blocks{end+1} = block;


trial_tag = 0;
filename = strcat(filepath, 'storytime_replay_', timestamp);
block = stim_maker_storytime(filename, 'stimulus_components/Language/Story_audio1n.wav', part1_onsets, true, trial_tag, params);
block.filename=filename;
block.instruction_type = 'story';
block.instructions = [];%%%%%%% REPEATING STORY
all_blocks{end+1} = block;
% 
% trial_tag = 0;
% filename = strcat(filepath, 'storytime_2_', timestamp);
% block = stim_maker_storytime(filename, 'stimulus_components/Language/Story_audio2n.wav', part2_onsets, 0, params);
% block.filename=filename;
% block.instruction_type = 'story';
% block.instructions = story_inst;%%%
% all_blocks{end+1} = block;

trial_tag = 1+10*params.listen_standard_tag;
filename = strcat(filepath, 'listen_metronome_', timestamp);
block = stim_maker_standard(filename, mean_delay, 120, false, trial_tag, params);
block.filename=filename;
block.instruction_type = 'listen';
block.instructions = distract_inst;
all_blocks{end+1} = block;

trial_tag = 2+10*params.listen_standard_tag;
filename = strcat(filepath, 'listen_random_', timestamp);
block = stim_maker_standard(filename, uniform_delay_gen, 120, false, trial_tag, params);
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

trial_tag = 4+10*params.listen_omission_tag;
filename = strcat(filepath, 'omission_', timestamp);
block = stim_maker_omission(filename, mean_delay, 240, .15, false, trial_tag, params);
block.filename=filename;
block.instruction_type = 'listen';
block.instructions = [];%%%
all_blocks{end+1} = block;

trial_tag = 5+10*params.listen_standard_tag;
filename = strcat(filepath, 'SSAEP_', timestamp);
block = stim_maker_SSAEP(filename, mean_delay, 240, .075, 0, .01, trial_tag, params);
block.filename=filename;
block.instruction_type = 'SSAEP';
block.instructions = SSAEP_inst;%%%
all_blocks{end+1} = block;

n_trials = 25;

trial_tag = 6+10*params.detect_tag;
filename=strcat(filepath, 'beat_detect_', timestamp);
block = stim_maker_detect(filename, n_trials, 3, fixed_delay_gen, fixed_interval_gen, true, trial_tag, params);
block.filename=filename;
block.instructions = beat_cued_detect_instruction;
all_blocks{end+1} = block;

trial_tag = 7+ 10*params.detect_tag;
filename = strcat(filepath, 'rand_detect_', timestamp);
block = stim_maker_detect(filename, n_trials, 1, rand_long_delay_gen, fixed_interval_gen, true, trial_tag, params);
block.filename=filename;
block.instructions = random_detect_instruction;
all_blocks{end+1} = block;



%Add delayed detection blocks


fullsound = [];

for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks{i}.instructions, all_blocks{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_passive_', timestamp, '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_passive.mat_', timestamp, '.mat'), 'fullsound', 'all_blocks');
