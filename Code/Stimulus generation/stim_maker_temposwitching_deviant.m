function block=stim_maker_temposwitching_deviant(filename, periods, n_events, deviant_rate, end_target, trial_tag, params)

% INPUTS:
% . filename    - unique file identifier for wav, save, etc.
% . period      - inter-click interval
% . n_events    - number

allowable_distance = params.allowable_distance;
lead_in = params.lead_in;

identities = [];
intervals = [];

counter = 0;
for j = 1:length(n_events)
    for i=1:n_events(j)
        intervals(end+1) = periods(j);
        if (rand()>deviant_rate || i<=lead_in || counter>0)
            identities(end+1) = params.standard_index + 10*j;
            counter = counter-1;
        else
            identities(end+1) = params.deviant_index + 10*j;
            counter = allowable_distance;
        end
    end 
end

if end_target
    intervals(end) = params.target_delay*periods(end);
    intervals(end+1) = .1;
    identities(end+1) = params.target_index;
end

block = struct();

block.sound=master_stim_maker(filename, intervals, mod(identities, 10), params);
block.params = params;

block.trial_tag = trial_tag;
block.code = identities + 100*trial_tag;
block.type = 'temposwitching_deviant';
block.intervals = intervals;
block.identities = identities;
block.periods = periods;
block.n_events = n_events;

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
