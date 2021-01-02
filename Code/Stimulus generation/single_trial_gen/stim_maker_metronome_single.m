function [times, phase_shifts, time_shifts] = stim_maker_metronome_single(filestem, period, n_clicks, time_jitter, interval_jitter)
Fs = 44100;

components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/'
tick = audioread(strcat(components_path, 'wood_tick.wav'));
tick = 0.2*tick(:,1);

sound_list = {};
for i=1:n_clicks
    sound_list{i} = tick;
end

phase_shifts = interval_jitter*randn(1, n_clicks)
intervals_0 = period + phase_shifts;

times_0 = cumsum(intervals_0);
time_shifts = min(period/2, max(-period/2, time_jitter*randn(size(times_0))));
times = times_0 + time_shifts;
times = [0, times];
time_shifts = [0, time_shifts];

intervals = diff(times);
times = times(1:end-1);
time_shifts = time_shifts(1:end-1);

snd_total=zeros(floor((sum(intervals))*Fs), 2);
pointer = 0;

for i=1:length(intervals)
    snd_total(1+pointer:pointer+length(sound_list{i}), 1) = sound_list{i} + snd_total(1+pointer:pointer+length(sound_list{i}), 1);
    pointer = pointer + floor(Fs * intervals(i));
end

snd_total(:, 2)=snd_total(:, 1);

audiowrite(strcat(filestem, '.wav'),snd_total,Fs);

