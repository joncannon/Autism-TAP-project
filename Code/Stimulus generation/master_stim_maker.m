function snd_total=master_stim_maker(filename, intervals, identities, params)

% interval = vector

snd_total=zeros(floor((sum(intervals)+2+2)*44100), 2);

Fs = params.Fs;

sound_list = params.sound_list;

sync_samples = floor(params.sync_eeg_samples*Fs/512);

snd_total(1:sync_samples, 2)=params.sync_amplitude;
snd_total(1+sync_samples*2:sync_samples*3, 2)=params.sync_amplitude;

pointer = 2*44100;

for i=1:length(intervals)
    
    snd_num = identities(i);

    snd_total(1+pointer:pointer+length(sound_list{snd_num}), 1) = sound_list{snd_num} + snd_total(1+pointer:pointer+length(sound_list{snd_num}), 1);
    
    snd_total(1+pointer:pointer+sync_samples, 2) = params.sync_amplitude;
    
    pointer = pointer + floor(Fs * intervals(i));
end


snd_total(1+pointer:pointer+sync_samples, 2)=params.sync_amplitude;
snd_total(1+pointer+sync_samples*2:pointer+sync_samples*3, 2)=params.sync_amplitude;
snd_total(1+pointer+sync_samples*4:pointer+sync_samples*5, 2)=params.sync_amplitude;


if params.wav_separate
    audiowrite(strcat(filename, '.wav'),snd_total,Fs);
end