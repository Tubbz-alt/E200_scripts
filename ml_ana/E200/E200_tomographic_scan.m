%% E200_tomographic_scan
%  Function to make a plot from data collected during a
%  tomographic scan.
%
%  M.Litos 20131206
function [ tomo_proj ] = E200_tomographic_scan( )

% loop over datasets
year  = 2013;
month = 11;
day   = 11;
datasetlist = [11524:11529,11532:11534]; % list of datasets
% datasetlist = [11524];

% get cell array of preprocessed datasets if not given
nfile=length(datasetlist);
for ifile=1:nfile
    
    disp('');
    disp('DATESET:');
    disp(datasetlist(ifile));
    disp('');
    
    % get raw data
    data = E200_easy_load_data(year,month,day,datasetlist(ifile));
    
    % preprocess data
    data = E200_preproc(data,'IP2A','read');
        
    % get averaged projections
    [data, avg_proj_x, avg_proj_y] = E200_get_avg_proj(data,'IP2A');
    
    % get tomographic projection slice
    tomo_proj(ifile,:) = cell2mat(data.processed.vectors.IP2A.tomo.avg_proj_y.dat);
    
end

E_axis = [-1.35,-1.05,-0.75,-0.45,-0.15,+0.15,+0.45,+0.75];

% make plot
figure(1);
imagesc(tomo_proj);
cmap = custom_cmap();
colormap(cmap.mjet);
colorbar;
title('Longitudinal Phase Space');
xlabel('z');
ylabel('E');

output = 0;

end

