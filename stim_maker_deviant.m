function [snd_total, key]=stim_maker_deviant(filename, period, n_events, deviant_rate, params)

allowable_distance = params.allowable_distance;
lead_in = params.lead_in;

identities = zeros(1, n_events+1);
intervals = zeros(1,n_events+1)+period;

counter = 0;
for i=1:n_events
    if (rand()>deviant_rate || i<=lead_in || counter>0)
        identities(i) = params.standard_code;
        counter = counter-1;
    else
        identities(i) = params.deviant_code;
        counter = allowable_distance;
    end

end
identities(end)= target_code;
snd_total = master_stim_maker(filename, intervals, identities, params);
key=struct();
key.code = identities;
key.type = 'deviant';
key.period = period;

if params.save_separate
    save(strcat(filename, '.mat'),'key');
end
