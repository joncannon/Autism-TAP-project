timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');


filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/shift_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

all_periods = [.55, .575, .6, .625, .650];
all_shifts = [-.05];
%all_per_words = {'600'};
%all_shift_words = {'-50'};

params = default_params();

all_blocks = {};

separation_space = zeros(44100*params.intertrial_time, 2);

% intervals = [10, 1];
% identities = [params.target_index, params.target_index];
% [snd_total, code]=master_stim_maker(strcat(filepath, 'free_tap_', j, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), intervals, identities, params);
% free_block = struct();
% free_block.sound = snd_total;
% free_block.code = code;
% free_block.type = 'free';
% free_block.instructions = free_inst;

n_reps = 3;
filename = 'tmp'

for i = 1:length(all_periods)
    for j = 1:length(all_shifts)
        for n = 1:n_reps
            %filename = strcat(filepath, 'phase_shift_', all_shift_words{j}, '_', all_per_words{i}, '_', timestamp);
            block = stim_maker_temposhift(filename, all_periods(i), 3, 1, 4, all_shifts(j), 10*i+j, params);
            block.instruction_type = 'tap_along';
            block.instructions = []
            all_blocks{end+1} = block;

            filename = strcat(filepath, 'phase_shift_2_', all_shift_words{j}, '_', all_per_words{i}, '_', timestamp);
            block = stim_maker_phaseshift(filename, all_periods(i), randi(4)+6, 2, 3, all_shifts(j), 10*i+j, params);
            block.instruction_type = 'tap_along';
            block.instructions = []
            block.type = 'phase_shift_2'
            all_blocks{end+1} = block;

            filename = strcat(filepath, 'tempo_shift_', all_shift_words{j}, '_', all_per_words{i}, '_', timestamp);
            block = stim_maker_phaseshift(filename, all_periods(i), randi(4)+6, 5, 0, all_shifts(j), 10*i+j, params);
            block.instruction_type = 'tap_along';
            block.instructions = []
            block.type = 'tempo_shift'
            all_blocks{end+1} = block;
        end
    end
end


[B,i_shift] = sort(rand(1, length(all_blocks)));
for i = 1:length(all_blocks)
    all_blocks_shuffled{i} = all_blocks{i_shift(i)};
end
all_blocks_shuffled{1}.instructions = [];


%all_blocks = horzcat(free_block, all_blocks)%, {contingency_block});
%all_blocks_shuffled = horzcat(free_block, all_blocks_shuffled)%, {contingency_block});
shuffled_indices = i_shift;%horzcat(1, i_shift+1);

fullsound = [];
for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks_shuffled{i}.instructions, all_blocks_shuffled{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_shift_metronomes_', timestamp, '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_shift_metronomes_', timestamp, '.mat'), 'fullsound', 'all_blocks', 'all_blocks_shuffled', 'shuffled_indices', 'params');