%% E200_add_proc_vector
%  Function to add a processed vector to the main data struct
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
%  step_num: integer; step number of scan (optional)
%
%  Final data structure format:
%  data.processed.vectors.cam_name.ana_name.dat_name.[UID, dat, units,
%  description, step_num]
%
% M.Litos 11/4/2013
function [ data ] = E200_add_proc_vector(data,cam_name,ana_name,ishot,uid,...
                                         dat,dat_name,units,desc,step_num)
                                     
data.processed.vectors.(cam_name).(ana_name).(dat_name).UID(ishot)         = uid;
if length(dat)>1 || ischar(dat) % if dat is array
    data.processed.vectors.(cam_name).(ana_name).(dat_name).dat{ishot}     = dat;
elseif length(dat)==1 % if dat is single scalar
    data.processed.vectors.(cam_name).(ana_name).(dat_name).dat(ishot)     = dat;
else % if dat is empty
    data.processed.vectors.(cam_name).(ana_name).(dat_name).dat(ishot)     = 0;
end
data.processed.vectors.(cam_name).(ana_name).(dat_name).units{ishot}       = units;
data.processed.vectors.(cam_name).(ana_name).(dat_name).description{ishot} = desc;

if nargin<10
    step_num=1;
end
data.processed.vectors.(cam_name).(ana_name).(dat_name).step_num(ishot)    = step_num;

end

