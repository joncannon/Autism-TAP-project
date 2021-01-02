
out = readtable('~/Documents/MATLAB/Entrainment-Contingency/Data/Jon-tap-new-12-22/jjc_tap-new_2020_Dec_22_1154_1.csv');
r_num = size(out,1);
all_response_times = {};
all_click_times = {};
metronome_data = struct();
metronome_data.alpha = [];
metronome_data.st = [];
metronome_data.sm = [];
metronome_data.As = {};
metronome_data.R = {};
jitter_data = metronome_data;
drift_data = metronome_data;
click2 = struct()
click2.pos = {};
click2.neg = {};
click2.posAs = {};
click2.negAs = {};
click5 = click2;

for i = 1:r_num
    i
    tok = regexp(out.key_resp_2_rt{i},'(\d*.\d*),', 'tokens')
    last_tok = regexp(out.key_resp_2_rt{i},'(\d*.\d*)]', 'tokens')
    if ~isempty(last_tok)
        response_times = [];
        for j = 1:length(tok)
            response_times(end+1) = str2num(tok{j}{1});
        end
        response_times(end+1) = str2num(last_tok{1}{1});
        all_response_times{end+1} = response_times;

    
        tok = regexp(out.click_times{i},'(\d*.\d*),', 'tokens')
        last_tok = regexp(out.click_times{i},'(\d*.\d*)]', 'tokens')
        click_times = [];
        for j = 1:length(tok)
            click_times(end+1) = str2num(tok{j}{1});
        end
        click_times(end+1) = str2num(last_tok{1}{1});
        all_click_times{end+1} = click_times;
    end

    if strcmpi(out.task{i}, '2click')
        if out.shift(i)==66
            click2.pos{end+1} = response_times;
            'ding'
            click2.posAs{end+1} = response_times(1:(length(click_times) - 2)) - (1.3:.65:5)%click_times(3:end);
        else
            click2.neg{end+1} = response_times;
            click2.negAs{end+1} = response_times(1:(length(click_times) - 2)) - (1.3:.65:5)%click_times(3:end);
        end
    elseif strcmpi(out.task{i}, '5click')
        if out.shift(i)==66
            click5.pos{end+1} = response_times;
            click5.posAs{end+1} = response_times(1:(length(click_times) - 5)) - (3.25:.65:5)%click_times(6:end);
        else
            click5.neg{end+1} = response_times;
            click5.negAs{end+1} = response_times(1:(length(click_times) - 5)) - (3.25:.65:5)%click_times(6:end);
        end
        
    
    elseif strcmpi(out.task{i}, 'metronome') | strcmpi(out.task{i}, 'jitter') | strcmpi(out.task{i}, 'drift') | strcmpi(out.task{i}, 'drift')
        relevant_responses = response_times(1:(length(click_times)-2));
        As = relevant_responses(2:end) - click_times(4:end);
        R = diff(relevant_responses);
        [alphas,st,sm]=bGLS_phase_model_single_and_multiperson(R',As',mean(As),mean(R));
        if strcmpi(out.task{i}, 'metronome')
            metronome_data.alpha(end+1) = alphas;
            metronome_data.st(end+1) = st;
            metronome_data.sm(end+1) = sm;
            metronome_data.As{end+1} = As;
            metronome_data.R{end+1} = R;
        elseif strcmpi(out.task{i}, 'jitter')
            jitter_data.alpha(end+1) = alphas;
            jitter_data.st(end+1) = st;
            jitter_data.sm(end+1) = sm;
            jitter_data.As{end+1} = As;
            jitter_data.R{end+1} = R;
        elseif strcmpi(out.task{i}, 'drift')
            drift_data.alpha(end+1) = alphas;
            drift_data.st(end+1) = st;
            drift_data.sm(end+1) = sm;
            drift_data.As{end+1} = As;
            drift_data.R{end+1} = R;
        end
    end
end

click2.posAsmean = zeros(size(click2.posAs{1}));
click2.negAsmean = zeros(size(click2.posAs{1}));
click5.posAsmean = zeros(size(click5.posAs{1}));
click5.negAsmean = zeros(size(click5.posAs{1}));

for i = 1:length(click2.pos)
    click2.posAsmean = click2.posAsmean + click2.posAs{i}/length(click2.pos);
    click2.negAsmean = click2.negAsmean + click2.negAs{i}/length(click2.pos);
    click5.posAsmean = click5.posAsmean + click5.posAs{i}/length(click2.pos);
    click5.negAsmean = click5.negAsmean + click5.negAs{i}/length(click2.pos);
end
    
figure()
hold on
for i = 1:length(click2.pos)
    plot(click2.posAs{i}, 'bo-')
    plot(click2.negAs{i}, 'ro-')
    plot(4:6, click5.posAs{i}, 'ko-')
    plot(4:6, click5.negAs{i}, 'go-')
end

figure()
hold on
plot(click2.posAsmean, 'bo-')
    plot(click2.negAs{i}, 'ro-')
    plot(4:6, click5.posAsmean, 'ko-')
    plot(4:6, click5.negAsmean, 'go-')
    plot([1,6], [.040,.040], 'k')
    plot([1,6], -[.040,.040], 'k')


