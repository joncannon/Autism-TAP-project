trialtypes_async = zeros(5, 2, 8);
all_periods = [.45, .55, .65, .75, .85];
% check double taps

for n = 1:length(all_blocks_w_data)
    block = all_blocks_w_data{n};
    all_asynchronies = get_asynchronies(all_blocks_w_data{n}.wav_tap_times, all_blocks_w_data{n}.wav_event_times);
    all_ITIs = get_ITIs_w_sync(all_blocks_w_data{n}.wav_tap_times, all_blocks_w_data{n}.wav_event_times) - all_blocks_w_data{n}.period;
    
    all_blocks_w_data{n}.all_asynchronies = all_asynchronies;
    
    if streq(block.type, 'third_beat')
        leadtime = 1;
    else
        leadtime = 2;
    end
    
    rep = mod(floor(block.trial_tag/10), 10);
    period_num = floor(block.trial_tag/100);
    
    trialtypes_async(period_num, leadtime, rep) = all_asynchronies(end);

end
%%
yrange = [-.15, .15];

figure()
subplot(1,2, 1)
hold on
for i = 1:5
    plot(zeros(8,1)+all_periods(i), squeeze(trialtypes_async(i, 1, :)), 'o')
end
errorbar(all_periods, squeeze(nanmean(trialtypes_async(:, 1, :), 3)), squeeze(nanstd(trialtypes_async(:, 1, :), 0,3)), 'ko-')
ylim(yrange)

subplot(1,2, 2)
hold on
for i = 1:5
    plot(zeros(8,1)+all_periods(i), squeeze(trialtypes_async(i, 2, :)), 'o')
end
errorbar(all_periods, squeeze(nanmean(trialtypes_async(:, 2, :), 3)), squeeze(nanstd(trialtypes_async(:, 2, :), 0,3)), 'ko-')
ylim(yrange)



figure()
subplot(1,2, 1)
hold on
for i = 1:5
    plot(zeros(8,1)+all_periods(i), squeeze(trialtypes_async(i, 1, :))+all_periods(i), 'o')
end
errorbar(all_periods', squeeze(nanmean(trialtypes_async(:, 1, :), 3))+all_periods', squeeze(nanstd(trialtypes_async(:, 1, :), 0,3)), 'ko-')
plot([.4, .9], [.4, .9])
ylim([0,1])

subplot(1,2, 2)
hold on
for i = 1:5
    plot(zeros(8,1)+all_periods(i), squeeze(trialtypes_async(i, 2, :))+all_periods(i), 'o')
end
errorbar(all_periods', squeeze(nanmean(trialtypes_async(:, 2, :), 3))+all_periods', squeeze(nanstd(trialtypes_async(:, 2, :), 0,3)), 'ko-')
plot([.4, .9], [.4, .9])
ylim([0,1])

%%


