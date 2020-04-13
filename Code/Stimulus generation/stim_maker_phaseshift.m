function block=stim_maker_phaseshift(filename, ICI, n_before, n_shifted, n_after, ms_shift, beep, trial_tag, params)

intervals = horzcat(zeros(1,n_before)+ICI, zeros(1,n_shifted)+ICI+ms_shift, zeros(1,n_after)+ICI);
identities = zeros(size(intervals))+params.standard_index;

if beep
    identities(end) = params.target_index;
end

block = struct();

block.trial_tag = trial_tag;

if beep
    block.code = horzcat(zeros(1,n_before+1)+params.standard_index,  zeros(1,n_shifted)+params.tempo_code+params.standard_index, zeros(1,n_after-2)+params.shift_code+params.standard_index, [params.shift_code+params.target_index]) + 100*trial_tag;
else
    block.code = horzcat(zeros(1,n_before+1)+params.standard_index,  zeros(1,n_shifted)+params.tempo_code+params.standard_index, zeros(1,n_after-1)+params.shift_code+params.standard_index) + 100*trial_tag;
end

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
