timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('../../stimulus_sequences/', 'detect_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

params = default_params();

%%
mean_delay = 1;
uniform_rand_delay_gen = @(i) 2*(mean_delay - .2)*(rand() - .5) + mean_delay;
fixed_delay_gen = @(i) mean_delay;

short_trial_length_gen = @(i) .2 + 2*(mean_delay - .2) + 1 + 2*rand();
beat_trial_length_gen = @(i) 3*mean_delay + 1.5 + rand();



rand_long_delay_gen = @(i) exprnd(3)+.1;
fixed_interval_gen = @(i) 3;
variable_interval_gen = @(i) 2+2*rand();

%%

separation_space = zeros(44100*params.intertrial_time, 2);

calibration_inst = audioread('stimulus_components/Calibrate.wav');
calibration_inst = vertcat(calibration_inst, params.calibration_sound);
calibration_inst(:,2) = 0;

hearingtest_inst = audioread('stimulus_components/Raise_hand.wav');
hearingtest_inst(:,2) = 0;
hearingtest_inst = vertcat(hearingtest_inst, zeros(44100*3, 2));

distract_inst = audioread('stimulus_components/Safari_time.wav');
distract_inst(:,2) = 0;
distract_inst = vertcat(distract_inst, zeros(44100*5, 2));

detect_instruction = audioread('stimulus_components/Detect/Detect.wav');

start_w_click_instruction = audioread('stimulus_components/Detect/Begin_with_a_woodblock.wav');
start_w_three_clicks_instruction = audioread('stimulus_components/Detect/Three_clicks.wav');

after_rand_instruction = audioread('stimulus_components/Detect/Random_detect_2.wav');
exact_interval_instruction = audioread('stimulus_components/Detect/Interval_detect_exactly.wav');
other_times_instruction = audioread('stimulus_components/Detect/Interval_detect_quickly.wav');

after_beats_instruction = audioread('stimulus_components/Detect/Beat_detect_2.wav');

some_examples_instruction = audioread('stimulus_components/detect/Some_examples.wav');
will_last_instruction = audioread('stimulus_components/detect/Will_last.wav');
lets_start_instruction = audioread('stimulus_components/detect/Lets_get_started.wav');


example_interval = master_stim_maker('nil', [mean_delay, .2], [params.standard_index, params.target_index], params);
after_fixed_instruction = vertcat(exact_interval_instruction, example_interval(:,1), other_times_instruction);

beat_examples_block = stim_maker_detect(filename, n_trials, 3, fixed_delay_gen, beat_trial_length_gen, false, true, trial_tag, params);
random_examples_block = stim_maker_detect(filename, n_trials, 1, uniform_rand_delay_gen, short_trial_length_gen, false, true, trial_tag, params);
interval_example_block = stim_maker_detect(filename, n_trials, 1, fixed_delay_gen, short_trial_length_gen, false, true, trial_tag, params);

some_interval_examples = interval_example_block.sound(:,1);
some_beat_examples = beat_examples_block.sound(:,1);
some_random_examples = random_examples_block.sound(:,1);

random_detect_instruction = vertcat(detect_instruction, start_w_click_instruction, params.sound_list{params.standard_index}, after_rand_instruction, some_examples_instruction, some_rand_examples, will_last_instruction, lets_start_instruction);
random_detect_instruction(:,2) = 0;

interval_cued_detect_instruction = vertcat(detect_instruction, start_w_click_instruction, params.sound_list{params.standard_index}, after_fixed_instruction, some_examples_instruction, some_interval_examples, will_last_instruction, lets_start_instruction);
interval_cued_detect_instruction(:,2) = 0;

beat_cued_detect_instruction = vertcat(detect_instruction, start_w_three_clicks_instruction, beat_example, after_beats_instruction, some_examples_instruction, some_beat_examples, will_last_instruction, lets_start_instruction);
beat_cued_detect_instruction(:,2) = 0;

contingency_detect_instruction = vertcat(detect_instruction, start_w_click_instruction, params.sound_list{params.standard_index}, will_last_instruction, lets_start_instruction);
contingency_detect_instruction(:,2) = 0;

%%

all_blocks= {};
n_trials = 80;

%%

%Actual experiment code starts here


phase_types = {};
phase_types{1} = struct();
phase_types{1}.n_cued_targets = 0;
phase_types{1}.n_events = 40;
phase_types{1}.cue_interval = mean_delay;
phase_types{1}.cue_rate = 0;
phase_types{1}.phase_code = 1;

phase_types{2}=phase_types{1};
phase_types{2}.n_cued_targets = 80;
phase_types{2}.phase_code = 2;
phase_types{2}.cue_rate = .7;

phases = phase_types;

trial_tag = 10*params.detect_tag + 1;
filename=strcat(filepath, 'beat_detect_', timestamp);
block = stim_maker_detect(filename, n_trials, 3, fixed_delay_gen, beat_trial_length_gen, false, false, trial_tag, params);
block.filename=filename;
block.instructions = beat_cued_detect_instruction;
all_blocks{end+1} = block;

trial_tag = 10*params.detect_tag + 2;
filename = strcat(filepath, 'int_detect_', timestamp);
block = stim_maker_detect(filename, n_trials, 1, fixed_delay_gen, short_trial_length_gen, false, false, trial_tag, params);
block.filename=filename;
block.instructions = interval_cued_detect_instruction;
all_blocks{end+1} = block;

trial_tag = 10*params.detect_tag + 3;
filename = strcat(filepath, 'rand_detect_', timestamp);
block = stim_maker_detect(filename, n_trials, 1, uniform_rand_delay_gen, short_trial_length_gen, false, false, trial_tag, params);
block.filename=filename;
block.instructions = random_detect_instruction;
all_blocks{end+1} = block;

trial_tag = 10*params.detect_tag + 4;
filename=strcat(filepath, 'contingency_detect_', timestamp);
contingency_block = stim_maker_detect_contingency(filename, phases, uniform_rand_delay_gen, short_trial_length_gen, trial_tag, params);
contingency_block.filename=filename;
contingency_block.instructions = contingency_detect_instruction;
all_blocks{end+1} = contingency_block;

fullsound = [];

for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks{i}.instructions, all_blocks{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

wnoise = zeros(size(fullsound));
wnoise(:,1) = params.noise_amplitude*randn([size(wnoise, 1), 1]);

audiowrite(strcat(filepath, 'all_detect_', timestamp, '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_detect.mat_', timestamp, '.mat'), 'all_blocks');
