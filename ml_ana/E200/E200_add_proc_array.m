%% E200_add_proc_array
%  Function to add a processed array to the main data struct
%  in a format condusive to being saved to the remote disk.
%
%  data: struct; main data struct from E200_load_data
%  cam_name: string; name of camera
%  ana_name: string; name of analysis
%  ishot: integer; shot or element number of the struct
%  uid: integer; UID of the shot
%  dat: whatever; the data being stored
%  dat_name: string; the name of the data being stored
%  units: string; units of the data being stored
%  desc: string; description of the data being stored
%
%  Final data structure format:
%  data.processed.arrays.cam_name.ana_name.dat_name.[UID, dat, units,
%  description]
%
% M.Litos 11/4/2013
function [ data ] = E200_add_proc_array(data,cam_name,ana_name,ishot,uid,...
                                         dat,dat_name,units,desc)

data.processed.arrays.(cam_name).(ana_name).(dat_name).UID(ishot)         = uid;
if length(dat)>1 || ischar(dat)
    data.processed.arrays.(cam_name).(ana_name).(dat_name).dat{ishot}     = dat;
else
    data.processed.arrays.(cam_name).(ana_name).(dat_name).dat(ishot)     = dat;
end    
data.processed.arrays.(cam_name).(ana_name).(dat_name).units{ishot}       = units;
data.processed.arrays.(cam_name).(ana_name).(dat_name).description{ishot} = desc;

end

