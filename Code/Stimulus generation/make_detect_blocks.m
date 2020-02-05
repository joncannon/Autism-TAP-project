timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('../stimulus_sequences/', 'detect_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

params = default_params();

separation_space = zeros(44100*params.intertrial_time, 2);


distract_inst = audioread('../stimulus_components/Safari_time.wav');
distract_inst(:,2) = 0;
distract_inst = vertcat(distract_inst, zeros(44100*5, 2));

detect_instruction = audioread('../stimulus_components/Detect/Detect.wav');

start_w_click_instruction = audioread('../stimulus_components/Detect/Begin_with_a_woodblock.wav');
start_w_three_clicks_instruction = audioread('../stimulus_components/Detect/Three_clicks.wav');

after_rand_instruction = audioread('../stimulus_components/Detect/Random_detect.wav');
after_fixed_instruction = audioread('../stimulus_components/Detect/Interval_detect.wav');
after_beats_instruction = audioread('../stimulus_components/Detect/Beat_detect.wav');

some_examples_instruction = audioread('../stimulus_components/detect/Some_examples.wav');
will_last_instruction = audioread('../stimulus_components/detect/Will_last.wav');
lets_start_instruction = audioread('../stimulus_components/detect/Lets_get_started.wav');

mean_delay = .7;
fixed_delay_gen = @(i) mean_delay;
rand_delay_gen = @(i) exprnd(mean_delay);

rand_long_delay_gen = @(i) exprnd(3);
fixed_interval_gen = @(i) 3;

rand_example_1 =zeros((.7+3)*44100, 1);
rand_example_1(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
rand_example_1(.7*44100+1:.7*44100+length(params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)})) = params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)};

rand_example_2 =zeros((.4+3)*44100, 1);
rand_example_2(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
rand_example_2(.4*44100+1:.4*44100+length(params.sound_list{params.get_detect_id(1,1)})) = params.sound_list{params.get_detect_id(1,1)};

rand_example_3 =zeros((1.5+3)*44100, 1);
rand_example_3(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
rand_example_3(1.5*44100+1:1.5*44100+length(params.sound_list{params.get_detect_id(3,params.n_detect_difficulties-1)})) = params.sound_list{params.get_detect_id(3,params.n_detect_difficulties-1)};

some_rand_examples = vertcat(interval_example_1, interval_example_2, interval_example_3);

random_detect_instruction = vertcat(detect_instruction, start_w_click_instruction, params.sound_list{params.standard_index}, after_rand_instruction, some_examples_instruction, some_rand_examples, will_last_instruction, lets_start_instruction);
random_detect_instruction(:,2) = 0;

interval_example_1 =zeros((fixed_delay_gen()+3)*44100, 1);
interval_example_1(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
interval_example_1(.8*44100+1:.8*44100+length(params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)})) = params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)};

interval_example_2 =zeros((fixed_delay_gen()+3)*44100, 1);
interval_example_2(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
interval_example_2(.8*44100+1:.8*44100+length(params.sound_list{params.get_detect_id(1,1)})) = params.sound_list{params.get_detect_id(1,1)};

interval_example_3 =zeros((fixed_delay_gen()+3)*44100, 1);
interval_example_3(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
interval_example_3(.8*44100+1:.8*44100+length(params.sound_list{params.get_detect_id(1,params.n_detect_difficulties-1)})) = params.sound_list{params.get_detect_id(3,params.n_detect_difficulties-1)};

some_interval_examples = vertcat(interval_example_1, interval_example_2, interval_example_3);
interval_cued_detect_instruction = vertcat(detect_instruction, start_w_click_instruction, params.sound_list{params.standard_index}, after_fixed_instruction, some_examples_instruction, some_interval_examples, will_last_instruction, lets_start_instruction);
interval_cued_detect_instruction(:,2) = 0;


beat_example =zeros(floor((3*fixed_delay_gen())*44100), 1);
beat_example(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
beat_example(fixed_delay_gen()*44100+1:fixed_delay_gen()*44100+length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
beat_example(2*fixed_delay_gen()*44100+1:2*fixed_delay_gen()*44100+length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};

beat_example_1 =zeros(floor((3*fixed_delay_gen()+3)*44100), 1);
beat_example_1(1:length(beat_example)) = beat_example;
beat_example_2 = beat_example_1;
beat_example_3 = beat_example_1;

beat_example_1(3*fixed_delay_gen()*44100+1:3*fixed_delay_gen()*44100+length(params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)})) = params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)};
beat_example_2(3*fixed_delay_gen()*44100+1:3*fixed_delay_gen()*44100+length(params.sound_list{params.get_detect_id(1,1)})) = params.sound_list{params.get_detect_id(1,1)};
beat_example_3(3*fixed_delay_gen()*44100+1:3*fixed_delay_gen()*44100+length(params.sound_list{params.get_detect_id(1,params.n_detect_difficulties-1)})) = params.sound_list{params.get_detect_id(1,params.n_detect_difficulties-1)};

some_beat_examples = vertcat(beat_example_1, beat_example_2, beat_example_3);

beat_cued_detect_instruction = vertcat(detect_instruction, start_w_three_clicks_instruction, beat_example, after_beats_instruction, some_examples_instruction, some_beat_examples, will_last_instruction, lets_start_instruction);
beat_cued_detect_instruction(:,2) = 0;

contingency_detect_instruction = vertcat(detect_instruction, will_last_instruction, lets_start_instruction);
contingency_detect_instruction(:,2) = 0;


all_blocks= {};
n_trials = 25;

trial_tag = i+10*params.listen_standard_tag;
block = stim_maker_standard(strcat(filepath, 'listen_metronome_', timestamp), all_periods(i), 25+floor(rand()*5), false, trial_tag, params);
block.instruction_type = 'listen';
block.instructions = [];%rxn_inst;
listening_blocks{end+1} = block;

trial_tag = 10*params.detect_tag + 1;
block = stim_maker_detect(strcat(filepath, 'rand_detect_', timestamp), n_trials, 1, rand_long_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = random_detect_instruction;
all_blocks{end+1} = block;


trial_tag = 10*params.detect_tag + 2;
block = stim_maker_detect(strcat(filepath, 'int_detect_', timestamp), n_trials, 1, fixed_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = interval_cued_detect_instruction;
all_blocks{end+1} = block;


trial_tag = 10*params.detect_tag + 3;
block = stim_maker_detect(strcat(filepath, 'beat_detect_', timestamp), n_trials, 3, fixed_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = beat_cued_detect_instruction;
all_blocks{end+1} = block;

% trial_tag = 10*params.detect_tag + 1;
% block = stim_maker_detect(strcat(filepath, 'rand_detect_2_', timestamp), n_trials, 1, rand_delay_gen, fixed_interval_gen, trial_tag, params);
% block.instructions = random_detect_instruction;
% all_blocks{end+1} = block;


phase_types = {};
phase_types{1} = struct();
phase_types{1}.n_cued_targets = 35;
phase_types{1}.n_events = 110;
phase_types{1}.cue_interval = .7;
phase_types{1}.cue_rate = .7;
phase_types{1}.phase_code = 1;

phases = {phase_types{1}};

trial_tag = 10*params.detect_tag + 4;
contingency_block = stim_maker_detect_contingency(strcat(filepath, 'contingency_detect_', timestamp), phases, rand_long_delay_gen, fixed_interval_gen, trial_tag, params);
contingency_block.instructions = contingency_detect_instruction;
all_blocks{end+1} = contingency_block;

fullsound = [];
for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks{i}.instructions, all_blocks{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_detect_', timestamp, '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_detect.mat_', timestamp, '.mat'), 'fullsound', 'all_blocks', 'params');
