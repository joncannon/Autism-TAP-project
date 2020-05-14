function trial = stim_maker_discrim_single(filename, t_sep, pitch1, dir, initial_delay, n_cues, cue_delay, trial_length_after_cue)

amplitude = .04;
pitch2 = pitch1*6/5;
Fs = 44100;

components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/'
tick = audioread(strcat(components_path, 'wood_tick.wav'));
tick = 0.2*tick(:,1);

x_beep = 1:(.2 * Fs);
n_samples = length(x_beep);
envlp = min(n_samples/2-abs((1:n_samples) - floor(n_samples/2)), .005*Fs)./(.005*Fs);
beep1 = amplitude * sin(x_beep * 2*pi * pitch1 / Fs).* envlp;
beep2 = amplitude * sin(x_beep * 2*pi * pitch2 / Fs).* envlp;

if dir == 1
    firstbeep = beep1;
    secondbeep = beep2;
else
    firstbeep = beep2;
    secondbeep = beep1;
end

doublebeep = firstbeep;
doublebeep(end+1 : t_sep*Fs + length(secondbeep)) = 0;
doublebeep(1+t_sep*Fs : t_sep*Fs + length(secondbeep)) = doublebeep(1+t_sep*Fs : t_sep*Fs + length(secondbeep)) + secondbeep;


pointer = floor(Fs * initial_delay);

intervals = [initial_delay];
sound_list = {[]};

for i = 1:n_cues
    intervals(end+1) = cue_delay;
    sound_list{end+1} = tick;
end

intervals(end+1) = trial_length_after_cue - cue_delay;
sound_list{end+1} = doublebeep';


snd_total=zeros(floor((sum(intervals))*Fs), 2);

for i=1:length(intervals)
    
    snd_total(1+pointer:pointer+length(sound_list{i}), 1) = sound_list{i} + snd_total(1+pointer:pointer+length(sound_list{i}), 1);
    pointer = pointer + floor(Fs * intervals(i));
end

snd_total(:, 2)=snd_total(:, 1);

trial = struct();
trial.snd_total = snd_total;
trial.intervals = intervals;
trial.sound_list = sound_list;
trial.pitch = pitch1;
trial.t_sep = t_sep;

audiowrite(strcat(filename, '.wav'),trial.snd_total,Fs);

