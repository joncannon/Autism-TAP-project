function block=stim_maker_general(varargin)

p = inputParser;
addParameter(p,'filename','nofile',@isstring);
addParameter(p,'mode','metronome',@isstring);
addParameter(p,'period',.5,@isnumeric);
addParameter(p,'n_events',20,@isnumeric);
addParameter(p,'jitter',0,@isnumeric);
addParameter(p,'deviant_rate',0,@isnumeric);
addParameter(p,'end_target',true,@islogical);
addParameter(p,'id_tag',0,@isnumeric);
addParameter(p,'lead_in',3,@isnumeric);
addParameter(p,'allowable_distance',3,@isnumeric);
addParameter(p,'target_delay',2,@isnumeric);
addParameter(p,'event_type',0, @isnumeric);

addParameter(p,'params',default_params(),@isstruct);

parse(p,varargin{:});

params = p.Results.params;

event_type = p.Results.event_type;
period = p.Results.period;
deviant_rate = p.Results.deviant_rate;
n_events = p.Results.n_events;
jitter = p.Results.jitter;
id_tag = p.Results.id_tag;

if event_type == 0
    event_type = params.standard_index;
end

n_conditions = max([length(n_events), length(period), length(deviant_rate), length(event_type), length(jitter)]);

if length(n_events)==1
    n_events = repmat(n_events, [1,n_conditions]);
elseif length(n_events)~=n_conditions
    error('n_events is not an acceptable length');
end

if length(id_tag)==1
    id_tag = repmat(id_tag, [1,n_conditions]);
elseif length(id_tag)~=n_conditions
    error('id_tag is not an acceptable length');
end

if length(period)==1
    period = repmat(period, [1,n_conditions]);
elseif length(period)~=n_conditions
    error('periods is not an acceptable length');
end

if length(deviant_rate)==1
    deviant_rate = repmat(deviant_rate, [1,n_conditions]);
elseif length(deviant_rate)~=n_conditions
    error('deviant_rate is not an acceptable length');
end

if length(event_type)==1
    event_type = repmat(event_type, [1,n_conditions]);
elseif length(event_type)~=n_conditions
    error('event_type is not an acceptable length');
end

if length(jitter)==1
    jitter = repmat(jitter, [1,n_conditions]);
elseif length(jitter)~=n_conditions
    error('jitter is not an acceptable length');
end


identities = [];
intervals = [];
code = [];

counter = 0;

for j=1:length(period)
    event_count = 0;
    for i=1:n_events(j)
        event_count = event_count+1;
        intervals(end+1) = period(j) + jitter(j)*(rand()*2 - 1);
        if (rand()>deviant_rate(j) || i<=p.Results.lead_in || counter>0)
            identities(end+1) = event_type(j);
            counter = counter-1;
        else
            identities(end+1) = params.deviant_index;
            counter = p.Results.allowable_distance;
        end 
        code(end+1) = identities(end) + 100*id_tag(j);
    end
end  
  


if p.Results.end_target
    intervals(end) = p.Results.target_delay*period(end);
    intervals(end+1) = .1;
    identities(end+1) = params.target_index;
end

block = struct();

block.sound=master_stim_maker(p.Results.filename, intervals, identities, params);
block.params = params;
block.code = code;
block.id_tag = id_tag;
block.intervals = intervals;
block.identities = identities;
block.period = period;

if params.save_separate
    save(strcat(filename, '.mat'),'block');
end
