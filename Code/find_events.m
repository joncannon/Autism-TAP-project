file_tag = 'Isaac_2_4'

tap_audio = audioread(strcat(file_tag, '_tap.wav'));
beep_audio = audioread(strcat(file_tag, '_rerecording.wav'));

d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',44100);

tap_audio_filt = filtfilt(d,tap_audio(:,1));

%%

beep_threshold = .75;
tap_threshold = .06;

wav_beep_times = get_times(beep_audio(:,1), beep_threshold);
wav_tap_times = get_times(tap_audio_filt, tap_threshold);

block_struct = divide_data(wav_beep_times, wav_tap_times, all_blocks_shuffled)

%%

sync_channel = 43;

event2 = [];
i = 2;
counter = 0;
look_ahead = floor(params.sync_samples/60);
jump_ahead = 100;
while i < size(EEG.data, 2)-look_ahead
    if EEG.data(sync_channel, i)-EEG.data(sync_channel, i-1)>500
        counter = counter+1;
        event2(end+1).latency = i;
        event2(end).duration = 0;
        event2(end).chanindex = 0;
        event2(end).urevent = counter;
        if EEG.data(sync_channel, i+look_ahead)<EEG.data(sync_channel, i-look_ahead)-1000
            event2(end).type = 0;
        else
            event2(end).type = params.end_code;
            length(event2)
            i = i+floor((params.intertrial_time+.1)*512);
        end
        i = i+jump_ahead;
    end
    i = i+1;
end

%%
event_count = 0;

for i = 1:length(block_struct)
    i
    block_struct{i}.eeg_beep_times = [];
    type = block_struct{i}.type
    length(block_struct{i}.code)
    for j = 1:length(block_struct{i}.code)
        event_count = event_count+1;
        if event_count>length(event2)
            "ran out of events"
        break
        end
        event2(event_count).type = block_struct{i}.code(j);
        block_struct{i}.eeg_beep_times(end+1) = event2(event_count).latency/512;
    end
    event_count = event_count+1
    if event_count>length(event2)
        "ran out of events"
        break
    end
    if event2(event_count).type ~= params.end_code
        event2(event_count).type
        "bad"
    end
end

%% Remove later

for i = 1:length(block_struct)
    block_struct{i}.trial_tag = floor(block_struct{i}.code(1)/100);
end

%%
events_with_taps = event2;
counter = event2(end).urevent;

for i = 1:length(block_struct)
    block_struct{i}.eeg_tap_times = block_struct{i}.wav_tap_times + block_struct{i}.eeg_beep_times(1) - block_struct{i}.wav_beep_times(1);
    for j = 1:length(block_struct{i}.eeg_tap_times)
        counter = counter+1;
        events_with_taps(end+1).latency = floor(block_struct{i}.eeg_tap_times(j) * 512);
        events_with_taps(end).duration = 0;
        events_with_taps(end).chanindex = 0;
        events_with_taps(end).urevent = counter;
        events_with_taps(end).type = block_struct{i}.trial_tag*100 + 10000;
    end
    
end
