function param = AD_startImage(param)

camPVs = param.cams;

use_cs01 = logical(sum(param.is_CS01));
use_cs02 = logical(sum(param.is_CS02));
use_cs03 = logical(sum(param.is_CS03));
use_pm20 = logical(sum(param.is_PM20));
use_pm21 = logical(sum(param.is_PM21));

evrPVs = {};
if use_cs01; evrPVs = [evrPVs; 'EVR:LI20:CS01']; end;
if use_cs02; evrPVs = [evrPVs; 'EVR:LI20:CS02']; end;
if use_cs03; evrPVs = [evrPVs; 'EVR:LI20:CS03']; end;
if use_pm20; evrPVs = [evrPVs; 'EVR:LI20:PM20']; end;
if use_pm21; evrPVs = [evrPVs; 'EVR:LI20:PM21']; end;

num_cam = numel(camPVs);
num_evr = numel(evrPVs);
% NOTE: All file prefixes should be same length
filePrefix = param.names;
data_path = '/nas/nas-li20-pm01/daq_testing/';
file_format = '%s%s_%4.4d.tif';
file_number = 0;
n_shots = param.nShots;

data_string = '_data';

for i=1:num_cam
    cam_Acq{i,1}                = [char(camPVs(i)), ':Acquisition'];
    cam_ImageMode{i,1}          = [char(camPVs(i)), ':ImageMode'];
    cam_NumImages{i,1}          = [char(camPVs(i)), ':NumImages'];
    cam_TiffCallbacks{i,1}      = [char(camPVs(i)), ':TIFF:EnableCallbacks'];
    cam_TiffAutoSave{i,1}       = [char(camPVs(i)), ':TIFF:AutoSave'];
    cam_TiffFilePath{i,1}       = [char(camPVs(i)), ':TIFF:FilePath'];
    cam_TiffFileFormat{i,1}     = [char(camPVs(i)), ':TIFF:FileTemplate'];
    cam_TiffFileNumber{i,1}     = [char(camPVs(i)), ':TIFF:FileNumber'];
    cam_TiffFilePathExists{i,1} = [char(camPVs(i)), ':TIFF:FilePathExists_RBV'];
    cam_TiffFileName{i,1}       = [char(camPVs(i)), ':TIFF:FileName'];
    cam_DetectorState{i,1}      = [char(camPVs(i)), ':DetectorState_RBV'];
end

for i=1:num_evr
    evr_Event1CtrlOut0{i,1} = [char(evrPVs(i)),':EVENT1CTRL.OUT0'];
    evr_Event1CtrlOut1{i,1} = [char(evrPVs(i)),':EVENT1CTRL.OUT1'];
    evr_Event1CtrlOut2{i,1} = [char(evrPVs(i)),':EVENT1CTRL.OUT2'];
    evr_Event1CtrlIRQ{i,1}  = [char(evrPVs(i)),':EVENT1CTRL.VME'];
end

% Check if there is proper delimiter at the end of data path
if (data_path(end) ~= '/')
    delimiter = '/';
else
    delimiter = '';    
end

% Stop image acquisiton before any changes
lcaPutNoWait(cam_Acq, 'Idle');

% Disable EVR triggering
lcaPut(evr_Event1CtrlOut0, 'Disabled');
lcaPut(evr_Event1CtrlOut1, 'Disabled');
lcaPut(evr_Event1CtrlOut2, 'Disabled');

% Set filepath format
ff = zeros(1,256);
formatASCII = double(file_format);
n_el = length(formatASCII);
ff(1:n_el) = formatASCII;
lcaPut(cam_TiffFileFormat, ff);

% Set filepath for saved data (path must already exist)
for i=1:numel(filePrefix)
    
    fp = zeros(1,256);
    path = param.cam_path{i};
    if ~exist(path,'dir')
        mkdir(path);
    end
    pathASCII = double(path);
    n_el = length(pathASCII);
    fp(1:n_el) = pathASCII;
    lcaPut(cam_TiffFilePath{i}, fp);
end

% Check that all paths exists
for i=1:num_cam
    ext = lcaGet(cam_TiffFilePathExists(i));
    if (~strcmp(ext,'Yes'))
      error(['File path: ' data_path ' does not exist.']);
    end
end

% Stop camera acquisition and triggering
lcaPutNoWait(cam_Acq, 'Idle');
lcaPut(evr_Event1CtrlOut0, 'Disabled');
lcaPut(evr_Event1CtrlOut1, 'Disabled');
lcaPut(evr_Event1CtrlOut2, 'Disabled');

% Set name for data images
for i=1:num_cam
    fn = zeros(1,256);
    filename = [filePrefix{i}, data_string];
    fileASCII = double(filename);
    n_el = length(fileASCII);
    fn(1:n_el) = fileASCII;
    lcaPut(cam_TiffFileName(i), fn);
end

% Set acquisition mode to Multiple, set number of images to acquire
lcaPut(cam_ImageMode, 'Multiple');
lcaPut(cam_NumImages, n_shots);
lcaPut(cam_TiffFileNumber,'0');
lcaPut(cam_TiffCallbacks, 'Enable');
lcaPut(cam_TiffAutoSave, 'Yes');
lcaPut(evr_Event1CtrlIRQ, 'Enabled');

% Start image acquisition
lcaPutNoWait(cam_Acq, 'Acquire');
lcaPut(evr_Event1CtrlOut0, 'Enabled');
lcaPut(evr_Event1CtrlOut1, 'Enabled');
lcaPut(evr_Event1CtrlOut2, 'Enabled');

pause(0.5);

% Wait until all cameras return to Idle state
lcaSetMonitor(cam_DetectorState);
lcaGet(cam_DetectorState);
for i=1:num_cam
    while 1
        if (lcaNewMonitorValue(cam_DetectorState(i)))
            t_var = lcaGet(cam_DetectorState(i));
            if (strcmp(t_var{1},'Idle'))
                break;
            end
        else
            pause(0.2);           
        end
    end
end
lcaClear(cam_DetectorState);
    
lcaPutNoWait(cam_Acq, 'Idle');
lcaPut(cam_TiffCallbacks, 'Disable');
lcaPut(cam_ImageMode, 'Continuous');
lcaPutNoWait(cam_Acq, 'Acquire');