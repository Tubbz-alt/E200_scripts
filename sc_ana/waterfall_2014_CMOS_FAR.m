clear all;

% header = '';
header = '/Volumes/PWFA_4big';
nas  ='/nas/nas-li20-pm00/';
expt = 'E200';
year = '/2014/';
day  = '20140609/';
dataset = '13284';
pyro_cut = [0 15000];
pyro_cut = [5500 7000];


data_path = [nas expt year day expt '_' dataset '/' expt '_' dataset '.mat'];

%% Load data
load([header data_path]);

n_step         = data.raw.metadata.n_steps;
step_num       = data.raw.scalars.step_num.dat;
step_val       = data.raw.scalars.step_value.dat;

EPICS_UID = data.raw.scalars.PATT_SYS1_1_PULSEID.UID;
PYRO = data.raw.scalars.BLEN_LI20_3014_BRAW;
PYRO_CUT_UID = PYRO.UID(PYRO.dat>pyro_cut(1) & PYRO.dat<pyro_cut(2));

[~,PYRO_CUT_index,~] = intersect(EPICS_UID,PYRO_CUT_UID);
step_num = step_num(PYRO_CUT_index);
step_val = step_val(PYRO_CUT_index);
PYRO_CUT_DAT = PYRO.dat(PYRO_CUT_index);

%% CMOS_FAR chunk
CMOS_FAR = data.raw.images.CMOS_FAR;
CMOS_FAR_bg = load([header CMOS_FAR.background_dat{1}]);

[~,EPICS_index,CMOS_FAR_index] = intersect(PYRO_CUT_UID,CMOS_FAR.UID);
QS_VALS = step_val(EPICS_index);
STEPS = step_num(EPICS_index);
PYRO_CUT_DAT = PYRO_CUT_DAT(EPICS_index);

cmos_far_roi.top = 1;
cmos_far_roi.bottom = 2559;
cmos_far_roi.left = 280;
cmos_far_roi.right = 420;
cmos_far_roi.rot = 1;
cmos_far_roi.fliplr = 0;
cmos_far_roi.flipud = 0;

CMOS_FAR_ANA = basic_image_ana(CMOS_FAR,1,cmos_far_roi,header);

%% Energy axis for CMOS FAR

B5D36 = getB5D36(data.raw.metadata.E200_state.dat{1});
if( str2num(day(1:8)) > 20140521 )
    % after 2014 QS quad move
    E_CMOS_FAR = E200_Eaxis_ana(1:2559, 1597, 62.65e-6,  2016.0398, 6e-3, B5D36);
else
    % before 2014 QS quad move
    E_CMOS_FAR = E200_Eaxis_ana(1:2559, 1623, 62.65e-6,  2016.0398, 6e-3, B5D36);
end

%% Waterfall image

CMOS_FAR_SPECS = CMOS_FAR_ANA.y_profs(:,CMOS_FAR_index) - 1000;


%% Plotting below

cmap  = custom_cmap();

figure(1)
set(gcf,'color','w');
set(gca,'fontsize',14);
subplot(3,1,[1 2]);
pcolor(1:numel(CMOS_FAR_index),E_CMOS_FAR,CMOS_FAR_SPECS); shading flat; box off; colorbar;
xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
XTick_position  = find(diff(step_num))+1;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num)])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list);
colormap(cmap.wbgyr);
% set(gca, 'YTick', []);
for i = 1:(n_step-1)
    line([XTick_position(i) XTick_position(i)],[E_CMOS_FAR(1) E_CMOS_FAR(end)],'color','k','linestyle','--');
end

ylabel('Energy [GeV]','fontsize',14);
title(['Dataset ' dataset '. QS scan with CMOS FAR.'],'fontsize',14);
% title(['Dataset ' dataset '. Phase ramp scan with ELANEX.'],'fontsize',14);
caxis([0 5000]);
ylim([10 30]);

subplot(313);
plot(PYRO_CUT_DAT);
for i = 1:(n_step-1)
    line([XTick_position(i) XTick_position(i)],[pyro_cut(1) pyro_cut(end)],'color','k','linestyle','--','linewidth',2);
end
box off;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num)])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list);
xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
ylabel('Pyro [arb. u.]','fontsize',14);
xlim([0 length(step_num)]);
ylim(pyro_cut);

% saveas(1, ['/nas/nas-li20-pm00/' data.raw.metadata.param.dat{1}.tail_path '/' expt '_' dataset '_ELANEX_waterfall_Pyro_Cut_' num2str(pyro_cut(1)) '_' num2str(pyro_cut(2))], 'fig');




