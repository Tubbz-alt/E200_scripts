%% E200_get_Qcal
%  Function to get pixel count to charge calibration.
%
%  inputs-->
%  data      : struct; main data struct from E200_load_data
%  cam_name  : string; name of camera
%  readwrite : string;
%              'read'  - only read from disk, create from scratch
%                        if not on disk, but don't write to disk
%              'write' - read from disk if there, create from
%                        scratch and save to disk if not
%              'overwrite' - create from scratch and save to disk,
%                        saving over previous value if there
%
% M.Litos 11/4/2013
function [ data, cnt2e, cnt2nC ] = ...
    E200_get_Qcal( data, cam_name, readwrite )

% default: don't save to remote disk
if nargin<3
    readwrite='read';
end

% check if values already exist in the data struct
in_data=false;
if isfield(data.processed.vectors,cam_name)
    if isfield(data.processed.vectors.(cam_name),'preproc')
        if isfield(data.processed.vectors.(cam_name).preproc,'cnt2e') && ...
                isfield(data.processed.vectors.(cam_name).preproc,'cnt2nC')
            in_data=true;
            
            cnt2e  = data.processed.vectors.(cam_name).preproc.cnt2e.dat(1);
            cnt2nC = data.processed.vectors.(cam_name).preproc.cnt2nC.dat(1);
            
        end
    end
end

% create energy calibration
if ~(in_data) || strcmpi(readwrite,'overwrite')
    % charge of electron in nC
    qenC = (1.602e-19)/(1.0e-9);
    % check date
    ymd = E200_get_date(data,'ymd');
    
    % FACET User Run 2 end: 2013/07/04
    if str2double(ymd)<=20130704
        if strcmpi(cam_name,'CEGAIN')
            cnt2e = 1./(2.1913e-03); % for 6/29/2013
        elseif strcmpi(cam_name,'CELOSS')            
            cnt2e = 1./(2.6654e-03); % for 6/29/2013
        elseif strcmpi(cam_name,'CMOS')
            cnt2e = 1;
    % default: 1
    else
        cnt2e = 1;
    end
    
    % calculate charge conversion in nC
    cnt2nC = qenC*cnt2e;
    
    % add to data struct
    data = E200_add_proc_vector(data,cam_name,'preproc',1,1,...
        cnt2e,'cnt2e','electrons',...
        'Calibration factor for electrons per camera pixel count.');
    data = E200_add_proc_vector(data,cam_name,'preproc',1,1,...
        cnt2nC,'cnt2nC','nC',...
        'Calibration factor for nC per camera pixel count.');
end

% save data struct to disk
if  strcmpi(readwrite,'overwrite') || ...
   (strcmpi(readwrite,'write') && ~(in_data))
    E200_save_remote(data);
end

end

