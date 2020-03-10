waitfor(msgbox('Please select the wav file to clone'))
[stimfile, stimpath] = uigetfile('*.wav');
stim_audio = audioread(fullfile(stimpath,stimfile));

mkdir(horzcat(stimfile, '_clones'));

cd(horzcat(stimfile, '_clones'));

delta_db = -20:2:10;
signal = stim_audio;

for i = 1:length(delta_db)
    signal(:,1) = stim_audio(:,1) * 10^(delta_db(i)/20);
    audiowrite(horzcat(stimfile, '_', num2str(delta_db(i)),'dB.wav'), signal, 44100);
end