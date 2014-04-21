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
            
            % X-Axis is energy axis
            % but I will call it 'y' in math below
            % NOTE: pixel 1 is lowest energy,
            % pixel 2559 is highest energy
            % calibration: 19.531um/px
            cal = data.raw.images.(cam_name).RESOLUTION(1)/1000; % mm/px
            
            % for all energies...
            % y = y_inf - eta*E0/E

            % for E = E0+dE...
            % y = y_inf - eta*E0/(E0+dE)
            %   = y_inf - eta*E0/(E0(1+dE/E0))
            %   = y_inf - eta/(1+dE/E0)
            %   = y_inf - eta(1-dE/E0)
            %   = y_inf - eta + eta*(dE/E0)            
            %   = y0 + eta*(dE/E0)
            %  -> y_inf = y0 + eta

            % E = E0*eta/(y_inf-y)
            
            % get pixel array
            y_px = [1:size_x];
            
            % known values:

            % nominal energy
            E0 = 20.35; % GeV
            
            % nominal y location for E0
            dataset = E200_get_dataset(data);
            if dataset==11327 % QS = 0
                y0 = 1910.64; % px
            elseif dataset==11330 % QS = +2
                y0 = 1924.94; % px
            elseif dataset==11328 % QS = +2
                y0 = 1925.82; % px
            else
                y0 = 1910.64; % px (NOT ACCURATE, BUT CLOSE)
            end
            
            % Spencer's dispersion value
            % from CMOS calibration file
            % cmos_cal_20130629
            % eta = 60.90mm
%             eta = 60.90/cal; % px -> 3118
            
            % Clayton's dispersion value
            % positive, sice +E is toward +y
            % eta = 56.05mm
            eta = 56.05/cal; % px -> 2877

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % FOR ERROR ESTIMATION
            %
            % eta = 1.01*eta;
            % eta = 0.99*eta;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            % calculated values:
            
            % initial guess of a from estimated dispersion
            fudge = 0; % px; fudge factor to get the true y0 right
            y_inf = (y0+fudge) + eta; % px -> 4788
            
            % energy as a function of y
            E_GeV = E0*eta./(y_inf-y_px);
            
        elseif strcmpi(cam_name,'CEGAIN') || strcmpi(cam_name,'CELOSS')
            
            % Mike's hand calculation->
%             y_px = [1:size_y];
%             E_GeV = 27289./(y_px+251);
            
            B5D36  = getB5D36(data.raw.metadata.E200_state);
            % high res energy cal. from function
            [E_GeV Eres Dy] = E200_cher_get_E_axis('20130423', ...
                cam_name, 0, 1:1392, 0, B5D36);
            %         % low res energy cal. from function (faster)
            %         E_GeV = E200_cher_get_E_axis('20130423', cam_name, 0, ...
            %                           1:1392, 0, B5D36);
        elseif strcmpi(cam_name,'ELANEX')
            % use quadratic fit made from Chris Clayton's LUT
            y_px = [1:size_y];
            E_GeV = (1.047E-6)*(y_px.^2)-0.005824*y_px+24.83;
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

