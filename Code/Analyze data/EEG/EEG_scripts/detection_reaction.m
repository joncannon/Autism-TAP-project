% EEGLAB script for detection reaction bins
% ------------------------------------------------
% current prerequisites: bin descriptor, bdf file, consolidated eeg data
% file, and the script.

% dialog box to select filter
prompt = {'Filter out frequencies below :','Filter out frequencies above :'};
dlgtitle = 'Input';
dims = [1 100];
definput = {'0.1','50'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
low = str2double(answer(1,1));
high = str2double(answer(2,1));

% dialog box to select files
waitfor(msgbox('Please select the bdf file with raw data'))
[bdffile, bdfpath] = uigetfile('*.bdf');
waitfor(msgbox('Please select the mat file with consolidated_data'))
[matfile, matpath] = uigetfile('*.mat');
waitfor(msgbox('Please select the bin_descriptor file'))
[binfile, binpath] = uigetfile('*.txt');
dir = binpath;

% initialize naming of files
n = strlength(bdffile) - 3;
base_dataset_name = extractBefore(bdffile,n);
filtered_dataset_name = strcat(base_dataset_name,'_filt');
be_dataset_name = strcat(filtered_dataset_name, '_elist_bins_be');
erp_name = strcat(base_dataset_name, '.erp');

% load mat file
load(strcat(matpath,matfile));

% creates the dataset
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_biosig(strcat(bdfpath, bdffile), 'ref',[35 36] ,'refoptions',{'keepref' 'off'});
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',base_dataset_name,'gui','off'); 

% assigns the channels
try 
    EEG=pop_chanedit(EEG, 'lookup','/Applications/eeglab2019_1/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp','changefield',{41 'type' 'SYNC'},'changefield',{34 'type' 'EYE'},'changefield',{33 'type' 'EYE'});
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
catch
    disp("Error: Missing channel location file or channel location file in wrong directory. Check that dipfit/standard_BESA is located in the eeglab2019_1/plugins folder of your applications!");
end
EEG.event = events_w_taps;

% two filters
EEG = pop_eegfiltnew(EEG, 'locutoff',low,'hicutoff',high,'plotfreqz',1);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',filtered_dataset_name,'savenew',filtered_dataset_name,'gui','off'); 

% extract using bin descriptor
EEG  = pop_creabasiceventlist( EEG , 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', strcat(dir, 'elist.txt' ));
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
EEG  = pop_binlister( EEG , 'BDF', strcat(binpath,binfile), 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' );
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'savenew',be_dataset_name,'gui','off'); 

% create erp set & do averages
ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',  4, 'ExcludeBoundary', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname',base_dataset_name, 'filename', erp_name, 'filepath', dir, 'Warning', 'on');

% creates an ERP plot
ERP = pop_ploterps( ERP,  1, [ 31 32] , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 2 1], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' }, 'LineWidth',  1, 'Maximize', 'on',...
 'Position', [ 103.714 51.6667 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -199.0 798.0   -100 0:200:600 ],...
 'YDir', 'normal' );
ERP = pop_ploterps( ERP, [ 1 2], [ 31 32] , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 2 1], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1,...
 'Maximize', 'on', 'Position', [ 103.714 51.6667 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -199.0 798.0   -100 0:200:600 ], 'YDir', 'normal' );
ERP = pop_ploterps( ERP, [ 4 5], [ 31 32] , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 2 1], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1,...
 'Maximize', 'on', 'Position', [ 103.714 51.6667 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -199.0 798.0   -100 0:200:600 ], 'YDir', 'normal' );
ERP = pop_ploterps( ERP, [ 1 8], [ 31 32] , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 2 1], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1,...
 'Maximize', 'on', 'Position', [ 103.714 51.6667 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -199.0 798.0   -100 0:200:600 ], 'YDir', 'normal' );

