function params = default_params()
    params = struct();

    params.components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/'
    params.lead_in=4;
    params.allowable_distance = 3;

    params.save_separate = false;
    params.wav_separate = false;
    params.Fs = 44100;
    params.sound_list = {};

%    params.beep_shift = floor(.1*params.Fs);

    tick = audioread(strcat(params.components_path, 'wood_tick.wav'));
    params.sound_list{1} = 0.2*tick(:,1);
    params.standard_index = 1;
    
    params.sound_list{7} = 0.05*tick(:,1);
    params.quiet_index = 7;

    params.sound_list{2} = .2*resample(tick(:,1), 5,4);
    params.deviant_index = 2;
    
    bell = audioread(strcat(params.components_path, 'Bell.wav'));
    params.sound_list{6} = 0.2*bell(:,1);
    size(params.sound_list{6})
    params.bell_index = 6;
    
    x_beep = 1:(.2 * 44100);
    n_samples = length(x_beep);
    
    envlp = min(n_samples/2-abs((1:n_samples) - floor(n_samples/2)), .005*44100)./(.005*44100);
    params.beep_envelope = envlp;
    
    beep1 = .02*sin(x_beep * 2*pi * 770 / 44100).* envlp;
    % beep2 = .02*sin(x_beep * 2*pi * 790 / 44100).* envelope;
    % beepup = .02*sin(x_beep * 2*pi .* risingfreq / 44100).* envelope;
    % beepdown = .02*sin(x_beep * 2*pi .* fallingfreq / 44100).* envelope;

    params.sound_list{3} = beep1';
    params.target_index = 3;

    params.sound_list{4} = 0;
    params.omission_index = 4;
    
    
    params.noise_amplitude = .001;

    lowfreq = 400;
    hifreq = 600;
    logmeanfreqs = log(lowfreq): (log(hifreq)-log(lowfreq))/3 : log(hifreq);
    logfreqspreads = .005 : .005 : .025;
    logvolspreads = 1.5 : .5 : 1.5;
    
    params.frequencies = exp(logmeanfreqs);
    params.anchor_decibel = 50;
    params.anchor_amplitude = .1;
    
    anchor_duration = 30;
    params.calibration_sound = params.anchor_amplitude*sin((1:(anchor_duration * 44100)) * 2*pi * 440 / 44100)';
    % set to 50 decibels
    
    params.delta_decibel = 2;
    params.center_decibel = 12;
    
    params.n_detect_difficulties = 7;
    
    params.decibels = [-inf, ((1:(params.n_detect_difficulties-2)) - params.n_detect_difficulties/2)*params.delta_decibel + params.center_decibel, 40];
    
    params.amplitudes = params.anchor_amplitude * 10.^((params.decibels-params.anchor_decibel)/20);
    
    params.n_detect_pitches = length(logmeanfreqs);
    params.get_detect_id = @(pitch, difficulty) 100*pitch + 10*difficulty;
    
    for i = 1:params.n_detect_pitches
        for j = 1:params.n_detect_difficulties
            beep = params.amplitudes(j)*sin(x_beep * 2*pi * exp(logmeanfreqs(i)) / 44100).* envlp;
            id = params.get_detect_id(i,j);
            params.sound_list{id} = beep';
        end
    end
    
    params.n_discrim_difficulties = length(logfreqspreads);
    params.n_discrim_pitches = length(logmeanfreqs);
    params.get_discrim_id = @(pitch, difficulty, direction) 100*pitch + 10*difficulty + direction + 8;
    
    for i = 1:params.n_discrim_pitches
        for j = 1:params.n_discrim_difficulties

            risingfreq = exp(logmeanfreqs(i) + 2*logfreqspreads(j)*(x_beep/(n_samples)-.5));
            beepup = .02*sin(x_beep * 2*pi .* risingfreq / 44100).* envlp;
            id = params.get_discrim_id(i,j,0);
            params.sound_list{id} = beepup';

            beepdown = flip(beepup);
            id = params.get_discrim_id(i,j,1);
            params.sound_list{id} = beepdown';
        end
    end
    
    
    risingfreq = exp(log(880) + 2*.1*(x_beep/(n_samples)-.5));
    beepup = .02*sin(x_beep * 2*pi .* risingfreq / 44100).* envlp;
    params.sound_list{5} = beepup';
    params.query_index = 5;
    
    params.n_vdiscrim_difficulties = length(logvolspreads);
    params.n_vdiscrim_pitches = length(logmeanfreqs);
    params.get_vdiscrim_id = @(pitch, difficulty, direction) 100*pitch + 10*difficulty + direction + 1;
    
    for i = 1:params.n_vdiscrim_pitches
        for j = 1:params.n_vdiscrim_difficulties

            rising_envelope = envlp .* exp(logvolspreads(j)*((1:n_samples)-n_samples/2)/n_samples);
            beepup = .02*sin(x_beep * 2*pi .* exp(logmeanfreqs(i)) / 44100).* rising_envelope;
            id = params.get_vdiscrim_id(i,j,0);
            params.sound_list{id} = beepup';

            beepdown = flip(beepup);
            id = params.get_vdiscrim_id(i,j,1);
            params.sound_list{id} = beepdown';
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
    params.detect_tag = 9;

    params.target_delay = 6;

    params.sync_amplitude = 0.02;
    params.sync_eeg_samples = 3;
    params.intertrial_time = 3;
    
    