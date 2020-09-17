timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');


filepath = strcat('/Users/cannon/Documents/MATLAB/Entrainment-Contingency/stimulus_sequences/multilead_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

all_periods = [.45, .55, .65, .75, .85];
all_per_words = {'450', '550', '650', '750', '850'};

params = default_params();

all_blocks = {};

separation_space = zeros(44100*params.intertrial_time, 2);

thirdbeat_instruction = audioread('stimulus_components/thirdbeat.wav');
fourthbeat_instruction = audioread('stimulus_components/fourthbeat.wav');
thirdbeat_instruction(:,2) = 0;
fourthbeat_instruction(:,2) = 0;
% intervals = [10, 1];
% identities = [params.target_index, params.target_index];
% [snd_total, code]=master_stim_maker(strcat(filepath, 'free_tap_', j, '_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), intervals, identities, params);
% free_block = struct();
% free_block.sound = snd_total;
% free_block.code = code;
% free_block.type = 'free';
% free_block.instructions = free_inst;

n_reps = 8;

for i = 1:length(all_periods)

        for n = 1:n_reps
            filename = strcat(filepath, 'thirdbeat_', all_per_words{i}, '_', timestamp);
            block = stim_maker_taplast(filename, all_periods(i), 2, true, n*10+i*100, params);
            block.instruction_type = 'tap_3';
            block.instructions = thirdbeat_instruction;
            block.type = 'third_beat';
            all_blocks{end+1} = block;

            filename = strcat(filepath, 'fourthbeat_', all_per_words{i}, '_', timestamp);
            block = stim_maker_taplast(filename, all_periods(i), 3, true, 1+n*10+i*100, params);
            block.instruction_type = 'tap_4';
            block.instructions = fourthbeat_instruction;
            block.type = 'fourth_beat';
            all_blocks{end+1} = block;

        end

end


[B,i_shift] = sort(rand(1, length(all_blocks)));
for i = 1:length(all_blocks)
    all_blocks_shuffled{i} = all_blocks{i_shift(i)};
end
%all_blocks_shuffled{1}.instructions = [];


shuffled_indices = i_shift;%horzcat(1, i_shift+1);

fullsound = [];
for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks_shuffled{i}.instructions, all_blocks_shuffled{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
end

audiowrite(strcat(filepath, 'all_leadin_metronomes_', timestamp, '.wav'), fullsound, 44100);

save(strcat(filepath, 'all_leadin_metronomes_', timestamp, '.mat'), 'fullsound', 'all_blocks', 'all_blocks_shuffled', 'shuffled_indices', 'params');