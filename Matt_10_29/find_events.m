
event2 = [];
i = 1;
counter = 0;
look_ahead = 14;
jump_ahead = 25;
while i < size(EEG.data, 2)-look_ahead
    if EEG.data(end, i)<-1*10^5
        counter = counter+1;
        event2(end+1).latency = i;
        event2(end).duration = 0;
        event2(end).chanindex = 0;
        event2(end).urevent = counter;
        if EEG.data(end, i+look_ahead)>1*10^5
            event2(end).type = 1;
        else
            event2(end).type = 4;
        end
        i = i+jump_ahead;
    end
    i = i+1;
end

%%
event_count = 0;

for i = 1:length(listening_blocks_shuffled)
    block = listening_blocks_shuffled{i};
    type = block.key.type;
    for j = 1:length(block.key.code)
        event_count = event_count+1;
        event_code = block.key.code(j);
        if event_code == 1 && streq(block.key.type, 'omission')
            event2(event_count).type = 3;
        else
            event2(event_count).type = event_code;
        end
    end
    event_count = event_count+1;
    if event2(event_count).type == 4
        "ding"
    end
    
end
        

            