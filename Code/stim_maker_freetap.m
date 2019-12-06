function block=stim_maker_freetap(filename, duration, trial_tag, params)

intervals = [duration, 1];
identities = [params.target_index, params.target_index];

block = struct();
block.sound=master_stim_maker(filename, intervals, identities, params);
block.params = params;

block.trial_tag = trial_tag;
block.code = identities + 100*trial_tag;
block.type = 'free';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end