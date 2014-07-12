function QC_INFO = FACET_DAQ_QC(par,epics_set)

dataset    = par.n_saves;
n_steps    = par.n_step;
n_shots    = par.n_shot;
filePrefix = par.names;
data_path  = par.save_path;

QC_INFO.EPICS.PIDS = [];
QC_INFO.EPICS.UIDS = [];
QC_INFO.EPICS.STEP = [];

for j = 1:n_steps
    epics_data = epics_set{j};
    EPID = [epics_data.PATT_SYS1_1_PULSEID]';
    n_el = numel(EPID);
    STEP = j*ones(n_el,1);
    QC_INFO.EPICS.STEP = [QC_INFO.EPICS.STEP; STEP];
    QC_INFO.EPICS.PIDS = [QC_INFO.EPICS.PIDS; EPID];
    UIDS = UID(EPID,j,dataset);
    QC_INFO.EPICS.UIDS = [QC_INFO.EPICS.UIDS; UIDS.epics_UID];
end

display('Profile Monitor Info:');
for i=1:numel(filePrefix)
    IMAGES.dat = cell(1,n_shots*n_steps);
    IMAGES.format = cell_construct('tif',1,n_shots*n_steps);
    IMAGES.IDtype= 'Image';
    IMAGES.isfile= ones(1,n_shots*n_steps);
    IMAGES.PID = zeros(1,n_shots*n_steps);
    IMAGES.UID = zeros(1,n_shots*n_steps);
    IMAGES.N_EXPT = n_shots*n_steps;
    IMAGES.ERRORS = [];
    
    for s=1:n_steps
        saved_images = dir([data_path '/' filePrefix{i} '/' filePrefix{i} '_data_step' num2str(s,'%02d') '*.tif']);
        extra_error = 0;
        for j = 1:numel(saved_images)
            if j > n_shots
                extra_error = 1;
                continue;
            end
            ind=sub2ind([n_shots n_steps],j,s);
            
            img_name    = saved_images(j).name;
            file_path   = [data_path '/' filePrefix{i} '/' img_name];
            tiff_header = tiff_read_header(file_path);
            img_pulseID = bitand(tiff_header.private_65003, hex2dec('0001FFFF'));

            if strncmp('CMOS',filePrefix{i},4)
                %display(img_pulseID);
                odd = rem(img_pulseID,10);
                if odd == 9
                    img_pulseID = img_pulseID + 1;
                    %display(img_pulseID);
                end
            end
            out = UID(QC_INFO.EPICS.PIDS(QC_INFO.EPICS.STEP==s),s,dataset,img_pulseID);
            if isempty(out.image_UID);  out.image_UID = j; end
            
            IMAGES.PID(ind) = img_pulseID;
            IMAGES.UID(ind) = out.image_UID;
            
            uid_name = [filePrefix{i} '_' num2str(out.image_UID) '.tif'];
            uid_path = [data_path '/' filePrefix{i} '/' uid_name];
            movefile(file_path,uid_path);
            IMAGES.dat{ind} = uid_path;
        end
    end
    saved_ind = ~cellfun(@isempty,IMAGES.dat);
    IMAGES.N_IMGS = sum(saved_ind);
    IMAGES.N_UIDS = numel(unique(IMAGES.UID(IMAGES.UID>1000)));
    IMAGES.N_NOUID= sum(IMAGES.UID<1000);
    
    if IMAGES.N_IMGS < IMAGES.N_EXPT;
        IMAGES.ERRORS = [IMAGES.ERRORS 1];
    end
    if IMAGES.N_UIDS < IMAGES.N_IMGS;
        IMAGES.ERRORS = [IMAGES.ERRORS 2];
    end
    if IMAGES.N_NOUID > 0;
        IMAGES.ERRORS = [IMAGES.ERRORS 3];
    end
    if extra_error
        IMAGES.ERRORS = [IMAGES.ERRORS 4];
    end
    
    display([filePrefix{i} ' saved ' num2str(IMAGES.N_IMGS) ...
        ' out of ' num2str(n_shots*n_steps) ' images and recorded ' num2str(IMAGES.N_UIDS) ' unique pulse IDs.']);
    QC_INFO.IMAGES.(filePrefix{i})=IMAGES;
end

% display('Pulse ID Information:');
% fprintf('Channel\t PID_Start\t PID_End\n');
% fprintf('EPICS\t %d \t\t %d\n',EPID(1),EPID(end));
% for i = 1:numel(filePrefix)
%     fprintf('%s\t %d \t\t %d\n',filePrefix{i}, IMAGES.PID(1), IMAGES.PID(end));
% end


display('Profile Monitor Errors:');
for i = 1:numel(filePrefix)
    nErr(i) = numel(QC_INFO.IMAGES.(filePrefix{i}).ERRORS);
    for j = 1:nErr(i)
        err = QC_INFO.IMAGES.(filePrefix{i}).ERRORS(j);
        if err == 1
            display([filePrefix{i} ' is missing shots.']);
        elseif err == 2
            display([filePrefix{i} ' has repeat pulse IDs.']);
        elseif err == 3
            display([filePrefix{i} ' has unmatched pulse IDs.']);
        elseif err == 4
            display([filePrefix{i} ' has extra images.']);
        end
    end
end
if sum(nErr(i)) == 0; display('No Errors!'); end
