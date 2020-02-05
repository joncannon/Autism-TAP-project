% Script takes block struct with data and extracts interesting
% detection/reaction statistics


block_struct = all_blocks_w_data

for n = 1:length(all_blocks_w_data)
    % Get info about each tone
    block_struct{n}.tone_times = block_struct{n}.wav_event_times(mod(block_struct{n}.code, 10)==0);
    block_struct{n}.tone_volumes = floor(mod(block_struct{n}.code(mod(block_struct{n}.code, 10)==0), 100)/10);
    block_struct{n}.tone_pitches = floor(mod(block_struct{n}.identities(mod(block_struct{n}.code, 10)==0), 1000)/100);

    % Get reaction times
    block_struct{n}.tap_rxn_times = get_asynchronies(block_struct{n}.wav_tap_times, block_struct{n}.tone_times);

    % Get more fun info
    block_struct{n}.undetected_pitches = block_struct{n}.tone_pitches(isnan(block_struct{n}.tap_rxn_times));
    block_struct{n}.undetected_volumes = block_struct{n}.tone_volumes(isnan(block_struct{n}.tap_rxn_times));
    block_struct{n}.detected_pitches = block_struct{n}.tone_pitches(~isnan(block_struct{n}.tap_rxn_times));
    block_struct{n}.detected_volumes = block_struct{n}.tone_volumes(~isnan(block_struct{n}.tap_rxn_times));
    block_struct{n}.quiet_delays =  block_struct{n}.tap_rxn_times(block_struct{n}.tone_volumes>1 & block_struct{n}.tone_volumes<5 & ~isnan(block_struct{n}.tap_rxn_times));
    block_struct{n}.loud_delays =  block_struct{n}.tap_rxn_times(block_struct{n}.tone_volumes>4);
end