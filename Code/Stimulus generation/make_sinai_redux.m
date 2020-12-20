timestamp = datestr(clock, 'dd-mmm-yyyy_HH+MM+SS');
Fs = 44100;

filepath = strcat('../../stimulus_sequences/', 'sinai_', timestamp);
mkdir(filepath);
filepath = strcat(filepath, '/');

params = default_params();
params.sound_list{params.standard_index} = params.sound_list{params.standard_index}*4;
params.sound_list{params.deviant_index} = resample(params.sound_list{params.standard_index}, 15,14);

separation_space = zeros(44100*params.intertrial_time, 2);

sync_time = (params.sync_eeg_samples/512);

params.components_path = params.components_path+"MtSinai/";

numbers = cell(1,10);
for i=1:10
    numbers{i} = audioread(params.components_path+num2str(i)+".m4a");
end


tempi = [106, 112, 118, 124, 130];
periods = 60./tempi;
listening_deviant_rate = 0.05;
tag = 0;

track_nums = [1,5,6,7,8,9,10,13,14,15,17,19,20,21,22,23,24,28,29,30];
all_tracks = cell(size(track_nums));

for i = 1:length(track_nums)
    track = .2*audioread("music/"+num2str(track_nums(i))+".mp3");
    all_tracks{i} = track(:,1);
end


delay_samples = 2*44100 - 2200;


tap_switching_blocks = {};
switching_n_duplicates = 5;



for n = 1:switching_n_duplicates

    n_events = randi([10,13], [1,5])
    
    filename = strcat(filepath, 'nofile', timestamp);
    tap_block = stim_maker_general('params', params,...
            'period', [periods(1),periods(3),periods(1),periods(3),periods(1)],...
            'id_tag', [1,2,1,2,1],...
            'n_events',n_events,...
            'deviant_rate', 0,...
            'target_delay', 3);
    tap_block.filename=filename;
    tap_block.instruction_type = 'tap';
    tap_block.type = 'tap_switching_metronome';
    tap_block.instructions = [];%%%
    tap_switching_blocks{end+1} = tap_block;
end


music_n_duplicates = 2;
listen_music_blocks = {};
tap_music_blocks = {};
track_counter = 1;

for p= 1:length(periods)
    
    for n = 1:music_n_duplicates
        track = resample(all_tracks{track_counter}, 125, tempi(p));
        track = vertcat(zeros(delay_samples, 1), track);
%        track_counter = track_counter+1;
        
        listen_block = stim_maker_general('params', params,...
            'period', periods(p),...
            'n_events',30,...
            'deviant_rate', 0,...
            'event_type', params.omission_index,...
            'target_delay', .5);
        
        listen_block.sound(1:length(track),1) = listen_block.sound(1:length(track),1) + track;
        listen_block.instruction_type = 'listen';
        listen_block.type = 'listen_music';
        listen_block.instructions = [];%%%
        listen_music_blocks{end+1} = listen_block;

%         track = resample(all_tracks{track_counter}, 125, tempi(p));
%         track = vertcat(zeros(delay_samples, 1), track);
        track_counter = track_counter+1;
        
        tap_block = stim_maker_general('params', params,...
            'period', periods(p),...
            'n_events',30,...
            'deviant_rate', 0,...
            'event_type', params.omission_index,...
            'target_delay', .5);
        
        tap_block.sound(1:length(track),1) = tap_block.sound(1:length(track),1) + track;
        tap_block.instruction_type = 'tap';
        tap_block.type = 'tap_music';
        tap_block.instructions = [];%%%
        tap_music_blocks{end+1} = tap_block;
    end
    
end


music_tap_example_block = stim_maker_general('params', params,...
            'period', 0.5085,...
            'n_events',[3, 27],...
            'deviant_rate', 0,...
            'event_type', [params.omission_index, params.tap_index],...
            'target_delay', .5);
track = resample(all_tracks{1}, 125, 118);
track = vertcat(zeros(delay_samples, 1), track);
music_tap_example_block.sound(1:length(track),1) = music_tap_example_block.sound(1:length(track),1) + track;



free_tap_duration = 10;
free_tap_blocks = {};
free_tap_reps = 3;

for n = 1:free_tap_reps
    filename = strcat(filepath, 'nofile', timestamp);

    free_block = stim_maker_general('params', params,...
        'period', free_tap_duration,...
        'n_events',1,...
        'event_type', params.target_index,...
        'target_delay', 1);

    free_block.instruction_type = 'free';
    free_block.type = 'free_tap';
    free_block.instructions = [];%%%
    free_tap_blocks{end+1} = free_block;


end

tap_switching_blocks = tap_switching_blocks(randperm(numel(tap_switching_blocks)));
listen_music_blocks = listen_music_blocks(randperm(numel(listen_music_blocks)));
tap_music_blocks = tap_music_blocks(randperm(numel(tap_music_blocks)));

tap_switching_blocks{1}.instructions = vertcat(...
    audioread(params.components_path+"redux_6_taptoclicks.m4a"),...
    audioread(params.components_path+"redux_7_rhythmchange.m4a"),...
    audioread(params.components_path+"Trial.m4a"),...
    audioread(params.components_path+"1.m4a"),...
    audioread(params.components_path+"of.m4a"),...
    audioread(params.components_path+num2str(length(tap_switching_blocks))+".m4a"));

tap_switching_blocks{1}.instructions(:,2) = 0;
    
for i = 2:length(tap_switching_blocks)
    tap_switching_blocks{i}.instructions = vertcat(...
        audioread(params.components_path+"Trial.m4a"),...
        audioread(params.components_path+num2str(i)+".m4a"),...
        audioread(params.components_path+"of.m4a"),...
        audioread(params.components_path+num2str(length(tap_switching_blocks))+".m4a"));
    tap_switching_blocks{i}.instructions(:,2) = 0;
end

listen_music_blocks{1}.instructions = vertcat(...
    audioread(params.components_path+"redux_1_electronic.m4a"),...
    audioread(params.components_path+"redux_2_listen.m4a"),...
    audioread(params.components_path+"Trial.m4a"),...
    audioread(params.components_path+"1.m4a"),...
    audioread(params.components_path+"of.m4a"),...
    audioread(params.components_path+num2str(length(listen_music_blocks))+".m4a"));

listen_music_blocks{1}.instructions(:,2) = 0;
    
for i = 2:length(listen_music_blocks)
    listen_music_blocks{i}.instructions = vertcat(...
        audioread(params.components_path+"Trial.m4a"),...
        audioread(params.components_path+num2str(i)+".m4a"),...
        audioread(params.components_path+"of.m4a"),...
        audioread(params.components_path+num2str(length(listen_music_blocks))+".m4a"));
    listen_music_blocks{i}.instructions(:,2) = 0;
end

free_tap_blocks{1}.instructions = vertcat(...
    audioread(params.components_path+"redux_3_freetap.m4a"),...
    audioread(params.components_path+"redux_3x_recap.m4a"),...
    audioread(params.components_path+"Trial.m4a"),...
    audioread(params.components_path+"1.m4a"),...
    audioread(params.components_path+"of.m4a"),...
    audioread(params.components_path+num2str(length(free_tap_blocks))+".m4a"));

free_tap_blocks{1}.instructions(:,2) = 0;
    
for i = 2:length(free_tap_blocks)
    free_tap_blocks{i}.instructions = vertcat(...
        audioread(params.components_path+"Trial.m4a"),...
        audioread(params.components_path+num2str(i)+".m4a"),...
        audioread(params.components_path+"of.m4a"),...
        audioread(params.components_path+num2str(length(free_tap_blocks))+".m4a"));
    free_tap_blocks{i}.instructions(:,2) = 0;
end

tap_music_blocks{1}.instructions = vertcat(...
    audioread(params.components_path+"redux_1_electronic.m4a"),...
    audioread(params.components_path+"redux_4_taptomusic.m4a"),...
    audioread(params.components_path+"redux_5_example.m4a"),...
    music_tap_example_block.sound(:,1),...
    audioread(params.components_path+"Trial.m4a"),...
    audioread(params.components_path+"1.m4a"),...
    audioread(params.components_path+"of.m4a"),...
    audioread(params.components_path+num2str(length(tap_music_blocks))+".m4a"));

tap_music_blocks{1}.instructions(:,2) = 0;
    
for i = 2:length(tap_music_blocks)
    tap_music_blocks{i}.instructions = vertcat(...
        audioread(params.components_path+"Trial.m4a"),...
        audioread(params.components_path+num2str(i)+".m4a"),...
        audioread(params.components_path+"of.m4a"),...
        audioread(params.components_path+num2str(length(tap_music_blocks))+".m4a"));
    tap_music_blocks{i}.instructions(:,2) = 0;
end

all_blocks = horzcat(listen_music_blocks, free_tap_blocks, tap_music_blocks, tap_switching_blocks);

fullsound = [];

for i = 1:length(all_blocks)
    fullsound = vertcat(fullsound,all_blocks{i}.instructions, all_blocks{i}.sound);   
    fullsound = vertcat(fullsound,separation_space);
    
end

thankyou = audioread(params.components_path+"redux_8_thankyou.m4a");
thankyou(:,2) = 0; 
fullsound = vertcat(fullsound,thankyou);

audiowrite(strcat(filepath, 'all_sinai_', timestamp, '.m4a'), fullsound, 44100);

save(strcat(filepath, 'all_sinai.mat_', timestamp, '.mat'), 'all_blocks');
