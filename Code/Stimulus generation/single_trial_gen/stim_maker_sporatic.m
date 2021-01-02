function [times, shifts] = stim_maker_sporatic(filestem, period, lead_in, shift_type, shift_list, in_between_options)
Fs = 44100;

components_path = '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Code/Stimulus generation/stimulus_components/'
tick = audioread(strcat(components_path, 'wood_tick.wav'));
tick = 0.2*tick(:,1);



rand_between = @() in_between_options(randi(length(in_between_options)));


    intervals = period*ones([1,lead_in]);
    intervals = [intervals, period*ones([1,rand_between()])];
    shifts = zeros(size(intervals));
    
    for i = 1:length(shift_list)
        intervals(end+1) = period + shift_list(i);
        shifts(end+1) = shift_list(i);
        n_between = rand_between();
        
        if strcmp(shift_type, 'phase')
            intervals = [intervals, period*ones([1,n_between])];
            
        elseif strcmp(shift_type, 'event')
            intervals = [intervals, period - shift_list(i), period*ones([1,n_between-1])];
        end
        shifts = [shifts, zeros([1,n_between])];
    end
    
    shifts = [0, shifts(1:end-1)];

    times = cumsum(intervals);
    times = [0, times(1:end-1)];
    


    sound_list = {};
    for i=1:length(intervals)
        sound_list{i} = tick;
    end
    
    snd_total=zeros(floor((sum(intervals))*Fs), 2);
    pointer = 0;
    for i=1:length(intervals)

        snd_total(1+pointer:pointer+length(sound_list{i}), 1) = sound_list{i} + snd_total(1+pointer:pointer+length(sound_list{i}), 1);
        pointer = pointer + floor(Fs * intervals(i));
    end

    snd_total(:, 2)=snd_total(:, 1);

    audiowrite(strcat(filestem, '.wav'),snd_total,Fs);

