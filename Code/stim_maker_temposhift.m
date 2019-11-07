function block=stim_maker_temposhift(filename, ICI, n_before, n_after, ms_shift, trial_tag, params)

intervals = horzcat(zeros(1,n_before)+ICI, zeros(1,n_after)+ICI+ms_shift);
identities = zeros(size(intervals))+params.standard_index;

block = struct();
block.code = horzcat(zeros(1,n_before)+params.standard_index, zeros(1,n_after+1)+params.tempo_code) + 100*trial_tag;
block.type = 'temposhift';
block.magnitude = ms_shift;
block.period = ICI;

block.sound=master_stim_maker(filename, intervals, identities, params);
block.params = params;

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
