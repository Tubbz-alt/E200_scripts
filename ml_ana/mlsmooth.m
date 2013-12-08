%% Mike's profile smoothing function

function [ smprof ] = mlsmooth( prof )

smsize=9;
hsmsize=floor(smsize/2);

smprof = zeros(1,length(prof));

smprof(1:hsmsize) = prof(1:hsmsize);
for i=hsmsize+1:length(prof)-hsmsize
    smprof(i) = mean(prof(i-hsmsize:i+hsmsize));
end
smprof(end-hsmsize+1:end) = prof(end-hsmsize+1:end);

end

