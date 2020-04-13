function params = single_trial_params()

    % create sound parameters specific to this experiment
    params = struct();

    params.Fs = 44100;
    components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/'
    tick = audioread(strcat(components_path, 'wood_tick.wav'));

    params.sound_list{1} = 0.2*tick(:,1);
    params.standard_index = 1;

    x_beep = 1:(.2 * params.Fs);
    n_samples = length(x_beep);

    envlp = min(n_samples/2-abs((1:n_samples) - floor(n_samples/2)), .005*params.Fs)./(.005*params.Fs);
    params.beep_envelope = envlp;

    params.sound_list{4} = 0;
    params.omission_index = 4;

    params.noise_dB = 0;

    lowfreq = 400;
    hifreq = 600;
    logmeanfreqs = log(lowfreq): (log(hifreq)-log(lowfreq))/3 : log(hifreq);
    logfreqspreads = .005 : .005 : .025;

    logvolspreads = 1.5 : .5 : 1.5;

    params.frequencies = exp(logmeanfreqs);
    params.delta_decibel = 2;
    params.center_decibel = 12;
    params.anchor_decibel = 50;
    params.anchor_amplitude = .1;

    params.n_detect_difficulties = 7;
    params.easy_volume = params.n_detect_difficulties;
    params.difficult_volumes = 2:6;
    params.silent_volume = 1;
    difficult_volumes = ((1:(params.n_detect_difficulties-2)) - params.n_detect_difficulties/2)*params.delta_decibel + params.center_decibel;
    params.decibels = [-inf, difficult_volumes, 40];
    params.amplitudes = params.anchor_amplitude * 10.^((params.decibels-params.anchor_decibel)/20);

    params.n_detect_pitches = length(logmeanfreqs);
    params.get_detect_id = @(pitch, difficulty) 10*pitch + 1*difficulty;

    for i = 1:params.n_detect_pitches
        for j = 1:params.n_detect_difficulties
            beep = params.amplitudes(j)*sin(x_beep * 2*pi * exp(logmeanfreqs(i)) / params.Fs).* envlp;
            id = params.get_detect_id(i,j);
            params.sound_list{id} = beep';
        end
    end
