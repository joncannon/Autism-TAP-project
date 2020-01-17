file_tag = 'Suliman'

tap_audio = audioread(strcat(file_tag, '_TAP.wav'));
beep_audio = audioread(strcat(file_tag, '_RR.wav'));


d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',44100);

tap_audio_filt = filtfilt(d,tap_audio(:,1));

%%
Fs = 44100; 
dft = fft(tap_audio_filt(1:60000000));
dft = dft(1:60000000/2+1);
DF = Fs/60000000; % frequency increment
freqvec = 0:DF:Fs/2;
plot(freqvec,abs(dft))

%%
d2 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',84,'HalfPowerFrequency2',86, ...
               'DesignMethod','butter','SampleRate',44100);
d3 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',118,'HalfPowerFrequency2',122, ...
               'DesignMethod','butter','SampleRate',44100);
           
d4 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',168,'HalfPowerFrequency2',172, ...
               'DesignMethod','butter','SampleRate',44100);
d5 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',253,'HalfPowerFrequency2',257, ...
               'DesignMethod','butter','SampleRate',44100);
d6 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',338,'HalfPowerFrequency2',342, ...
               'DesignMethod','butter','SampleRate',44100);

Dhigh = designfilt('highpassfir','StopbandFrequency',240,'PassbandFrequency',250,'PassbandRipple',.5,'StopbandAttenuation',65,'DesignMethod','kaiserwin', 'SampleRate',44100);
Dlow = designfilt('lowpassfir','StopbandFrequency',320,'PassbandFrequency',300,'PassbandRipple',.5,'StopbandAttenuation',65,'DesignMethod','kaiserwin', 'SampleRate',44100);
 

tap_audio_filt_2 = tap_audio_filt;
tap_audio_filt_2(1:60000000) = filtfilt(d6, filtfilt(d5, filtfilt(d4, filtfilt(d3, filtfilt(d2,tap_audio_filt(1:60000000))))));

%%
%beep_threshold = .1 % A
beep_threshold = .75;% Isaac;
%tap_threshold = .06;
tap_threshold = .02;

wav_beep_times = get_times(beep_audio, beep_threshold)
wav_tap_times = get_times(tap_audio_filt_2, tap_threshold)

block_struct = divide_data(wav_beep_times, wav_tap_times, all_blocks_shuffled)


%%
sync_channel = 41;

event2 = [];
i = 2;
counter = 0;
%look_ahead = floor(params.sync_samples/60);
look_ahead = 3%6;

jump_ahead = 100;
end_counter = 0;
while i < size(EEG.data, 2)-look_ahead
    %if EEG.data(sync_channel, i)-EEG.data(sync_channel, i-1)>500
    if EEG.data(sync_channel, i)>500
        counter = counter+1;
        event2(end+1).latency = i-1;
        event2(end).duration = 0;
        event2(end).chanindex = 0;
        event2(end).urevent = counter;
        
        if EEG.data(sync_channel, i+look_ahead)<-1000
        
        %if EEG.data(sync_channel, i+look_ahead)-EEG.data(sync_channel, i-look_ahead)<-1000
        %if EEG.data(sync_channel, i+look_ahead)<EEG.data(sync_channel, i-look_ahead)-500
            event2(end).type = 0;
            end_counter = end_counter+1
        else
            event2(end).type = params.end_code;
            i = i+floor((params.intertrial_time-1)*512)
        end
        i = i+jump_ahead;
        'boing'
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
        end
        if event2(event_count).type == params.end_code
            "overwritten:"
            event_count
        end
        event2(event_count).type = block_struct{i}.code(j);
        block_struct{i}.eeg_beep_times(end+1) = event2(event_count).latency/512;
        event_count
    end
    event_count = event_count+1;
    if event_count>length(event2)
        "ran out of events"
        break
    end
    if event2(event_count).type ~= params.end_code
        event2(event_count).type
        "bad"
    end
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
