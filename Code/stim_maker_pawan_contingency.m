function block=stim_maker_contingency(filename, phases, intertrial_range, uncued_targets, trial_tag, params)

identities = [];
intervals = [];
block = struct();
block.code = [];

for p = 1:length(phases)
    phase = phases{p};
    if uncued_targets
        cue_cutoff = phase.cue_rate / (1+(1-phase.cue_rate))
        fake_target_cutoff = 1 / (1+(1-phase.cue_rate))
    else
        cue_cutoff = phase.cue_rate;
        fake_target_cutoff = 1;
    end
    cued_target_counter = 0;
    event_counter = 0;
    while cued_target_counter<phase.n_cued_targets | event_counter<phase.n_events
        r = rand();
        event_counter = event_counter+1;
        if r<cue_cutoff
            identities(end+1) = params.standard_index;
            intervals(end+1) = phase.cue_interval;
            identities(end+1) = params.target_index;
            cued_target_counter = cued_target_counter+1;
            block.code(end+1:end+2)= [params.standard_index, params.target_index] + 10000 + phase.phase_code*100000 + + p*1000000;
        elseif r<fake_target_cutoff
            identities(end+1) = params.standard_index;
            block.code(end+1) = params.standard_index + phase.phase_code*100000 + p*1000000;
        else
            identities(end+1) = params.target_index;
            block.code(end+1) = params.target_index + phase.phase_code*100000 + p*1000000;
            %counter = counter+1;
        end
        
        intervals(end+1) = intertrial_range(1) + exprnd(intertrial_range(2));
    end
    cued_target_counter
    event_counter
end

block.trial_tag = trial_tag;
block.code = block.code + 100*trial_tag;
block.intervals = intervals;
size(intervals)
block.sound = master_stim_maker(filename, intervals, identities, params);
block.type = 'pawan_contingency';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
