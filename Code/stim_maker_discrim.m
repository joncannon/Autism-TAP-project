function block=stim_maker_discrim(filename, n_trials, cue_delay, intertrial_interval, trial_tag, params)

identities = [];
intervals = [];

for i = 1:n_trials
    identities(end+1) = params.standard_index;
    intervals(end+1) = cue_delay;
    
    up_or_down = floor(rand()*2);
    difficulty = floor(rand()*params.n_difficulties)+1;
    pitch = floor(rand()*params.n_pitches)+1;
    id = params.get_id(pitch, difficulty, up_or_down)
    
    identities(end+1) = id;
    intervals(end+1) = intertrial_interval;
end

block = struct();

block.sound=master_stim_maker(filename, intervals, identities, params);
block.params = params;

block.trial_tag = trial_tag;
block.code = identities + 100*trial_tag;
block.intervals = intervals;
block.identities = identities;
block.type = 'discrim';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
