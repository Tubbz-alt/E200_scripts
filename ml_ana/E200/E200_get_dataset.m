%% E200_get_dataset
%  function to get the dataset number
%  format: 'string' --> return dataset number as string
%          'num'    --> return dataset number as a number (default)
function [ dataset ] = E200_get_dataset( data, format )

if nargin<2
    format='num';
end

% read in date from filename
filename = data.VersionInfo.originalfilename;

% tokenize it

% experiment name
[exp filename] = strtok(filename,'_');
% dataset number
[dataset filename] = strtok(filename(2:end),'_');
% year
[year filename] = strtok(filename(2:end),'-');
% month
[month filename] = strtok(filename(2:end),'-');
% day
[day filename] = strtok(filename(2:end),'-');
% hour
[hour filename] = strtok(filename(2:end),'-');
% minute
[min filename] = strtok(filename(2:end),'-');
% second
[sec filename] = strtok(filename(2:end),'-');

if ~strcmpi(format,'string')
    dataset = str2num(dataset);
end
    
end

