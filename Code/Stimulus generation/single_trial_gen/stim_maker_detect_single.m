function trial = stim_maker_detect_single(filename, volume, pitch, initial_delay, cue_delay, trial_length_after_cue, params)

identities = [params.omission_index, params.standard_index, params.get_detect_id(pitch, volume)];
intervals = [initial_delay, cue_delay, trial_length_after_cue - cue_delay];

trial = struct();

snd_total=master_stim_maker_nosync(intervals, identities, params);

trial.snd_total = snd_total + 10^((params.noise_dB-40)/20)*randn(size(snd_total));

trial.intervals = intervals;
trial.identities = identities;
trial.pitch = pitch;
trial.volume = volume;

audiowrite(strcat(filename, '.wav'),trial.snd_total,params.Fs);
