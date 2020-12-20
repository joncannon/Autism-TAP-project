function block=stim_maker_music_deviant(filename, period, n_events_before_after, deviant_rate, end_target, trial_tag, params)

% INPUTS:
% . filename    - unique file identifier for wav, save, etc.
% . period      - inter-click interval
% . n_events    - number

allowable_distance = params.allowable_distance;
lead_in = params.lead_in;


identities = [];
intervals = [];

counter = 0;

for i=1:n_events_before_after(1)
    intervals(end+1) = period;
    if (rand()>deviant_rate || i<=lead_in || counter>0)
        identities(end+1) = params.standard_index;
        counter = counter-1;
    else
        identities(end+1) = params.deviant_index;
        counter = allowable_distance;
    end 
end

intervals(end) = 4*period;

for i=1:n_events_before_after(2)
    intervals(end+1) = period;
    if (rand()>deviant_rate || i<=lead_in || counter>0)
        identities(end+1) = params.standard_index;
        counter = counter-1;
    else
        identities(end+1) = params.deviant_index;
        counter = allowable_distance;
    end 
end


if end_target
    intervals(end) = params.target_delay*period;
    intervals(end+1) = .1;
    identities(end+1) = params.target_index;
end

block = struct();

block.sound=master_stim_maker(filename, intervals, identities, params);
block.params = params;

block.trial_tag = trial_tag;
block.code = identities + 100*trial_tag;
block.type = 'music_deviant';
block.intervals = intervals;
block.identities = identities;
block.period = period;

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
