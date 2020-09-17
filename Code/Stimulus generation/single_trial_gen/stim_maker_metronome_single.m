function stim_maker_metronome_single(filestem, period, n_clicks)
Fs = 44100;

components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/'
tick = audioread(strcat(components_path, 'wood_tick.wav'));
tick = 0.2*tick(:,1);

sound_list = {};
for i=1:n_clicks
    sound_list{i} = tick;
end

intervals = period+zeros(1,n_clicks);

    snd_total=zeros(floor((sum(intervals))*Fs), 2);
    pointer = 0;
    for i=1:length(intervals)

        snd_total(1+pointer:pointer+length(sound_list{i}), 1) = sound_list{i} + snd_total(1+pointer:pointer+length(sound_list{i}), 1);
        pointer = pointer + floor(Fs * intervals(i));
    end

    snd_total(:, 2)=snd_total(:, 1);

    audiowrite(strcat(filestem, '.wav'),snd_total,Fs);
