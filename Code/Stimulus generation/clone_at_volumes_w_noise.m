function clone_at_volumes_w_noise(params)

waitfor(msgbox('Please select the wav file to clone'))
[stimfile, stimpath] = uigetfile('*.wav');
stim_audio = audioread(fullfile(stimpath,stimfile));

mkdir(horzcat(stimpath, stimfile, '_clones'));

cd(horzcat(stimpath, stimfile, '_clones'));

delta_db = -20:4:20;
signal = stim_audio;

wnoise = zeros(size(stim_audio));
wnoise(:,1) = params.noise_amplitude*randn([size(wnoise, 1), 1]);
audiowrite(strcat(stimfile, '_noise.wav'), wnoise, 44100);

for i = 1:length(delta_db)
    signal(:,1) = stim_audio(:,1) * 10^(delta_db(i)/20);
    audiowrite(horzcat(stimfile, '_', num2str(delta_db(i)),'dB.wav'), signal+wnoise, 44100);
end