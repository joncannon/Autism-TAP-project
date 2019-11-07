function [snd_total, code]=master_stim_maker(filename, intervals, identities, params)

% interval = vector

snd_total=[];
code = zeros(length(intervals));

Fs = params.Fs;

sound_list = params.sound_list;

for i=1:length(intervals)

    snd = zeros(floor(Fs * intervals(i)),2);
    snd_num = mod(identities(i), 10);
    
    snd(1:length(sound_list{snd_num}), 1) = sound_list{snd_num};
    snd(1:params.sync_samples, 2)=params.eeg_amplitude;
    
    snd_total=vertcat(snd_total,snd);
end

if params.wav_separate
    audiowrite(strcat(filename, '.wav'),snd_total,Fs);
end
