%% E200_get_Ecal
%  retrieve Energy calibrated axes for cameras
%  and add to the main data struct
%
%  inputs-->
%  data     : main data struct from E200_load_data
%  save     : boolean value to save to remote disk or not
%
function [ data ] = E200_get_Ecal( data, cam_name, save )

% default: don't save to remote disk
if nargin<2
    save=false;
end

% check if energy calibration already exists
skip=false;
if isfield(data.processed.vectors,cam_name)
    if isfield(data.processed.vectors.(cam_name),'E_GeV')
        skip=true;
    end
end

% get energy calibration
if ~(skip) || (save)
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
        E_GeV = zeros(data.raw.images.(cam_name).ROI_XNP(1));
        disp('E200_get_Ecal: WARNING: No energy calibration found.');
    end                
    % save to main data struct
    data.processed.vectors.(cam_name).E_GeV = E_GeV;    
end

% save E_GeV vectors to disk
if (save)
    E200_save_remote(data);
end

end

