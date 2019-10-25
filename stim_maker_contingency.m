function [snd_total, key]=stim_maker_contingency(filename, fake_rate, phases, intertrial_min, intertrial_max, params)

identities = [];
intervals = [];
key = struct();
key.code = [];

for p = 1:length(phases)
    phase = phases(p);
    counter = 0;
    while counter<phases.n_targets
        identities(end+1) = 0;
        if rand()>fake_rate
            intervals(end+1) = (phase.max - phase.min)*rand() + phase.min;
            identities(end+1) = 2;
            counter = counter+1;
            key.code(end+1:end+2)= [1, 2];
        else
            key.code(end+1) = 0;
        end
        
        intervals(end+1) = (intertrial_max - intertrial_min)*rand() + intertrial_min;
    end
end

key.intervals = intervals;
snd_total = master_stim_maker(filename, intervals, identities, params);