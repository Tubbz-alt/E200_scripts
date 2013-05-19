function par = E200_startImage(par)

nImgs = par.n_shot;
tse = par.event_code;
nCAM = par.num_CAM;
nNAS = par.num_NAS;

par.pm01_cams = 0;
par.pm02_cams = 0;
par.pm03_cams = 0;

% Cameras are paired by EVR     
cam_pair_1 = {'OTRS:LI20:3158';
              'OTRS:LI20:3180';
              'PROF:LI20:3185';
              'OTRS:LI20:3070';
              'PROF:LI20:3487';
              'PROF:LI20:3486';
              'PROF:LI20:3484';
              'PROF:LI20:3483';
              'MIRR:LI20:3202';
              'PROF:LI20:3488';
              'EXPT:LI20:3206';
              'EXPT:LI20:3203'};

cam_pair_2 = {'OTRS:LI20:3175';
              'OTRS:LI20:3075';
              'YAGS:LI20:2432';
              ''              ;
              'OTRS:LI20:3206';
              'OTRS:LI20:3208';
              'PROF:LI20:3485';
              ''              ;
              'EXPT:LI20:3208';
              'MIRR:LI20:3230';
              'EXPT:LI20:3176';
              ''              };

PMEVR_list = {'EVR:LI20:PM02';
              'EVR:LI20:PM03';
              'EVR:LI20:PM04';
              'EVR:LI20:PM05';
              'EVR:LI20:PM06';
              'EVR:LI20:PM07';
              'EVR:LI20:PM12';
              'EVR:LI20:PM13';
              'EVR:LI20:PM08';
              'EVR:LI20:PM09';
              'EVR:LI20:PM10';
              'EVR:LI20:PM11'};       
          
% Set up cameras for data taking    
for i=1:nCAM
    
    % Set timestamp event
    lcaPut(strcat(par.cams(i,2),':IMAGE_TS_EVENT'),tse);
    
    % Find Camera Pair and EVR
    ind1 = find(strcmp(par.cams(i,2),cam_pair_1));
    ind2 = find(strcmp(par.cams(i,2),cam_pair_2));
    if isempty(ind1)
        lcaPut(strcat(cam_pair_1(ind2),':TCTL'),0);
        lcaPut(strcat(cam_pair_1(ind2),':ENABLE_DAQ'),0);
        ind = ind2;
    elseif ~strcmp(cam_pair_2(ind1),'')
        lcaPut(strcat(cam_pair_2(ind1),':TCTL'),0);
        lcaPut(strcat(cam_pair_2(ind1),':ENABLE_DAQ'),0);
        ind = ind1;
    elseif 1
        ind = ind1;
    end
    
    % Set Event Code at Trigger Panel
    tse_213 = lcaGetSmart(strcat(PMEVR_list(ind),':EVENT1CTRL.ENM'));
    tse_53  = lcaGetSmart(strcat(PMEVR_list(ind),':EVENT2CTRL.ENM'));
    if tse_213 == tse
        lcaPut(strcat(PMEVR_list(ind),':EVENT1CTRL.OUT0'),1);
        lcaPut(strcat(PMEVR_list(ind),':EVENT1CTRL.OUT1'),1);
        lcaPut(strcat(PMEVR_list(ind),':EVENT1CTRL.VME'), 1);
        lcaPut(strcat(PMEVR_list(ind),':EVENT2CTRL.OUT0'),0);
        lcaPut(strcat(PMEVR_list(ind),':EVENT2CTRL.OUT1'),0);
        lcaPut(strcat(PMEVR_list(ind),':EVENT2CTRL.VME'), 0);
    elseif tse_53 == tse
        lcaPut(strcat(PMEVR_list(ind),':EVENT1CTRL.OUT0'),0);
        lcaPut(strcat(PMEVR_list(ind),':EVENT1CTRL.OUT1'),0);
        lcaPut(strcat(PMEVR_list(ind),':EVENT1CTRL.VME'), 0);
        lcaPut(strcat(PMEVR_list(ind),':EVENT2CTRL.OUT0'),1);
        lcaPut(strcat(PMEVR_list(ind),':EVENT2CTRL.OUT1'),1);
        lcaPut(strcat(PMEVR_list(ind),':EVENT2CTRL.VME'), 1);
    else
        error('Event code not enumerated correctly on %s Trigger Diagnostic Panel',PMEVR_list(ind));
    end
        
    % Set Number of Images
    lcaPut(strcat(par.cams(i,2),':NUM_IMAGES_DAQ'), nImgs);
    
    % Set save path
    k = mod(i-1,3)+1;
    if k == 1; par.pm01_cams = par.pm01_cams + 1; end
    if k == 2; par.pm02_cams = par.pm02_cams + 1; end
    if k == 3; par.pm03_cams = par.pm03_cams + 1; end

    ftp_path = ['FTP' num2str(k) ':/PM/' par.tail_path];
    lcaPut(strcat(par.cams(i,2),':SAVE_IMG_DIR'),ftp_path);

    filename = strcat([par.experiment, '_', num2str(lcaGetSmart('SIOC:SYS1:ML02:AO001')), '_'], par.cams(i,1));
    lcaPut(strcat(par.cams(i,2),':IMAGE_NAME'), filename);    
    
    % Enable camera trigger and DAQ
    lcaPut(strcat(par.cams(i,2),':TCTL'),1);
    lcaPut(strcat(par.cams(i,2),':ENABLE_DAQ'),1);
    
end

% Check Camera Status
pause(3);
fr = lcaGetSmart(strcat(par.cams(:,2),':FRAME_RATE'));
ifr = find(fr == 0);
if ~isempty(ifr)
    for f = 1:length(ifr)
        warning('Camera %s is not triggered. Camera will be removed from list.',char(par.cams(ifr(f),1)));
        lcaPut(strcat(par.cams(ifr(f),2),':ENABLE_DAQ'),0);
        im_path  = char(lcaGet(strcat(par.cams(ifr(f),2),':SAVE_IMG_DIR')));
        if strcmp(im_path(4),'1'); par.pm01_cams = par.pm01_cams - 1; end
        if strcmp(im_path(4),'2'); par.pm02_cams = par.pm02_cams - 1; end
        if strcmp(im_path(4),'3'); par.pm03_cams = par.pm03_cams - 1; end
    end
    par.cams(ifr,:) = [];
end
sd = lcaGetSmart(strcat(par.cams(:,2),':STATUS_DAQ'));
isd = find(sd ~= 0);
if ~isempty(isd)
    for s = 1:length(isd)
        warning('Camera %s has bad DAQ status. Camera will be removed from list.',char(par.cams(isd(s),1)));
        lcaPut(strcat(par.cams(isd(s),2),':ENABLE_DAQ'),0);
        im_path  = char(lcaGet(strcat(par.cams(isd(s),2),':SAVE_IMG_DIR')));
        if strcmp(im_path(4),'1'); par.pm01_cams = par.pm01_cams - 1; end
        if strcmp(im_path(4),'2'); par.pm02_cams = par.pm02_cams - 1; end
        if strcmp(im_path(4),'3'); par.pm03_cams = par.pm03_cams - 1; end
        par.cams(isd(s),:) = [];
    end
end

% Start DAQ
disp(['DAQ ATTACK! ' datestr(clock,'HH:MM:SS')]);
lcaPut('SIOC:LI20:PM01:DAQ_CTRL',1);

end
