function snd_total=master_stim_maker(filename, intervals, identities, params)

% interval = vector

snd_total=[];

Fs = params.Fs;

sound_list = params.sound_list;

sync_samples = floor(params.sync_eeg_samples*Fs/512);

snd = zeros(floor(Fs),2);
snd(1:sync_samples, 2)=params.sync_amplitude;
snd(sync_samples*2+1:sync_samples*3, 2)=params.sync_amplitude;

snd_total=vertcat(snd_total,snd);

for i=1:length(intervals)

    snd = zeros(floor(Fs * intervals(i)),2);
    snd_num = identities(i);
    
    snd(1:length(sound_list{snd_num}), 1) = sound_list{snd_num};
    snd(1:sync_samples, 2)=params.sync_amplitude;
    
    snd_total=vertcat(snd_total,snd);
end


snd = zeros(floor(Fs),2);
snd(1:sync_samples, 2)=params.sync_amplitude;
snd(sync_samples*2+1:sync_samples*3, 2)=params.sync_amplitude;
snd(sync_samples*4+1:sync_samples*5, 2)=params.sync_amplitude;

snd_total=vertcat(snd_total,snd);

if params.wav_separate
    audiowrite(strcat(filename, '.wav'),snd_total,Fs);
end