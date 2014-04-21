%% E200_get_full_filename
%  Gets the full filename as it would be used
%  with the E200_load_data script.
% 
% M.Litos Feb.12,2014
function [ full_filename ] = E200_get_full_filename( data )

% get date
year  = E200_get_date(data,'year');
ymd   = E200_get_date(data,'ymd');

% get dataset
experiment = 'E200';
datasetnum = E200_get_dataset(data,'string');
dataset    = [experiment '_' datasetnum];

% define the path components
nas_path   = 'nas/nas-li20-pm01/';

% define the full path filename
full_filename  = fullfile(nas_path,experiment,year,ymd,dataset);

end

