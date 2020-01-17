
unref = EEG.data(40,:);
unref = repmat(unref, [size(EEG.data, 1)-34,1]);
EEG.data(35:end, :) = EEG.data(35:end, :) - unref;

%%
% High-pass the EEG sync channel



%%

% Exclude bad channels (reselect?)
% Change channel types to specify EEG, EMG, eyes, GSR, and SYNC in Edit > Channel Locations menu

%%
EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'hicutoff',80,'chantype',{'EEG', 'EYE'});
    % Maybe lower hi-cut for just ERPs ? 40? 30?
	%filter eyes too!

%%
% Epoch -1000:1000

% Exclude epochs with bad global movement artifacts (not including eyes)???
% Perform ICA on data set with just EEG and eyes
% Auto label components