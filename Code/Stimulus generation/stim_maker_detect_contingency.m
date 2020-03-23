function block=stim_maker_detect_contingency(filename, phases, choose_a_volume, random_delay_generator, trial_length_generator, trial_tag, params)

identities = [];
intervals = [];
block = struct();
block.code = [];

for p = 1:length(phases)
    phase = phases{p};
    cued_target_counter = 0;
    event_counter = 0;
    phase.n_cued_targets
    while cued_target_counter<phase.n_cued_targets | event_counter <phase.n_events
        r = rand();
        event_counter = event_counter+1;
        
        difficulty = choose_a_volume(floor(rand()*length(choose_a_volume))+1);
        pitch = floor(rand()*params.n_detect_pitches)+1;
        id = params.get_detect_id(pitch, difficulty);
        
        if r<phase.cue_rate
            identities(end+1) = params.standard_index;
            intervals(end+1) = phase.cue_interval;
            identities(end+1) = id;
            cued_target_counter = cued_target_counter+1;
            block.code(end+1:end+2)= [params.standard_index, id] + 100000 + p*1000000;
        else
            identities(end+1) = params.standard_index;
            intervals(end+1) = random_delay_generator();
            identities(end+1) = id;
            block.code(end+1:end+2)= [params.standard_index, id] + p*1000000;
            %counter = counter+1;
        end
        
        intervals(end+1) = trial_length_generator(0) - intervals(end);
    end
end

block.trial_tag = trial_tag;
block.code = block.code + 100*trial_tag;
block.intervals = intervals;
block.identities = identities;
size(intervals)
block.sound = master_stim_maker(filename, intervals, identities, params);
block.type = 'detect_contingency';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
