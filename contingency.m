params = struct();
params.target_sound = 'wood_tick.wav';
params.cue_sound = 'blip.wav';
params.distractor_sounds = {};
params.phases = [20, 20];
params.target_rates = [.3, .3];
params.means = [.6, 1]
params.SDs = [.2, .2]

sound(contingency_stimulus(params), 44100)


function snd_total=contingency_stimulus(params)

[target_sound, target_Fs] = audioread(params.target_sound);
Fs = target_Fs;
target_sound = target_sound(:,1);
length(target_sound)
"ding"
[cue_sound, cue_Fs] = audioread(params.cue_sound);
cue_sound = cue_sound(:,1);

distractor_sounds = {};
distractor_Fs = [];



for i = 1:length(params.distractor_sounds)
    [D,F] = audioread(params.distractor_sounds(i));
    distractor_Fs(end+1) = F
    distractor_sounds{end+1} = D
end

duration = sum(params.phases)

targets = zeros(1, Fs*(duration+1));
cues = zeros(1, Fs*(duration+1));
distractors = zeros(1, Fs*(duration+1));
snd_total = zeros(1, Fs*(duration+1));

phase_start_sample = 1;
for j = 1:length(params.phases)
    current_targets = (rand(1,params.phases(j)*Fs+1) < params.target_rates(j)/Fs);
    targets(phase_start_sample : phase_start_sample + params.phases(j)*Fs) = current_targets;   
    snd_total(phase_start_sample : phase_start_sample + length(current_targets) +length(target_sound)- 2) = conv(current_targets, target_sound);
    all_targets = find(current_targets);
    size(all_targets)
    for target_num = 1:length(all_targets)
        cue_sample = all_targets(target_num) - floor((params.SDs(j)*Fs*randn(1) + Fs*params.means(j)));
        
        if phase_start_sample + cue_sample>0
            snd_total(phase_start_sample + cue_sample : phase_start_sample + cue_sample + length(cue_sound)-1) = snd_total(phase_start_sample + cue_sample : phase_start_sample + cue_sample + length(cue_sound)-1) + cue_sound';
            cues(phase_start_sample + cue_sample) = 1;
        end
    end
    phase_start_sample = phase_start_sample + params.phases(j)*Fs
end



end