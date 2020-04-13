function all_blocks_w_data = get_detection_reaction_data(all_blocks_w_data);

% Script takes block struct with data and extracts interesting
% detection/reaction statistics



for n = 1:length(all_blocks_w_data)
    n
    % Get info about each tone
    code_is_tone = mod(all_blocks_w_data{n}.code, 10)==0;
    code_is_audible_tone = code_is_tone & floor(mod(all_blocks_w_data{n}.code, 100)/10)>1;
    code_is_silent_tone = code_is_tone & floor(mod(all_blocks_w_data{n}.code, 100)/10)==1;
    
    % Get reaction times
    all_rxn_times = get_delays(all_blocks_w_data{n}.wav_tap_times, all_blocks_w_data{n}.wav_event_times);
    all_is_detected = ~isnan(all_rxn_times);
    
    all_blocks_w_data{n}.all_rxn_times = all_rxn_times;
    all_blocks_w_data{n}.all_is_detected = all_is_detected;
    all_blocks_w_data{n}.code_is_tone = code_is_tone;
    all_blocks_w_data{n}.code_is_audible_tone = code_is_audible_tone;
    all_blocks_w_data{n}.code_is_silent_tone = code_is_silent_tone;
    
    
    if streq(all_blocks_w_data{n}.type, 'detect_contingency')
        code_is_cued = mod(floor(all_blocks_w_data{n}.code/100000),10);
        code_phase = mod(floor(all_blocks_w_data{n}.code/1000000),10);
        all_blocks_w_data{n}.code_is_cued = code_is_cued;
        
        all_blocks_w_data{n}.phase_transition = all_blocks_w_data{n}.wav_event_times(find(code_phase == 2, 1));
        all_blocks_w_data{n}.cued_tone_rxn_times = all_rxn_times(code_is_audible_tone & code_is_cued & all_is_detected);
        all_blocks_w_data{n}.uncued_tone_rxn_times = all_rxn_times(code_is_audible_tone & ~code_is_cued & all_is_detected);
        all_blocks_w_data{n}.cued_tone_times = all_blocks_w_data{n}.wav_event_times(code_is_audible_tone & code_is_cued & all_is_detected);
        all_blocks_w_data{n}.uncued_tone_times = all_blocks_w_data{n}.wav_event_times(code_is_audible_tone & ~code_is_cued & all_is_detected);
       
    end
    
    all_blocks_w_data{n}.false_positives = all_is_detected & code_is_silent_tone;
    all_blocks_w_data{n}.true_negatives = ~all_is_detected & code_is_silent_tone;
    all_blocks_w_data{n}.misses = ~all_is_detected & code_is_audible_tone;
    all_blocks_w_data{n}.hits = all_is_detected & code_is_audible_tone;
    
    all_blocks_w_data{n}.tone_times = all_blocks_w_data{n}.wav_event_times(code_is_tone);
    all_blocks_w_data{n}.tone_volumes = floor(mod(all_blocks_w_data{n}.code(code_is_tone), 100)/10);
    all_blocks_w_data{n}.tone_pitches = floor(mod(all_blocks_w_data{n}.identities(code_is_tone), 1000)/100);

    all_blocks_w_data{n}.tap_rxn_times = all_rxn_times(code_is_tone);
    
    % Get more fun info
    all_blocks_w_data{n}.undetected_pitches = all_blocks_w_data{n}.tone_pitches(isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.undetected_volumes = all_blocks_w_data{n}.tone_volumes(isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.detected_pitches = all_blocks_w_data{n}.tone_pitches(~isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.detected_volumes = all_blocks_w_data{n}.tone_volumes(~isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.quiet_delays =  all_blocks_w_data{n}.tap_rxn_times(all_blocks_w_data{n}.tone_volumes>1 & all_blocks_w_data{n}.tone_volumes<5 & ~isnan(all_blocks_w_data{n}.tap_rxn_times));
    all_blocks_w_data{n}.loud_delays =  all_blocks_w_data{n}.tap_rxn_times(all_blocks_w_data{n}.tone_volumes>4);
    
    n_hits = sum(all_blocks_w_data{n}.hits);
    n_misses = sum(all_blocks_w_data{n}.misses);
    n_false_positives = sum(all_blocks_w_data{n}.false_positives);
    n_true_negatives = sum(all_blocks_w_data{n}.true_negatives);
    
    all_blocks_w_data{n}.detect_rate = n_hits / (n_hits+n_misses);
    all_blocks_w_data{n}.fp_rate = n_false_positives / (n_false_positives + n_true_negatives);
    all_blocks_w_data{n}.mean_rxn_time = mean( all_rxn_times( code_is_audible_tone & all_is_detected));
    all_blocks_w_data{n}.rxn_time_std = std( all_rxn_times( code_is_audible_tone & all_is_detected), 1, 'all');
    
end