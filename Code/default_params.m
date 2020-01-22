function params = default_params()

    params = struct();

    params.lead_in=4;
    params.allowable_distance = 3;

    params.save_separate = false;
    params.wav_separate = false;
    params.Fs = 44100;
    params.sound_list = {};

%    params.beep_shift = floor(.1*params.Fs);

    tick = audioread('../stimulus_components/wood_tick.wav');
    params.sound_list{1} = 0.2*tick(:,1);
    params.standard_index = 1;

    params.sound_list{2} = .2*resample(tick(:,1), 5,4);
    params.deviant_index = 2;

    x_beep = 1:(.2 * 44100);
    
    envelope = min(length(x_beep)/2-abs((1:length(x_beep)) - floor(length(x_beep)/2)), .005*44100)./(.005*44100);

    beep1 = .02*sin(x_beep * 2*pi * 770 / 44100).* envelope;
    % beep2 = .02*sin(x_beep * 2*pi * 790 / 44100).* envelope;
    % beepup = .02*sin(x_beep * 2*pi .* risingfreq / 44100).* envelope;
    % beepdown = .02*sin(x_beep * 2*pi .* fallingfreq / 44100).* envelope;

    params.sound_list{3} = beep1;
    params.target_index = 3;

    params.sound_list{4} = 0;
    params.omission_index = 4;

    lowfreq = 330;
    hifreq = 880;
    logmeanfreqs = log(lowfreq): (log(hifreq)-log(lowfreq))/3 : log(hifreq);
    logfreqspreads = .025 : .025 : .1;

    params.n_difficulties = length(logfreqspreads);
    params.n_pitches = length(logmeanfreqs);
    params.get_id = @(pitch, difficulty, direction) 100*pitch + 10*difficulty + direction + 8;

    for i = 1:length(logmeanfreqs)
        for j = 1:length(logfreqspreads)

            risingfreq = exp(logmeanfreqs(i) + 2*logfreqspreads(j)*(x_beep/(length(x_beep))-.5));
            beepup = .02*sin(x_beep * 2*pi .* risingfreq / 44100).* envelope;
            id = params.get_id(i,j,0);
            params.sound_list{id} = beepup;

            beepdown = flip(beepup);
            id = params.get_id(i,j,1);
            params.sound_list{id} = beepdown;
        end
    end



    params.shift_code = 10;
    params.tempo_code = 20;

    params.listen_standard_tag = 0;
    params.tap_standard_tag = 1;
    params.listen_deviant_tag = 2;
    params.listen_omission_tag = 3;
    params.tap_omission_tag = 4;
    params.deviant_control_tag = 5;
    params.free_tap_tag = 6;
    params.contingency_tag = 7;
    params.discrim_tag = 8;

    params.target_delay = 6;

    params.sync_amplitude = 0.02;
    params.sync_eeg_samples = 3;
    params.intertrial_time = 5;