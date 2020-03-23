function block=stim_maker_detect_practice(filename, n_trials, choose_a_volume, interval_generator, delta_db, trial_tag, params)

identities = [];
intervals = [];

for i = 1:n_trials  
    
    difficulty = choose_a_volume(floor(rand()*length(choose_a_volume))+1);
    pitch = floor(rand()*params.n_detect_pitches)+1;
    id = params.get_detect_id(pitch, difficulty);
    
    identities(end+1) = id;
    
    intervals(end+1) = interval_generator(i);
    
end

block = struct();

block.sound=master_stim_maker(filename, intervals, identities, params);
block.sound(1,:) = block.sound(1,:) * 10^(delta_db / 20);
block.sound(2,:) = 0;

block.params = params;

block.trial_tag = trial_tag;
block.code = mod(identities,100) + 100*trial_tag;
block.intervals = intervals;
block.identities = identities;
block.type = 'detect';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
