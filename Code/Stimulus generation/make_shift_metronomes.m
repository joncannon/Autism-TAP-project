timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');

all_periods = [.6, .7, .8];
all_shifts = [-.02, -.01, 0, .01, .02];
all_per_words = {'600', '700', '800'};
all_shift_words = {'-20', '-10', '0', '10', '20'};
mkdir(strcat('../stimulus_sequences/', timestamp, '_shift'));
filepath = strcat('../stimulus_sequences/', timestamp, '_shift/');

params = struct();
params = default_params();

all_blocks = {};

separation_space = zeros(44100*params.intertrial_time, 2);



intervals = [10, 1];
identities = [params.target_index, params.target_index];
[snd_total, code]=master_stim_maker(strcat(filepath, 'free_tap_', j, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), intervals, identities, params);
free_block = struct();
free_block.sound = snd_total;
free_block.code = code;
free_block.type = 'free';
free_block.instructions = free_inst;

for i = 1:length(all_periods)
    for j = 1:length(all_shifts)
        filename = strcat(filepath, 'phase_shift_', all_shift_words{j}, '_', all_per_words{i}, '_', timestamp);
        block = stim_maker_phaseshift(filename, all_periods(i), randi(4)+8, 8, all_shifts(j), 10*i+j, params);
        block.instruction_type = 'tap_along';
        block.instructions = []
        all_blocks{end+1} = block;

        filename = strcat(filepath, 'tempo_shift_', all_shift_words{j}, '_', all_per_words{i}, '_', timestamp);
        block = stim_maker_temposhift(filename, all_periods(i), randi(4)+8, 8, all_shifts(j), 10*i+j, params);
        block.instruction_type = 'tap_along';
        block.instructions = []
        all_blocks{end+1} = block;

    end
end


% 
% phase_types = {};
% phase_types{1} = struct();
% phase_types{2} = struct();
% phase_types{1}.n_targets = 20;
% phase_types{2}.n_targets = 20;
% phase_types{1}.range = [.5,1.5];
% phase_types{2}.range = [.5,.8];
% phases = {phase_types{1}, phase_types{2}, phase_types{1}, phase_types{2}, phase_types{1}, phase_types{2}};
% 
% intertrial_range = [.8, 1.5];
% contingency_block = stim_maker_contingency(strcat(filepath, 'contingency_two_phase_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), .5, phases, intertrial_range, 0, params);
% contingency_block.instructions = vertcat( init_rxn_inst, rxn_inst);
% 
[B,i_shift] = sort(rand(1, length(all_blocks)));
for i = 1:length(all_blocks)
    all_blocks_shuffled{i} = all_blocks{i_shift(i)};
end
all_blocks_shuffled{1}.instructions = [];


all_blocks = horzcat(free_block, all_blocks)%, {contingency_block});
all_blocks_shuffled = horzcat(free_block, all_blocks_shuffled)%, {contingency_block});
shuffled_indices = horzcat(1, i_shift+1);

fullsound = [];
for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks_shuffled{i}.instructions, all_blocks_shuffled{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_shift_metronomes_', timestamp, '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_shift_metronomes_', timestamp, '.mat'), 'fullsound', 'all_blocks', 'all_blocks_shuffled', 'shuffled_indices', 'params');