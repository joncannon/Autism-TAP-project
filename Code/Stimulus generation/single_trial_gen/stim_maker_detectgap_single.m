function trial = stim_maker_detectgap_single(filename, duration, initial_delay, n_cues, cue_delay, trial_length_after_cue)

Fs = 44100;
noise_amplitude = .01;

components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/'
tick = audioread(strcat(components_path, 'wood_tick.wav'));
tick = 0.2*tick(:,1);

silent_gap = zeros(Fs*duration, 1);

pointer = floor(Fs * initial_delay);

intervals = [initial_delay];
sound_list = {[]};
gaps = [false];

for i = 1:n_cues
    intervals(end+1) = cue_delay;
    sound_list{end+1} = tick;
    gaps(end+1) = false;
end

intervals(end+1) = trial_length_after_cue - cue_delay;
sound_list{end+1} = silent_gap;
gaps(end+1) = true;

snd_total= noise_amplitude * randn(floor((sum(intervals))*Fs), 2);

for i=1:length(intervals)
    if gaps(i)
        snd_total(1+pointer:pointer+length(sound_list{i}), 1) = 0;
    end
    
    snd_total(1+pointer:pointer+length(sound_list{i}), 1) = sound_list{i} + snd_total(1+pointer:pointer+length(sound_list{i}), 1);
    pointer = pointer + floor(Fs * intervals(i));
end

snd_total(:, 2)=snd_total(:, 1);

trial = struct();
trial.snd_total = snd_total;
trial.intervals = intervals;
trial.duration = duration;
trial.sound_list = sound_list;

audiowrite(strcat(filename, '.wav'),trial.snd_total,Fs);

