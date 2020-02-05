function block=stim_maker_vdiscrim(filename, n_trials, n_cues, cue_delay_generator, intertrial_interval_generator, trial_tag, params)

identities = [];
intervals = [];

for i = 1:n_trials
    for j = 1:n_cues
        identities(end+1) = params.standard_index;
        intervals(end+1) = cue_delay_generator(i);
    end
    
    up_or_down = floor(rand()*2);
    difficulty = floor(rand()*params.n_vdiscrim_difficulties)+1;
    pitch = floor(rand()*params.n_vdiscrim_pitches)+1;
    id = params.get_vdiscrim_id(pitch, difficulty, up_or_down)
    
    identities(end+1) = id;
    intervals(end+1) = intertrial_interval_generator(i);
end

block = struct();

block.sound=master_stim_maker(filename, intervals, identities, params);
block.params = params;

block.trial_tag = trial_tag;
block.code = identities + 100*trial_tag;
block.intervals = intervals;
block.identities = identities;
block.type = 'vdiscrim';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
