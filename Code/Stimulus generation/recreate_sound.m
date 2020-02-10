function all_blocks_revamped = recreate_sound(all_blocks, params)

all_blocks_revamped = all_blocks;

for n = 1:length(all_blocks)
    if isfield(all_blocks{n}, 'filename')
        filename = all_blocks_revamped{n}.filename;
    else
        filename = '';
    end
    
    all_blocks_revamped{n}.sound = master_stim_maker(filename, all_blocks{n}.intervals, all_blocks{n}.identities, params);
    all_blocks_revamped{n}.params = params;
end