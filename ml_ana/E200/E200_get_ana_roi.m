%% E200_get_ana_roi
%  Function to generic analysis ROI values for any camera.
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
%  NOTE: full size for UNIQ: 1040x1392
%  NOTE: full size for CMOS: 2159x2559
%
% M.Litos 11/4/2013
function [ data, ana_roi_x, ana_roi_y ] = ...
    E200_get_ana_roi( data, cam_name, readwrite )

% default: don't save to remote disk
if nargin<3
    readwrite='read';
end

%% check if values already exist in the data struct
in_data=false;
if isfield(data.processed.vectors,cam_name)
    if isfield(data.processed.vectors.(cam_name),'preproc')
        if isfield(data.processed.vectors.(cam_name).preproc,'ana_roi_x') && ...
                isfield(data.processed.vectors.(cam_name).preproc,'ana_roi_y')
            in_data=true;
            
            ana_roi_x = cell2mat(data.processed.vectors.(cam_name).preproc.ana_roi_x.dat(1));
            ana_roi_y = cell2mat(data.processed.vectors.(cam_name).preproc.ana_roi_y.dat(1));
            
        end
    end    
end

%% create analysis ROIs
if ~(in_data) || strcmpi(readwrite,'overwrite')
    % get full size
    size_x = data.raw.images.(cam_name).ROI_XNP(1);
    size_y = data.raw.images.(cam_name).ROI_YNP(1);
    % check date
    ymd = E200_get_date(data,'ymd');
    
    % --------------------------------
    % FACET User Run 2 end: 2013/07/04
    if str2double(ymd)<=20130704
        if strcmpi(cam_name,'CEGAIN')
            ana_roi_x = [  51  550];
            ana_roi_y = [  51  750];
        elseif strcmpi(cam_name,'CELOSS')
            ana_roi_x = [ 601 1392];
            ana_roi_y = [ 101  800];
        elseif strcmpi(cam_name,'CMOS')
            ana_roi_x = [1001 2400];
%             ana_roi_y = [ 821 1330];
            ana_roi_y = [ 821 1326];
        elseif strcmpi(cam_name,'ELANEX')
            ana_roi_x = [  51 1392];
%             ana_roi_y = [   1 1040];
            ana_roi_y = [ 241 1040];
        else
            ana_roi_x = [1 size_x];
            ana_roi_y = [1 size_y];
        end
        
%     % --------------------------------
%     % FACET User Run 3
%     % Nov. 11, 2013 - long. tomography scan
%     elseif str2double(ymd)==20131111
%         if strcmpi(cam_name,'IP2A')
%             ana_roi_x = [  51  550];
%             ana_roi_y = [  51  751];
%         else
%             ana_roi_x = [1 size_x];
%             ana_roi_y = [1 size_y];
%         end
        
    % --------------------------------
    % default: full size
    else
        ana_roi_x = [1 size_x];
        ana_roi_y = [1 size_y];
    end
    
    %% add to data struct
    data = E200_add_proc_vector(data,cam_name,'preproc',1,1,...
        ana_roi_x,'ana_roi_x','',...
        'Analysis ROI along x.');
    data = E200_add_proc_vector(data,cam_name,'preproc',1,1,...
        ana_roi_y,'ana_roi_y','',...
        'Analysis ROI along y.');
end

%% save data struct to disk
if  strcmpi(readwrite,'overwrite') || ...
   (strcmpi(readwrite,'write') && ~(in_data))
    E200_save_remote(data);
end

end

