function A = get_asynchronies(tap, sync)

A = ones(size(sync)) * NaN;

thres = .2;
for i = 1:length(sync)
    sync_i = sync(i);
    tap_i = tap(tap > sync_i-thres & tap < sync_i + thres);

    if ~isempty(tap_i)
        A(i) = tap_i(1) - sync_i;
    end
    if length(tap_i)>1
        tap_i
        'double tap'
    end
end

end