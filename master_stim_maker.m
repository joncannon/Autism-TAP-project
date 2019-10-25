function snd_total=master_stim_maker(filename, intervals, identities, params)

% interval = vector

snd_total=[];

Fs = params.Fs;
tick = params.tick;
tick_samples = size(tick,1);

if isfield(params, 'deviant')
    deviant = params.deviant;
else
    deviant = zeros(10,1);
end
deviant_samples = size(deviant,1);

if isfield(params, 'target')
    target = params.target;
else
    target = zeros(10,1);
end
target_samples = size(target,1);

for i=1:length(intervals)
    metroperiod = intervals(i);
    snd = zeros(floor(Fs * metroperiod),2);
    
    if identities(i) == 2
        snd(1:target_samples,1) = target;
        
    elseif identities(i) == 1
        snd(1:deviant_samples,1) = deviant;
        
    else
        snd(1: tick_samples, 1) = tick;
        
    end
    
    snd(1:1000, 2)=1;
    %x_beep = 1:(metroduration * Fs);
    %beep = sin(x_beep * 2*pi * tonefreq / Fs);
    %snd(Fs * (i-1) * metroperiod + 1: Fs * (i-1) * metroperiod + metroduration * Fs, 1) = beep;
    
    snd_total=vertcat(snd_total,snd);

end

audiowrite(strcat(filename, '.wav'),snd_total,Fs);
