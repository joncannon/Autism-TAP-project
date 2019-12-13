n_epochs = size(EEG.data, 3);
n_samples = size(EEG.data, 2);
n_channels = size(EEG.data, 1);
n_bins = ERP.nbin;

Fs = 512;

all_event_bins = cell(1, n_epochs);
%all_transforms = cell(n_channels, n_epochs);
transform_means = cell(n_channels, n_bins);
bin_counter = zeros(1,n_bins);

fb = cwtfilterbank('SignalLength',n_samples,'SamplingFrequency',Fs,'FrequencyLimits',[1 50]);

for j = 1:n_channels
    for b = 1:n_bins
        transform_means{j,b} = zeros(71, n_samples);
    end
end

for i=1:n_epochs
    
    event_bins = [];
    for j = 1:length(EEG.epoch(i).eventlatency)
        if EEG.epoch(i).eventlatency{j}==0
            event_bins = EEG.epoch(i).eventbini{j};
        end
    end
    all_event_bins{i} = event_bins;
    for j = 1:n_channels
        [spectro, F] = cwt(double(EEG.data(j,:,i)), 'FilterBank',fb);
        %all_transforms{i, j} = spectro;
        for k = 1:length(event_bins)
            if length(event_bins)>2
                'i'
            end
            bin_counter(event_bins(k)) = bin_counter(event_bins(k))+1;
            transform_means{j, event_bins(k)} = transform_means{j, event_bins(k)}+spectro;
        end
        
    end

end

for b=1:n_bins
    for j = 1:n_channels
        transform_means{j, b} = transform_means{j, b}/bin_counter(b);
    end
end
