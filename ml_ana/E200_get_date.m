%% E200_get_date
%  function to get the date in various formats from
%  the main data struct. Returns a string value.
function [ data_date ] = E200_get_date( data, format )

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

if strcmpi(format,'year')
    data_date = year;
elseif strcmpi(format,'month')
    data_date = year;
elseif strcmpi(format,'day')
    data_date = year;
elseif strcmpi(format,'ymd')
    data_date = [year month day];
elseif strcmpi(format,'time')
    data_date = [hour ':' min ':' sec];
else
    data_date = [year month day hour min sec];
end

end

