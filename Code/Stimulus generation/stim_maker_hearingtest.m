function block=stim_maker_hearingtest(filename, params)

test_decibels = 0:2:20;
test_amplitudes = params.anchor_amplitude * 10.^((test_decibels-params.anchor_decibel)/20)

x_beep = 1:(.2 * 44100);
n_samples = length(x_beep);
envlp = min(n_samples/2-abs((1:n_samples) - floor(n_samples/2)), .005*44100)./(.005*44100);

%snd_total = params.calibration_sound;
snd_total = [];%vertcat(snd_total, zeros(5*44100, 1));


for i = 1:length(test_amplitudes)
    beep = test_amplitudes(i)*sin(x_beep * 2*pi * params.frequencies(1) / 44100).* envlp;
    snd_total = vertcat(snd_total, beep');
    snd_total = vertcat(snd_total, zeros(4*44100, 1));
end

for i = 1:length(test_amplitudes)
    beep = test_amplitudes(i)*sin(x_beep * 2*pi * params.frequencies(end) / 44100).* envlp;
    snd_total = vertcat(snd_total, beep');
    snd_total = vertcat(snd_total, zeros(4*44100, 1));
end
    

snd_total(:,2)=0;

start_snd = zeros(floor(Fs),2);
start_snd(1:sync_samples, 2)=params.sync_amplitude;
start_snd(sync_samples*2+1:sync_samples*3, 2)=params.sync_amplitude;


end_snd = zeros(floor(Fs),2);
end_snd(1:sync_samples, 2)=params.sync_amplitude;
end_snd(sync_samples*2+1:sync_samples*3, 2)=params.sync_amplitude;
end_snd(sync_samples*4+1:sync_samples*5, 2)=params.sync_amplitude;

block = struct();

block.sound=vertcat(start_snd, snd_total, end_snd);

block.params = params;

block.code = []
block.type = 'hearing';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
