function snd_total=master_stim_maker_nosync(filename, intervals, identities, params)

% interval = vector

snd_total=zeros(floor((sum(intervals)+2+2)*44100), 2);

Fs = params.Fs;

sound_list = params.sound_list;

pointer = 0;

for i=1:length(intervals)
    
    snd_num = identities(i);

    snd_total(1+pointer:pointer+length(sound_list{snd_num}), 1) = sound_list{snd_num} + snd_total(1+pointer:pointer+length(sound_list{snd_num}), 1);
    
    pointer = pointer + floor(Fs * intervals(i));
end

snd_total(:, 2)=snd_total(:, 1);

audiowrite(strcat(filename, '.wav'),snd_total,Fs);
