
out = readtable('~/Documents/MATLAB/Entrainment-Contingency/Data/Jon-tap-new-12-22/jc_tap-new_2020_Dec_23_1602.csv');
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
phase_data = metronome_data;
event_data = metronome_data;

all_data = {metronome_data, jitter_data, drift_data, phase_data, event_data};

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
    if length(response_times)>length(click_times)-2
        relevant_responses = response_times(1:(length(click_times)-2));
        relevant_clicks = click_times(4:end);
    else
        relevant_responses = response_times;
        relevant_clicks = click_times(4:length(response_times)+2);
    end
        As = relevant_responses(2:end) - relevant_clicks;
        R = diff(relevant_responses);
        [alphas,st,sm]=bGLS_phase_model_single_and_multiperson(R',As',mean(As),mean(R));
    
        struct_index = 0;
        if strcmpi(out.task{i}, 'metronome')
            struct_index = 1;
            
        elseif strcmpi(out.task{i}, 'jitter')
            struct_index = 2;

        elseif strcmpi(out.task{i}, 'drift')
            struct_index = 3;
        elseif strcmpi(out.task{i}, 'phase')
            struct_index = 4;
        elseif strcmpi(out.task{i}, 'event')
            struct_index = 5;
        end
        
        if struct_index>0
            all_data{struct_index}.alpha(end+1) = alphas;
            all_data{struct_index}.st(end+1) = st;
            all_data{struct_index}.sm(end+1) = sm;
            all_data{struct_index}.As{end+1} = As;
            all_data{struct_index}.R{end+1} = R;
        end
    end


