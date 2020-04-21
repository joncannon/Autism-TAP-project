% EEGLAB script for detection reaction bins
% ------------------------------------------------
% Current prerequisites: bin descriptor, bdf file, consolidated eeg data
% file, and the script.
% 
% This file is a working progresss: goals are to make it more versatile,
% robust, and more general. At the moment, it takes halely's data from the bdf file to the erp and the plot.

dataset = "Halely_consolidated_eeg_data.mat";
base_dataset_name = "halely";
filtered_dataset_name = base_dataset_name + "_filt";
metronome_frequency = 1.25;
low_band = 1;
high_band = 2;
load(dataset);

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_biosig('/Users/allenwang/Desktop/MATLAB Workspace/Script/halely.bdf', 'ref',[35 36] ,'refoptions',{'keepref' 'off'});
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','halely','gui','off'); 

try 
    EEG=pop_chanedit(EEG, 'lookup','/Applications/eeglab2019_1/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp','changefield',{41 'type' 'SYNC'},'changefield',{34 'type' 'EYE'},'changefield',{33 'type' 'EYE'});
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
catch
    disp("Error: Missing channel location file or channel location file in wrong directory. Check that dipfit/standard_BESA is located in the eeglab2019_1/plugins folder of your applications!");
end
EEG.event = events_w_taps;

EEG = pop_eegfiltnew(EEG, 'locutoff',0.1,'hicutoff',50,'plotfreqz',1);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','halely_filt','gui','off'); 
EEG = pop_eegfiltnew(EEG, 'locutoff',low_band,'hicutoff',high_band,'revfilt',1,'plotfreqz',1);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname','halely_filt_w_band','savenew','halely_filt','gui','off');

EEG  = pop_creabasiceventlist( EEG , 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', '/Users/allenwang/Desktop/MATLAB Workspace/Script/elist.txt' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off'); 
EEG  = pop_binlister( EEG , 'BDF', '/Users/allenwang/Desktop/MATLAB Workspace/Script/Detection_reaction_bin_descriptor.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' );
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'savenew','halely_filt_w_band_elist_bins_be','gui','off'); 

ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname','halely', 'filename', 'halely.erp', 'filepath', '/Users/allenwang/Desktop/MATLAB Workspace/Script', 'Warning', 'on');
ERP = pop_ploterps( ERP, [ 4 5], [ 31 32] , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 2 1], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1,...
 'Maximize', 'on', 'Position', [ 103.714 51.6667 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -199.0 798.0   -100 0:200:600 ], 'YDir', 'normal' );

