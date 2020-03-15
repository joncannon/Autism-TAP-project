function block=stim_maker_detect(filename, n_trials, n_cues, cue_delay_generator, trial_length_generator, bell, is_example, trial_tag, params)

identities = [];
intervals = [];

if is_example
    n_trials = 3;
end
example_difficulties = [6,4,1];
example_pitches = [1,4,1];

for i = 1:n_trials
    duration_counter = 0;
    for j = 1:n_cues
        identities(end+1) = params.standard_index;
        intervals(end+1) = cue_delay_generator(i);
        duration_counter = duration_counter + intervals(end);
    end
    
    if is_example
        difficulty = example_difficulties(i);
        pitch = example_pitches(i);
    else
        difficulty = floor(rand()*params.n_detect_difficulties)+1;
        pitch = floor(rand()*params.n_detect_pitches)+1;
    end
    
    id = params.get_detect_id(pitch, difficulty);
    
    identities(end+1) = id;
    
    intervals(end+1) = trial_length_generator(i) - duration_counter;
    
    if bell
        identities(end+1) = params.bell_index;
        intervals(end+1) = 4;
    end

end

block = struct();

block.sound=master_stim_maker(filename, intervals, identities, params);
if is_example
    block.sound(:,2) = 0;
end

block.params = params;

block.trial_tag = trial_tag;
block.code = mod(identities,100) + 100*trial_tag;
block.intervals = intervals;
block.identities = identities;
block.type = 'detect';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
