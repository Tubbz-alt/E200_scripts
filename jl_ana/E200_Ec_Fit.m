%% Main script used to fit the critical energy.
%%%  This is the main script used to determine the critical energy.
%%%  It is designed as a loop on each shot of a selection of shots.
%%%
%%%  For a given shot, the script will fit the critical energy if do_fit is
%%%  enabled and will plot the residual if do_plot is enabled.
%%%  In case both are set to 1, then it will also calculate the 10% Error
%%%  margin and display it on the plot.
%%%  If neither do_fit or do_plot are enabled, the script will scan
%%%  through various critical energies and plot the relative error on each
%%%  filter for each energy.
%%%
%%%  The script will display on figure 1 the processed images of BETAL/1/2,
%%%  the measured signal on the different filters and the relative errors
%%%  between simulation at a given energy and measurement.
%%%  On figure 2 is displayed the residual for the different critical
%%%  energies (if do_plot=1).
%%%
%%%  To make the calculations faster, three pre-calculated matrices are
%%%  loaded. To calculate them the first time, use "mat_num_eval.m"
%%%
%%%  The pick on the BETA cameras is centered using a maximum detection
%%%  function. As it is, this requires a manual test to properly center the
%%%  selection because of regular shot-to-shot variation.
%%%  If do_max_pick=1, the script will use the first shot to determine the
%%%  center. Since this position shouldn't change from a dataset to another,
%%%  a default position of the center has been determined on E200_10567 and
%%%  will be used if do_max_pick=0.
%%%
%%%  The shots are indexed in a Ind matrix whose first line (I) is the step
%%%  index and second line (J) is the shot number.
%%%  If do_shot_pick=1, the script will expect a pre-selection of shots to
%%%  be hand-picked and entered (see below). Else, it will run on all shots
%%%  of the dataset.



%% Settings

do_fit_k = 1; % 1 if the function fits for the factors k1 and k2, 0 if the function uses the value given below
k1_0 = 0.82;
k2_0 = 0.97;

do_max_pick = 0;
do_shot_pick = 1;

do_save_1 = 0; % If 1, save the processed variable in the data structure mat file
do_save_2 = 0; % If 1, save fig 1 plot (best fit)

do_plot = 0; % Turn on fig 2 plot looping over Ec
do_save_3 = 0; % If 1, save fig 2 plot for all Ec's

% prefix = '/Volumes/PWFA_4big';
prefix = '~/PWFA_4big';
day = '20130430';
experiment = 'E200';
data_set_num = 11000;
save_path = ['~/Dropbox/SeB/PostDoc/Projects/2013_E200_Data_Analysis/' day '/'];
data_set = [experiment '_' num2str(data_set_num)];

Ec = logspace(-1,2,150);  % Critical energy interval in MeV
l0 = 1;
ec0 = 1;
pick = [1:2, 3:4, 5:7]; % Selection of filters to be used for the Ec fit
pick_radius = 1.;
center = [-0.75,12.13]; % Initial value from Jacques
center = [-2.5,9.5]; % Manual testing
CI_threshold = 1.3;
lining_pid_up = 0;

do_generate_sextufilter_data = 0; % 1 to run the script "generate_sextufilter_data"
% to generate the structure "sextufilter", 0 to load the pre-generated structure

fontsize = 16;



%% Shot selection

clear I J Ind;
if do_shot_pick;
    if strcmp(data_set, 'E200_10567')
%         I(1:3)=2; I(4:19)=3; I(20:32)=4; I(33:42)=5; I(43:45)=6;
%         J=[18,19,20, 2:6, 8:12, 14:18, 20, 1:5, 10:14,16:18, 1,2,5,8,11,14:17,19,3,4,19];
        I(1:1)=[3]; J=[5];
    elseif strcmp(data_set, 'E200_10756')
        I=1; J=75;
    elseif strcmp(data_set, 'E200_10757')
        I=1; J=7;
    elseif strcmp(data_set, 'E200_11000')
        I(1:1)=3; J=10;
    elseif strcmp(data_set, 'E200_11004')
        I(1:1)=1; J=10;
    else
        error('No preselection entered');
    end
end



%% Generate or load sextufilter data
if do_generate_sextufilter_data
    generate_sextufilter_data;
else
    load('sextufilter.mat');
end



%% Get dataset info and sets BETA variables and background

cmap = custom_cmap();

BETAL_caxis = [0 1000];
BETA1_caxis = [0 1000];
% BETA2_caxis = [0 1000];

path = [prefix '/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/'];
if(~exist([save_path data_set '/E200_Ec_Fit/'], 'dir')); mkdir([save_path data_set '/E200_Ec_Fit/']); end;

scan_info_file = dir([path '*scan_info*']);
if size(scan_info_file,1) == 1
    load([path scan_info_file.name]);
    n_step = size(scan_info,2);
    is_qsbend_scan = strcmp(scan_info(1).Control_PV_name, 'set_QSBEND_energy');
    is_qs_scan = strcmp(scan_info(1).Control_PV_name, 'set_QS_energy');
    is_scan = 1;
elseif ( size(scan_info_file,1) == 0 && str2num(day) <= 20130423 )
    list = dir([path data_set '*BETAL*.header']);
    scan_info.BETAL = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*BETA1*.header']);
    scan_info.BETA1 = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*BETA2*.header']);
    scan_info.BETA2 = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*CEGAIN*.header']);
    scan_info.CEGAIN = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*CELOSS*.header']);
    scan_info.CELOSS = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    list = dir([path data_set '*YAG*.header']);
    scan_info.YAG = strtok(['/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/' list.name],'.');
    n_step = 1;
    is_qsbend_scan = 0;
    is_qs_scan = 0;
    is_scan = 0;
elseif ( size(scan_info_file,1) == 0 && str2num(day) > 20130423 )
    filenames_file = dir([path data_set '*_filenames.mat']);
    load([path filenames_file.name]);
    scan_info = filenames;
    n_step = 1;
    is_qsbend_scan = 0;
    is_qs_scan = 0;
    is_scan = 0;
else
    error('There are more than 1 scan info file.');
end

list = dir([path data_set '_2013*.mat']);
mat_filenames = {list.name};
if str2num(day)>20130423; mat_filenames = {mat_filenames{1:2:end}}; end;

load([path mat_filenames{1}]);
n_shot = param.n_shot;

% cam_back = cam_back1
BETAL = cam_back.BETAL;
BETA1 = cam_back.BETA1;
% BETA2 = cam_back.BETA2;

BETAL.X_RTCL_CTR = 700;
BETAL.Y_RTCL_CTR = 500;
BETA1.X_RTCL_CTR = 700;
BETA1.Y_RTCL_CTR = 500;
% BETA2.X_RTCL_CTR = 700;
% BETA2.Y_RTCL_CTR = 500;

BETAL.xx = 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_X-BETAL.X_RTCL_CTR+1):(BETAL.ROI_X+BETAL.ROI_XNP-BETAL.X_RTCL_CTR) );
BETAL.yy = sqrt(2) * 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_Y-BETAL.Y_RTCL_CTR+1):(BETAL.ROI_Y+BETAL.ROI_YNP-BETAL.Y_RTCL_CTR) );
BETA1.xx = 0.1148 * ( (BETA1.ROI_X-BETA1.X_RTCL_CTR+1):(BETA1.ROI_X+BETA1.ROI_XNP-BETA1.X_RTCL_CTR) );
BETA1.yy = 0.1061 * ( (BETA1.ROI_Y-BETA1.Y_RTCL_CTR+1):(BETA1.ROI_Y+BETA1.ROI_YNP-BETA1.Y_RTCL_CTR) );
% BETA2.xx = 1e-3*BETA2.RESOLUTION * ( (BETA2.ROI_X-BETA2.X_RTCL_CTR+1):(BETA2.ROI_X+BETA2.ROI_XNP-BETA2.X_RTCL_CTR) );
% BETA2.yy = sqrt(2) * 1e-3*BETA2.RESOLUTION * ( (BETA2.ROI_Y-BETA2.Y_RTCL_CTR+1):(BETA2.ROI_Y+BETA2.ROI_YNP-BETA2.Y_RTCL_CTR) );

B5D36 = getB5D36(E200_state);
QS = getQS(E200_state);

S_sim = interp1(sextufilter.Ec, sextufilter.S_sim, Ec);
Err = zeros(size(Ec));
Err_1L = zeros(size(Ec,2), 7);
Err_2L = zeros(size(Ec,2), 7);
k1 = k1_0*ones(size(Ec));
k2 = k2_0*ones(size(Ec));

if ~do_shot_pick
    for k=1:n_step
        I(1+(k-1)*n_shot:k*n_shot) = k;
        J(1+(k-1)*n_shot:k*n_shot) = 1:n_shot;
    end
end
Ind(1,:)=I; Ind(2,:)=J;



%%  Get first maximum used to center the picking

if do_max_pick
    [BETAL.img, ~, BETAL.pid] = E200_readImages([prefix scan_info(I(1)).BETAL]);
    BETAL.img = double(BETAL.img);
    for k=1:size(BETAL.img,3); BETAL.img(:,:,k) = BETAL.img(:,:,k) - cam_back.BETAL.img(:,:); end;
    [BETAL.img2, BETAL.ana.img, BETAL.ana.GAMMA_YIELD, BETAL.ana.GAMMA_MAX, BETAL.ana.GAMMA_DIV] = Ana_BETAL_img(BETAL.xx, BETAL.yy, BETAL.img(:,:,J(1)));
    
    BETAL.ana.i_max = get_beta_max(filter2(ones(5)/5^2,BETAL.img2), BETAL.xx, BETAL.yy);
else
    BETAL.ana.i_max = center;
end

BETA1.ana.i_max(1)= BETAL.ana.i_max(1) + 20.2906; BETA1.ana.i_max(2)= BETAL.ana.i_max(2) + 1.5526;
% BETA2.ana.i_max(1)= BETA1.ana.i_max(1) - 11.2836; BETA2.ana.i_max(2)= BETA1.ana.i_max(2) - 3.5933;



%% Figure preparation

fig1 = figure(1);
clf(fig1)
set(fig1, 'position', [500, 100, 1100, 900]);
set(fig1, 'PaperPosition', [0., 0., 10, 10]);
set(fig1, 'color', 'w');

fig2 = figure(2);
clf(fig2)
set(fig2, 'position', [1000, 400, 500, 500]);
set(fig2, 'PaperPosition', [0., 0., 6, 6]);
set(fig2, 'color', 'w');



%% Initialize processed variables

clear processed;
clear tmp_data_struct;
if exist([save_path data_set '.mat'], 'file')
    tmp_data_struct = load([save_path data_set]);
    if isfield(tmp_data_struct,'data')
        if isfield(tmp_data_struct.data,'user')
            if isfield(tmp_data_struct.data.user,'scorde')
                if isfield(tmp_data_struct.data.user.scorde,'processed')
                    processed = tmp_data_struct.data.user.scorde.processed;
                end
            end
        end
    end
end
if ~exist('processed', 'var'); processed = struct(); end;

processed.scalars.GAMMA_MAX.dat = [];
processed.scalars.GAMMA_YIELD.dat = [];
processed.scalars.GAMMA_DIV.dat = [];
processed.scalars.GAMMA_EC_BESTFIT.dat = [];
processed.scalars.GAMMA_EC_CI_MIN.dat = [];
processed.scalars.GAMMA_EC_CI_MAX.dat = [];
processed.scalars.GAMMA_EC_K1_BESTFIT.dat = [];
processed.scalars.GAMMA_EC_K2_BESTFIT.dat = [];
processed.scalars.GAMMA_EC_RESIDUE_BESTFIT.dat = [];
processed.vectors.GAMMA_EC_LIST.dat = {};
processed.vectors.GAMMA_EC_RESIDUE.dat = {};
processed.vectors.GAMMA_EC_K1.dat = {};
processed.vectors.GAMMA_EC_K2.dat = {};
processed.vectors.GAMMA_EC_S_EXP.dat = {};
processed.vectors.GAMMA_EC_S_EXP_BESTFIT.dat = {};
processed.vectors.GAMMA_EC_S_SIM_BESTFIT.dat = {};

processed.scalars.GAMMA_MAX.UID = [];
processed.scalars.GAMMA_YIELD.UID = [];
processed.scalars.GAMMA_DIV.UID = [];
processed.scalars.GAMMA_EC_BESTFIT.UID = [];
processed.scalars.GAMMA_EC_CI_MIN.UID = [];
processed.scalars.GAMMA_EC_CI_MAX.UID = [];
processed.scalars.GAMMA_EC_K1_BESTFIT.UID = [];
processed.scalars.GAMMA_EC_K2_BESTFIT.UID = [];
processed.scalars.GAMMA_EC_RESIDUE_BESTFIT.UID = [];
processed.vectors.GAMMA_EC_LIST.UID = [];
processed.vectors.GAMMA_EC_RESIDUE.UID = [];
processed.vectors.GAMMA_EC_K1.UID = [];
processed.vectors.GAMMA_EC_K2.UID = [];
processed.vectors.GAMMA_EC_S_EXP.UID = [];
processed.vectors.GAMMA_EC_S_EXP_BESTFIT.UID = [];
processed.vectors.GAMMA_EC_S_SIM_BESTFIT.UID = [];



%% Loop on the different shots

for l=l0:size(J,2)
    
    i=I(l); j=J(l);
    if(l==l0 || I(l) ~= I(l-1))
        [BETAL.img, ~, BETAL.pid] = E200_readImages([prefix scan_info(i).BETAL]);
        BETAL.img = double(BETAL.img);
        for k=1:size(BETAL.img,3); BETAL.img(:,:,k) = BETAL.img(:,:,k) - cam_back.BETAL.img(:,:); end;
        [BETA1.img, ~, BETA1.pid] = E200_readImages([prefix scan_info(i).BETA1]);
        BETA1.img = double(BETA1.img);
        for k=1:size(BETA1.img,3); BETA1.img(:,:,k) = BETA1.img(:,:,k) - cam_back.BETA1.img(:,:); end;
%         [BETA2.img, ~, BETA2.pid] = E200_readImages([prefix scan_info(i).BETA2]);
%         BETA2.img = double(BETA2.img);
%         for k=1:size(BETA2.img,3); BETA2.img(:,:,k) = BETA2.img(:,:,k) - cam_back.BETA2.img(:,:); end;
    data = load([path mat_filenames{i}]);
    pid = [data.epics_data.PATT_SYS1_1_PULSEID];
    end
    
    j1 = j + lining_pid_up; %%%%%%%%%%%%%%%%%%%%%% CAREFUL HERE, lining up BETAL and BETA1 %%%%%%%%%%%%%%%%%%%%%%%%
    if j1<1 || j1>size(BETA1.img,3); continue; end;
        
    fprintf('\n %d \t %d\n', BETAL.pid(j), BETA1.pid(j1));
    if BETAL.pid(j)~=BETA1.pid(j1); error('BETAL and BETA1 pulse Id''s are not lined up.'); end;
    
    % Image analysis
    [BETAL.img2, BETAL.ana.img, BETAL.ana.GAMMA_YIELD, BETAL.ana.GAMMA_MAX, BETAL.ana.GAMMA_DIV] = Ana_BETAL_img(BETAL.xx, BETAL.yy, BETAL.img(:,:,j));
    [BETA1.img2, BETA1.ana.img, BETA1.ana.GAMMA_YIELD, BETA1.ana.GAMMA_MAX, BETA1.ana.GAMMA_DIV, BETA1.ana.xx, BETA1.ana.yy] = Ana_BETA1_img(BETA1.xx, BETA1.yy, BETA1.img(:,:,j1));
%     [BETA2.img2, BETA2.ana.img, BETA2.ana.GAMMA_YIELD, BETA2.ana.GAMMA_MAX, BETA2.ana.GAMMA_DIV] = Ana_BETA2_img(BETA2.xx, BETA2.yy, BETA2.img(:,:,j));
    
    tmp_1 = mean(mean(BETAL.img2(50:150, 1100:1250)));
    tmp_2 = mean(mean(BETAL.img2(650:900, 70:170)));
    tmp_3 = mean(mean(BETAL.img2(200:450, 70:170)));
    tmp_4 = mean(mean(BETAL.img2(940:1020, 1200:1300)));
%     tmp_1 = []; tmp_3 = [];
    BETAL.img2 = BETAL.img2 - mean([tmp_1 tmp_2 tmp_3 tmp_4]);
    BETAL.img2(50:150, 1100:1250) = 0;
    BETAL.img2(650:900, 70:170) = 0;
    BETAL.img2(200:450, 70:170) = 0;
    BETAL.img2(940:1020, 1200:1300) = 0;

    tmp_5 = mean(mean(BETA1.img2(1:50, 200:300)));
    BETA1.img2 = BETA1.img2 - tmp_5;
    BETA1.img2(1:50, 200:300) = 0;
    
    % Evaluation of the signal on BETAL and BETA1
    [S_BETAL, BETAL.pick.img] = Gamma_eval(BETAL.img2, BETAL.xx, BETAL.yy, BETAL.ana.i_max, pick_radius);
    [S_BETA1, BETA1.pick.img] = Gamma_eval(BETA1.img2, BETA1.ana.xx, BETA1.ana.yy, BETA1.ana.i_max, pick_radius);
%     [S_BETA2, BETA2.pick.img] = Gamma_eval(BETA2.img2, BETA2.xx, BETA2.yy, BETA2.ana.i_max, pick_radius);
    S_BETA2 = zeros(1,7);

    
%     S_BETAL = 1./(1./S_BETAL-1/7000);
%     S_BETA1 = 1./(1./S_BETA1-1/10000);


    % Fit on a selection of filters
    S_exp = [S_BETA1./S_BETAL S_BETA2./S_BETAL];
    if do_fit_k
        [z_fit, Err_min] = fminsearch(@(z) energy_fit_1(z, S_exp, pick, sextufilter), [10, 1]);
        Ec_fit = z_fit(1);
        k1_fit = z_fit(2);
    else
        [z_fit, Err_min] = fminsearch(@(z) energy_fit_2(z, k1_0, k2_0, S_exp, pick, sextufilter), 10);
        Ec_fit = z_fit(1);
        k1_fit = k1_0;        
    end
    k2_fit = k2_0;
    S_exp_fit = [k1_fit*S_exp(1:7) k2_fit*S_exp(8:14)];
    S_sim_fit = interp1(sextufilter.Ec, sextufilter.S_sim, Ec_fit);
        
    % Loop on the critical energy to calculate the Residual
    for ec=ec0:size(Ec,2)
        if do_fit_k
            [z_fit, ~] = fminsearch(@(z) k_fit(z, Ec(ec), S_exp, pick, sextufilter), 1);        
            k1(ec) = z_fit(1);
            k2(ec) = k2_0;
        else
            k1(ec) = k1_0;
            k2(ec) = k2_0;
        end
        tmp = [k1(ec)*S_exp(1:7) k2(ec)*S_exp(8:14)];
        Err(ec) = sqrt(sum((tmp(pick) - S_sim(ec,pick)).^2)/size(pick,2));
        Err_1L(ec,:) = k1(ec)*S_exp(1:7) - S_sim(ec,1:7); % Absolute difference
%         Err_1L(ec,1:7) = 100*(k1(ec)*S_exp(1:7) - S_sim(1:7))./(k1(ec)*S_exp(1:7)); % Relative difference
        Err_2L(ec,:) = k2(ec)*S_exp(8:14) - S_sim(ec,8:14); % Absolute difference
%         Err_2L(ec,1:7) = 100*(k2(ec)*S_exp(8:14) - S_sim(8:14))./(k2(ec)*S_exp(8:14)); % Relative difference
    end
    
    %  Critical energy confidence interval [CI_MIN CI_MAX]
    x = Ec(1):0.1:Ec(end);
    i_CI_MIN = 1;
    i_CI_MAX = 0;
    Err_interp = interp1(Ec,Err,x);
    limit_positions = x( [abs(diff(Err_interp<CI_threshold*min(Err_interp))) 0] == 1);
    if size(limit_positions,2)~=2
        disp('Less or more than 2 values found to define confidence interval. Confidence interval width set to 0.');
        CI_MIN = Ec_fit;
        CI_MAX = Ec_fit;
    else
        CI_MIN=limit_positions(1)+0.05;
        CI_MAX=limit_positions(2)+0.05;
    end

    % Filling processed structure
    processed.scalars.GAMMA_MAX.dat(end+1) = BETAL.ana.GAMMA_MAX;
    processed.scalars.GAMMA_YIELD.dat(end+1) = BETAL.ana.GAMMA_YIELD;
    processed.scalars.GAMMA_DIV.dat(end+1) = BETAL.ana.GAMMA_DIV;
    processed.scalars.GAMMA_EC_BESTFIT.dat(end+1) = Ec_fit;
    processed.scalars.GAMMA_EC_CI_MIN.dat(end+1) = CI_MIN;
    processed.scalars.GAMMA_EC_CI_MAX.dat(end+1) = CI_MAX;
    processed.scalars.GAMMA_EC_K1_BESTFIT.dat(end+1) = k1_fit;
    processed.scalars.GAMMA_EC_K2_BESTFIT.dat(end+1) = k2_fit;
    processed.scalars.GAMMA_EC_RESIDUE_BESTFIT.dat(end+1) = Err_min;
    processed.vectors.GAMMA_EC_LIST.dat{end+1} = Ec;
    processed.vectors.GAMMA_EC_RESIDUE.dat{end+1} = Err;
    processed.vectors.GAMMA_EC_K1.dat{end+1} = k1;
    processed.vectors.GAMMA_EC_K2.dat{end+1} = k2;
    processed.vectors.GAMMA_EC_S_EXP.dat{end+1} = S_exp;
    processed.vectors.GAMMA_EC_S_EXP_BESTFIT.dat{end+1} = S_exp_fit;
    processed.vectors.GAMMA_EC_S_SIM_BESTFIT.dat{end+1} = S_sim_fit;
    UID = getUID(data_set_num, i, BETAL.pid(j), pid);
    processed.scalars.GAMMA_MAX.UID(end+1) = UID;
    processed.scalars.GAMMA_YIELD.UID(end+1) = UID;
    processed.scalars.GAMMA_DIV.UID(end+1) = UID;
    processed.scalars.GAMMA_EC_BESTFIT.UID(end+1) = UID;
    processed.scalars.GAMMA_EC_CI_MIN.UID(end+1) = UID;
    processed.scalars.GAMMA_EC_CI_MAX.UID(end+1) = UID;
    processed.scalars.GAMMA_EC_K1_BESTFIT.UID(end+1) = UID;
    processed.scalars.GAMMA_EC_K2_BESTFIT.UID(end+1) = UID;
    processed.scalars.GAMMA_EC_RESIDUE_BESTFIT.UID(end+1) = UID;
    processed.vectors.GAMMA_EC_LIST.UID(end+1) = UID;
    processed.vectors.GAMMA_EC_RESIDUE.UID(end+1) = UID;
    processed.vectors.GAMMA_EC_K1.UID(end+1) = UID;
    processed.vectors.GAMMA_EC_K2.UID(end+1) = UID;
    processed.vectors.GAMMA_EC_S_EXP.UID(end+1) = UID;
    processed.vectors.GAMMA_EC_S_EXP_BESTFIT.UID(end+1) = UID;
    processed.vectors.GAMMA_EC_S_SIM_BESTFIT.UID(end+1) = UID;
    
    % Figure settings
    if l==l0
        figure(1)
        h_text = axes('Position', [0.12, 0.92, 0.3, 0.035], 'Visible', 'off');
        if is_scan; STEP = text(0., 1., [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)], 'fontsize', fontsize); end;
        SHOT = text(0., 0., ['Shot #' num2str(j)], 'fontsize', fontsize);
        h_text2 = axes('Position', [0.42, 0.92, 0.3, 0.035], 'Visible', 'off');
        if is_qs_scan; B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', fontsize); end;
        if ~is_qs_scan && ~is_qsbend_scan
            QS_text = text(0., 1., ['QS = ' num2str(QS, '%.0f') ' GeV'], 'fontsize', fontsize);
            B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', fontsize);
        end
        h_text3 = axes('Position', [0.72, 0.92, 0.3, 0.035], 'Visible', 'off');
        Pick_text = text(0., 1., ['Pick = [' num2str(pick) ']'], 'fontsize', fontsize);
        Ec_text = text(0.,0., ['Ec fit = ' num2str(Ec_fit) ' MeV'],'fontsize', fontsize);
        
        ax_BETAL = axes('position', [0.1, 0.58, 0.35, 0.25]);
        set(gca, 'fontsize', fontsize);
        image(BETAL.xx,BETAL.yy,BETAL.pick.img,'CDataMapping','scaled');
        colormap(cmap.wbgyr);
        fig_BETAL = get(gca,'Children');
        daspect([1 1 1]);
        axis xy;
        if BETAL.ana.GAMMA_MAX > BETAL_caxis(1)
            caxis([BETAL_caxis(1) BETAL.ana.GAMMA_MAX]);
        else
            caxis(BETAL_caxis);
        end
        colorbar('fontsize', fontsize);
        xlabel('x (mm)'); ylabel('y (mm)');
        title('BETAL');
        %
        %   ax_beta1 = axes('position', [0.5, 0.58, 0.30, 0.25]);
        %         image(BETA1.ana.xx,BETA1.ana.yy,BETA1.pick.img,'CDataMapping','scaled');
        %         colormap(cmap.wbgyr);
        %         fig_beta1 = get(gca,'Children');
        %         daspect([1 1 1]);
        %         axis xy;
        %         if BETA1.ana.GAMMA_MAX > BETA1_caxis(1)
        %             caxis([BETA1_caxis(1) BETA1.ana.GAMMA_MAX]);
        %         else
        %             caxis(BETAL_caxis);
        %         end
        %         colorbar('fontsize', fontsize);
        %         title('BETA1');
        
        ax_BETA1 = axes('position', [0.55, 0.58, 0.35, 0.25]);
        set(gca, 'fontsize', fontsize);
        image(BETA1.ana.xx, BETA1.ana.yy, BETA1.pick.img,'CDataMapping','scaled');
        colormap(cmap.wbgyr);
        fig_BETA1 = get(gca,'Children');
        daspect([1 1 1]);
        axis xy;
        if BETA1.ana.GAMMA_MAX > BETA1_caxis(1)
            caxis([BETA1_caxis(1) BETA1.ana.GAMMA_MAX]);
        else
            caxis(BETA1_caxis);
        end
        colorbar('fontsize', fontsize);
        xlabel('x (mm)'); ylabel('y (mm)');
        title('BETA1');
        
        ax_S_ratio1L = axes ('position', [0.05, 0.08, 0.27, 0.35]);
        set(gca, 'fontsize', 8);
        bar( [S_exp_fit(1:7); S_sim_fit(1:7)]');
        fig_S_ratio1L = get(gca, 'Children');
        set(fig_S_ratio1L(1), 'FaceColor', 'b');
        set(fig_S_ratio1L(2), 'FaceColor', 'g');
        name = {'Cu 1' ; 'Cu 3' ; 'Cu 10' ; 'W 3' ;'W 1' ; 'Cu 0.3'; 'None'};
        set(gca, 'xticklabel', name);
        ylim([0 max(S_sim(:))]);
        title('S BETA1 / S BETAL', 'fontsize', fontsize);
        xlabel('Converter', 'fontsize', fontsize);
        h_legend = legend('Exp','Sim');
        set(h_legend, 'fontsize', fontsize);
        
        % ax_S_ratio2L = axes('position', [0.37, 0.32, 0.29, 0.25]);
        %         bar(S_ratio2L, 'b');
        %         fig_S_ratio2L= get(gca, 'Children');
        %        name= {'Cu 1' ; 'Cu 3' ; 'Cu 10' ; 'W 3' ;'W 1' ; 'Cu 0.3'; 'No filter'};
        %         set(gca, 'xticklabel', name);
        %         title('S BETA2/S BETAL');
        
        ax_fit_err1L = axes ('position', [0.36, 0.08, 0.27, 0.35]);
        set(gca, 'fontsize', 8);
        bar(interp1(Ec,Err_1L,Ec_fit),'r');
        fig_fit_err1L = get(gca, 'Children');
        set(gca, 'xticklabel', name);
        title('Diff Exp - Sim (BETA1)', 'fontsize', fontsize);
        xlabel('Converter', 'fontsize', fontsize);
        
        %  ax_fit_err2L = axes ('position', [0.37, 0.02, 0.29, 0.23]);
        %         bar(Err_2L(ec,:),'b');
        %         fig_fit_err2L=get(gca, 'Children');
        %         set(gca, 'xticklabel', name);
        %         title('%Err 2L');
        
        ax_fit_Err = axes('position', [0.68, 0.08, 0.30, 0.35]);
        set(gca, 'fontsize', fontsize);
        plot(Ec, Err, Ec, k1-k1_0);
        legend('Residual', 'Delta k1', 'Location', 'SouthEast');
        fig_fit_Err = get(gca, 'Children');
        xlabel('Critical Energy (MeV)');
        
    else
        if is_scan; set(STEP, 'String', [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)]); end;
        set(SHOT, 'String', ['Shot #' num2str(j)]);
        set(fig_BETAL,'CData',BETAL.pick.img);
        if BETAL.ana.GAMMA_MAX > BETAL_caxis(1)
            set(ax_BETAL, 'CLim', [BETAL_caxis(1) BETAL.ana.GAMMA_MAX]);
        else
            set(ax_BETAL, 'CLim', BETAL_caxis);
        end
        set(fig_BETA1,'CData',BETA1.pick.img);
        if BETA1.ana.GAMMA_MAX > BETA1_caxis(1)
            set(ax_BETA1, 'CLim', [BETA1_caxis(1) BETA1.ana.GAMMA_MAX]);
        else
            set(ax_BETA1, 'CLim', BETA1_caxis);
        end
        %         set(fig_BETA2,'CData',BETA2.pick.img);
        %         if BETA2.ana.GAMMA_MAX > BETA2_caxis(1)
        %             set(ax_BETA2, 'CLim', [BETA2_caxis(1) BETA2.ana.GAMMA_MAX]);
        %         else
        %             set(ax_beta1, 'CLim', BETA2_caxis);
        %         end
    end
    
    % For each shot, display the data at the fitted critical energy
    set(fig_fit_err1L, 'YData', interp1(Ec,Err_1L,Ec_fit));
%     set(fig_fit_err2L, 'YData', interp1(Ec, Err_2L, Ec_fit));
    set(Ec_text, 'string', ['Ec fit = ' num2str(Ec_fit) ' MeV']) ;
    set(fig_S_ratio1L(1), 'YData', S_sim_fit(1:7));
    set(fig_S_ratio1L(2), 'YData', S_exp_fit(1:7));
    set(fig_fit_Err(1),'YData', k1-k1_0);
    set(fig_fit_Err(2),'YData', Err);
    drawnow;  


    
%     %  Error bars
%     
%     if l==l0
%         y1=line([1 Ec(size(Ec,2))], [d_min d_min]);
%         x_err1=line([err(1) err(1)], [0 Err(1)]);
%         x_err2=line([err(2) err(2)], [0 Err(1)]);
%         y2=line([1 Ec(size(Ec,2))], [1.1*d_min 1.1*d_min]);
%         
%         h_text3 = axes('Position', [0.48, 0.9, 0.2, 0.05], 'Visible', 'off');
%         Ec_fit_m_text=text(0.7, 0.2, ['10% Margin = [' num2str(err(1)) ' ; ' num2str(err(2)) ']'] , 'fontsize', 16);
%     else
%         set(y1, 'YData', [d_min d_min]);
%         set(x_err1, 'XData', [err(1) err(1)]);
%         set(x_err2, 'XData', [err(2) err(2)]);
%         set(y2, 'Ydata', [1.1*d_min 1.1*d_min]);
%         
%         set(Ec_fit_m_text,'string',['10% Margin = [' num2str(err(1)) ' ; ' num2str(err(2)) ']'] );
%     end;
    



    % Saving
    if  do_save_2
        filename = ['Ec_Fit_Shot_' num2str(i, '%.2d') '_' num2str(j, '%.3d') '.png' ];
        saveas(1, [save_path data_set '/E200_Ec_Fit/' filename], 'png');
    end
      
    %  Movie with varying Ec
    if do_plot
        for ec=ec0:size(Ec,2)
            if ec==ec0
                figure(2);
                bar([k1(ec)*S_exp(1:7); S_sim(ec,1:7); Err_1L(ec,:)]');
                set(gca, 'fontsize', 12);
                fig_all_Ec = get(gca, 'Children');
                set(fig_all_Ec(1), 'FaceColor', 'r');
                set(fig_all_Ec(2), 'FaceColor', 'b');
                set(fig_all_Ec(3), 'FaceColor', 'g');
                set(gca, 'xticklabel', name);
                ylim([-0.5 max(S_sim(:))]);
                title('S BETA1 / S BETAL and Diff Exp - Sim', 'fontsize', fontsize);
                xlabel('Converter', 'fontsize', fontsize);
                h_legend = legend('Exp','Sim', 'Exp-Sim');
                set(h_legend, 'fontsize', fontsize);
                h_text4 = text(0.3, 1.5, ['Ec = ' num2str(Ec(ec)) ' MeV'], 'fontsize', fontsize+4);
            else
                set(fig_all_Ec(1), 'YData', Err_1L(ec,:));
                set(fig_all_Ec(2), 'YData', S_sim(ec,1:7));
                set(fig_all_Ec(3), 'YData', k1(ec)*S_exp(1:7));
                set(h_text4, 'String', ['Ec = ' num2str(Ec(ec)) ' MeV']);
            end
            if do_save_3
                tmp_path = [save_path data_set '/E200_Ec_Fit/Ec_Fit_Shot_' num2str(i, '%.2d') '_' num2str(j, '%.3d') '/'];
                if(~exist(tmp_path, 'dir')); mkdir(tmp_path); end;
                filename = [tmp_path 'frame_' num2str(ec, '%.5d') '.png' ];
                saveas(2, filename, 'png');
            else
                pause(0.001);
            end
        end
        if do_save_3; system(['/usr/local/bin/ffmpeg -i ' tmp_path 'frame_%05d.png ' tmp_path(1:end-1) '.mpeg']); end;
    end
    
    
end

tmp_data_struct.data.user.scorde.processed = processed;
if do_save_1; save([save_path data_set '.mat'], '-struct', 'tmp_data_struct'); end;





