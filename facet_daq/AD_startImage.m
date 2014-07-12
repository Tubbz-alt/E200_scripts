function param = AD_startImage(param,stepnum)

camPVs = param.cams;

use_cs01 = logical(sum(param.is_CS01));
use_cs02 = logical(sum(param.is_CS02));
use_cs03 = logical(sum(param.is_CS03));
use_cs04 = logical(sum(param.is_CS04));
use_pm20 = logical(sum(param.is_PM20));
use_pm21 = logical(sum(param.is_PM21));
use_pm22 = logical(sum(param.is_PM22));

evrPVs = {};
if use_cs01; evrPVs = [evrPVs; 'EVR:LI20:CS01']; end;
if use_cs02; evrPVs = [evrPVs; 'EVR:LI20:CS02']; end;
if use_cs03; evrPVs = [evrPVs; 'EVR:LI20:CS03']; end;
if use_cs04; evrPVs = [evrPVs; 'EVR:LI20:CS04']; end;
if use_pm20; evrPVs = [evrPVs; 'EVR:LI20:PM20']; end;
if use_pm21; evrPVs = [evrPVs; 'EVR:LI20:PM21']; end;
if use_pm22; evrPVs = [evrPVs; 'EVR:LI20:PM22']; end;

num_cam = numel(camPVs);
num_evr = numel(evrPVs);

filePrefix = param.names;
file_format = '%s%s_%4.4d.tif';

n_shots = param.n_shot;

data_string = ['_data_step' sprintf('%02d',stepnum)];

for i=1:num_cam
    cam_Acq{i,1}                = [char(camPVs(i)), ':Acquisition'];
    cam_ImageMode{i,1}          = [char(camPVs(i)), ':ImageMode'];
    cam_ImageModeRBV{i,1}       = [char(camPVs(i)), ':ImageMode_RBV'];
    cam_NumImages{i,1}          = [char(camPVs(i)), ':NumImages'];
    cam_NumImagesRBV{i,1}       = [char(camPVs(i)), ':NumImages_RBV'];
    cam_ImCountRBV{i,1}         = [char(camPVs(i)), ':NumImagesCounter_RBV'];
    cam_TiffCallbacks{i,1}      = [char(camPVs(i)), ':TIFF:EnableCallbacks'];
    cam_TiffAutoSave{i,1}       = [char(camPVs(i)), ':TIFF:AutoSave'];
    cam_TiffAutoIncrement{i,1}  = [char(camPVs(i)), ':TIFF:AutoIncrement'];
    cam_TiffFilePath{i,1}       = [char(camPVs(i)), ':TIFF:FilePath'];
    cam_TiffFileFormat{i,1}     = [char(camPVs(i)), ':TIFF:FileTemplate'];
    cam_TiffFileNumber{i,1}     = [char(camPVs(i)), ':TIFF:FileNumber'];
    cam_TiffFilePathExists{i,1} = [char(camPVs(i)), ':TIFF:FilePathExists_RBV'];
    cam_TiffFileName{i,1}       = [char(camPVs(i)), ':TIFF:FileName'];
    cam_DetectorState{i,1}      = [char(camPVs(i)), ':DetectorState_RBV'];
    cam_Connection{i,1}         = [char(camPVs(i)), ':AsynIO.CNCT'];
    cam_TSS_SETEC{i,1}          = [char(camPVs(i)), ':TSS_SETEC'];
end

for i=1:num_evr
    %evr_Event1CtrlENM{i,1}  = [char(evrPVs(i)),':EVENT1CTRL.ENM'];
    evr_Event1CtrlOut0{i,1} = [char(evrPVs(i)),':EVENT1CTRL.OUT0'];
    evr_Event1CtrlOut1{i,1} = [char(evrPVs(i)),':EVENT1CTRL.OUT1'];
    evr_Event1CtrlOut2{i,1} = [char(evrPVs(i)),':EVENT1CTRL.OUT2'];
    evrPV = evrPVs{i};
    if sum(strcmp(evrPV(10:13),{'CS01';'CS02';'CS03';'CS04'}))
        evr_Event1CtrlIRQ{i,1}  = [char(evrPVs(i)),':EVENT2CTRL.VME'];
        evr_Event1CtrlENM{i,1}  = [char(evrPVs(i)),':EVENT1CTRL.ENM'];
        evr_Event2CtrlENM{i,1}  = [char(evrPVs(i)),':EVENT2CTRL.ENM'];
        if param.event_code == 233
            lcaPut(evr_Event1CtrlENM{i,1}, 227);
            lcaPut(evr_Event2CtrlENM{i,1}, param.event_code);
        elseif param.event_code == 213
            lcaPut(evr_Event1CtrlENM{i,1}, 221);
            lcaPut(evr_Event2CtrlENM{i,1}, param.event_code);
        end
    else
        evr_Event1CtrlENM{i,1}  = [char(evrPVs(i)),':EVENT1CTRL.ENM'];
        evr_Event1CtrlIRQ{i,1}  = [char(evrPVs(i)),':EVENT1CTRL.VME'];
        lcaPut(evr_Event1CtrlENM{i,1}, param.event_code);
    end
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
      error(['File path: ' path ' does not exist.']);
    end
end

% Set name for data images
for i=1:num_cam
    fn = zeros(1,256);
    filename = [filePrefix{i}, data_string];
    fileASCII = double(filename);
    n_el = length(fileASCII);
    fn(1:n_el) = fileASCII;
    lcaPut(cam_TiffFileName(i), fn);
    
    % set time stamp event
    if strcmp(filePrefix{i},'CMOS_NEAR')
        lcaPut('IOC:LI20:CS01:TSS_SETEC',param.event_code);
    elseif strcmp(filePrefix{i},'CMOS_FAR')
        lcaPut('IOC:LI20:CS03:TSS_SETEC',param.event_code);
    else
        lcaPut(cam_TSS_SETEC(i),param.event_code);
    end
end

% Enable saving 
lcaPut(cam_TiffFileNumber,'0');
lcaPut(cam_TiffCallbacks, 'Enable');
lcaPut(cam_TiffAutoSave, 'Yes');
lcaPut(cam_TiffAutoIncrement, 'Yes');

% Enable PID tagging
lcaPut(evr_Event1CtrlIRQ, 'Enabled');

% Enable multiple acqusition
lcaPut(cam_ImageMode, 'Multiple');
lcaPut(cam_NumImages, n_shots);

% Camera ready to take images
lcaPutNoWait(cam_Acq, 'Acquire');

IM_stat = lcaGet(cam_ImageModeRBV);
NI_stat = lcaGet(cam_NumImagesRBV);
DS_stat = lcaGet(cam_DetectorState);

im_bad = ~strcmp('Multiple',IM_stat);
ni_bad = ~(NI_stat == n_shots);
ds_bad = ~strcmp('Acquire',DS_stat);

im_count = 0;
while sum(im_bad)
    lcaPut(cam_ImageMode(im_bad),'Multiple');
    pause(0.05);
    IM_stat = lcaGet(cam_ImageModeRBV);
    im_bad = ~strcmp('Multiple',IM_stat);
    im_count = im_count + 1;
    if im_count > 50
        lcaPut(evr_Event1CtrlOut0, 'Enabled');
        lcaPut(evr_Event1CtrlOut1, 'Enabled');
        lcaPut(evr_Event1CtrlOut2, 'Enabled');
        lcaPutNoWait(cam_Acq, 'Idle');
        lcaPut(cam_TiffCallbacks, 'Disable');
        lcaPut(cam_ImageMode, 'Continuous');
        lcaPutNoWait(cam_Acq, 'Acquire');
        warning(['Could not set camera ' param.names{im_bad} ' to DAQ ready state.']);
        param.fail = true;
        return;
    end        
end

ni_count = 0;
while sum(ni_bad)
    lcaPut(cam_ImageMode(ni_bad),n_shots);
    pause(0.05);
    NI_stat = lcaGet(cam_NumImagesRBV);
    ni_bad = ~(NI_stat == n_shots);
    ni_count = ni_count + 1;
    if ni_count > 50
        lcaPut(evr_Event1CtrlOut0, 'Enabled');
        lcaPut(evr_Event1CtrlOut1, 'Enabled');
        lcaPut(evr_Event1CtrlOut2, 'Enabled');
        lcaPutNoWait(cam_Acq, 'Idle');
        lcaPut(cam_TiffCallbacks, 'Disable');
        lcaPut(cam_ImageMode, 'Continuous');
        lcaPutNoWait(cam_Acq, 'Acquire');
        warning(['Could not set camera ' param.names{ni_bad} ' to DAQ ready state.']);
        param.fail = true;
        return;
    end
end

ds_count = 0;
while sum(ds_bad)
    lcaPutNoWait(cam_ImageMode(ds_bad),'Acquire');
    pause(0.05);
    DS_stat = lcaGet(cam_DetectorState);
    ds_bad = ~strcmp('Acquire',DS_stat);
    ds_count = ds_count + 1;
    if ds_count > 50
        lcaPut(evr_Event1CtrlOut0, 'Enabled');
        lcaPut(evr_Event1CtrlOut1, 'Enabled');
        lcaPut(evr_Event1CtrlOut2, 'Enabled');
        lcaPutNoWait(cam_Acq, 'Idle');
        lcaPut(cam_TiffCallbacks, 'Disable');
        lcaPut(cam_ImageMode, 'Continuous');
        lcaPutNoWait(cam_Acq, 'Acquire');
        warning(['Could not set camera ' param.names{ds_bad} 'to DAQ ready state.']);
        param.fail = true;
        return;
    end
end

% Enable triggers
lcaPut(evr_Event1CtrlOut0, 'Enabled');
lcaPut(evr_Event1CtrlOut1, 'Enabled');
lcaPut(evr_Event1CtrlOut2, 'Enabled');

pause(0.5);

% Wait until all cameras return to Idle state
lcaSetMonitor(cam_DetectorState);
lcaGet(cam_DetectorState);
for i=1:num_cam
    while 1
        % Test for Disconnect (GigE camera fail)
        c_var = lcaGet(cam_Connection(i));
        if (strcmp(c_var{1},'Disconnect'))
            lcaPut(evr_Event1CtrlOut0, 'Enabled');
            lcaPut(evr_Event1CtrlOut1, 'Enabled');
            lcaPut(evr_Event1CtrlOut2, 'Enabled');
            lcaPutNoWait(cam_Acq, 'Idle');
            lcaPut(cam_TiffCallbacks, 'Disable');
            lcaPut(cam_ImageMode, 'Continuous');
            lcaPutNoWait(cam_Acq, 'Acquire');
            warning(['Camera ' param.names{i} ' is down.']);
            param.fail = true;
            return;
        end
        % Test for camera completion (both GigE and CMOS)
        if (lcaNewMonitorValue(cam_DetectorState(i)))
            t_var = lcaGet(cam_DetectorState(i));
            if (strcmp(t_var{1},'Idle'))
                break;
            end
            % Test for Error (both GigE and CMOS)
            if (strcmp(t_var{1},'Error') || strcmp(c_var{1},'Disconnect'))
                lcaPut(evr_Event1CtrlOut0, 'Enabled');
                lcaPut(evr_Event1CtrlOut1, 'Enabled');
                lcaPut(evr_Event1CtrlOut2, 'Enabled');
                lcaPutNoWait(cam_Acq, 'Idle');
                lcaPut(cam_TiffCallbacks, 'Disable');
                lcaPut(cam_ImageMode, 'Continuous');
                lcaPutNoWait(cam_Acq, 'Acquire');
                warning(['Camera ' param.names{i} ' is down.']);
                param.fail = true;
                return;
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
