EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');

EEG = pop_saveset(EEG, 'filename','Isaac_2_4_noref_elist_refef_filt_ICA.set','filepath','/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Isaac_2_4/');

EEG = pop_loadset('filename','Anna_11_6_noref_reref_filt.set','filepath','/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Anna_11_6/');

EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');

EEG = pop_saveset(EEG, 'filename','Anna_11_6_noref_reref_filt_ICA.set','filepath','/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Anna_11_6/');


Import without reference
Import channel locations
Exclude bad channels
Rereference only EEG: pop_reref( EEG, [1:32] ,'exclude',[33:43] ,'keepref','on');
Use find_events, then pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', '/Users/cannon/Documents/MATLAB/Entrainment-Contingency/Isaac_2_4/event_list_1.txt' );
Filter EEG channels: EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'hicutoff',80,'chantype',{'EEG'});
Perform ICA