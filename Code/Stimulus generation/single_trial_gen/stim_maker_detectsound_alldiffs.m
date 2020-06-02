function trial = stim_maker_detectsound_alldiffs(filename, all_volumes, initial_delay, n_cues, cue_delay, perturbation, trial_length_after_cue, valid)

Fs = 44100;
noise_amplitude = .01;

intervals = [initial_delay];
sound_list = {[]};

components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/';
tick = audioread(strcat(components_path, 'wood_tick.wav'));
tick = 0.4*tick(:,1);
crunch = audioread(strcat(components_path, 'crunch.wav'));
crunch = crunch(:,1);

full_BG = audioread(strcat(components_path, 'loud-czech-pub.wav'));
full_BG = full_BG(:,1);

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
first_sample = 1+floor(rand()*(length(full_BG)-bg_length-1));
background = full_BG(first_sample:first_sample+bg_length-1);

snd_total = background;

pointer = floor(Fs * initial_delay);
for i=1:length(intervals)-1
    snd_total(1+pointer:pointer+length(sound_list{i}), 1) = sound_list{i} + snd_total(1+pointer:pointer+length(sound_list{i}), 1);
    pointer = pointer + floor(Fs * intervals(i));
end

snd_total(:, 2)=snd_total(:, 1);
if valid
    
    for diff=1:length(all_volumes)
        volume = all_volumes(diff);
        snd_total_1 = snd_total;
        snd_total_1(1+pointer:pointer+length(crunch), :) = snd_total_1(1+pointer:pointer+length(crunch), :) + volume*crunch;

        trial.sounds{end+1} = snd_total_1;

        audiowrite(strcat(filename, '_diff', num2str(diff), '.wav'),snd_total_1,Fs);
    end
    
else
    trial.sounds{end+1} = snd_total;

    audiowrite(strcat(filename, '_invalid.wav'),snd_total,Fs);

end