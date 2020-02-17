function block=stim_maker_SSAEP(filename, period, n_events, fade_rate, fade_direction, noise_level, trial_tag, params)


block=stim_maker_standard(filename, period, n_events, false, trial_tag, params);



if fade_direction == 0
    x_envelope = [ceil(size(block.sound, 1)/2):-1:1, 1:floor(size(block.sound, 1)/2)];
    fade_envelope = exp(-fade_rate * x_envelope / 44100);
else
    x_envelope = 1:size(block.sound, 1);
    fade_envelope = exp(-fade_rate * x_envelope / 44100);
    if fade_direction == -1
        fade_envelope = fliplr(fade_envelope);
    end
end

block.sound(:,1) = block.sound(:,1) .* fade_envelope';
block.sound(:,1) = block.sound(:,1) + noise_level*randn(size(block.sound(:,1)));

block.type = 'standard_noisy_fade';
block.direction = fade_direction;