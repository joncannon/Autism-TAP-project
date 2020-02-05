%Event codes:
% ones place - event type: 1=standard, 2=deviant, 3=target, 4=omission,
% 5=end, 9=tap

% hundreds place - period: 1=.6s, 2=.7s, 3=.8s, 0=N/A or .5 (deviant
% control)

% thousands place - trial type: 0=listen metronome, 1=tap metronome,
% 2=listen deviant, 3=listen omission, 4=tap omission, 5=deviant control
% 6=free tap, 7=contingency


all_periods = [.6, .7, .8];
all_filewords = {'600', '700', '800'};

timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');
filepath = strcat('../stimulus_sequences/', 'discrim_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

params = default_params();
params.all_periods = all_periods;

listening_blocks = {};
tapping_blocks = {};
deviant_control_blocks = {};

separation_space = zeros(44100*params.intertrial_time, 2);

this_is_target = 1.2*audioread('../stimulus_components/ThisIsTargetSound.wav');
react = audioread('../stimulus_components/TapReaction2.wav');
dont_move = audioread('../stimulus_components/DoNotMove.wav');

distract_inst = audioread('../stimulus_components/Safari_time.wav');
distract_inst(:,2) = 0;
distract_inst = vertcat(distract_inst, zeros(44100*5, 2));

free_inst = audioread('../stimulus_components/FreeTap_2.wav');
free_inst(:,2) = 0;
free_inst = vertcat(free_inst, zeros(44100*3, 2));

init_rxn_inst = vertcat(this_is_target, params.sound_list{params.target_index}, react, dont_move, zeros(44100*2, 1));
init_rxn_inst(:,2) = 0;
contingency_rxn_inst = vertcat(this_is_target, params.sound_list{params.target_index}, react, zeros(44100*2, 1));
contingency_rxn_inst(:,2) = 0;
rxn_inst = vertcat(react, zeros(44100*2, 1));
rxn_inst(:,2) = 0;

tapalong_inst = vertcat(audioread('../stimulus_components/TapAlong.wav'), zeros(44100*1, 1));
tapalong_inst(:,2) = 0;

long_tapalong_inst = vertcat(audioread('../stimulus_components/long_tapalong.wav'), zeros(44100*1, 1));
long_tapalong_inst(:,2) = 0;



for i = 1:length(all_periods)
    i
    for j=1:2
        trial_tag = i+10*params.listen_standard_tag;
        block = stim_maker_standard(strcat(filepath, 'listen_metronome_', all_filewords{i}, '_', timestamp), all_periods(i), 25+floor(rand()*5), false, trial_tag, params);
        block.instruction_type = 'listen';
        block.instructions = [];%rxn_inst;
        listening_blocks{end+1} = block;
    end
    
    
    for j=1:2
        trial_tag = i+10*params.tap_standard_tag;
        block = stim_maker_standard(strcat(filepath, 'tap_metronome_', all_filewords{i}, '_', timestamp), all_periods(i), 25+floor(rand()*5), true, trial_tag, params);
        block.instruction_type = 'tap';
        block.instructions = zeros(44100,2);
        tapping_blocks{end+1} = block;
    end
    
    for j = 1:4
        trial_tag = i+10*params.listen_deviant_tag;
        block = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_', j, '_', all_filewords{i}, '_', timestamp), all_periods(i), 25+floor(rand()*5), 0.3, false, trial_tag, params);
        block.instruction_type = 'listen';
        block.instructions = [];%rxn_inst;
        listening_blocks{end+1} = block;
    end
    
%     block = stim_maker_deviant(strcat(filepath, 'tap_deviant_metronome_', all_filewords{i}, '_', timestamp), all_periods(i), 45+floor(rand()*5), 0.1, params);
%     key.instruction_type = 'tap';
%     tapping_blocks{end+1} = struct();
%     tapping_blocks{end}.sound = vertcat(tapalong_inst, snd_total);
%     tapping_blocks{end}.key = key;
%     tapping_blocks{end}.params = params;
    
    for j = 1:4
        trial_tag = i+10*params.listen_omission_tag;
        block = stim_maker_omission(strcat(filepath, 'listen_omission_metronome_', j, '_', all_filewords{i}, '_', timestamp), all_periods(i), 25+floor(rand()*5), 0.3, false, trial_tag, params);
        block.instruction_type = 'listen';
        block.instructions = [];%rxn_inst;
        listening_blocks{end+1} = block;
    end
    
    for j=1:3
        trial_tag = i+10*params.tap_omission_tag; %%!!! go through old data and check this code
        block = stim_maker_omission(strcat(filepath, 'tap_omission_metronome_', all_filewords{i}, '_', timestamp), all_periods(i), 25+floor(rand()*5), 0.3, true, trial_tag, params);
        block.instruction_type = 'tap';
        block.instructions = zeros(44100,2);
        tapping_blocks{end+1} = block;
    end
end

params.lead_in=0;
params.allowable_distance = 0;
for i = 2:2
    for j = 1:2
        trial_tag = i+10*params.deviant_control_tag;
        block = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_control_', j, '_', timestamp), all_periods(i), 25+floor(rand()*5), 1, false, trial_tag, params);
        block.type = 'all_deviant';
        block.instruction_type = 'listen';
        block.instructions = [];%rxn_inst;
        deviant_control_blocks{end+1} = block;
    end
end


trial_tag = 10*params.free_tap_tag;
free_block = stim_maker_freetap(strcat(filepath, 'free_tap_', j, '_', timestamp), 20, trial_tag, params);
free_block.instructions = free_inst;

'free done'

phase_types = {};
phase_types{1} = struct();
phase_types{2} = struct();
phase_types{1}.n_cued_targets = 35%40;
phase_types{2}.n_cued_targets = 35%40;
phase_types{1}.n_events = 110%180;
phase_types{2}.n_events = 110%180;
phase_types{1}.cue_interval = .7;
phase_types{2}.cue_interval = .7;
phase_types{1}.cue_rate = .5;
phase_types{2}.cue_rate = .8;
phase_types{1}.phase_code = 1;
phase_types{2}.phase_code = 2;

phases = {phase_types{1}, phase_types{2}, phase_types{1}};

intertrial_range = [1, 1.8];
trial_tag = 10*params.contingency_tag;
contingency_block = stim_maker_pawan_contingency(strcat(filepath, 'contingency_three_phase_', timestamp), phases, intertrial_range, true, trial_tag, params);
contingency_block.instructions = contingency_rxn_inst;

'c done'

deviant_control_blocks{1}.instructions = distract_inst;

[B,i_listen] = sort(rand(1, length(listening_blocks)));
listening_blocks_shuffled = {};
for i = 1:length(listening_blocks)
    listening_blocks_shuffled{i} = listening_blocks{i_listen(i)};
end

[B,i_tap] = sort(rand(1, length(tapping_blocks)));
tapping_blocks_shuffled = {};
for i = 1:length(tapping_blocks)
    tapping_blocks_shuffled{i} = tapping_blocks{i_tap(i)};
    seq_inst = audioread(strcat('../stimulus_components/seq', num2str(i), '.wav'));
    seq_inst(:,2) = 0;
    tapping_blocks_shuffled{i}.instructions = vertcat(seq_inst, tapping_blocks_shuffled{i}.instructions);
    if i==1
        tapping_blocks_shuffled{i}.instructions = vertcat(long_tapalong_inst, tapping_blocks_shuffled{i}.instructions);
    end
end

all_blocks = horzcat(deviant_control_blocks(1), listening_blocks, deviant_control_blocks(2), free_block, tapping_blocks, contingency_block);
all_blocks_shuffled = horzcat(deviant_control_blocks(1), listening_blocks_shuffled, deviant_control_blocks(2), free_block, tapping_blocks_shuffled, contingency_block);
shuffled_indices = horzcat(i_listen, length(i_listen)+1, i_tap+length(i_listen)+1, length(all_blocks));

fullsound = [];
for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks_shuffled{i}.instructions, all_blocks_shuffled{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
%    all_blocks_shuffled{i}.type
%    length(all_blocks_shuffled{i}.sound)
    
end

audiowrite(strcat(filepath, 'all_metronomes_', timestamp, '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_metronomes.mat_', timestamp, '.mat'), 'fullsound', 'all_blocks', 'all_blocks_shuffled', 'shuffled_indices', 'params');
