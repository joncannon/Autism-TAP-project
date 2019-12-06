function block=stim_maker_deviant(filename, period, n_events, deviant_rate, end_target, trial_tag, params)

% INPUTS:
% . filename    - unique file identifier for wav, save, etc.
% . period      - inter-click interval
% . n_events    - number

allowable_distance = params.allowable_distance;
lead_in = params.lead_in;

identities = zeros(1, n_events);
intervals = zeros(1,n_events)+period;

counter = 0;

for i=1:n_events
    if i==n_events && end_target
        identities(i) = params.target_index;
    elseif (rand()>deviant_rate || i<=lead_in || counter>0)
        identities(i) = params.standard_index;
        counter = counter-1;
    else
        identities(i) = params.deviant_index;
        counter = allowable_distance;
    end 
end

block = struct();

block.sound=master_stim_maker(filename, intervals, identities, params);
block.params = params;

block.trial_tag = trial_tag;
block.code = identities + 100*trial_tag;
block.type = 'deviant';
block.period = period;

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
