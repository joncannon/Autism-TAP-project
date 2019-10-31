all_periods = [.8, .7, .6, .5, .4];
all_filewords = {'800', '700', '600', '500', '400'};
mkdir(strcat('stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS')));
filepath = strcat('stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS'), '/');

params = struct();
params.lead_in=4;
params.allowable_distance = 3;
params.save_separate = false;
params.wav_separate = false;
params.Fs = 44100;
tick = audioread('stimulus_components/wood_tick.wav');
params.tick = 0.2*tick(:,1);
params.deviant = resample(tick(:,1), 2,3);
target = audioread('stimulus_components/target_beep.wav');
params.target = 0.2*target(:,1);
params.eeg_amplitude = 0.005;
params.intertrial_amplitude = .0025;
params.standard_code = 0;
params.deviant_code = 1;
params.omission_code = 3;
params.target_code = 2;

listening_blocks = {};
tapping_blocks = {};

separation_space = zeros(44100*5, 2);
separation_space(:,2)=params.intertrial_amplitude;

rxn_inst_1 = audioread('stimulus_components/ThisIsTargetSound.wav');
rxn_inst_2 = audioread('stimulus_components/TapReaction.wav');
rxn_inst_3 = audioread('stimulus_components/DoNotMove.wav');

init_rxn_inst = vertcat(rxn_inst_1, params.target);
init_rxn_inst(:,2) = 0;
rxn_inst = vertcat(rxn_inst_2, rxn_inst_3, zeros(44100*2, 1));
rxn_inst(:,2) = 0;

tapalong_inst = vertcat(audioread('stimulus_components/TapAlong.wav'), zeros(44100*1, 1));
tapalong_inst(:,2) = 0;

for i = 1:length(all_periods)
    [snd_total, key] = stim_maker_deviant(strcat(filepath, 'listen_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), 0, params);
    key.instruction = 'listen';
    listening_blocks{end+1} = struct();
    listening_blocks{end}.sound = vertcat(rxn_inst, snd_total);
    listening_blocks{end}.key = key;
    listening_blocks{end}.params = params;
    
    
    [snd_total, key] = stim_maker_deviant(strcat(filepath, 'tap_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), 0, params);
    key.instruction = 'tap';
    tapping_blocks{end+1} = struct();
    tapping_blocks{end}.sound = vertcat(tapalong_inst, snd_total);
    tapping_blocks{end}.key = key;
    tapping_blocks{end}.params = params;
    
    
    [snd_total, key] = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), 0.1, params);
    key.instruction = 'listen';
    listening_blocks{end+1} = struct();
    listening_blocks{end}.sound = vertcat(rxn_inst, snd_total);
    listening_blocks{end}.key = key;
    listening_blocks{end}.params = params;
    
%     [snd_total, key] = stim_maker_deviant(strcat(filepath, 'tap_deviant_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), 0.1, params);
%     key.instruction = 'tap';
%     tapping_blocks{end+1} = struct();
%     tapping_blocks{end}.sound = vertcat(tapalong_inst, snd_total);
%     tapping_blocks{end}.key = key;
%     tapping_blocks{end}.params = params;
    
    [snd_total, key] = stim_maker_omission(strcat(filepath, 'listen_omission_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), 0.1, params);
    key.instruction = 'listen';
    listening_blocks{end+1} = struct();
    listening_blocks{end}.sound = vertcat(rxn_inst, snd_total);
    listening_blocks{end}.key = key;
    listening_blocks{end}.params = params;
    
    [snd_total, key] = stim_maker_omission(strcat(filepath, 'listen_omission_metronome_2_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), 0.1, params);
    key.instruction = 'listen';
    listening_blocks{end+1} = struct();
    listening_blocks{end}.sound = vertcat(rxn_inst, snd_total);
    listening_blocks{end}.key = key;
    listening_blocks{end}.params = params;
    
    [snd_total, key] = stim_maker_omission(strcat(filepath, 'tap_omission_metronome_', all_filewords{i}, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), all_periods(i), 45+floor(rand()*5), 0.1, params);
    key.instruction = 'tap';
    tapping_blocks{end+1} = struct();
    tapping_blocks{end}.sound = vertcat(tapalong_inst, snd_total);
    tapping_blocks{end}.key = key;
    tapping_blocks{end}.params = params;

end

[snd_total, key] = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_control_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), .5, 45+floor(rand()*5), 0.1, params);
key.instruction = 'listen';
listening_blocks{end+1} = struct();
listening_blocks{end}.sound = vertcat(rxn_inst, snd_total);
listening_blocks{end}.key = key;
listening_blocks{end}.params = params;

phase_types = {};
phase_types{1} = struct();
phase_types{2} = struct();
phase_types{1}.n_targets = 20;
phase_types{2}.n_targets = 20;
phase_types{1}.range = [.5,1.5];
phase_types{2}.range = [.5,.8];
phases = {phase_types{1}, phase_types{2}, phase_types{1}, phase_types{2}, phase_types{1}, phase_types{2}};

intertrial_range = [.8, 1.5];
[snd_total, key] = stim_maker_contingency(strcat(filepath, 'contingency_two_phase_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), .5, phases, intertrial_range, params);
contingency_block = struct();
contingency_block.sound = vertcat( init_rxn_inst, rxn_inst, snd_total);
contingency_block.key = key;

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
fullsound = [];

fullsound= vertcat(fullsound, init_rxn_inst);

for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks_shuffled{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_metronomes_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS'), '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_metronomes.mat_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS'), '.mat'), 'fullsound', 'all_blocks', 'shuffled_indices');