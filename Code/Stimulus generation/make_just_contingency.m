%Event codes:
% ones place - event type: 1=standard, 2=deviant, 3=target, 4=omission,
% 5=end, 9=tap

% hundreds place - period: 1=.6s, 2=.7s, 3=.8s, 0=N/A or .5 (deviant
% control)

% thousands place - trial type: 0=listen metronome, 1=tap metronome,
% 2=listen deviant, 3=listen omission, 4=tap omission, 5=deviant control
% 6=free tap, 7=contingency

mkdir(strcat('../stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS')));
filepath = strcat('../stimulus_sequences/', datestr(clock, 'dd-mmm-yyyy HH+MM+SS'), '/');

params = struct();

params.all_periods = all_periods;

params.lead_in=4;
params.allowable_distance = 3;

params.save_separate = false;
params.wav_separate = false;
params.Fs = 44100;
params.sound_list = {};

tick = audioread('../stimulus_components/wood_tick.wav');
params.sound_list{1} = 0.2*tick(:,1);
params.standard_index = 1;

params.sound_list{2} = .2*resample(tick(:,1), 5,4);
params.deviant_index = 2;

target = audioread('../stimulus_components/target_beep.wav');
params.sound_list{3} = 0.2*target(:,1);
params.target_index = 3;

params.sound_list{4} = 0;
params.omission_index = 4;

params.end_code = 5;

params.shift_code = 10;
params.tempo_code = 20;

params.listen_standard_tag = 0;
params.tap_standard_tag = 1;
params.listen_deviant_tag = 2;
params.listen_omission_tag = 3;
params.tap_omission_tag = 4;
params.deviant_control_tag = 5;
params.free_tap_tag = 6;
params.contingency_tag = 7;

params.sync_amplitude = 0.005;
params.sync_samples = 200;
params.intertrial_amplitude = .0025;
params.intertrial_time = 5;

listening_blocks = {};
tapping_blocks = {};

separation_space = zeros(44100*params.intertrial_time, 2);
separation_space(:,2)=params.intertrial_amplitude;

rxn_inst_1 = 1.2*audioread('../stimulus_components/ThisIsTargetSound.wav');
rxn_inst_2 = audioread('../stimulus_components/TapReaction2.wav');
rxn_inst_3 = audioread('../stimulus_components/DoNotMove.wav');

distract_inst = audioread('../stimulus_components/DoStuff.wav');
distract_inst(:,2) = 0;

free_inst = audioread('../stimulus_components/FreeTap.wav');
free_inst(:,2) = 0;

init_rxn_inst = vertcat(rxn_inst_1, params.sound_list{params.target_index}, rxn_inst_2, rxn_inst_3, zeros(44100*2, 1));
init_rxn_inst(:,2) = 0;
contingency_rxn_inst = vertcat(rxn_inst_1, params.sound_list{params.target_index}, rxn_inst_2, zeros(44100*2, 1));
contingency_rxn_inst(:,2) = 0;
rxn_inst = vertcat(rxn_inst_2, zeros(44100*2, 1));
rxn_inst(:,2) = 0;

tapalong_inst = vertcat(audioread('../stimulus_components/TapAlong.wav'), zeros(44100*1, 1));
tapalong_inst(:,2) = 0;




phase_types = {};
phase_types{1} = struct();
phase_types{2} = struct();
phase_types{1}.n_cued_targets = 40%40;
phase_types{2}.n_cued_targets = 40%40;
phase_types{1}.n_events = 100%180;
phase_types{2}.n_events = 100%180;
phase_types{1}.cue_interval = .7;
phase_types{2}.cue_interval = .7;
phase_types{1}.cue_rate = .5;
phase_types{2}.cue_rate = .8;
phase_types{1}.phase_code = 1;
phase_types{2}.phase_code = 2;

phases = {phase_types{1}, phase_types{2}, phase_types{1}};

intertrial_range = [1, 2];
trial_tag = 10*params.contingency_tag;
contingency_block = stim_maker_pawan_contingency(strcat(filepath, 'contingency_three_phase_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS')), phases, intertrial_range, true, trial_tag, params);
contingency_block.instructions = contingency_rxn_inst;

fullsound = vertcat(contingency_block.instructions, contingency_block.sound);   

audiowrite(strcat(filepath, 'contingency_block_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS'), '.wav'), fullsound, 44100);

save(strcat(filepath, 'contingency_block_', datestr(clock, 'dd-mmm-yyyy_HH+MM+SS'), '.mat'), 'fullsound', 'all_blocks', 'all_blocks_shuffled', 'shuffled_indices', 'params');
