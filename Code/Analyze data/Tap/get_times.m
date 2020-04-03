function times = get_times(audio, threshold, ignore_samples)


% find all elements above given threshold
above_threshold = squeeze(find(audio > threshold)');
keyboard
% ignore samples within ignore_period
samples = above_threshold([true, diff(above_threshold) > ignore_samples]);

% convert samples to seconds
times = samples ./ 44100;
end