function block=stim_maker_contingency(filename, cue_rate, phases, intertrial_range, trial_tag, params)

identities = [];
intervals = [];
block = struct();
block.code = [];

cue_cutoff = cue_rate / (1+(1-cue_rate));
fake_cue_cutoff = 1 / (1+(1-cue_rate));

for p = 1:length(phases)
    phase = phases{p};
    counter = 0;
    while counter<phase.n_targets
        r = rand();
        if r<cue_cutoff
            identities(end+1) = params.standard_index;
            intervals(end+1) = phase.cue_interval;
            identities(end+1) = params.target_index;
            counter = counter+1;
            block.code(end+1:end+2)= [10+params.standard_index, 10+params.target_index];
        elseif r<fake_cue_cutoff
            identities(end+1) = params.standard_index;
            block.code(end+1) = params.standard_index;
        else
            identities(end+1) = params.target_index;
            block.code(end+1) = params.target_index;
        end
        
        intervals(end+1) = (intertrial_range(2) - intertrial_range(1))*rand() + intertrial_range(1)
    end
end

block.trial_tag = trial_tag;
block.code = block.code + 100*trial_tag;
block.intervals = intervals;
block.sound = master_stim_maker(filename, intervals, identities, params);
block.type = 'pawan_contingency';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
