clear all;

% header = '';
header = '/Volumes/PWFA_4big';
nas  ='/nas/nas-li20-pm00/';
expt = 'E200';
year = '/2014/';
day  = '20140531/';
dataset = '13094';
pyro_cut = [0 20000];
% pyro_cut = [13000 16000];
laser_on_threshold = 2;

data_path = [nas expt year day expt '_' dataset '/' expt '_' dataset '.mat'];
cmap  = custom_cmap();

% Pixel position of 20.35 GeV beam on CMOS FAR
if( str2num(day(1:8)) > 20140521 )
    pix_E0 = 1597; % after 2014 QS quad move
else
    pix_E0 = 1623; % before 2014 QS quad move
end
pix_E0 = 1585.7;  % Overwrite expected position

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



%% Select common UID (including pyro cut)
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

%% Determine laser on/off with laser power
laser_on_lsrpwr = zeros(1,n_common);
for i=1:n_common
    if isempty(laser_power.dat_common(i)); continue; end;
    laser_on_lsrpwr(i) = laser_power.dat_common(i);
end
laser_on = laser_on_lsrpwr > laser_on_threshold;

%% Determine laser on/off with E224_Probe

laser_on_E224 = zeros(1,n_common);
for i=1:n_common
    if isempty(E224_Probe.dat_common{i}); continue; end;
    laser_on_E224(i) = sum(sum(imread([header E224_Probe.dat_common{i}])));
end;
laser_on = laser_on_E224 > laser_on_threshold;



%% Determine laser on/off with DS_GOLD

laser_on_DS_GOLD = zeros(1,n_common);
for i=1:n_common
    if isempty(DS_GOLD.dat_common{i}); continue; end;
    laser_on_DS_GOLD(i) = sum(sum(imread([header DS_GOLD.dat_common{i}])));
end;
laser_on = laser_on_DS_GOLD > laser_on_threshold;



%% Energy axis for CMOS FAR

B5D36 = getB5D36(data.raw.metadata.E200_state.dat{1});
E_CMOS_FAR = E200_Eaxis_ana(1:2559, pix_E0, 62.65e-6,  2016.0398, 6e-3, B5D36);
E_CMOS_FAR = E_CMOS_FAR(cmos_far_roi.top:cmos_far_roi.bottom);



%% CMOS_FAR chunk

CMOS_FAR = image_ana_init(CMOS_FAR,1,cmos_far_roi,header);
% load('~/Dropbox/Data_Analysis/Backgrounds/CMOS_FAR_20140625_good_background.mat');
% CMOS_FAR.ana.bg.img = double(CMOS_FAR_20140625_good_background);
for i=1:n_common
    [CMOS_FAR, image] = image_ana(CMOS_FAR,1,cmos_far_roi,header,i);
%     image = image - 2144;
    image(image<1) = 1;
    figure(3); pcolor(1:size(image,2),E_CMOS_FAR,log10(image)); shading flat; colormap(cmap.wbgyr); caxis([2 4.5]); pause(0.01);
end



%% Waterfall image

CMOS_FAR_SPECS = CMOS_FAR.ana.y_profs(:,:);% - 2144;
CMOS_FAR_SPECS(CMOS_FAR_SPECS<1) = 1;

%% Plotting below

% cond = step_num<6 | step_num >10;
% cond = step_num<20;

% n_ON = sum(laser_on & cond);
n_ON = sum(laser_on);
n_OFF = n_common - n_ON;

CMOS_FAR_SPECS_laser_on = CMOS_FAR_SPECS(:,laser_on);
PYRO2 = PYRO.dat_common(laser_on);
step_num2 = step_num(laser_on);
% [~, ind] = sort(PYRO2);
% CMOS_FAR_SPECS_laser_on = CMOS_FAR_SPECS_laser_on(:,ind);
% PYRO2 = PYRO2(ind);
% step_num2 = step_num2(ind);
% [~, ind2] = sort(step_num2);
% CMOS_FAR_SPECS_laser_on = CMOS_FAR_SPECS_laser_on(:,ind2);
% PYRO2 = PYRO2(ind2);
% step_num2 = step_num2(ind2);
n_step2 = numel(unique(step_num2));

figure(1)
set(gcf,'color','w');
set(gca,'fontsize',14);
subplot(3,1,[1 2]);
pcolor(1:n_ON,E_CMOS_FAR,log10(CMOS_FAR_SPECS_laser_on)); shading flat; box  off; colorbar;
xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
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
caxis([0 4]);
ylim([E_CMOS_FAR(1) E_CMOS_FAR(end)]);

subplot(313);
plot(PYRO2);
for i = 1:(n_step2-1)
    line([XTick_position(i) XTick_position(i)],[pyro_cut(1) pyro_cut(end)],'color','k','linestyle','--','linewidth',2);
end
box off;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num2)])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num2)));
xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
ylabel('Pyro [arb. u.]','fontsize',14);
xlim([0 length(step_num2)]);
% ylim(pyro_cut);

% saveas(1, ['~/corde/work/' expt '_' dataset '_CMOS_FAR_waterfall_Pyro_Cut_' num2str(pyro_cut(1)) '_' num2str(pyro_cut(2))], 'fig');
% saveas(1, ['~/corde/work/' expt '_' dataset '_CMOS_FAR_waterfall_Pyro_Cut_' num2str(pyro_cut(1)) '_' num2str(pyro_cut(2))], 'png');
% saveas(1, ['/nas/nas-li20-pm00/' data.raw.metadata.param.dat{1}.tail_path '/' expt '_' dataset '_ELANEX_waterfall_Pyro_Cut_' num2str(pyro_cut(1)) '_' num2str(pyro_cut(2))], 'fig');
% saveas(1, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_CMOS_FAR_waterfall_Laser_On'], 'png');



%%
figure(2)
set(gcf,'color','w');
set(gca,'fontsize',14);
subplot(3,1,[1 2]);
pcolor(1:n_OFF,E_CMOS_FAR,log10(CMOS_FAR_SPECS(:,~laser_on))); shading flat; box off; colorbar;
xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
XTick_position  = find(diff(step_num(~laser_on)))+1;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num(~laser_on))])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num(~laser_on))));
colormap(cmap.wbgyr);
% set(gca, 'YTick', []);
for i = 1:(n_step-1)
    line([XTick_position(i) XTick_position(i)],[E_CMOS_FAR(1) E_CMOS_FAR(end)],'color','k','linestyle','--');
end

ylabel('Energy [GeV]','fontsize',14);
title(['Dataset ' dataset '. QS scan with CMOS FAR. Laser Off'],'fontsize',14);
% title(['Dataset ' dataset '. Phase ramp scan with ELANEX.'],'fontsize',14);
caxis([0 4]);
ylim([E_CMOS_FAR(1) E_CMOS_FAR(end)]);

subplot(313);
plot(PYRO.dat_common(~laser_on));
for i = 1:(n_step-1)
    line([XTick_position(i) XTick_position(i)],[pyro_cut(1) pyro_cut(end)],'color','k','linestyle','--','linewidth',2);
end
box off;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num(~laser_on))])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num(~laser_on))));
xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
ylabel('Pyro [arb. u.]','fontsize',14);
xlim([0 length(step_num(~laser_on))]);
ylim(pyro_cut);

saveas(2, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_CMOS_FAR_waterfall_Laser_Off'], 'png');


