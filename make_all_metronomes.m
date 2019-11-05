all_periods = [.6, .7, .8];
all_filewords = {'600', '700', '800'};
mkdir(strcat('stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS')));
filepath = strcat('stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS'), '/');

params = struct();

params.lead_in=4;
params.allowable_distance = 3;

params.save_separate = false;
params.wav_separate = false;
params.Fs = 44100;
params.sound_list = {};

tick = audioread('stimulus_components/wood_tick.wav');
params.sound_list{1} = 0.2*tick(:,1);
params.standard_index = 1;

params.sound_list{2} = .2*resample(tick(:,1), 4,5);
params.deviant_index = 2;

target = audioread('stimulus_components/target_beep.wav');
params.sound_list{3} = 0.2*target(:,1);
params.target_index = 3;

params.sound_list{4} = 0;
params.omission_index = 4;


params.shift_code = 10;
params.tempo_code = 20;

params.eeg_amplitude = 0.005;
params.sync_samples = 200;
params.intertrial_amplitude = .0025;

listening_blocks = {};
tapping_blocks = {};

separation_space = zeros(44100*5, 2);
separation_space(:,2)=params.intertrial_amplitude;

rxn_inst_1 = audioread('stimulus_components/ThisIsTargetSound.wav');
rxn_inst_2 = audioread('stimulus_components/TapReaction.wav');
rxn_inst_3 = audioread('stimulus_components/DoNotMove.wav');

init_rxn_inst = vertcat(rxn_inst_1, params.sound_list{params.target_index});
init_rxn_inst(:,2) = 0;
rxn_inst = vertcat(rxn_inst_2, rxn_inst_3, zeros(44100*2, 1));
rxn_inst(:,2) = 0;

tapalong_inst = vertcat(audioread('stimulus_components/TapAlong.wav'), zeros(44100*1, 1));
tapalong_inst(:,2) = 0;

for i = 1:length(all_periods)

    block = stim_maker_standard(strcat(filepath, 'listen_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), true, i, params);
    block.instruction_type = 'listen';
    block.instructions = rxn_inst;
    listening_blocks{end+1} = block;
    
    
    block = stim_maker_standard(strcat(filepath, 'tap_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), false, i, params);
    block.instruction_type = 'tap';
    block.instructions = tapalong_inst;
    tapping_blocks{end+1} = block;
    
    for j = 1:4
        block = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_', j, '_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 25+floor(rand()*5), 0.3, true, i, params);
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
        block = stim_maker_omission(strcat(filepath, 'listen_omission_metronome_', j, '_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 25+floor(rand()*5), 0.3, true, i, params);
        block.instruction_type = 'listen';
        block.instructions = rxn_inst;
        listening_blocks{end+1} = block;
    end
    
    block = stim_maker_omission(strcat(filepath, 'tap_omission_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), 0.3, false, i, params);
    block.instruction_type = 'tap';
    block.instructions = tapalong_inst;
    tapping_blocks{end+1} = block;

end

params.lead_in=0;
params.allowable_distance = 0;
for j = 1:2
    block = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_control_', j, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), .5, 25+floor(rand()*5), 1, true, 9, params);
    block.type = 'all_deviant';
    block.instruction_type = 'listen';
    block.instructions = rxn_inst;
    listening_blocks{end+1} = block;
end

phase_types = {};
phase_types{1} = struct();
phase_types{2} = struct();
phase_types{1}.n_targets = 20;
phase_types{2}.n_targets = 20;
phase_types{1}.range = [.5,1.5];
phase_types{2}.range = [.5,.8];
phases = {phase_types{1}, phase_types{2}, phase_types{1}, phase_types{2}, phase_types{1}, phase_types{2}};

intertrial_range = [.8, 1.5];
contingency_block = stim_maker_contingency(strcat(filepath, 'contingency_two_phase_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), .5, phases, intertrial_range, 0, params);
contingency_block.instructions = vertcat( init_rxn_inst, rxn_inst);

[B,i_listen] = sort(rand(1, length(listening_blocks)));
for i = 1:length(listening_blocks)
    listening_blocks_shuffled{i} = listening_blocks{i_listen(i)};
end
[B,i_tap] = sort(rand(1, length(tapping_blocks)));
for i = 1:length(tapping_blocks)
    tapping_blocks_shuffled{i} = tapping_blocks{i_tap(i)};
end


all_blocks = horzcat(listening_blocks, tapping_blocks, {contingency_block});
all_blocks_shuffled = horzcat(listening_blocks_shuffled, tapping_blocks_shuffled, {contingency_block});
shuffled_indices = horzcat(i_listen, i_tap+length(i_listen), length(all_blocks));

fullsound = init_rxn_inst;
for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks_shuffled{i}.instructions, all_blocks_shuffled{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_metronomes_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS'), '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_metronomes.mat_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS'), '.mat'), 'fullsound', 'all_blocks', 'shuffled_indices');