%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FACET DAQ for 2014                                                      %
%                                                                         %
%                                                                         %
% S. Corde, S. Gessner, Z. Oven                                           %
% 3/13/14                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [epics_data, param] = FACET_DAQ_2014(arg_param)

% Test that we are on the right machine
[id,hostname] = system('hostname');
if ~strncmp(char(hostname),'facet-srv20', 11)
    error('FACET DAQ must be run from facet-srv20. You are on %s', hostname);
end

% Load DAQ parameters
if nargin>0; param = arg_param; else param = FACET_Param(); end;

disp(['Creating directory structure ' datestr(clock,'HH:MM:SS')]);
param = FACET_save_path(param);

disp(['Starting EPICS acquistion ' datestr(clock,'HH:MM:SS')]);
myeDefNumber = E200_startEPICS();

disp(['Starting Image acquistion ' datestr(clock,'HH:MM:SS')]);
param = AD_startImage(param);

disp(['Finished Image acquistion ' datestr(clock,'HH:MM:SS')]);
epics_data = E200_getEPICS(myeDefNumber);

disp(['Performing data quality check ' datestr(clock,'HH:MM:SS')]);
% do QC here