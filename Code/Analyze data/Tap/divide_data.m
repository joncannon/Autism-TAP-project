function updated_struct = divide_data(event_times, tap_times, block_struct)

before_time = .1; % how much to widen tap threshold around events (sec)
after_time = 10;

updated_struct = block_struct;
event_index = 2;
for i = 1:length(block_struct)
    num_events = length(updated_struct{i}.code);
    updated_struct{i}.wav_event_times = event_times(event_index:event_index + num_events-1); %skips first and last
    event_index = event_index + num_events + 2;
end

for i = 1:length(block_struct)
    first_event = updated_struct{i}.wav_event_times(1);
    last_event = updated_struct{i}.wav_event_times(end);
    updated_struct{i}.wav_tap_times = tap_times(tap_times > first_event - before_time & tap_times < last_event + after_time);
end

end