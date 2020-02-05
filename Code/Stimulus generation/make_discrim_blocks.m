timestamp=datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

filepath = strcat('../stimulus_sequences/', 'discrim_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

params = default_params();

separation_space = zeros(44100*params.intertrial_time, 2);

discrim_instruction = audioread('../stimulus_components/Discrim/Rising_or_falling.wav');
discrim_instruction = vertcat(discrim_instruction, audioread('../stimulus_components/Discrim/Rising.wav'));
discrim_instruction = vertcat(discrim_instruction, params.sound_list{params.get_discrim_id(3, 4, 0)});
discrim_instruction = vertcat(discrim_instruction, audioread('../stimulus_components/Discrim/Falling.wav'));
discrim_instruction = vertcat(discrim_instruction, params.sound_list{params.get_discrim_id(3, 4, 1)});

start_w_click_instruction = audioread('../stimulus_components/Discrim/Begin_with_a_woodblock.wav');
start_w_three_clicks_instruction = audioread('../stimulus_components/Discrim/Three_clicks.wav');

after_rand_instruction = audioread('../stimulus_components/Discrim/After_random_delay.wav');
after_fixed_instruction = audioread('../stimulus_components/Discrim/After_800ms.wav');
after_beats_instruction = audioread('../stimulus_components/Discrim/On_the_fourth_beat.wav');

some_examples_instruction = audioread('../stimulus_components/Discrim/Some_examples.wav');
try_examples_instruction = audioread('../stimulus_components/Discrim/Try_example.wav');
will_last_instruction = audioread('../stimulus_components/Discrim/Will_last.wav');
lets_start_instruction = audioread('../stimulus_components/Discrim/Lets_get_started.wav');


random_discrim_instruction = vertcat(discrim_instruction, start_w_click_instruction, params.sound_list{params.standard_index}, after_rand_instruction, try_examples_instruction, params.sound_list{params.get_discrim_id(3,4,0)}, zeros(44100*3, 1), will_last_instruction, lets_start_instruction);
random_discrim_instruction(:,2) = 0;

interval_example_1 =zeros((.8+3)*44100, 1);
interval_example_1(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
interval_example_1(.8*44100+1:.8*44100+length(params.sound_list{params.get_discrim_id(3,4,0)})) = params.sound_list{params.get_discrim_id(3,4,0)};

interval_example_2 =zeros((.8+3)*44100, 1);
interval_example_2(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
interval_example_2(.8*44100+1:.8*44100+length(params.sound_list{params.get_discrim_id(1,3,1)})) = params.sound_list{params.get_discrim_id(1,3,1)};

interval_example_3 =zeros((.8+3)*44100, 1);
interval_example_3(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
interval_example_3(.8*44100+1:.8*44100+length(params.sound_list{params.get_discrim_id(4,3,0)})) = params.sound_list{params.get_discrim_id(4,3,0)};

some_interval_examples = vertcat(interval_example_1, interval_example_2, interval_example_3);
interval_cued_discrim_instruction = vertcat(discrim_instruction, start_w_click_instruction, params.sound_list{params.standard_index}, after_fixed_instruction, some_examples_instruction, some_interval_examples, will_last_instruction, lets_start_instruction);
interval_cued_discrim_instruction(:,2) = 0;


beat_example =zeros(floor((.8+.8+.8)*44100), 1);
beat_example(1:length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
beat_example(.8*44100+1:.8*44100+length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};
beat_example(2*.8*44100+1:2*.8*44100+length(params.sound_list{params.standard_index})) = params.sound_list{params.standard_index};

beat_example_1 =zeros(floor((.8+.8+.8+3)*44100), 1);
beat_example_1(1:length(beat_example)) = beat_example;
beat_example_2 = beat_example_1;
beat_example_3 = beat_example_1;

beat_example_1(3*.8*44100+1:3*.8*44100+length(params.sound_list{params.get_discrim_id(3,1,0)})) = params.sound_list{params.get_discrim_id(3,4,0)};
beat_example_2(3*.8*44100+1:3*.8*44100+length(params.sound_list{params.get_discrim_id(1,2,1)})) = params.sound_list{params.get_discrim_id(1,3,1)};
beat_example_3(3*.8*44100+1:3*.8*44100+length(params.sound_list{params.get_discrim_id(4,2,0)})) = params.sound_list{params.get_discrim_id(4,3,0)};

some_beat_examples = vertcat(beat_example_1, beat_example_2, beat_example_3);

beat_cued_discrim_instruction = vertcat(discrim_instruction, start_w_three_clicks_instruction, beat_example, after_beats_instruction, some_examples_instruction, some_beat_examples, will_last_instruction, lets_start_instruction);
beat_cued_discrim_instruction(:,2) = 0;

fixed_delay_gen = @(i) .8;
fixed_interval_gen = @(i) 3;
rand_delay_gen = @(i) exprnd(4);

all_blocks= {};
n_trials = 25;

trial_tag = 10*params.discrim_tag + 1;
block = stim_maker_discrim(strcat(filepath, 'rand_discrim_', timestamp), n_trials, 1, rand_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = random_discrim_instruction;
all_blocks{end+1} = block;


trial_tag = 10*params.discrim_tag + 2;
block = stim_maker_discrim(strcat(filepath, 'int_discrim_', timestamp), n_trials, 1, fixed_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = interval_cued_discrim_instruction;
all_blocks{end+1} = block;


trial_tag = 10*params.discrim_tag + 3;
block = stim_maker_discrim(strcat(filepath, 'beat_discrim_', timestamp), n_trials, 3, fixed_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = beat_cued_discrim_instruction;
all_blocks{end+1} = block;

trial_tag = 10*params.discrim_tag + 1;
block = stim_maker_discrim(strcat(filepath, 'rand_discrim_2_', timestamp), n_trials, 1, rand_delay_gen, fixed_interval_gen, trial_tag, params);
block.instructions = random_discrim_instruction;
all_blocks{end+1} = block;
        
fullsound = [];
for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks{i}.instructions, all_blocks{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_discrim_', timestamp, '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_discrim.mat_', timestamp, '.mat'), 'fullsound', 'all_blocks', 'params');
