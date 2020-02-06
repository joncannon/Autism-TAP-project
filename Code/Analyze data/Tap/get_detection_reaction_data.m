% Script takes block struct with data and extracts interesting
% detection/reaction statistics



for n = 1:length(all_blocks_w_data)
    % Get info about each tone
    all_blocks_w_data{n}.tone_times = all_blocks_w_data{n}.wav_event_times(mod(all_blocks_w_data{n}.code, 10)==0);
    all_blocks_w_data{n}.tone_volumes = floor(mod(all_blocks_w_data{n}.code(mod(all_blocks_w_data{n}.code, 10)==0), 100)/10);
    all_blocks_w_data{n}.tone_pitches = floor(mod(all_blocks_w_data{n}.identities(mod(all_blocks_w_data{n}.code, 10)==0), 1000)/100);

    % Get reaction times
    all_blocks_w_data{n}.tap_rxn_times = get_asynchronies(all_blocks_w_data{n}.wav_tap_times, all_blocks_w_data{n}.tone_times);

    % Get more fun info
    all_blocks_w_data{n}.undetected_pitches = all_blocks_w_data{n}.tone_pitches(isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.undetected_volumes = all_blocks_w_data{n}.tone_volumes(isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.detected_pitches = all_blocks_w_data{n}.tone_pitches(~isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.detected_volumes = all_blocks_w_data{n}.tone_volumes(~isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.quiet_delays =  all_blocks_w_data{n}.tap_rxn_times(all_blocks_w_data{n}.tone_volumes>1 & all_blocks_w_data{n}.tone_volumes<5 & ~isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.loud_delays =  all_blocks_w_data{n}.tap_rxn_times(all_blocks_w_data{n}.tone_volumes>4);
end