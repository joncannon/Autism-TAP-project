function [snd_total, key]=stim_maker_temposhift(filename, ICI, n_before, n_after, ms_shift, params)

intervals = horzcat(zeros(1,n_before)+ICI, zeros(1,n_after)+ICI+ms_shift);
identities = zeros(size(intervals));

key = struct();
key.code = horzcat(zeros(1,n_before), zeros(1,n_after+1)+2);
key.type = 'temposhift';
key.magnitude = ms_shift;

snd_total=master_stim_maker(filename, intervals, identities, params);

if params.save_separate
    save(strcat(filename, '.mat'),'key');
end