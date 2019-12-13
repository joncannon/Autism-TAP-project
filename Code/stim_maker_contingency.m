function block=stim_maker_contingency(filename, fake_rate, phases, intertrial_range, trial_tag, params)

identities = [];
intervals = [];
block = struct();
block.code = [];

for p = 1:length(phases)
    phase = phases{p};
    counter = 0;
    while counter<phase.n_targets
        identities(end+1) = params.standard_index;
        if rand()>fake_rate
            intervals(end+1) = phase.options(ceil(rand()*length(phase.options)));
            identities(end+1) = params.target_index;
            counter = counter+1;
            block.code(end+1:end+2)= [1, 2];
        else
            block.code(end+1) = 0;
        end
        
        intervals(end+1) = (intertrial_range(2) - intertrial_range(1))*rand() + intertrial_range(1);
    end
end

block.trial_tag = trial_tag;
block.code = block.code + 100*trial_tag;
block.intervals = intervals;
block.sound = master_stim_maker(filename, intervals, identities, params);
block.type = 'contingency';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
