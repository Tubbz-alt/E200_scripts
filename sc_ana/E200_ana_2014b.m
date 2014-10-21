
% Script to analyze E200 2014 data with the new processed data structure.

% Sebastien Corde
% Create: July 2014
% Last edit: October 18, 2014

%%
clear all;



%% Path and dataset

% header = '';
% header = '/Volumes/PWFA_4big';
header = '~/PWFA_4big';
nas  ='/nas/nas-li20-pm00/';
expt = 'E200';
year = '/2014/';
day  = '20140629/';
dataset = '13537';
pyro_cut = [100 20000];
% pyro_cut = [13000 18000];
laser_on_threshold = 0.5e7;

data_path = [nas expt year day expt '_' dataset '/' expt '_' dataset '.mat'];
cmap  = custom_cmap();

do_save_image = 1;

addpath('~/Dropbox/SeB/Papers/__In_Preparation__2014_Corde_High_Gradient_Positron_Acceleration/Data Analysis/Energy Axis/');

%% CMOS FAR settings

% Pixel position of 20.35 GeV beam on CMOS FAR
if( str2num(day(1:8)) > 20140521 )
    pix_E0 = 1597; % after 2014 QS quad move
else
    pix_E0 = 1623; % before 2014 QS quad move
end
% pix_E0 = 1572;  % Overwrite expected position
% pix_E0 = 1589;  % Good for 20140625 E200_13450 QS = 0
% pix_E0 = 1572;  % Good for 20140625 E200_13450 QS = 4.5
pix_E0 = 1593;  % Good for 20140625 E200_13445 to E200_13449, all QS
% pix_E0 = 1600;  % Good for 20140629 E200_13537 (to be verified with more Interaction Off shots)

% Charge calibration for CMOS FAR
cmos_far_charge_calib = 66; % in number of e-/e+ per count

% ROI for CMOS FAR
cmos_far_roi.top = 1;
cmos_far_roi.bottom = 2559;
cmos_far_roi.left = 71;
cmos_far_roi.right = 710;
% cmos_far_roi.left = 335-250; % Good for 20140625 E200_13445
% cmos_far_roi.right = 335+350; % Good for 20140625 E200_13445
% cmos_far_roi.left = 385-150; % Good for 20140625 E200_13448 to E200_13449
% cmos_far_roi.right = 385+150; % Good for 20140625 E200_13448 to E200_13449
% cmos_far_roi.left = 345-300; % Good for 20140625 E200_13450
% cmos_far_roi.right = 345+300; % Good for 20140625 E200_13450
% cmos_far_roi.left = 385-310; % Good for 20140629 E200_13537
% cmos_far_roi.right = 385+310; % Good for 20140629 E200_13537
% cmos_far_roi.left = 200; % Good for 20140629 E200_13543
% cmos_far_roi.right = 550; % Good for 20140629 E200_13543
cmos_far_roi.rot = 1;
cmos_far_roi.fliplr = 0;
cmos_far_roi.flipud = 0;

box_width = 100;

box.top = 100;      % For E200_13537
box.bottom = 2559;  % For E200_13537
box.left = 1;     % For E200_13537
box.right = 640;    % For E200_13537

cmos_far_roi.mask = ones(cmos_far_roi.bottom-cmos_far_roi.top+1, cmos_far_roi.right-cmos_far_roi.left+1);
cmos_far_roi.mask(box.top:box.bottom,box.left:box.right) = 0;
cmos_far_roi.mask = cmos_far_roi.mask==1;


%% ELANEX settings

elanex_roi.top = 1;
elanex_roi.bottom = 734;
elanex_roi.left = 1;
elanex_roi.right = 1292;
elanex_roi.rot = 0;
elanex_roi.fliplr = 0;
elanex_roi.flipud = 0;



%% Mount PWFA_4big if header does not exist
user = 'corde';

if ~exist(header,'dir')
    system(['mkdir ' header]);
    system(['/usr/local/bin/sshfs ' user '@quickpicmac3.slac.stanford.edu:/Volumes/PWFA_4big/' ' ' header]);
    pause(2);
end



%% Load raw data
load([header data_path]);



%% Load post-processed data
load(['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '.mat']);



%% Select common UID (including pyro cut)

EPICS_UID = data.raw.scalars.PATT_SYS1_1_PULSEID.UID;
CMOS_FAR = data.raw.images.CMOS_FAR;
ELANEX = data.raw.images.ELANEX;
SYAG = data.raw.images.SYAG;
BETAL = data.raw.images.BETAL;
E224_Probe = data.raw.images.E224_Probe;
% DS_GOLD = data.raw.images.DS_GOLD;

PYRO = data.raw.scalars.BLEN_LI20_3014_BRAW;
PYRO_CUT_UID = PYRO.UID(PYRO.dat>pyro_cut(1) & PYRO.dat<pyro_cut(2));

COMMON_UID = intersect(EPICS_UID,CMOS_FAR.UID);
COMMON_UID = intersect(COMMON_UID,ELANEX.UID);
COMMON_UID = intersect(COMMON_UID,SYAG.UID);
COMMON_UID = intersect(COMMON_UID,BETAL.UID);
COMMON_UID = intersect(COMMON_UID,E224_Probe.UID);
% COMMON_UID = intersect(COMMON_UID,DS_GOLD.UID);
COMMON_UID = intersect(COMMON_UID,PYRO_CUT_UID);
n_common = numel(COMMON_UID);

[~,~,EPICS_index] = intersect(COMMON_UID,data.raw.scalars.PATT_SYS1_1_PULSEID.UID);
[~,~,CMOS_FAR_index] = intersect(COMMON_UID,CMOS_FAR.UID);
[~,~,ELANEX_index] = intersect(COMMON_UID,ELANEX.UID);
[~,~,SYAG_index] = intersect(COMMON_UID,SYAG.UID);
[~,~,BETAL_index] = intersect(COMMON_UID,BETAL.UID);
[~,~,E224_Probe_index] = intersect(COMMON_UID,E224_Probe.UID);
% [~,~,DS_GOLD_index] = intersect(COMMON_UID,DS_GOLD.UID);

step_num       = data.raw.scalars.step_num.dat(EPICS_index);
step_val       = data.raw.scalars.step_value.dat(EPICS_index);
vals = unique(step_val);
n_step = numel(unique(step_num));

PYRO.dat_common = data.raw.scalars.BLEN_LI20_3014_BRAW.dat(EPICS_index);
CMOS_FAR.dat_common = CMOS_FAR.dat(CMOS_FAR_index);
CMOS_FAR.UID_common = CMOS_FAR.UID(CMOS_FAR_index);
ELANEX.dat_common = ELANEX.dat(ELANEX_index);
SYAG.dat_common = SYAG.dat(SYAG_index);
BETAL.dat_common = BETAL.dat(BETAL_index);
E224_Probe.dat_common = E224_Probe.dat(E224_Probe_index);
% DS_GOLD.dat_common = DS_GOLD.dat(DS_GOLD_index);

USTORO = data.raw.scalars.GADC0_LI20_EX01_AI_CH2_;
USTORO.dat_common = USTORO.dat(EPICS_index);
DSTORO = data.raw.scalars.GADC0_LI20_EX01_AI_CH3_;
DSTORO.dat_common = DSTORO.dat(EPICS_index);
TORO = data.raw.scalars.GADC0_LI20_EX01_AI_CH0_;
TORO.dat_common = TORO.dat(EPICS_index);



%% Determine laser on/off with E224_Probe

laser_on_E224 = zeros(1,n_common);
for i=1:n_common
    if isempty(E224_Probe.dat_common{i}); continue; end;
    laser_on_E224(i) = sum(sum(imread([header E224_Probe.dat_common{i}])));
end;
laser_on = laser_on_E224 > laser_on_threshold;



%% Determine laser on/off with DS_GOLD

% laser_on_DS_GOLD = zeros(1,n_common);
% for i=1:n_common
%     if isempty(DS_GOLD.dat_common{i}); continue; end;
%     laser_on_DS_GOLD(i) = sum(sum(imread([header DS_GOLD.dat_common{i}])));
% end;
% laser_on = laser_on_DS_GOLD > laser_on_threshold;
% 
% n_ON = sum(laser_on);
% n_OFF = n_common - n_ON;


%% Energy axis for CMOS FAR

B5D36 = getB5D36(data.raw.metadata.E200_state.dat{1});
E_CMOS_FAR = E200_Eaxis_ana(1:2559, pix_E0, 62.65e-6,  2016.0398, 5.73e-3, B5D36);
E_CMOS_FAR = E_CMOS_FAR(cmos_far_roi.top:cmos_far_roi.bottom);



%% CMOS_FAR image analysis

% mkdir(['~/Dropbox/Data_Analysis/' expt '_' dataset '/shots/']);
mkdir(['~/Dropbox/Data_Analysis/' expt '_' dataset '/laser_off_shots/']);
mkdir(['~/Dropbox/Data_Analysis/' expt '_' dataset '/laser_on_shots/']);

figure(3);
set(gcf,'color','w');
set(gcf,'paperposition',[0,0,24,8]);

CMOS_FAR = image_ana_init(CMOS_FAR,1,cmos_far_roi,header);
load('~/Dropbox/Data_Analysis/Backgrounds/CMOS_FAR_20140625_good_background.mat');
% CMOS_FAR.ana.bg.img = double(CMOS_FAR_20140625_good_background);
for i=1:n_common
    [CMOS_FAR, image] = image_ana(CMOS_FAR,2,cmos_far_roi,header,i);
    E_CMOS_FAR = Energy_Axis(dataset, step_val(i));
    E_CMOS_FAR = E_CMOS_FAR(cmos_far_roi.top:cmos_far_roi.bottom);
    CMOS_FAR.ana.charge_calib = cmos_far_charge_calib;
    [CMOS_FAR, filt_img] = Ana_Energy(CMOS_FAR, E_CMOS_FAR, image, box_width, i);
    if do_save_image;
        image(image<1) = 1;
        filt_img(filt_img<1) = 1;
        figure(3); clf;
        subplot(141);
        xx = ( (1:size(image,2)) - size(image,2)/2 ) * CMOS_FAR.RESOLUTION(i)*1e-3;
%         pcolor(xx,E_CMOS_FAR,log10(image)); shading flat; colormap(cmap.wbgyr);
        pcolor(xx,1:cmos_far_roi.bottom,log10(image)); shading flat; colormap(cmap.wbgyr);
        xlim([xx(1) xx(end-1)])
%         ylim([E_CMOS_FAR(1) 30])
        caxis([1 4.5]);
        xlabel('x (mm)', 'fontsize', 26);
        ylabel('E (GeV)', 'fontsize', 26);
        cb = colorbar();
        set(cb, 'YTick', [0 1 2 3 4]);
        set(cb, 'YTickLabel', [1 10 100 1000 10000]);
        set(gca, 'Fontsize', 20);
        subplot(142);
%         pcolor(xx,E_CMOS_FAR,image); shading flat; colormap(cmap.wbgyr);
        pcolor(xx,1:cmos_far_roi.bottom,image); shading flat; colormap(cmap.wbgyr);
        xlim([xx(1) xx(end-1)])
%         ylim([E_CMOS_FAR(1) 30])
        caxis([0 5000]);
        xlabel('x (mm)', 'fontsize', 26);
        ylabel('E (GeV)', 'fontsize', 26);
        title(['Shot ' num2str(CMOS_FAR.UID_common(i),'%d')], 'fontsize', 26);
        cb = colorbar();
        set(gca, 'Fontsize', 20);
        subplot(143);
%         pcolor(xx,E_CMOS_FAR,log10(filt_img)); shading flat; colormap(cmap.wbgyr);
        pcolor(xx,1:cmos_far_roi.bottom,log10(filt_img)); shading flat; colormap(cmap.wbgyr);
        xlim([xx(1) xx(end-1)])
%         ylim([E_CMOS_FAR(1) 30])
        caxis([1 4.5]);
        xlabel('x (mm)', 'fontsize', 26);
        ylabel('E (GeV)', 'fontsize', 26);
        cb = colorbar();
        set(cb, 'YTick', [0 1 2 3 4]);
        set(cb, 'YTickLabel', [1 10 100 1000 10000]);
        set(gca, 'Fontsize', 20);
        subplot(144);
        plot(E_CMOS_FAR, CMOS_FAR.ana.energy_spectrum(:,i), 'b'); hold on;
        plot(E_CMOS_FAR, CMOS_FAR.ana.energy_spectrum_2(:,i), 'r'); hold off;
        xlim([E_CMOS_FAR(1) 30]);
        ylim([-11 150]);
        xlabel('E (GeV)', 'fontsize', 26);
        ylabel('dQ/dE (pC/GeV)', 'fontsize', 26);
        set(gca, 'Fontsize', 20);
        legend({'Full Box', ['Small Box (' num2str(box_width) ' pix wide)']}, 'location', 'Northwest', 'fontsize', 18);
        if laser_on(i); string = 'laser_on'; else string = 'laser_off'; end;
        saveas(3, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' string '_shots/' expt '_' dataset '_CMOS_FAR_' string '_Shot_' num2str(CMOS_FAR.UID_common(i),'%d')], 'png');
%         saveas(3, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/shots/' expt '_' dataset '_CMOS_FAR_Shot_' num2str(CMOS_FAR.UID_common(i),'%d')], 'png');
    end
end



%% Save variables to file

if exist(['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '.mat'], 'file')
    save(['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '.mat'], ...
        'data', 'laser_on', 'pyro_cut', 'EPICS_index', 'COMMON_UID', 'CMOS_FAR', ...
        'cmos_far_roi', 'pix_E0', 'box_width', 'E_CMOS_FAR', 'ELANEX', 'elanex_roi', ...
        'PYRO', 'TORO', 'USTORO', 'DSTORO', 'n_common', 'n_step', 'step_num', 'step_val', ...
        'vals', '-append');
else
    save(['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '.mat'], ...
        'data', 'laser_on', 'pyro_cut', 'EPICS_index', 'COMMON_UID', 'CMOS_FAR', ...
        'cmos_far_roi', 'pix_E0', 'box_width', 'E_CMOS_FAR', 'ELANEX', 'elanex_roi', ...
        'PYRO', 'TORO', 'USTORO', 'DSTORO', 'n_common', 'n_step', 'step_num', 'step_val', ...
        'vals');
end



%% CMOS FAR: for each step and for laser On and Off, print one plot with all shots

figure(4); 
set(gcf,'color','w');
set(gcf,'paperposition',[0,0,20,6]);
    
list = 1:n_common;
for i=unique(step_num)
    for string={'Laser_On', 'Laser_Off'}
        if strcmp(string, 'Laser_On');
            cond = step_num == i & laser_on;
        else
            cond = step_num == i & ~laser_on;
        end
        
%         cond = cond & sorting_variable<0.21 & sorting_variable>0.09;
        
        shots = list(cond);
        n_shots = sum(cond);
        
        k = 1;
        figure(4); clf;
        for j=shots
            [CMOS_FAR, image] = image_ana(CMOS_FAR,1,cmos_far_roi,header,j);
            xx = ( (1:size(image,2)) - size(image,2)/2 ) * CMOS_FAR.RESOLUTION(j)*1e-3;
            image(image<1) = 1;
            figure(4);
            subplot(1,n_shots,k)
            pcolor(xx,E_CMOS_FAR,log10(image)); shading flat;
            colormap(cmap.wbgyr);
            caxis([1 4.5]);
            set(gca, 'Fontsize', 14);
            xlabel('x (mm)', 'fontsize', 12);
            if k>1
                set(gca, 'YTick', []);
            else
                ylabel('E (GeV) ', 'fontsize', 20);
            end;
            ylim([E_CMOS_FAR(1) 30])
            pause(0.01);
            k = k+1;
        end
%         saveas(4, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_CMOS_FAR_Many_shots_' char(string) '_Step_' num2str(i)], 'png');
    end
end



%% ELANEX: for each step and for laser On and Off, print one plot with all shots

figure(5); 
set(gcf,'color','w');
set(gcf,'paperposition',[0,0,20,6]);
    
ELANEX = image_ana_init(ELANEX,1,elanex_roi,header);
list = 1:n_common;
for i=unique(step_num)
    E_ELANEX = get_ELANEX_axis(unique(step_val(step_num==i)));
    for string={'Laser_On', 'Laser_Off'}
        if strcmp(string, 'Laser_On');
            cond = step_num == i & laser_on;
        else
            cond = step_num == i & ~laser_on;
        end
        
        shots = list(cond);
        n_shots = sum(cond);
        
        k = 1;
        figure(5); clf;
         
        for j=shots
            [ELANEX, image] = image_ana(ELANEX,1,elanex_roi,header,j);
            xx = ( (1:size(image,2)) - size(image,2)/2 ) * ELANEX.RESOLUTION(j)*1e-3/sqrt(2);
            image(image<1) = 1;
            figure(5);
            subplot(1,n_shots,k)
            pcolor(xx,E_ELANEX,image); shading flat;
            colormap(cmap.wbgyr);
            caxis([0 1500]);
            set(gca, 'Fontsize', 14);
            xlabel('x (mm)', 'fontsize', 12);
            if k>1
                set(gca, 'YTick', []);
            else
                ylabel('E (GeV)', 'fontsize', 26);
            end;
            ylim([E_ELANEX(end) E_ELANEX(1)])
            pause(0.01);
            k = k+1;
        end
        saveas(5, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_ELANEX_Many_shots_' char(string) '_Step_' num2str(i)], 'png');
    end
end



%% CMOS FAR Waterfall Plot for Laser On

CMOS_FAR_SPECS = CMOS_FAR.ana.y_profs(:,:)+20;
CMOS_FAR_SPECS2 = CMOS_FAR.ana.y_maxs(:,:);
CMOS_FAR_SPECS3 = CMOS_FAR.ana.y_profs_small_box(:,:);
CMOS_FAR_SPECS(CMOS_FAR_SPECS<1) = 1;
CMOS_FAR_SPECS2(CMOS_FAR_SPECS2<1) = 1;
CMOS_FAR_SPECS3(CMOS_FAR_SPECS3<1) = 1;


% sorting_variable = 9.4e-3 * (USTORO.dat_common - DSTORO.dat_common/1.0255); % Calibration with charge in unit of 10^10 e.
% sorting_variable = (9.4e-3 * USTORO.dat_common);
sorting_variable = PYRO.dat_common;
% sorting_variable = CMOS_FAR.ana.E_EMAX3;

% sorting_variable_label = 'Charge difference [10^{10} e]';
% sorting_variable_label = 'Positron Charge [10^{10} e]';
sorting_variable_label = 'Pyro (arb. u.)';

% cond = sorting_variable<0.21 & sorting_variable>0.09 & laser_on;
cond = laser_on;

% cond = (9.4e-3 * USTORO.dat_common)>1.32 | step_num<4;
% cond = cond & step_num<6 & ~laser_on;

% cond = mod(step_num,5) == 1 & abs(PYRO.dat_common-700) < 500;
% cond = cond | (mod(step_num,5) == 2 & abs(PYRO.dat_common-5000) < 800);
% cond = cond | (mod(step_num,5) == 3 & abs(PYRO.dat_common-10800) < 1000);
% cond = cond | (mod(step_num,5) == 4 & abs(PYRO.dat_common-5000) < 800);
% cond = cond | (mod(step_num,5) == 5 & abs(PYRO.dat_common-15400) < 500);
% cond = cond & laser_on;

PYRO2 = PYRO.dat_common(cond);
USTORO2 = USTORO.dat_common(cond);
DSTORO2 = DSTORO.dat_common(cond);
TORO2 = TORO.dat_common(cond);
step_num2 = step_num(cond);
n_step2 = numel(unique(step_num2));

[~, ind] = sort(sorting_variable(cond));
[~, ind2] = sort(step_num2(ind));

sorting = 1:n_common;
sorting = sorting(cond);
% sorting = sorting(ind);
% sorting = sorting(ind2);
step_num2 = step_num(sorting);

figure(1)
set(gcf,'color','w');
set(gca,'fontsize',14);
set(gcf,'paperposition',[0,0,10,8]);
subplot(3,1,[1 2]); hold off;
pcolor(1:numel(sorting),1:2559,log10(CMOS_FAR_SPECS(:,sorting))); shading flat; box off; 
% pcolor(1:numel(sorting),E_CMOS_FAR,log10(CMOS_FAR_SPECS(:,sorting))); shading flat; box off; 
cb = colorbar();
% caxis([3.4 6.3]);
caxis([5.5 6.5]);
% caxis([4 log10(2^16)]);
set(cb, 'YTick', [0 1 2 3 4 log10(2^16) 5 6 7]);
set(cb, 'YTickLabel', [1 10 100 1000 10000 2^16 100000 1000000 1e7]);
xlabel('Imaging Energy Relative to 20.35 GeV (GeV) ','fontsize',14);
% xlabel('Phase ramp [deg.]','fontsize',14);
XTick_position  = find(diff(step_num2))+1;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num2)])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num2)));
colormap(cmap.wbgyr);
% set(gca, 'YTick', []);
for i = 1:(n_step2-1)
    line([XTick_position(i) XTick_position(i)],[E_CMOS_FAR(1) E_CMOS_FAR(end)],'color','k','linestyle','--');
end

% ylabel('Energy (GeV)','fontsize',14);
title(['Dataset ' dataset '. QS scan with CMOS FAR. Laser On '],'fontsize',14);
% title(['Dataset ' dataset '. Phase ramp scan with CMOS FAR. Laser On '],'fontsize',14);
% ylim([E_CMOS_FAR(1) E_CMOS_FAR(end)]);
% ylim([E_CMOS_FAR(1) 30])
ylim([1520 1650])

hold on
% plot((1:numel(sorting))+0.5,CMOS_FAR.ana.E_EMAX3(sorting),'mo', 'MarkerFaceColor', 'm');
% plot((1:numel(sorting))+0.5,CMOS_FAR.ana.E_EMIN3(sorting),'c^', 'MarkerFaceColor', 'c');
plot((1:numel(sorting))+0.5,y(sorting),'ko', 'MarkerFaceColor', 'k');
plot([1 1000],[2400 2400 ],'m-', 'linewidth', 2);
plot([1 1000],[2410 2410 ],'m-', 'linewidth', 2);

subplot(313);
plot(sorting_variable(sorting), 'o');
for i = 1:(n_step2-1)
    line([XTick_position(i) XTick_position(i)],[min(sorting_variable(sorting)) max(sorting_variable(sorting))],'color','k','linestyle','--','linewidth',2);
end
box off;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num2)])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num2)));
xlabel('Imaging Energy Relative to 20.35 GeV (GeV) ','fontsize',14);
% xlabel('Phase ramp [deg.]','fontsize',14);
ylabel(sorting_variable_label,'fontsize',14);
xlim([0 length(step_num2)]);
ylim([min(sorting_variable(sorting)) max(sorting_variable(sorting))]);

% saveas(1, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_CMOS_FAR_Waterfall_Laser_On_Charge_Difference_Sorting'], 'png');
%%
saveas(1, '~/Dropbox/SeB/Papers/__In_Preparation__2014_Corde_Positron_plasma_wakes/Data Analysis/Calibration of Quadrupole Doublet Dispersion/E200_13540_CMOS_FAR_waterfall_Laser_On_y_maxs', 'png');



%% CMOS FAR Waterfall Plot for Laser Off

figure(2)
set(gcf,'color','w');
set(gca,'fontsize',14);
set(gcf,'paperposition',[0,0,10,8]);
subplot(3,1,[1 2]);
% pcolor(1:sum(~laser_on),E_CMOS_FAR,log10(CMOS_FAR_SPECS(:,~laser_on))); shading flat; box off;
pcolor(1:sum(~laser_on),1:2559,log10(CMOS_FAR_SPECS(:,~laser_on))); shading flat; box off;
cb = colorbar();
% caxis([3.4 6.3]);
caxis([5.5 6.9]);
% caxis([3.5 log10(2^16)]);
set(cb, 'YTick', [0 1 2 3 4 log10(2^16) 5 6 7]);
set(cb, 'YTickLabel', [1 10 100 1000 10000 2^16 100000 1e6 1e7]);
% xlabel('Imaging Energy Relative to 20.35 GeV (GeV) ','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
XTick_position  = find(diff(step_num(~laser_on)))+1;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num(~laser_on))])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num(~laser_on))));
colormap(cmap.wbgyr);
% set(gca, 'YTick', []);
for i = 1:(n_step-1)
    line([XTick_position(i) XTick_position(i)],[E_CMOS_FAR(1) E_CMOS_FAR(end)],'color','k','linestyle','--');
end

% ylabel('Energy [GeV]','fontsize',14);
title(['Dataset ' dataset '. QS scan with CMOS FAR. Laser Off '],'fontsize',14);
% title(['Dataset ' dataset '. Phase ramp scan with ELANEX.'],'fontsize',14);
% ylim([E_CMOS_FAR(1) E_CMOS_FAR(end)]);
% ylim([E_CMOS_FAR(1) 30])
ylim([1520 1650])

hold on
% plot((1:sum(~laser_on))+0.5,CMOS_FAR.ana.E_EMAX3(~laser_on),'mo', 'MarkerFaceColor', 'm');
% plot((1:sum(~laser_on))+0.5,CMOS_FAR.ana.E_EMIN3(~laser_on),'c^', 'MarkerFaceColor', 'c');
plot((1:sum(~laser_on))+0.5,y(~laser_on),'ko', 'MarkerFaceColor', 'k');
plot([1 1000],[1585 1585 ],'m-', 'linewidth', 2);
plot([1 1000],[1595 1595 ],'m-', 'linewidth', 2);

subplot(313);
plot(PYRO.dat_common(~laser_on), 'o');
for i = 1:(n_step-1)
    line([XTick_position(i) XTick_position(i)],[pyro_cut(1) pyro_cut(end)],'color','k','linestyle','--','linewidth',2);
end
box off;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num(~laser_on))])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list(unique(step_num(~laser_on))));
% xlabel('Imaging Energy Relative to 20.35 GeV (GeV) ','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
ylabel('Pyro (arb. u.)','fontsize',14);
xlim([0 length(step_num(~laser_on))]);
ylim(pyro_cut);

% saveas(2, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_CMOS_FAR_waterfall_Laser_Off'], 'png');
%%
saveas(2, '~/Dropbox/SeB/Papers/__In_Preparation__2014_Corde_Positron_plasma_wakes/Data Analysis/Calibration of Quadrupole Doublet Dispersion/E200_13450_CMOS_FAR_waterfall_Laser_Off_y_profs', 'png');





%% Various plots - Energy Gain vs Energy Loss

PYRO_center = 14000;
PYRO_semi_axis = 2000;
USTORO_center = 165;
USTORO_semi_axis = 4;

cond = (PYRO.dat_common-PYRO_center).^2/PYRO_semi_axis^2 + (USTORO.dat_common-USTORO_center).^2/USTORO_semi_axis^2 < 1;

figure(5); 
set(gcf,'color','w');
set(gca,'fontsize',14);
set(gcf,'paperposition',[0,0,7,5]);
plot(9.4e-3 * USTORO.dat_common(~cond & step_num==1),PYRO.dat_common(~cond & step_num==1), 'bs'); hold on;
plot(9.4e-3 * USTORO.dat_common(cond & step_num==1),PYRO.dat_common(cond & step_num==1), 'ro'); hold off;
xlabel('Positron Charge (10^{10} e)');
ylabel('Pyro (arb. u.)');
legend({'Non-Selected Shots', 'Selected Shots'}, 'location', 'Northwest', 'fontsize', 14);

% cond_1 = laser_on & PYRO.dat_common>16000 & PYRO.dat_common<18000;
% cond_2 = laser_on & PYRO.dat_common>13000 & PYRO.dat_common<15000;

cond_1 = laser_on;
cond_2 = ~laser_on;

step_num0 = 7;

figure(4)
set(gcf,'color','w');
set(gca,'fontsize',14);
set(gcf,'paperposition',[0,0,12,5]);
X_1 = 20.35-CMOS_FAR.ana.E_EMIN3(cond_1 & step_num==step_num0);
Y_11 = CMOS_FAR.ana.E_EMAX3(cond_1 & step_num==step_num0)-20.35;
Y_12 = CMOS_FAR.ana.Q_acc(cond_1 & step_num==step_num0);
X_2 = 20.35-CMOS_FAR.ana.E_EMIN3(cond_2 & step_num==step_num0);
Y_21 = CMOS_FAR.ana.E_EMAX3(cond_2& step_num==step_num0)-20.35;
Y_22 = CMOS_FAR.ana.Q_acc(cond_2 & step_num==step_num0);
subplot(121)
plot(X_1, Y_11, 'ms'); hold on;
plot(X_2, Y_21, 'co'); hold off;
xlim([0 7.5]);
% xlim([0 max(20.35-CMOS_FAR.ana.E_EMIN3(step_num==step_num0))]);
ylim([0 6]);
xlabel('Energy loss (GeV) ', 'fontsize', 18);
ylabel('Energy gain (GeV) ', 'fontsize', 18);
% legend({'Pyro 16000 to 18000', 'Pyro 13000 to 15000'}, 'location', 'Northwest', 'fontsize', 18);
legend({'Laser On', 'Laser Off'}, 'location', 'Northwest', 'fontsize', 18);

subplot(122)
plot(X_1, Y_12, 'ms'); hold on;
plot(X_2, Y_22, 'co'); hold off;
xlim([0 7.5]);
% xlim([0 max(20.35-CMOS_FAR.ana.E_EMIN3(step_num==step_num0))]);
ylim([0 max(CMOS_FAR.ana.Q_acc(step_num==step_num0))]);
xlabel('Energy loss (GeV) ', 'fontsize', 18);
ylabel('Accelerated Charge [pC] ', 'fontsize', 18);
% legend({'Pyro 16000 to 18000', 'Pyro 13000 to 15000'}, 'location', 'Northwest', 'fontsize', 18);
legend({'Laser On', 'Laser Off'}, 'location', 'Northwest', 'fontsize', 18);

figure(5); 
set(gcf,'color','w');
set(gca,'fontsize',14);
set(gcf,'paperposition',[0,0,12,5]);
plot(Y_12, Y_11./X_1, 'ms');
xlabel('Accelerated Charge [pC] ', 'fontsize', 18);
ylabel('Transformer Ratio ', 'fontsize', 18);


% saveas(4, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_Egain_vs_Eloss_stepnum_' num2str(step_num0)], 'png');
% saveas(4, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_Egain_vs_Eloss_stepnum_' num2str(step_num0) '_Two_Pyro_Cut'], 'png');
% saveas(4, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_Egain_vs_Eloss_stepnum_' num2str(step_num0) '_2D_Toro_Pyro_Cut'], 'png');
% saveas(5, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_Egain_vs_Eloss_stepnum_' num2str(step_num0) '_2D_Toro_Pyro_Cut_selected_shots'], 'png');


%%

% % figure(5)
% % set(gcf,'color','w');
% % set(gca,'fontsize',18);
% % set(gcf,'paperposition',[0,0,7,5]);
% % T = (CMOS_FAR.ana.E_EMAX3-20.35)./(20.35-CMOS_FAR.ana.E_EMIN3);
% % % plot(sorting_variable(cond), T(cond), 'ms'); hold on;
% % plot(sorting_variable(cond), CMOS_FAR.ana.E_EMAX3(cond), 'bs'); hold on;
% % plot(sorting_variable(cond), CMOS_FAR.ana.E_EMIN3(cond), 'ro'); hold on;
% % % plot(USTORO.dat_common(~laser_on), T(~laser_on), 'co'); 
% % hold off;
% % xlabel('Positron Charge [10^{10} e] ');
% % ylabel('Min/Max Energy [GeV] ');
% % legend({'Max Energy', 'Min Energy'}, 'location', 'Northwest', 'fontsize', 18);
% % % saveas(5, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_EminEmax_vs_Positron_Charge_Laser_On'], 'png');
% 
% 
% %%
% figure(5); 
% 
% cond = sorting_variable<0.21 & sorting_variable>0.09 & laser_on;
% 
% % plot(CMOS_FAR.ana.efficiency(step_num==7 & laser_on), CMOS_FAR.ana.Q_acc(step_num==7 & laser_on), 'bs'); hold off;
% % plot(CMOS_FAR.ana.efficiency(step_num==2 & ~laser_on), CMOS_FAR.ana.Q_acc(step_num==2 & ~laser_on), 'ro'); hold off;
% plot(CMOS_FAR.ana.efficiency(step_num==1 & cond), CMOS_FAR.ana.Q_acc(step_num==1 & cond), 'bs'); hold on;
% plot(CMOS_FAR.ana.efficiency(step_num==2 & cond), CMOS_FAR.ana.Q_acc(step_num==2 & cond), 'rs'); hold on;
% plot(CMOS_FAR.ana.efficiency(step_num==3 & cond), CMOS_FAR.ana.Q_acc(step_num==3 & cond), 'gs'); hold on;
% plot(CMOS_FAR.ana.efficiency(step_num==4 & cond), CMOS_FAR.ana.Q_acc(step_num==4 & cond), 'ks'); hold on;
% plot(CMOS_FAR.ana.efficiency(step_num==5 & cond), CMOS_FAR.ana.Q_acc(step_num==5 & cond), 'cs'); hold on;
% plot(CMOS_FAR.ana.efficiency(step_num==6 & cond), CMOS_FAR.ana.Q_acc(step_num==6 & cond), 'ms'); hold on;
% plot(CMOS_FAR.ana.efficiency(step_num==7 & cond), CMOS_FAR.ana.Q_acc(step_num==7 & cond), 'b^'); hold off;
% 
% % plot(CMOS_FAR.ana.eloss(step_num==1 & cond), CMOS_FAR.ana.egain(step_num==1 & cond), 'bs'); hold off;
% % plot(CMOS_FAR.ana.eloss(step_num==2 & cond), CMOS_FAR.ana.egain(step_num==2 & cond), 'rs'); hold on;
% % plot(CMOS_FAR.ana.eloss(step_num==3 & cond), CMOS_FAR.ana.egain(step_num==3 & cond), 'gs'); hold on;
% % plot(CMOS_FAR.ana.eloss(step_num==4 & cond), CMOS_FAR.ana.egain(step_num==4 & cond), 'ks'); hold on;
% % plot(CMOS_FAR.ana.eloss(step_num==5 & cond), CMOS_FAR.ana.egain(step_num==5 & cond), 'cs'); hold on;
% % plot(CMOS_FAR.ana.eloss(step_num==6 & cond), CMOS_FAR.ana.egain(step_num==6 & cond), 'ms'); hold on;
% % plot(CMOS_FAR.ana.eloss(step_num==7 & cond), CMOS_FAR.ana.egain(step_num==7 & cond), 'b^'); hold off;

% % xlim([0 1])
% % plot(E_CMOS_FAR, CMOS_FAR.ana.y_profs(:,step_num==7 & laser_on), 'b-'); hold off;
% plot(CMOS_FAR.ana.Q_acc(step_num==1 & laser_on), 'bs'); hold on;
% plot(CMOS_FAR.ana.Q_acc(step_num==2 & laser_on), 'rs'); hold on;
% plot(CMOS_FAR.ana.Q_acc(step_num==3 & laser_on), 'gs'); hold on;
% plot(CMOS_FAR.ana.Q_acc(step_num==4 & laser_on), 'ks'); hold on;
% plot(CMOS_FAR.ana.Q_acc(step_num==5 & laser_on), 'cs'); hold on;
% plot(CMOS_FAR.ana.Q_acc(step_num==6 & laser_on), 'ms'); hold on;
% plot(CMOS_FAR.ana.Q_acc(step_num==5 & laser_on), 'b^'); hold off;
% 
% plot(CMOS_FAR.ana.y_profs_small_box(:,step_num==5 & laser_on), 'b-'); hold off;
% 
% %%
% figure(5); 
% set(gcf,'color','w');
% set(gca,'fontsize',14);
% set(gcf,'paperposition',[0,0,6,5]);
% 
% cond = sorting_variable<0.21 & sorting_variable>0.09 & laser_on;
% % cond = laser_on;
% 
% plot(E_CMOS_FAR,CMOS_FAR.ana.energy_spectrum(:,step_num==3 & cond), 'linewidth', 2);
% ylim([0 100]), xlim([9 28])
% title('QS = 4.5', 'fontsize', 26);
% xlabel('E (GeV)', 'fontsize', 26);
% ylabel('dQ/dE (pC/GeV)', 'fontsize', 26);
% set(gca, 'Fontsize', 20);
% 
% % saveas(5, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_CMOS_FAR_Spectra_Laser_On_Shot_Selection_Step_7'], 'png');
% 


%%
figure(5); 
set(gcf,'color','w');
set(gca,'fontsize',14);
set(gcf,'paperposition',[0,0,6,5]);

UID_list = [1353700050020
    1353700050024
    1353700050028
    1353700050034
    1353700050042
    1353700050050
    1353700060003
    1353700060019
    1353700060033
    1353700070002
    1353700070010
    1353700070016
    1353700070028
    1353700070030
    1353700070032
    ];
test = ismember(COMMON_UID,UID_list);

% cond = sorting_variable<0.21 & sorting_variable>0.09 & laser_on;
cond = laser_on;

E = E_CMOS_FAR;

plot(E(E<15),mean(CMOS_FAR.ana.energy_spectrum(E<15,step_num==1 & cond),2), 'm', 'linewidth', 2); hold on;
plot(E(E>15 & E<16.5),mean(CMOS_FAR.ana.energy_spectrum(E>15 & E<16.5,step_num==2 & cond),2), 'r', 'linewidth', 2); hold on;
plot(E(E>16.5 & E<18),mean(CMOS_FAR.ana.energy_spectrum(E>16.5 & E<18,step_num==3 & cond),2), 'g', 'linewidth', 2); hold on;
plot(E(E>18 & E<22.1),mean(CMOS_FAR.ana.energy_spectrum(E>18 & E<22.1,step_num==4 & cond),2), 'k', 'linewidth', 2); hold on;
% plot(E(E>21 & E<26),mean(CMOS_FAR.ana.energy_spectrum_2(E>21 & E<26, test & step_num==5 & cond),2), 'm', 'linewidth', 2); hold on;
% plot(E(E>21 & E<26),mean(CMOS_FAR.ana.energy_spectrum_2(E>21 & E<26, test & step_num==6 & cond),2), 'c', 'linewidth', 2); hold on;
plot(E(E>22.1),mean(CMOS_FAR.ana.energy_spectrum_2(E>22.1, test & step_num==7 & cond),2), 'b', 'linewidth', 2); hold off;

ylim([0 100]), xlim([9 28])
set(gca, 'XTick', [10 12 14 16 18 20 22 24 26 28])
% title('Average Spectrum', 'fontsize', 26);
xlabel('E (GeV)', 'fontsize', 26);
ylabel('dQ/dE (pC/GeV)', 'fontsize', 26);
set(gca, 'Fontsize', 20);

hold on;
plot(E, 29*exp(-(E-23.1).^2/(2*1.2^2)), 'r--', 'linewidth', 2);
hold off;
saveas(5, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_CMOS_FAR_Average_Spectrum_Laser_On_Accelerated_Peak'], 'png');
% saveas(5, ['~/Dropbox/Data_Analysis/' expt '_' dataset '/' expt '_' dataset '_CMOS_FAR_Average_Spectrum_Laser_On_Shot_Selection'], 'png');

%%
a = mean(CMOS_FAR.ana.energy_spectrum(E<15,step_num==1 & cond),2);
b = mean(CMOS_FAR.ana.energy_spectrum(E>15 & E<16.5,step_num==2 & cond),2);
c = mean(CMOS_FAR.ana.energy_spectrum(E>16.5 & E<18,step_num==3 & cond),2);
d = mean(CMOS_FAR.ana.energy_spectrum(E>18 & E<24,step_num==4 & cond),2);
e = mean(CMOS_FAR.ana.energy_spectrum(E>24 & E<26,step_num==6 & cond),2);

E_new = E(E<26);
average_spectrum = [a; b; c; d; e];
plot(E(E<26),average_spectrum, 'ro');

ylim([0 100]), xlim([9 28])
title('QS = 4.5', 'fontsize', 26);
xlabel('E (GeV)', 'fontsize', 26);
ylabel('dQ/dE (pC/GeV)', 'fontsize', 26);
set(gca, 'Fontsize', 20);

Q_acc = trapz(E_new(E_new>21.35), average_spectrum(E_new>21.35)); % Accelerated charge in pC
Q_dec = trapz(E_new(E_new<19.35), average_spectrum(E_new<19.35)); % Decelerated charge in pC
Q_unaffected = trapz(E_new(E_new>19.35 & E_new<21.35), average_spectrum(E_new>19.35 & E_new<21.35)); % Unaffected charge in pC
eloss = 1e-3 * trapz(E_new(E_new<20.35),(20.35-E_new(E_new<20.35)').*average_spectrum(E_new<20.35)); % Total energy gained by accelerated particles in J
egain = 1e-3 * trapz(E_new(E_new>20.35),(E_new(E_new>20.35)'-20.35).*average_spectrum(E_new>20.35)); % Total energy lost by decelerated particles in J
efficiency = egain/eloss; % Single shot wake-to-bunch transfer efficiency




