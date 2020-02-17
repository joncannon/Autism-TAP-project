function block=stim_maker_storytime(filename, story_filename, onset_times, trial_tag, params)

Fs = 44100;
story_snd = audioread(story_filename);
story_snd(:,2) = 0;

sync_samples = floor(params.sync_eeg_samples*Fs/512);

for i = 1:length(onset_times)
    onset_sample = floor(onset_times(i)*Fs)+1;
    story_snd(onset_sample+1:onset_sample+sync_samples, 2)=params.sync_amplitude;
end


start_snd = zeros(floor(Fs),2);
start_snd(1:sync_samples, 2)=params.sync_amplitude;
start_snd(sync_samples*2+1:sync_samples*3, 2)=params.sync_amplitude;


end_snd = zeros(floor(Fs),2);
end_snd(1:sync_samples, 2)=params.sync_amplitude;
end_snd(sync_samples*2+1:sync_samples*3, 2)=params.sync_amplitude;
end_snd(sync_samples*4+1:sync_samples*5, 2)=params.sync_amplitude;

block = struct();

block.sound=vertcat(start_snd, story_snd, end_snd);
block.params = params;

block.trial_tag = trial_tag;
block.code = 1000*(1:length(onset_times));
block.type = 'story';

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
