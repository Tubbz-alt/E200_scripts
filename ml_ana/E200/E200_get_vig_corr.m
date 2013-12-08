%% E200_get_vig_corr
%  Function to retrive vignetting correction matrix
%  for CEGAIN or CELOSS. The matrix can then be multiplied
%  with the original image from the camera to correct for 
%  the vignetting.
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
function [ data, vig_corr, vig_corr_x, vig_corr_y ] = ...
    E200_get_vig_corr( data, cam_name, readwrite )

% default: don't save to remote disk
if nargin<3
    readwrite='read';
end

%% check if values already exists in the data struct
in_data=false;
if isfield(data.processed.vectors,cam_name)
    if isfield(data.processed.vectors.(cam_name),'preproc')
        if isfield(data.processed.vectors.(cam_name).preproc,'vig_corr_x') && ...
                isfield(data.processed.vectors.(cam_name).preproc,'vig_corr_y') && ...
                isfield(data.processed.vectors.(cam_name).preproc,'vig_corr')
            in_data=true;
            
            vig_corr_x = cell2mat(data.processed.vectors.(cam_name).preproc.vig_corr_x.dat(1));
            vig_corr_y = cell2mat(data.processed.vectors.(cam_name).preproc.vig_corr_y.dat(1));
            vig_corr   = cell2mat(data.processed.vectors.(cam_name).preproc.vig_corr.dat(1));
            
        end
    end
end

%% create vignetting correction
if ~(in_data) || strcmpi(readwrite,'overwrite')
    % get full size
    size_x = data.raw.images.(cam_name).ROI_XNP(1);
    size_y = data.raw.images.(cam_name).ROI_YNP(1);
    % check date
    ymd = E200_get_date(data,'ymd');
    
    % --------------------------------
    % FACET User Run 2 end: 2013/07/04
    if str2double(ymd)<=20130704
        % get x-axis vignetting correction
        if strcmpi(cam_name,'CEGAIN') || strcmpi(cam_name,'CELOSS')
            vig_data = load(['VIG_1D_' cam_name '_20130629']);
            % NOTE: vig_data.YI goes along nominal x-axis of camera
            vig_corr_x = max(vig_data.YI)./vig_data.YI;
        else
            vig_corr_x = ones(1,size_x);
        end
        % no y-axis vignetting correction
        vig_corr_y = ones(1,size_y);
        
    % --------------------------------
    % default: 1
    else
        vig_corr_x = ones(1,size_x);
        vig_corr_y = ones(1,size_y);
     end

    % make full matrix using x-axis vignetting correction
    vig_corr   = repmat(vig_corr_x,size_y,1);
    
    %% add to data struct
    data = E200_add_proc_vector(data,cam_name,'preproc',1,1,...
        vig_corr_x,'vig_corr_x','',...
        'Vignetting correction factor along x.');
    data = E200_add_proc_vector(data,cam_name,'preproc',1,1,...
        vig_corr_x,'vig_corr_y','',...
        'Vignetting correction factor along y.');
    data = E200_add_proc_vector(data,cam_name,'preproc',1,1,...
        vig_corr,'vig_corr','',...
        'Vignetting correction factor matrix.');
end

%% save data struct to disk
if  strcmpi(readwrite,'overwrite') || ...
   (strcmpi(readwrite,'write') && ~(in_data))
    E200_save_remote(data);
end

end

