
out = readtable('~/Documents/R/JC_pilot_x.xlsx');
r_num = size(out,1);
all_response_times = {};
all_click_times = {};
metronome_data = [];
jitter_data = metronome_data;
ps_data = metronome_data;

for i = 1:r_num
    tok = regexp(out.key_resp_2_rt{i},'(\d*.\d*),', 'tokens')
    last_tok = regexp(out.key_resp_2_rt{i},'(\d*.\d*)]', 'tokens')
    if ~isempty(last_tok)
        response_times = [];
        for j = 1:length(tok)
            response_times(end+1) = str2num(tok{j}{1});
        end
        response_times(end+1) = str2num(last_tok{1}{1});
        all_response_times{end+1} = response_times;

    
%     tok = regexp(out.click_times{i},'(\d*.\d*),', 'tokens')
%     last_tok = regexp(out.click_times{i},'(\d*.\d*)]', 'tokens')
%     click_times = [];
%     for j = 1:length(tok)
%         click_times(end+1) = str2num(tok{j}{1});
%     end
%     click_times(end+1) = str2num(last_tok{1}{1});
%     all_click_times{end+1} = click_times;
    end

    if strcmp(out.task, 'metronome') | strcmp(out.task, 'jitter') | strcmp(out.task, 'ps')
        relevant_responses = response_times(1:(length(click_times)-2));
        As = relevant_responses(2:end) - click_times(4:end);
        R = diff(relevant_responses);
        [alphas,st,sm]=bGLS_phase_model_single_and_multiperson(R,As,mean(As),mean(R));
        if strcmp(out.task, 'metronome')
            metronome_data(end+1, :) = [alphas,st,sm];
        elseif strcmp(out.task, 'jitter')
            jitter_data(end+1, :) = [alphas,st,sm];
        elseif strcmp(out.task, 'ps')
            ps_data(end+1, :) = [alphas,st,sm];
        end
    end
end
