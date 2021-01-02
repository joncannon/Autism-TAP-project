function times_list = stim_maker_event_shift_single(filestem, shifts, shift_names, period)
Fs = 44100;

components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/'
tick = audioread(strcat(components_path, 'wood_tick.wav'));
tick = 0.2*tick(:,1);
times_list = {};

for s = 1:length(shifts)
    intervals = [period, period, period, period+shifts(s), period, period, period, period];
    sound_list = {tick, tick, tick, tick, tick, [], [], []};
    times = cumsum(intervals);
    times = [0, times(1:end-1)];
    
    snd_total=zeros(floor((sum(intervals))*Fs), 2);
    pointer = 0;
    for i=1:length(intervals)

        snd_total(1+pointer:pointer+length(sound_list{i}), 1) = sound_list{i} + snd_total(1+pointer:pointer+length(sound_list{i}), 1);
        pointer = pointer + floor(Fs * intervals(i));
    end

    snd_total(:, 2)=snd_total(:, 1);

    audiowrite(strcat(filestem, '_', shift_names{s}, '.wav'),snd_total,Fs);
    times_list{end+1} = times;
end
