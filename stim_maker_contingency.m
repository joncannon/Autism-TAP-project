function [snd_total, key]=stim_maker_contingency(filename, fake_rate, phases, intertrial_range, params)

identities = [];
intervals = [];
key = struct();
key.code = [];

for p = 1:length(phases)
    phase = phases{p};
    counter = 0;
    while counter<phase.n_targets
        identities(end+1) = 0;
        if rand()>fake_rate
            intervals(end+1) = (phase.range(2) - phase.range(1))*rand() + phase.range(1);
            identities(end+1) = 2;
            counter = counter+1;
            key.code(end+1:end+2)= [1, 2];
        else
            key.code(end+1) = 0;
        end
        
        intervals(end+1) = (intertrial_range(2) - intertrial_range(1))*rand() + intertrial_range(1);
    end
end

key.intervals = intervals;
snd_total = master_stim_maker(filename, intervals, identities, params);
if params.save_separate
    save(strcat(filename, '.mat'),'key');
end