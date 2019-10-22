function snd_total=stim_maker_3(interval)

% interval = vector
% Fs = scalar;
% tonefreq = scalar;
% metroduration = sclar;
snd_total=[];

%interval=round(interval);
[tick, Fs] = audioread('wood_tick.wav');
tick = tick(:,1);

for i=1:length(interval)
    metroperiod = interval(i)
    snd = zeros(Fs * metroperiod,2);
    tick_samples = size(tick,1);
    snd(1: tick_samples, 1) = tick;
    
    %x_beep = 1:(metroduration * Fs);
    %beep = sin(x_beep * 2*pi * tonefreq / Fs);
    %snd(Fs * (i-1) * metroperiod + 1: Fs * (i-1) * metroperiod + metroduration * Fs, 1) = beep;
    
    snd_total=vertcat(snd_total,snd);

end
audiowrite("soundtest_2.wav",snd_total,Fs)

