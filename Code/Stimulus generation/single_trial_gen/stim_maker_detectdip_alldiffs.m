function trial = stim_maker_detectdip_alldiffs(filename, all_volumes, initial_delay, n_cues, cue_delay, perturbation, trial_length_after_cue, valid)

Fs = 44100;

intervals = [initial_delay];
sound_list = {[]};

components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/';
tick = audioread(strcat(components_path, 'wood_tick.wav'));
tick = 0.4*tick(:,1);

for i = 1:n_cues-1
    intervals(end+1) = cue_delay;
    sound_list{end+1} = tick;
end

intervals(end+1) = cue_delay + perturbation;
sound_list{end+1} = tick;

intervals(end+1) = trial_length_after_cue - cue_delay;

trial = struct();
trial.intervals = intervals;
trial.cue_delay = cue_delay;
trial.perturbation = perturbation;
trial.valid = valid;
trial.sounds = {};
trial.all_volumes = all_volumes;

trial.sound_list = sound_list;

bg_length = floor((sum(intervals))*Fs);
x_list = 1:bg_length;

snd_total = zeros(bg_length, 1);

pointer = floor(Fs * initial_delay);
for i=1:length(intervals)-1
    snd_total(1+pointer:pointer+length(sound_list{i}), 1) = sound_list{i} + snd_total(1+pointer:pointer+length(sound_list{i}), 1);
    pointer = pointer + floor(Fs * intervals(i));
end

dip_length = 1000;
dip_time = pointer; 
dip_func = @(x) exp(-(x.^2)/(dip_length^2));

freqs = [];
freqs(end+1) = 220 * 2^(rand()*.5);
freqs(end+1) = 330 * 2^(rand()*.5);
freqs(end+1) = 495 * 2^(rand()*.5);
which_one = randi(length(freqs));

tones = zeros(bg_length, length(freqs));

for i = 1:length(freqs)
    tones(:,i) = .1*sin(x_list * 2*pi * freqs(i) / Fs);
    if i~=which_one
        snd_total = snd_total + tones(:,i);
    end
end

snd_total(:, 2)=snd_total(:, 1);

if valid
    for diff=1:length(all_volumes)
        volume = all_volumes(diff);
        envelope = ones(bg_length, 1) - volume.*dip_func(x_list' - dip_time);
        final_tone = repmat(tones(:,which_one) .* envelope, [1,2]);
        snd_total_1 = snd_total + final_tone;

        audiowrite(strcat(filename, '_diff', num2str(diff), '.wav'),snd_total_1,Fs);
    end
    
else
    snd_total = snd_total + repmat(tones(:,which_one), [1,2]);
    audiowrite(strcat(filename, '_invalid.wav'),snd_total,Fs);
end








