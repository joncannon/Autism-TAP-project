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
    if i==n_events && end_target
        identities(i) = params.target_index;
    else
        identities(i) = params.standard_index;
    end 
end

block = struct();

block.sound=master_stim_maker(filename, intervals, identities, params);
block.params = params;

block.code = identities + 100*trial_tag;
block.type = 'standard';
block.period = period;

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
