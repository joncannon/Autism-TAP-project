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
mkdir(strcat('../stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS')));
filepath = strcat('../stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS'), '/');

params = struct();

params.all_periods = all_periods;

params.lead_in=4;
params.allowable_distance = 3;

params.save_separate = false;
params.wav_separate = false;
params.Fs = 44100;
params.sound_list = {};

tick = audioread('../stimulus_components/wood_tick.wav');
params.sound_list{1} = 0.2*tick(:,1);
params.standard_index = 1;

params.sound_list{2} = .2*resample(tick(:,1), 5,4);
params.deviant_index = 2;

target = audioread('../stimulus_components/target_beep.wav');
params.sound_list{3} = 0.2*target(:,1);
params.target_index = 3;

params.sound_list{4} = 0;
params.omission_index = 4;

params.end_code = 5;

params.shift_code = 10;
params.tempo_code = 20;

params.listen_standard_tag = 0;
params.tap_standard_tag = 1;
params.listen_deviant_tag = 2;
params.listen_omission_tag = 3;
params.tap_omission_tag = 4;
params.deviant_control_tag = 5;
params.free_tap_tag = 6;
params.contingency_tag = 7;

params.sync_amplitude = 0.005;
params.sync_samples = 200;
params.intertrial_amplitude = .0025;
params.intertrial_time = 5;

listening_blocks = {};
tapping_blocks = {};

separation_space = zeros(44100*params.intertrial_time, 2);
separation_space(:,2)=params.intertrial_amplitude;

rxn_inst_1 = 1.2*audioread('../stimulus_components/ThisIsTargetSound.wav');
rxn_inst_2 = audioread('../stimulus_components/TapReaction2.wav');
rxn_inst_3 = audioread('../stimulus_components/DoNotMove.wav');

free_inst = audioread('../stimulus_components/FreeTap.wav');
free_inst(:,2) = 0;

init_rxn_inst = vertcat(rxn_inst_1, params.sound_list{params.target_index}, rxn_inst_2, rxn_inst_3, zeros(44100*2, 1));
init_rxn_inst(:,2) = 0;
rxn_inst = vertcat(rxn_inst_2, zeros(44100*2, 1));
rxn_inst(:,2) = 0;

tapalong_inst = vertcat(audioread('../stimulus_components/TapAlong.wav'), zeros(44100*1, 1));
tapalong_inst(:,2) = 0;

for i = 1:length(all_periods)
    i
    for j=1:2
        trial_tag = i+10*params.listen_standard_tag;
        block = stim_maker_standard(strcat(filepath, 'listen_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 25+floor(rand()*5), true, trial_tag, params);
        block.instruction_type = 'listen';
        block.instructions = rxn_inst;
        listening_blocks{end+1} = block;
    end
    
    
    for j=1:2
        trial_tag = i+10*params.tap_standard_tag;
        block = stim_maker_standard(strcat(filepath, 'tap_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 25+floor(rand()*5), false, trial_tag, params);
        block.instruction_type = 'tap';
        block.instructions = tapalong_inst;
        tapping_blocks{end+1} = block;
    end
    
    for j = 1:4
        trial_tag = i+10*params.listen_deviant_tag;
        block = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_', j, '_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 25+floor(rand()*5), 0.3, true, trial_tag, params);
        block.instruction_type = 'listen';
        block.instructions = rxn_inst;
        listening_blocks{end+1} = block;
    end
    
%     block = stim_maker_deviant(strcat(filepath, 'tap_deviant_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), 0.1, params);
%     key.instruction_type = 'tap';
%     tapping_blocks{end+1} = struct();
%     tapping_blocks{end}.sound = vertcat(tapalong_inst, snd_total);
%     tapping_blocks{end}.key = key;
%     tapping_blocks{end}.params = params;
    
    for j = 1:4
        trial_tag = i+10*params.listen_omission_tag;
        block = stim_maker_omission(strcat(filepath, 'listen_omission_metronome_', j, '_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 25+floor(rand()*5), 0.3, true, trial_tag, params);
        block.instruction_type = 'listen';
        block.instructions = rxn_inst;
        listening_blocks{end+1} = block;
    end
    
    for j=1:3
        grial_tag = i+10*params.tap_omission_tag;
        block = stim_maker_omission(strcat(filepath, 'tap_omission_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 25+floor(rand()*5), 0.3, false, trial_tag, params);
        block.instruction_type = 'tap';
        block.instructions = tapalong_inst;
        tapping_blocks{end+1} = block;
    end
end

params.lead_in=0;
params.allowable_distance = 0;
for i = 2:2
    for j = 1:2
        trial_tag = i+10*params.deviant_control_tag;
        block = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_control_', j, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 25+floor(rand()*5), 1, true, trial_tag, params);
        block.type = 'all_deviant';
        block.instruction_type = 'listen';
        block.instructions = rxn_inst;
        listening_blocks{end+1} = block;
    end
end

trial_tag = 10*params.free_tap_tag;
free_block = stim_maker_freetap(strcat(filepath, 'free_tap_', j, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), 20, trial_tag, params);
free_block.instructions = free_inst;

'free done'

phase_types = {};
phase_types{1} = struct();
phase_types{2} = struct();
phase_types{1}.n_targets = 50;
phase_types{2}.n_targets = 50;
phase_types{1}.cue_interval = .7;
phase_types{2}.cue_interval = .7;
phase_types{1}.cue_rate = .4;
phase_types{2}.cue_rate = .8;

phases = {phase_types{1}, phase_types{2}, phase_types{1}};

intertrial_range = [1, 1.8];
trial_tag = 10*params.contingency_tag;
contingency_block = stim_maker_pawan_contingency(strcat(filepath, 'contingency_three_phase_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), .25, phases, intertrial_range, trial_tag, params);
contingency_block.instructions = vertcat( init_rxn_inst, rxn_inst);

'c done'

[B,i_listen] = sort(rand(1, length(listening_blocks)));
listening_blocks_shuffled = {};
for i = 1:length(listening_blocks)
    listening_blocks_shuffled{i} = listening_blocks{i_listen(i)};
end
listening_blocks_shuffled{1}.instructions = init_rxn_inst;

[B,i_tap] = sort(rand(1, length(tapping_blocks)));
tapping_blocks_shuffled = {};
for i = 1:length(tapping_blocks)
    tapping_blocks_shuffled{i} = tapping_blocks{i_tap(i)};
end

all_blocks = horzcat(listening_blocks, free_block, tapping_blocks, contingency_block);
all_blocks_shuffled = horzcat(listening_blocks_shuffled, free_block, tapping_blocks_shuffled, contingency_block);
shuffled_indices = horzcat(i_listen, length(i_listen)+1, i_tap+length(i_listen)+1, length(all_blocks));

fullsound = [];
for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks_shuffled{i}.instructions, all_blocks_shuffled{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
    all_blocks_shuffled{i}.type
    length(all_blocks_shuffled{i}.sound)
    
end

audiowrite(strcat(filepath, 'all_metronomes_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS'), '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_metronomes.mat_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS'), '.mat'), 'fullsound', 'all_blocks', 'all_blocks_shuffled', 'shuffled_indices', 'params');
