function [snd_total, key]=stim_maker_phaseshift(filename, ICI, n_before, n_after, ms_shift, params)

intervals = horzcat(zeros(1,n_before)+ICI, ICI+ms_shift, zeros(1,n_after)+ICI);
identities = zeros(size(intervals));

key = struct();
key.code = horzcat(zeros(1,n_before), [3], zeros(1,n_after+1));
key.type = 'phaseshift';
key.magnitude = ms_shift;

snd_total=master_stim_maker(filename, intervals, identities, params);

if params.save_separate
    save(strcat(filename, '.mat'),'key');
end