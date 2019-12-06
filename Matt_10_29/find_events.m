
event2 = [];
i = 2;
counter = 0;
look_ahead = 10;
jump_ahead = 100;
while i < size(EEG.data, 2)-look_ahead
    if EEG.data(41, i)-EEG.data(41, i-1)>500
        counter = counter+1;
        event2(end+1).latency = i;
        event2(end).duration = 0;
        event2(end).chanindex = 0;
        event2(end).urevent = counter;
        if counter==1022
            'hi'
        end
        if EEG.data(41, i+look_ahead)<EEG.data(41, i-look_ahead)
            event2(end).type = 0;
        else
            event2(end).type = params.end_code;
            length(event2)

        end
        i = i+jump_ahead;
    end
    i = i+1;
end

%%
event_count = 0;

for i = 1:length(all_blocks_shuffled)
    block = all_blocks_shuffled{i};
    type = block.type;
    for j = 1:length(block.code)
        event_count = event_count+1;
        event2(event_count).type = block.code(j);
    end
    event_count = event_count+1
    if event2(event_count).type ~= params.end_code
        event2(event_count).type
        "bad"
    end
    
end
        

            