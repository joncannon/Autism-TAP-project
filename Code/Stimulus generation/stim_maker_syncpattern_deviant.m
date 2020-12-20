function block=stim_maker_syncpattern_deviant(filename, period, n_reps, deviant_rate, end_target, trial_tag, params)

% INPUTS:
% . filename    - unique file identifier for wav, save, etc.
% . period      - inter-click interval
% . n_events    - number

allowable_distance = params.allowable_distance;
lead_in = params.lead_in;

identities = [];
intervals = [];

counter = 0;

for i=1:n_reps
    intervals(end+1) = period;
    if (rand()>deviant_rate || i<=ceil(lead_in/4) || counter>0)
        identities(end+1) = params.standard_index;
        counter = counter-1;
    else
        identities(end+1) = params.deviant_index;
        counter = allowable_distance;
    end 
    
    intervals(end+1) = period;
    if (rand()>deviant_rate || i<=ceil(lead_in/4) || counter>0)
        identities(end+1) = params.standard_index;
        counter = counter-1;
    else
        identities(end+1) = params.deviant_index;
        counter = allowable_distance;
    end 
    
    intervals(end+1) = period/2;
    if (rand()>deviant_rate || i<=ceil(lead_in/4) || counter>0)
        identities(end+1) = params.standard_index;
        counter = counter-1;
    else
        identities(end+1) = params.deviant_index;
        counter = allowable_distance;
    end 
    
    intervals(end+1) = period/2;
    identities(end+1) = params.standard_index+10;
    
    intervals(end+1) = period/2;
    identities(end+1) = params.omission_index;
    
    intervals(end+1) = period/2;
    identities(end+1) = params.standard_index+10;
end

if end_target
    intervals(end) = params.target_delay*period;
    intervals(end+1) = .1;
    identities(end+1) = params.target_index;
end

block = struct();

block.sound=master_stim_maker(filename, intervals, mod(identities,10), params);
block.params = params;

block.trial_tag = trial_tag;
block.code = identities + trial_tag;
block.type = 'syncpattern_deviant';
block.intervals = intervals;
block.identities = identities;
block.period = period;

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
