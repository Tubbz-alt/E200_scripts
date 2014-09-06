clear all;

% file location

header = '/Volumes/PWFA_4big';
nas  ='/nas/nas-li20-pm00/';
expt = 'E200';
year = '/2014/';
day  = '20140531/';
dataset = '13094';

data_path = [nas expt year day expt '_' dataset '/' expt '_' dataset '.mat'];

% cuts, thresholds, other variables
pyro_cut = [0 20000];
laser_on_th = 2;
cmap  = custom_cmap();

% Pixel position of 20.35 GeV beam on CMOS FAR
if( str2num(day(1:8)) > 20140521 )
    pix_E0 = 1597; % after 2014 QS quad move
else
    pix_E0 = 1623; % before 2014 QS quad move
end
% pix_E0 = 1585.7;  % Overwrite expected position

% ROI for CMOS FAR
cmos_far_roi.top = 1000;
cmos_far_roi.bottom = 1900;
cmos_far_roi.left = 315-100;
cmos_far_roi.right = 315+100;
cmos_far_roi.rot = 1;
cmos_far_roi.fliplr = 0;
cmos_far_roi.flipud = 0;

%% Load data
load([header data_path]);

%%
% Select common UID (including pyro cut)
EPICS_UID = data.raw.scalars.PATT_SYS1_1_PULSEID.UID;
CMOS_FAR = data.raw.images.CMOS_FAR;
ELANEX = data.raw.images.ELANEX;
SYAG = data.raw.images.SYAG;
BETAL = data.raw.images.BETAL;
E224_Probe = data.raw.images.E224_Probe;
DS_GOLD = data.raw.images.DS_GOLD;

laser_power = data.raw.scalars.PMTR_LA20_10_PWR;
PYRO = data.raw.scalars.BLEN_LI20_3014_BRAW;
PYRO_CUT_UID = PYRO.UID(PYRO.dat>pyro_cut(1) & PYRO.dat<pyro_cut(2));

COMMON_UID = intersect(EPICS_UID,CMOS_FAR.UID);
COMMON_UID = intersect(COMMON_UID,ELANEX.UID);
COMMON_UID = intersect(COMMON_UID,SYAG.UID);
COMMON_UID = intersect(COMMON_UID,BETAL.UID);
COMMON_UID = intersect(COMMON_UID,E224_Probe.UID);
COMMON_UID = intersect(COMMON_UID,DS_GOLD.UID);
COMMON_UID = intersect(COMMON_UID,PYRO_CUT_UID);
n_common = numel(COMMON_UID);

[~,~,EPICS_index] = intersect(COMMON_UID,EPICS_UID);
[~,~,CMOS_FAR_index] = intersect(COMMON_UID,CMOS_FAR.UID);
[~,~,ELANEX_index] = intersect(COMMON_UID,ELANEX.UID);
[~,~,SYAG_index] = intersect(COMMON_UID,SYAG.UID);
[~,~,BETAL_index] = intersect(COMMON_UID,BETAL.UID);
[~,~,E224_Probe_index] = intersect(COMMON_UID,E224_Probe.UID);
[~,~,DS_GOLD_index] = intersect(COMMON_UID,DS_GOLD.UID);

step_num       = data.raw.scalars.step_num.dat(EPICS_index);
step_val       = data.raw.scalars.step_value.dat(EPICS_index);
n_step = numel(unique(step_num));

PYRO.dat_common = PYRO.dat(EPICS_index);
laser_power.dat_common = laser_power.dat(EPICS_index);
CMOS_FAR.dat_common = CMOS_FAR.dat(CMOS_FAR_index);
ELANEX.dat_common = ELANEX.dat(ELANEX_index);
SYAG.dat_common = SYAG.dat(SYAG_index);
BETAL.dat_common = BETAL.dat(BETAL_index);
E224_Probe.dat_common = E224_Probe.dat(E224_Probe_index);
DS_GOLD.dat_common = DS_GOLD.dat(DS_GOLD_index);
