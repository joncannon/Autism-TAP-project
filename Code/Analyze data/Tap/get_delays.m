function D = get_delays(tap, sync)

D = ones(size(sync)) * NaN;

thres = 1;
for i = 1:length(sync)
    sync_i = sync(i);
    tap_i = tap(tap > sync_i & tap < sync_i + thres);
%     if i < length(sync)
%         tap_i = tap_i(tap_i < sync(i + 1));
%     end
    if ~isempty(tap_i)
        D(i) = tap_i(1) - sync_i;
    end
    if length(tap_i)>1
        'double tap'
    end
end

end