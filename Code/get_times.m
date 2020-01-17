function times = get_times(audio, threshold)

ignore_period = 6000; % samples after detected peak to ignore

% find all elements above given threshold
above_threshold = squeeze(find(audio > threshold)');

% ignore samples within ignore_period
samples = above_threshold([true, diff(above_threshold) > ignore_period]);

% convert samples to seconds
times = samples ./ 44100;
end