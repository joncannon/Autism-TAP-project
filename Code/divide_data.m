function updated_struct = divide_data(beep_times, tap_times, block_struct)

before_time = .1; % how much to widen tap threshold around beeps (sec)
after_time = 10;

updated_struct = block_struct;
beep_index = 1;
for i = 1:length(block_struct)
    i
    num_beeps = length(updated_struct{i}.code);
    updated_struct{i}.wav_beep_times = beep_times(beep_index:beep_index + num_beeps - 1);
    beep_index = beep_index + num_beeps
end


for i = 1:length(block_struct)
    first_beep = updated_struct{i}.wav_beep_times(1);
    last_beep = updated_struct{i}.wav_beep_times(end);
    updated_struct{i}.wav_tap_times = tap_times(tap_times > first_beep - before_time & tap_times < last_beep + after_time);
end

end