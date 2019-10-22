function stim_maker(interval, Fs, tonefreq, metroduration)

% interval = vector
% Fs = scalar;
% tonefreq = scalar;
% metroduration = sclar;
snd_total=[];

interval=round(interval);

for i=1:length(interval)
    metroperiod = interval(i);
    snd = zeros(Fs * metroperiod,2);
    x_beep = 1:(metroduration * Fs);
    tick = audioread('Good_tick.wav')
    %beep = sin(x_beep * 2*pi * tonefreq / Fs);
    snd(Fs * (i-1) * metroperiod + 1: Fs * (i-1) * metroperiod + metroduration * Fs, 1) = beep;
    snd_total=vertcat(snd_total,snd);

audiowrite("soundtest.wav",snd_total,Fs)

end