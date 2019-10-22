Fs = 44100
tonefreq = 440

metroperiod = .5
metroduration = .1

clicks = 10

snd = zeros(clicks * Fs * metroperiod,2);
x_beep = 1:(metroduration * Fs);
beep = sin(x_beep * 2*pi * tonefreq / Fs);


for i=1:clicks
    snd(Fs * (i-1) * metroperiod + 1: Fs * (i-1) * metroperiod + metroduration * Fs, 1) = beep;
end

audiowrite("soundtest.wav",snd,Fs)