meanref = mean(EEG.data(1:32, :), 1);
bigmeanref = repmat(meanref, [32,1]);

EEG.data(1:32, :) = EEG.data(1:32, :)-bigmeanref;

%%

