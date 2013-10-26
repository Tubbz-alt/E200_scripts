%% easy_load_data
%  Loads an E200 dataset using E200_load_data, 
%  but with easier arguments.
% 
% M.Litos Oct.25,2013
function [ data ] = easy_load_data(year,month,day,datasetnum)


%% load the data

%-------------------
% default arguments

% June 29 two-bunch PWFA data: 11330
% Note: Odd shots are laser-on, even shots are laser-off
if nargin<1
    year       = 2013;
end
if nargin<2
    month      = 6;
end
if nargin<3
    day        = 29;
end
if nargin<4
    datasetnum = 11330;
end

% convert to strings
year=num2str(year);
month=num2str(month,'%02.f');
day=num2str(day,'%02.f');
experiment = 'E200';

% define the path components
nas_path   = 'nas/nas-li20-pm01/';
ymd        = [year month day];
dataset    = [experiment '_' num2str(datasetnum)];
% define the full path filename
full_filename  = fullfile(nas_path,experiment,year,ymd,dataset);

% load the data
data = E200_load_data(full_filename);
    
end