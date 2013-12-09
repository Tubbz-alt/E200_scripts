%% E200_tomographic_scan
%  Function to make a plot from data collected during a
%  tomographic scan.
%
%  cam_name: string; name of camera to use. Default is IP2A.
%  onoffline: string; whether running online (e.g. facet-srv)
%             or offline. Default is online.
%
%  tomo_proj: 2-D array of tomographically reconstructed phase-space
%
%  M.Litos 20131206
function [ tomo_proj, energy ] = E200_tomographic_scan( cam_name, onoffline )

% default camera: IP2A
if nargin<1
    cam_name = 'IP2A';
end

% define dataset
year  = 2013;
month = 11;
day   = 11;
datasetnum = 11524;

% get raw data from a tomographic scan
data = E200_easy_load_data(year,month,day,datasetnum);

% preprocess data
if nargin<2
    onoffline = 'online';
end
if strcmpi(onoffline,'offline')
    data = E200_preproc(data,cam_name,'read');
else
    data = E200_preproc_online(data,cam_name,'read');
end


    
% YAG energy calibration    
% yag_cal = data.raw.scalars.SIOC_SYS1_ML00_AO777; % GeV/mm
yag_cal = 20.35*0.01; % GeV/mm



% loop over steps in scan
nstep = data.raw.scalars.step_num.dat(end);
for istep=1:nstep
    
    disp('');
    disp('SCAN STEP NUMBER:');
    disp(istep);
    disp('');
            
    % get averaged projections
    [data, avg_proj_x, avg_proj_y] = E200_get_avg_proj(data,cam_name);
    
    % get tomographic projection slice
    tomo_proj(istep,:) = avg_proj_y;
    
    % get energy value for this step
    
    % central value on YAG in mm
    yag_mm(istep) = data.raw.scalars.step_value.dat{istep};

    % central energy for this step in GeV
    energy(istep) = yag_cal*yag_mm(istep);
    
end

% define energy axis
E_axis = [-1.35,-1.05,-0.75,-0.45,-0.15,+0.15,+0.45,+0.75];

% make plot
figure(1);
imagesc(tomo_proj);
cmap = custom_cmap();
colormap(cmap.mjet);
colorbar;
title('Longitudinal Phase Space');
xlabel('z');
ylabel('E');

output = 0;

end

