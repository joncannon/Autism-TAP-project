all_subjects_plus = all_subjects;

for s = 1:length(all_subjects_plus)
    s
    all_subjects_plus{s} = get_detection_reaction_data(all_subjects{s});

end

all_detection_rates = zeros(6, 3);
all_rxn_means = zeros(6, 3);
contingency_cued_rxn_times = zeros(6, sum(all_subjects_plus{1}{1}.code_is_audible_tone & all_subjects_plus{1}{1}.code_is_cued));
contingency_uncued_rxn_times = zeros(6, sum(all_subjects_plus{1}{1}.code_is_audible_tone & ~all_subjects_plus{1}{1}.code_is_cued));
shifted_cued_rxn_times = zeros(6, sum(all_subjects_plus{1}{1}.code_is_audible_tone & all_subjects_plus{1}{1}.code_is_cued));


for s = 1:length(all_subjects_plus)    
    contingency_cued_rxn_times(s,:) = all_subjects_plus{s}{1}.all_rxn_times((all_subjects_plus{s}{1}.code_is_audible_tone & all_subjects_plus{s}{1}.code_is_cued))
    contingency_uncued_rxn_times(s,:) = all_subjects_plus{s}{1}.all_rxn_times((all_subjects_plus{s}{1}.code_is_audible_tone & ~all_subjects_plus{s}{1}.code_is_cued))
    shifted_cued_rxn_times(s,:) = contingency_cued_rxn_times(s,:) - nanmean(contingency_cued_rxn_times(s,:));
    %shifted_uncued_rxn_times(s,:) = all_subjects_plus{s}{1}.all_rxn_times((all_subjects_plus{s}{1}.code_is_audible_tone & ~all_subjects_plus{s}{1}.code_is_cued))
    
    for n = 1:3
        all_detection_rates(s,n) = all_subjects_plus{s}{n+1}.detect_rate;
        all_rxn_means(s,n) = all_subjects_plus{s}{n+1}.mean_rxn_time;
    end
    
end

x_cued = all_subjects_plus{1}{1}.wav_event_times(all_subjects_plus{1}{1}.code_is_audible_tone & all_subjects_plus{1}{1}.code_is_cued);
x_uncued = all_subjects_plus{1}{1}.wav_event_times(all_subjects_plus{1}{1}.code_is_audible_tone & ~all_subjects_plus{1}{1}.code_is_cued);

cued_means = nanmean(contingency_cued_rxn_times, 1);
uncued_means = nanmean(contingency_uncued_rxn_times, 1);
shifted_cued_means = nanmean(shifted_cued_rxn_times, 1);

detection_rate_mean = mean(all_detection_rates, 1);
rxn_mean_mean = mean(all_rxn_means, 1);

n_cued_rxns = sum(~isnan(contingency_cued_rxn_times), 1);
n_uncued_rxns = sum(~isnan(contingency_uncued_rxn_times), 1);
valid_cued_rxns = (n_cued_rxns >= 3);
valid_uncued_rxns = (n_uncued_rxns >= 3);

cued_std_errors = nanstd(contingency_cued_rxn_times, 1)./sqrt(n_cued_rxns);
uncued_std_errors = nanstd(contingency_uncued_rxn_times, 1)./sqrt(n_uncued_rxns);
shifted_cued_std_errors = nanstd(contingency_cued_rxn_times, 1)./sqrt(n_cued_rxns);

detection_rate_std_error = std(all_detection_rates, 1)/sqrt(6);
rxn_mean_std_error = std(all_rxn_means, 1)/sqrt(6);

X = categorical({'interval', 'beat', 'random'});
X = reordercats(X,{'interval', 'beat', 'random'});
%%
figure()
bar(X,detection_rate_mean)                

hold on
title('detection rates')
er = errorbar(X,detection_rate_mean,detection_rate_std_error, 'k');                               
er.LineStyle = 'none';  

hold off

%%
figure()
bar(X,rxn_mean_mean)                

hold on
title('rxn times')
er = errorbar(X,rxn_mean_mean,rxn_mean_std_error, 'k');                               
er.LineStyle = 'none';  

hold off

%%
figure()

errorbar(x_cued(valid_cued_rxns), cued_means(valid_cued_rxns), cued_std_errors(valid_cued_rxns), 'o-');
hold on
%errorbar(x_uncued(valid_uncued_rxns), uncued_means(valid_uncued_rxns), uncued_std_errors(valid_uncued_rxns), 'o-');
plot(all_subjects_plus{1}{1}.phase_transition*[1,1], [0,1])
plot(x_cued(valid_cued_rxns), contingency_cued_rxn_times(:, valid_cued_rxns), 'o');


plot(x_cued(~valid_cued_rxns), cued_means(~valid_cued_rxns), '*')
%plot(x_uncued(~valid_uncued_rxns), uncued_means(~valid_uncued_rxns), '*')

%%
figure()

errorbar(x_cued(valid_cued_rxns), shifted_cued_means(valid_cued_rxns), shifted_cued_std_errors(valid_cued_rxns), 'o-');
hold on
plot(all_subjects_plus{1}{1}.phase_transition*[1,1], [0,1])
plot(x_cued(valid_cued_rxns), shifted_cued_rxn_times(:, valid_cued_rxns), 'o');

plot(x_cued(~valid_cued_rxns), shifted_cued_means(~valid_cued_rxns), '*')

%%

figure()
hold on
%plot(x_uncued(valid_uncued_rxns), contingency_uncued_rxn_times(:, valid_uncued_rxns), 'o-');

plot(all_subjects_plus{1}{1}.phase_transition*[1,1], [0,1])
