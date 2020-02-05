function A = get_asynchronies(tap, sync)

A = ones(size(sync)) * NaN;

thres = 1;
for i = 1:length(sync)
    sync_i = sync(i);
    tap_i = tap(tap > sync_i-thres & tap < sync_i + thres);
%     if i < length(sync)
%         tap_i = tap_i(tap_i < sync(i + 1));
%     end
    if ~isempty(tap_i)
        A(i) = tap_i(1) - sync_i;
    end
    if length(tap_i)>1
        'double tap'
    end
end

end