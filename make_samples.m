params = struct();
params.lead_in=2;
params.allowable_distance = 2;
params.save_separate = false;
params.wav_separate = false;
params.Fs = 44100;
tick = audioread('stimulus_components/wood_tick.wav');
params.tick = 0.2*tick(:,1);
params.deviant = resample(tick(:,1), 4,5);
target = audioread('stimulus_components/target_beep.wav');
params.target = 0.2*target(:,1);
params.eeg_amplitude = 0.005;
params.intertrial_amplitude = .0025;
params.standard_code = 0;
params.deviant_code = 1;
params.omission_code = 3;
params.target_code = 2;

all_blocks = {};

rxn_inst_1 = audioread('stimulus_components/ThisIsTargetSound.wav');
rxn_inst_2 = audioread('stimulus_components/TapReaction.wav');
rxn_inst_3 = audioread('stimulus_components/DoNotMove.wav');

init_rxn_inst = vertcat(rxn_inst_1, params.target);
init_rxn_inst(:,2) = 0;
rxn_inst = vertcat(rxn_inst_2, rxn_inst_3, zeros(44100*2, 1));
rxn_inst(:,2) = 0;

tapalong_inst = vertcat(audioread('stimulus_components/TapAlong.wav'), zeros(44100*1, 1));
tapalong_inst(:,2) = 0;    

mkdir('examples_11-5-2019')

[snd_total, key] = stim_maker_deviant('example_deviant_listen', .6, 10, .3, false, params);
key.code
audiowrite('examples_11-5-2019/example_deviant_listen.wav', snd_total(:,1), 44100);

[snd_total, key] = stim_maker_omission('example_omission', .6, 10, 0.3, false, params);
audiowrite('examples_11-5-2019/example_omission.wav', snd_total(:,1), 44100);
key.code

[snd_total, key] = stim_maker_deviant('example_steady_tapping', .5, 10, 0, false, params);
audiowrite('examples_11-5-2019/example_steady_tapping.wav', vertcat(tapalong_inst(:, 1), snd_total(:,1)), 44100);

phase_types = {};
phase_types{1} = struct();
phase_types{1}.n_targets = 4;
phase_types{1}.range = [.5,.5];
phases = {phase_types{1}};

[snd_total, key] = stim_maker_contingency('example_contingency', .3, phases, [1.5,2.5], params);
audiowrite('examples_11-5-2019/example_contingency.wav', snd_total(:,1), 44100);

