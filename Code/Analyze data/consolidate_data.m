%%% The goal of this set of these subscripts is to synthesize the stimulus
%%% block data structure, the sound files, and the EEG data, leaving the
%%% EEG data file with a coded event list and leaving the stimulus block
%%% struct with all event and tap times in it, in both wav-file time
%%% coordinates and eeg time coordinates.

%%% It needs a lot of cleaning up. Sorry guys.

%%

with_eeg = true;

basic_filter = true;
heavy_filter = false:

answer = quastdlg('Do you have a file with tap audio?')
if streq(answer, 'no')
    with_tap = false;
else
    tapfile = uigetfile;
    answer = quastdlg('Please select the file with rerecord audio')
    rrfile = uigetfile;
    with_tap=true;
end

answer = quastdlg('Do you have EEG data? (If so, make sure it is loaded in EEGlab before running this script.)')
if streq(answer, 'yes')
    with_eeg = true;
else
    with_eeg=false;
end

event_audio_threshold = .75;
event_eeg_threshold = 1400;
tap_threshold = .06;
sync_channel = 41;
%%

if with_tap
    tap_audio = audioread(tapfile);
    event_audio = audioread(rrfile);

    if basic_filter

        d = designfilt('bandstopiir','FilterOrder',2, ...
                       'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
                       'DesignMethod','butter','SampleRate',44100);

        d1 = designfilt('bandstopiir','FilterOrder',2, ...
                       'HalfPowerFrequency1',119,'HalfPowerFrequency2',121, ...
                       'DesignMethod','butter','SampleRate',44100);

        d2 = designfilt('bandstopiir','FilterOrder',2, ...
                       'HalfPowerFrequency1',178,'HalfPowerFrequency2',182, ...
                       'DesignMethod','butter','SampleRate',44100);
        tap_audio_filt = filtfilt(d2, filtfilt(d1, filtfilt(d,tap_audio(:,1))));
        if heavy_filter
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


            tap_audio_filt = filtfilt(d6, filtfilt(d5, filtfilt(d4, filtfilt(d3, filtfilt(d2,tap_audio_filt)))));
        end
    else
        tap_audio_filt = tap_audio(:,1);
    end


    % Extract tap times and assign them to the corresponding blocks.

    wav_event_times = get_times(event_audio, event_threshold)
    wav_tap_times = get_times(tap_audio_filt, tap_threshold)

    block_struct = divide_data(wav_event_times, wav_tap_times, all_blocks)

end

%% Get all EEG-locked event times, add to block struct and event list
if with_eeg
    n_block = 0;
    block_struct_w_eeg = block_struct;
    EE
    i = 2;
    counter = 1;
    pulse_spacing = 2*params.sync_eeg_samples;

    events_w_taps = [];
    collecting = false;

    while i < size(EEG.data, 2)-2*pulse_spacing

        if EEG.data(sync_channel, i)>event_eeg_threshold
            n_pulses = 1 + (EEG.data(sync_channel, i+1+pulse_spacing)>event_eeg_threshold) + (EEG.data(sync_channel, i+1+2*pulse_spacing)>event_eeg_threshold);
            if n_pulses == 3 % end-of-block signal

                if collecting & length(block_struct_w_eeg{n_block}.eeg_event_latencies)==length(block_struct_w_eeg{n_block}.code)
                    block_struct_w_eeg{n_block}.complete = true;
                end


                block_struct_w_eeg{n_block}.block_latency_range(end+1) = i;
                block_struct_w_eeg{n_block}.block_time_range(end+1) = i/512;

    %            block_struct_w_eeg{n_block}.eeg_tap_times = block_struct_w_eeg{n_block}.wav_tap_times + block_struct_w_eeg{n_block}.eeg_event_times(1) - block_struct_w_eeg{n_block}.wav_event_times(1);    
    %            block_struct_w_eeg{n_block}.eeg_tap_latencies = floor(block_struct_w_eeg{n_block}.eeg_tap_times*512);
                collecting = false;

                if block_struct_w_eeg{n_block}.complete
                    for n = 1:length(block_struct_w_eeg{n_block}.code)
                        events_w_taps(end+1).latency = block_struct_w_eeg{n_block}.eeg_event_latencies(n);
                        events_w_taps(end).duration = 0;
                        events_w_taps(end).chanindex = 0;
                        events_w_taps(end).urevent = counter;
                        events_w_taps(end).type = block_struct_w_eeg{n_block}.code(n);
                        counter=counter+1;
                    end
    %                 for n = 1:length(block_struct_w_eeg{n_block}.wav_tap_times)
    %                     events_w_taps(end+1).latency = block_struct_w_eeg{n_block}.eeg_tap_latencies(n);
    %                     events_w_taps(end).duration = 0;
    %                     events_w_taps(end).chanindex = 0;
    %                     events_w_taps(end).urevent = counter;
    %                     events_w_taps(end).type = block_struct_w_eeg{n_block}.trial_tag*100 + 10000;
    %                     counter=counter+1;
    %                 end
                end
            elseif n_pulses==2 % beginning-of-block signal

                n_block = n_block + 1;
                collecting = true;
                block_struct_w_eeg{n_block}.eeg_event_times = [];
                block_struct_w_eeg{n_block}.eeg_event_latencies = [];
                block_struct_w_eeg{n_block}.block_latency_range = [i];
                block_struct_w_eeg{n_block}.block_time_range = [i/512];


            else % regular event

                if collecting
                    block_struct_w_eeg{n_block}.eeg_event_latencies(end+1) = i-1;
                    block_struct_w_eeg{n_block}.eeg_event_times(end+1) = (i-1)/512;
                end
            end
            i = i+3*pulse_spacing;
        end
        i = i+1;
    end

end