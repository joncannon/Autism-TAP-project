function block=stim_maker_phaseshift(filename, ICI, n_before, n_after, ms_shift, trial_tag, params)

intervals = horzcat(zeros(1,n_before)+ICI, ICI+ms_shift, zeros(1,n_after)+ICI);
identities = zeros(size(intervals))+params.standard_index;

block = struct();
block.snd_total = snd_total;

block.trial_tag = trial_tag;
block.code = horzcat(zeros(1,n_before)+params.standard_index, [params.shift_code], zeros(1,n_after+1)+params.standard_index) + 100*trial_tag;
block.type = 'phaseshift';
block.intervals = intervals;
block.identities = identities;
block.magnitude = ms_shift;
block.period = ICI;

block.sound=master_stim_maker(filename, intervals, identities, params);
block.params = params;

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
