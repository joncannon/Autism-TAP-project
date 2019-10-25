all_periods = [.8, .7, .6, .5, .4];
all_filewords = {'800', '700', '600', '500', '400'};
mkdir(strcat('stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS')));
filepath = strcat('stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS'), '/');

params = struct();
params.lead_in=4;
params.allowable_distance = 3;
params.Fs = 44100;
tick = audioread('stimulus_components/wood_tick.wav');
params.tick = tick(:,1);
deviant = audioread('stimulus_components/wood_tick.wav');
params.deviant = resample(deviant(:,1), 2,3);
target = audioread('stimulus_components/target_beep.wav');
params.target = target(:,1);

listening_blocks = {};
tapping_blocks = {};

separation_space = zeros(44100*5, 2);
separation_space(:,2)=.5;

rxn_inst_1 = audioread('stimulus_components/ThisIsTargetSound.wav');
rxn_inst_2 = audioread('stimulus_components/TapReaction.wav');
rxn_inst_3 = audioread('stimulus_components/DoNotMove.wav');
rxn_inst = vertcat(rxn_inst_1, target, rxn_inst_2, rxn_inst_3);
rxn_inst(:,2) = 0;

tapalong_inst = audioread('stimulus_components/TapAlong.wav');
tapalong_inst(:,2) = 0;

for i = 1:length(all_periods)
    [snd_total, key] = stim_maker_deviant(strcat(filepath, 'listen_metronome_', all_filewords{i}), all_periods(i), 45+floor(rand()*5), 0, params);
    key.instruction = 'listen';
    listening_blocks{end+1} = struct();
    listening_blocks{end}.sound = vertcat(rxn_inst, snd_total);
    listening_blocks{end}.key = key;
    listening_blocks{end}.params = params;
    
    
    [snd_total, key] = stim_maker_deviant(strcat(filepath, 'tap_metronome_', all_filewords{i}), all_periods(i), 45+floor(rand()*5), 0, params);
    key.instruction = 'tap';
    tapping_blocks{end+1} = struct()
    tapping_blocks{end}.sound = vertcat(tapalong_inst, snd_total);
    tapping_blocks{end}.key = key;
    tapping_blocks{end}.params = params;
    
    
    [snd_total, key] = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_', all_filewords{i}), all_periods(i), 45+floor(rand()*5), 0.1, params);
    key.instruction = 'listen';
    listening_blocks{end+1} = struct();
    listening_blocks{end}.sound = vertcat(rxn_inst, snd_total);
    listening_blocks{end}.key = key;
    listening_blocks{end}.params = params;
    
    [snd_total, key] = stim_maker_deviant(strcat(filepath, 'tap_deviant_metronome_', all_filewords{i}), all_periods(i), 45+floor(rand()*5), 0.1, params);
    key.instruction = 'tap';
    tapping_blocks{end+1} = struct();
    tapping_blocks{end}.sound = vertcat(tapalong_inst, snd_total);
    tapping_blocks{end}.key = key;
    tapping_blocks{end}.params = params;
    
    [snd_total, key] = stim_maker_omission(strcat(filepath, 'listen_omission_metronome_', all_filewords{i}), all_periods(i), 45+floor(rand()*5), 0.1, params);
    key.instruction = 'listen';
    listening_blocks{end+1} = struct();
    listening_blocks{end}.sound = vertcat(rxn_inst, snd_total);
    listening_blocks{end}.key = key;
    listening_blocks{end}.params = params;
    
    [snd_total, key] = stim_maker_omission(strcat(filepath, 'tap_omission_metronome_', all_filewords{i}), all_periods(i), 45+floor(rand()*5), 0.1, params);
    key.instruction = 'tap';
    tapping_blocks{end+1} = struct()
    tapping_blocks{end}.sound = vertcat(tapalong_inst, snd_total);
    tapping_blocks{end}.key = key;
    tapping_blocks{end}.params = params;

end

[snd_total, key] = stim_maker_deviant(strcat(filepath, 'listen_deviant_metronome_control'), .5, 45+floor(rand()*5), 0.1, params);
key.instruction = 'listen';
listening_blocks{end+1} = struct();
listening_blocks{end}.sound = vertcat(rxn_inst, snd_total);
listening_blocks{end}.key = key;
listening_blocks{end}.params = params;

[B,i_listen] = sort(rand(1, length(listening_blocks)));
[B,i_tap] = sort(rand(1, length(tapping_blocks)));
i_tap = i_tap + length(listening_blocks);

shuffled_indices = horzcat(i_listen, i_tap);
all_blocks = horzcat(listening_blocks, tapping_blocks);
fullsound = [];

for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks{shuffled_indices(i)}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_metronomes.wav'), fullsound, 44100)

save(strcat(filepath, 'all_metronomes.mat'), 'fullsound', 'all_blocks')