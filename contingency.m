params = struct();
params.target_sound = 'wood_tick.wav';
params.cue_sound = 'blip.wav';
params.distractor_sounds = {};
params.phases = [20, 20];

params.means = [.3, 1];
params.SDs = [0, .2];

params.method = "intervals"
params.target_rates = [.3, .3];
params.intertarget_interval_range = [2, 3];

stimulus = contingency_stimulus(params);

audiowrite("contingency.wav", stimulus, 44100);


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
snd_total = zeros(Fs*(duration+1),2);

phase_start_sample = 1;


if params.method == "rates"
    for j = 1:length(params.phases)
        current_targets = (rand(1,params.phases(j)*Fs+1) < params.target_rates(j)/Fs);
        targets(phase_start_sample : phase_start_sample + params.phases(j)*Fs) = current_targets;   
        snd_total(phase_start_sample : phase_start_sample + length(current_targets) +length(target_sound)- 2, 1) = conv(current_targets, target_sound);
        all_targets = find(current_targets);
        for target_num = 1:length(all_targets)
            cue_sample = all_targets(target_num) - max(floor((params.SDs(j)*Fs*randn(1) + Fs*params.means(j))), 0);
            if phase_start_sample + cue_sample>0
                snd_total(phase_start_sample + cue_sample : phase_start_sample + cue_sample + length(cue_sound)-1, 1) = snd_total(1, phase_start_sample + cue_sample : phase_start_sample + cue_sample + length(cue_sound)-1, 1) + cue_sound';
                cues(phase_start_sample + cue_sample) = 1;
            end
        end
        phase_start_sample = phase_start_sample + params.phases(j)*Fs

       
            
    end
        
elseif params.method == "intervals"
    max_int = params.intertarget_interval_range(2)
    min_int = params.intertarget_interval_range(1)
    sample = 1;
    
    while sample < size(snd_total,1) - 2*max_int*Fs
        sample = sample + floor(Fs*((max_int - min_int)*rand() + min_int))
        targets(sample) = 1;
        snd_total(sample : sample + length(target_sound)-1, 1) = snd_total(sample : sample + length(target_sound)-1, 1) + target_sound;
            
    end
    
    all_targets = find(targets);
    phase_bounds = cumsum(params.phases);
    for target_num = 1:length(all_targets)
        current_phase = 1;
        for b = 1:length(phase_bounds)-1
            
            if all_targets(target_num) > phase_bounds(b)*Fs
                current_phase = current_phase+1;
            end
        end
                
        cue_sample = all_targets(target_num) - max(floor((params.SDs(current_phase)*Fs*randn(1) + Fs*params.means(current_phase))),0);
        if cue_sample>0
            snd_total(cue_sample : cue_sample + length(cue_sound)-1, 1) = snd_total(cue_sample : cue_sample + length(cue_sound)-1, 1) + cue_sound;
            cues(cue_sample) = 1;
        end
    end
    
end

snd_total(:,2) = cumsum(cues) - cumsum(targets);

end