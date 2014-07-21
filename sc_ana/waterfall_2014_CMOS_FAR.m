clear all;

header = '';
% header = '/Volumes/PWFA_4big';
nas  ='/nas/nas-li20-pm00/';
expt = 'E200';
year = '/2014/';
day  = '20140625/';
dataset = '13449';
pyro_cut = [0 20000];
% pyro_cut = [13000 16000];
laser_on_threshold = 0.5e7;

data_path = [nas expt year day expt '_' dataset '/' expt '_' dataset '.mat'];

%% Load data
load([header data_path]);

EPICS_UID = data.raw.scalars.PATT_SYS1_1_PULSEID.UID;
CMOS_FAR = data.raw.images.CMOS_FAR;
ELANEX = data.raw.images.ELANEX;
% SYAG = data.raw.images.SYAG;
% BETAL = data.raw.images.BETAL;
E224_Probe = data.raw.images.E224_Probe;

PYRO = data.raw.scalars.BLEN_LI20_3014_BRAW;
PYRO_CUT_UID = PYRO.UID(PYRO.dat>pyro_cut(1) & PYRO.dat<pyro_cut(2));

COMMON_UID = intersect(EPICS_UID,CMOS_FAR.UID);
COMMON_UID = intersect(COMMON_UID,ELANEX.UID);
% COMMON_UID = intersect(COMMON_UID,SYAG.UID);
% COMMON_UID = intersect(COMMON_UID,BETAL.UID);
COMMON_UID = intersect(COMMON_UID,E224_Probe.UID);
COMMON_UID = intersect(COMMON_UID,PYRO_CUT_UID);
n_common = numel(COMMON_UID);

[~,~,EPICS_index] = intersect(COMMON_UID,data.raw.scalars.PATT_SYS1_1_PULSEID.UID);
[~,~,CMOS_FAR_index] = intersect(COMMON_UID,CMOS_FAR.UID);
[~,~,ELANEX_index] = intersect(COMMON_UID,ELANEX.UID);
% [~,~,BETAL_index] = intersect(COMMON_UID,SYAG.UID);
% [~,~,BETAL_index] = intersect(COMMON_UID,BETAL.UID);
[~,~,E224_Probe_index] = intersect(COMMON_UID,E224_Probe.UID);

step_num       = data.raw.scalars.step_num.dat(EPICS_index);
step_val       = data.raw.scalars.step_value.dat(EPICS_index);
n_step = numel(unique(step_num));

PYRO.dat_common = data.raw.scalars.BLEN_LI20_3014_BRAW.dat(EPICS_index);
CMOS_FAR.dat_common = CMOS_FAR.dat(CMOS_FAR_index);
ELANEX.dat_common = ELANEX.dat(ELANEX_index);
% SYAG.dat_common = SYAG.dat(SYAG_index);
% BETAL.dat_common = BETAL.dat(BETAL_index);
E224_Probe.dat_common = E224_Probe.dat(E224_Probe_index);



%% Determine laser on/off with E224_Probe

laser_on_E224 = zeros(1,n_common);
for i=1:n_common
    if isempty(E224_Probe.dat_common{i}); continue; end;
    laser_on_E224(i) = sum(sum(imread(E224_Probe.dat_common{i})));
end;
laser_on = laser_on_E224 > laser_on_threshold;

%% CMOS_FAR chunk
% CMOS_FAR_bg = load([header CMOS_FAR.background_dat{1}]);

cmos_far_roi.top = 1000;
cmos_far_roi.bottom = 1900;
cmos_far_roi.left = 345-100;
cmos_far_roi.right = 345+100;
cmos_far_roi.rot = 1;
cmos_far_roi.fliplr = 0;
cmos_far_roi.flipud = 0;

CMOS_FAR_ANA = basic_image_ana(CMOS_FAR,0,cmos_far_roi,header);

%% Energy axis for CMOS FAR

B5D36 = getB5D36(data.raw.metadata.E200_state.dat{1});
if( str2num(day(1:8)) > 20140521 )
    % after 2014 QS quad move
    E_CMOS_FAR = E200_Eaxis_ana(1:2559, 1597, 62.65e-6,  2016.0398, 6e-3, B5D36);
else
    % before 2014 QS quad move
    E_CMOS_FAR = E200_Eaxis_ana(1:2559, 1623, 62.65e-6,  2016.0398, 6e-3, B5D36);
end
E_CMOS_FAR = E_CMOS_FAR(cmos_far_roi.top:cmos_far_roi.bottom);

%% Waterfall image

CMOS_FAR_SPECS = CMOS_FAR_ANA.y_profs(:,:) - 2200;
CMOS_FAR_SPECS(CMOS_FAR_SPECS<1) = 1;

%% Plotting below

cmap  = custom_cmap();

cond = step_num<6 | step_num >10;

n_ON = sum(laser_on & cond);
n_OFF = n_common - n_ON;

CMOS_FAR_SPECS_laser_on = CMOS_FAR_SPECS(:,laser_on & cond);
PYRO2 = PYRO.dat_common(laser_on & cond);
step_num2 = step_num(laser_on & cond);
[~, ind] = sort(PYRO2);
CMOS_FAR_SPECS_laser_on = CMOS_FAR_SPECS_laser_on(:,ind);
PYRO2 = PYRO2(ind);
step_num2 = step_num2(ind);
[~, ind2] = sort(step_num2);
CMOS_FAR_SPECS_laser_on = CMOS_FAR_SPECS_laser_on(:,ind2);
PYRO2 = PYRO2(ind2);
step_num2 = step_num2(ind2);
n_step2 = numel(unique(step_num2));

figure(1)
set(gcf,'color','w');
set(gca,'fontsize',14);
subplot(3,1,[1 2]);
pcolor(1:n_ON,E_CMOS_FAR,log10(CMOS_FAR_SPECS_laser_on)); shading flat; box off; colorbar;
% xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
XTick_position  = find(diff(step_num2))+1;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num2)])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num2)));
colormap(cmap.wbgyr);
% set(gca, 'YTick', []);
for i = 1:(n_step2-1)
    line([XTick_position(i) XTick_position(i)],[E_CMOS_FAR(1) E_CMOS_FAR(end)],'color','k','linestyle','--');
end

ylabel('Energy [GeV]','fontsize',14);
title(['Dataset ' dataset '. QS scan with CMOS FAR. Laser On'],'fontsize',14);
% title(['Dataset ' dataset '. Phase ramp scan with ELANEX.'],'fontsize',14);
caxis([1.5 4.5]);
ylim([E_CMOS_FAR(1) E_CMOS_FAR(end)]);

subplot(313);
plot(PYRO2);
for i = 1:(n_step2-1)
    line([XTick_position(i) XTick_position(i)],[pyro_cut(1) pyro_cut(end)],'color','k','linestyle','--','linewidth',2);
end
box off;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num2)])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num2)));
% xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
ylabel('Pyro [arb. u.]','fontsize',14);
xlim([0 length(step_num2)]);
% ylim(pyro_cut);

saveas(1, ['~/corde/work/' expt '_' dataset '_CMOS_FAR_waterfall_Pyro_Cut_' num2str(pyro_cut(1)) '_' num2str(pyro_cut(2))], 'fig');
saveas(1, ['~/corde/work/' expt '_' dataset '_CMOS_FAR_waterfall_Pyro_Cut_' num2str(pyro_cut(1)) '_' num2str(pyro_cut(2))], 'png');
% saveas(1, ['/nas/nas-li20-pm00/' data.raw.metadata.param.dat{1}.tail_path '/' expt '_' dataset '_ELANEX_waterfall_Pyro_Cut_' num2str(pyro_cut(1)) '_' num2str(pyro_cut(2))], 'fig');

%%
% figure(2)
% set(gcf,'color','w');
% set(gca,'fontsize',14);
% subplot(3,1,[1 2]);
% pcolor(1:n_OFF,E_CMOS_FAR,CMOS_FAR_SPECS(:,~laser_on)); shading flat; box off; colorbar;
% xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% % xlabel('Phase ramp','fontsize',14);
% XTick_position  = find(diff(step_num(~laser_on)))+1;
% set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num(~laser_on))])/2);
% set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num(~laser_on))));
% colormap(cmap.wbgyr);
% % set(gca, 'YTick', []);
% for i = 1:(n_step-1)
%     line([XTick_position(i) XTick_position(i)],[E_CMOS_FAR(1) E_CMOS_FAR(end)],'color','k','linestyle','--');
% end
% 
% ylabel('Energy [GeV]','fontsize',14);
% title(['Dataset ' dataset '. QS scan with CMOS FAR. Laser Off'],'fontsize',14);
% % title(['Dataset ' dataset '. Phase ramp scan with ELANEX.'],'fontsize',14);
% caxis([0 2000]);
% ylim([E_CMOS_FAR(1) E_CMOS_FAR(end)]);
% 
% subplot(313);
% plot(PYRO.dat_common(~laser_on));
% for i = 1:(n_step-1)
%     line([XTick_position(i) XTick_position(i)],[pyro_cut(1) pyro_cut(end)],'color','k','linestyle','--','linewidth',2);
% end
% box off;
% set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num(~laser_on))])/2);
% set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num(~laser_on))));
% xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% % xlabel('Phase ramp','fontsize',14);
% ylabel('Pyro [arb. u.]','fontsize',14);
% xlim([0 length(step_num(~laser_on))]);
% ylim(pyro_cut);



