function block=stim_maker_standard(filename, period, n_events, end_target, trial_tag, params)

% INPUTS:
% . filename    - unique file identifier for wav, save, etc.
% . period      - inter-click interval
% . n_events    - number

allowable_distance = params.allowable_distance;
lead_in = params.lead_in;

identities = zeros(1, n_events);
intervals = zeros(1,n_events)+period;


for i=1:n_events
    identities(i) = params.standard_index; 
end

if end_target
    intervals(end) = params.target_delay*period;
    intervals(end+1) = 1;
    identities(end+1) = params.target_index;
end

block = struct();

block.sound=master_stim_maker(filename, intervals, identities, params);
block.params = params;

block.trial_tag = trial_tag;
block.code = identities + 100*trial_tag;
block.intervals = intervals;
block.identities = identities;
block.type = 'standard';
block.period = period;

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
