%% E200_get_Ecal
%  retrieve Energy calibrated axes for cameras
%  and add to the main data struct
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
function [ data, E_GeV, dE_GeV ] = ...
    E200_get_Ecal( data, cam_name, readwrite )

% default: don't save to remote disk
if nargin<3
    readwrite='read';
end

%% check if values already exist in the data struct
in_data=false;
if isfield(data.processed.vectors,cam_name)
    if isfield(data.processed.vectors.(cam_name),'preproc')
        if isfield(data.processed.vectors.(cam_name).preproc,'E_GeV') && ...
                isfield(data.processed.vectors.(cam_name).preproc,'dE_GeV')
            in_data=true;
        
            E_GeV  = cell2mat(data.processed.vectors.(cam_name).preproc.E_GeV.dat(1));
            dE_GeV = cell2mat(data.processed.vectors.(cam_name).preproc.dE_GeV.dat(1));

        end
    end
end

%% create energy calibration
if ~(in_data) || strcmpi(readwrite,'overwrite')
    % get full size
    size_x = data.raw.images.(cam_name).ROI_XNP(1);
    size_y = data.raw.images.(cam_name).ROI_YNP(1);
    % check date
    ymd = E200_get_date(data,'ymd');
    
    % --------------------------------
    % FACET User Run 2 end: 2013/07/04
    if str2double(ymd)<=20130704
        
        if strcmpi(cam_name,'CMOS')
            % get CMOS calibration info from file
            Ecal_data = load('cmos_cal_20130629');
            E_GeV = Ecal_data.cmos_axis_gev;
        elseif strcmpi(cam_name,'CEGAIN') || strcmpi(cam_name,'CELOSS')
            % energy setting of spect. dipole
            B5D36  = getB5D36(data.raw.metadata.E200_state);
            % high res energy cal. from function
            [E_GeV Eres Dy] = E200_cher_get_E_axis('20130423', ...
                cam_name, 0, 1:1392, 0, B5D36);
            %         % low res energy cal. from function (faster)
            %         E_GeV = E200_cher_get_E_axis('20130423', cam_name, 0, ...
            %                           1:1392, 0, B5D36);
        else
            E_GeV = zeros(1,size_x);
            disp('E200_get_Ecal: WARNING: No energy calibration found.');
        end
        
    % --------------------------------
    % default: 0
    else
        E_GeV = zeros(1,size_x);
        disp('E200_get_Ecal: WARNING: No energy calibration found.');
    end
    
    %% calculate deltaE of each pixel row
    % (works independent of date)
    dE_GeV = zeros(1,length(E_GeV));
    for i=2:length(E_GeV)-1
        dE_GeV(i) = (1/2)*abs(E_GeV(i+1)-E_GeV(i-1));
    end
    dE_GeV(1) = dE_GeV(2);
    dE_GeV(length(E_GeV)) = dE_GeV(length(E_GeV)-1);
        
    %% add to data struct
    data = E200_add_proc_vector(data,cam_name,'preproc',1,1,...
        E_GeV,'E_GeV','GeV',...
        'Energy value for each pixel row in GeV.');
    data = E200_add_proc_vector(data,cam_name,'preproc',1,1,...
        dE_GeV,'dE_GeV','GeV',...
        'Spread of energy for each pixel row in GeV.');
end

%% save data struct to disk
if  strcmpi(readwrite,'overwrite') || ...
   (strcmpi(readwrite,'write') && ~(in_data))
    E200_save_remote(data);
end

end

