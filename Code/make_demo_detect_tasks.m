
filepath = 'demo_2_5';
mkdir(filepath);

params = default_params();

separation_space = zeros(44100*params.intertrial_time, 2);

detect_instruction = audioread('../stimulus_components/Detect/Detect.wav');

start_w_click_instruction = audioread('../stimulus_components/Detect/Begin_with_a_woodblock.wav');
start_w_three_clicks_instruction = audioread('../stimulus_components/Detect/Three_clicks.wav');

after_rand_instruction = audioread('../stimulus_components/Detect/Random_detect.wav');
after_fixed_instruction = audioread('../stimulus_components/Detect/Interval_detect.wav');
after_beats_instruction = audioread('../stimulus_components/Detect/Beat_detect.wav');

some_examples_instruction = audioread('../stimulus_components/detect/Some_examples.wav');
will_last_instruction = audioread('../stimulus_components/detect/Will_last.wav');
lets_start_instruction = audioread('../stimulus_components/detect/Lets_get_started.wav');



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

random_detect_instruction = vertcat(start_w_click_instruction, params.sound_list{params.standard_index}, after_rand_instruction, lets_start_instruction);
random_detect_instruction(:,2) = 0;

interval_example_1 =zeros((.8+3)*44100, 1);
interval_example_1(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
interval_example_1(.8*44100+1:.8*44100+length(params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)})) = params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)};

interval_example_2 =zeros((.8+3)*44100, 1);
interval_example_2(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
interval_example_2(.8*44100+1:.8*44100+length(params.sound_list{params.get_detect_id(1,1)})) = params.sound_list{params.get_detect_id(1,1)};

interval_example_3 =zeros((.8+3)*44100, 1);
interval_example_3(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
interval_example_3(.8*44100+1:.8*44100+length(params.sound_list{params.get_detect_id(1,params.n_detect_difficulties-1)})) = params.sound_list{params.get_detect_id(3,params.n_detect_difficulties-1)};

some_interval_examples = vertcat(interval_example_1, interval_example_2, interval_example_3);
interval_cued_detect_instruction = vertcat(start_w_click_instruction, params.sound_list{params.standard_index}, after_fixed_instruction, some_examples_instruction, some_interval_examples, lets_start_instruction);
interval_cued_detect_instruction(:,2) = 0;


beat_example =zeros(floor((.8+.8+.8)*44100), 1);
beat_example(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
beat_example(.8*44100+1:.8*44100+length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
beat_example(2*.8*44100+1:2*.8*44100+length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};

beat_example_1 =zeros(floor((.8+.8+.8+3)*44100), 1);
beat_example_1(1:length(beat_example)) = beat_example;
beat_example_2 = beat_example_1;
beat_example_3 = beat_example_1;

beat_example_1(3*.8*44100+1:3*.8*44100+length(params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)})) = params.sound_list{params.get_detect_id(4,params.n_detect_difficulties)};
beat_example_2(3*.8*44100+1:3*.8*44100+length(params.sound_list{params.get_detect_id(1,1)})) = params.sound_list{params.get_detect_id(1,1)};
beat_example_3(3*.8*44100+1:3*.8*44100+length(params.sound_list{params.get_detect_id(1,params.n_detect_difficulties-1)})) = params.sound_list{params.get_detect_id(1,params.n_detect_difficulties-1)};

some_beat_examples = vertcat(beat_example_1, beat_example_2, beat_example_3);

beat_cued_detect_instruction = vertcat(start_w_three_clicks_instruction, beat_example, after_beats_instruction, lets_start_instruction);
beat_cued_detect_instruction(:,2) = 0;


implicit_detect_instruction = [];


mean_delay = .7;
fixed_delay_gen = @(i) mean_delay;
rand_delay_gen = @(i) exprnd(mean_delay);

rand_long_delay_gen = @(i) exprnd(3);
fixed_interval_gen = @(i) 3;

all_blocks= {};
n_trials = 3;

trial_tag = 10*params.detect_tag + 1;
block = stim_maker_detect(strcat(filepath, 'rand_detect_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), n_trials, 1, rand_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = random_detect_instruction;
all_blocks{end+1} = block;
audiowrite(strcat(filepath, '/unpredictable.wav'), vertcat(block.instructions(:,1), block.sound(:,1)), 44100);

trial_tag = 10*params.detect_tag + 2;
block = stim_maker_detect(strcat(filepath, 'int_detect_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), n_trials, 1, fixed_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = interval_cued_detect_instruction;
all_blocks{end+1} = block;
audiowrite(strcat(filepath, '/interval.wav'), vertcat(block.instructions(:,1), block.sound(:,1)), 44100);

trial_tag = 10*params.detect_tag + 3;
block = stim_maker_detect(strcat(filepath, 'beat_detect_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), n_trials, 3, fixed_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = beat_cued_detect_instruction;
all_blocks{end+1} = block;
audiowrite(strcat(filepath, '/beatbased.wav'), vertcat(block.instructions(:,1), block.sound(:,1)), 44100);



phase_types = {};
phase_types{1} = struct();
phase_types{1}.n_cued_targets = 6;
phase_types{1}.n_events = 6;
phase_types{1}.cue_interval = .7;
phase_types{1}.cue_rate = .6;
phase_types{1}.phase_code = 1;

phases = {phase_types{1}};


contingency_block = stim_maker_detect_contingency(strcat(filepath, 'contingency_detect_', timestamp), phases, rand_long_delay_gen, fixed_interval_gen, trial_tag, params);
trial_tag = 10*params.detect_tag + 4;
contingency_block.instructions = implicit_detect_instruction;
all_blocks{end+1} = contingency_block;
audiowrite(strcat(filepath, '/implicit.wav'), vertcat(contingency_block.instructions, contingency_block.sound(:,1)), 44100);
     
