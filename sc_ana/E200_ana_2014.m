
% Script to analyze E200 2014 data with the new processed data structure.

% Sebastien Corde
% Create: May 2, 2014
% Last edit: July 8, 2014

%% Define data set and paths

user = 'corde';
% prefix = '~/PWFA_4big';
prefix = '/Volumes/PWFA_4big';
day = '20140609';
experiment = 'E200';
data_set_num = 13284;
do_save = 1;
save_path = ['~/Dropbox/SeB/PostDoc/Projects/2014_E200_Data_Analysis/' day '/'];
data_set = [experiment '_' num2str(data_set_num)];

E_range = [11 26];
% x_range = [220 350];
x_range = [290 420];
pix_E0 = 1582; % Pixel position of 20.35 GeV electrons on CMOS FAR, from Erik: 1597 after May 21 and 1623 before.
SYAG_caxis = [0 400];
CMOS_FAR_caxis = [0 4.];
ELANEX_caxis = [0 1500];
fs = 20;

pyro_cut = [0 15000]; % for Waterfall Plot
pyro_cut = [5500 7000];



%% Load data

if ~exist(prefix,'dir')
    system(['mkdir ' prefix]);
    system(['/usr/local/bin/sshfs ' user '@quickpicmac3.slac.stanford.edu:/Volumes/PWFA_4big/' ' ' prefix]);
    pause(2);
end

%%
load([prefix '/nas/nas-li20-pm00/E200/2014/' day '/' data_set '/' data_set '.mat']);


%%

cmap = custom_cmap();

if(~exist([save_path data_set], 'dir')); mkdir([save_path data_set '/frames/']); end;

is_scan = isfield(data.raw.metadata.param.dat{1}, 'fcnHandle');
n_step = data.raw.metadata.param.dat{1}.n_step;
n_shot = data.raw.metadata.param.dat{1}.n_shot;

is_qsbend_scan = 0;
is_qs_scan = 0;
if is_scan
    is_qsbend_scan = strcmp(char(data.raw.metadata.param.dat{1}.fcnHandle), 'set_QSBEND_energy_PEXT');
    is_qs_scan = strcmp(char(data.raw.metadata.param.dat{1}.fcnHandle), 'set_QS_energy_PEXT');
end

EPICS_UID = data.raw.scalars.PATT_SYS1_1_PULSEID.UID;

CMOS_FAR = data.raw.images.CMOS_FAR;
SYAG = data.raw.images.SYAG;
ELANEX = data.raw.images.ELANEX;

% Find the UID that are common to all data of interest
COMMON_UID = intersect(EPICS_UID, CMOS_FAR.UID);
COMMON_UID = intersect(COMMON_UID, SYAG.UID);
COMMON_UID = intersect(COMMON_UID, ELANEX.UID);
n_common = numel(COMMON_UID);

% Indexes for each data to retrieve the shots in COMMON_UID
[~, ~, EPICS_index] = intersect(COMMON_UID, EPICS_UID);
[~, ~, CMOS_FAR_index] = intersect(COMMON_UID, CMOS_FAR.UID);
[~, ~, SYAG_index] = intersect(COMMON_UID, SYAG.UID);
[~, ~, ELANEX_index] = intersect(COMMON_UID, ELANEX.UID);

% Load camera background images
tmp = load([prefix '/' CMOS_FAR.background_dat{1}]);
CMOS_FAR.back = tmp.img;
tmp = load([prefix '/' SYAG.background_dat{1}]);
SYAG.back = tmp.img;
tmp = load([prefix '/' ELANEX.background_dat{1}]);
ELANEX.back = tmp.img;

PYRO = data.raw.scalars.BLEN_LI20_3014_BRAW.dat(EPICS_index);
QS = data.raw.scalars.step_value.dat(EPICS_index);

if sum(SYAG.UID ~= CMOS_FAR.UID); 
    disp('SYAG and CMOS_FAR are not synchronous.');
end

if ~sum(SYAG.UID(SYAG_index) ~= CMOS_FAR.UID(CMOS_FAR_index)); 
    disp('But common UIDs were selected.');
end


%% Energy axis for CMOS FAR and ELANEX

B5D36 = getB5D36(data.raw.metadata.E200_state.dat{1});
E_CMOS_FAR = E200_Eaxis_ana(1:2559, pix_E0, 62.65e-6,  2016.0398, 6e-3, B5D36);

QS_init = getQS(data.raw.metadata.E200_state.dat{1});
E_ELANEX = get_ELANEX_axis(QS_init);
is_QS_PEXT_scan = strcmp(char(data.raw.metadata.param.dat{1}.fcnHandle), 'set_QS_energy_PEXT');

%% Initialisation of waterfalls and vectors
clear waterfall;
waterfall.CMOS_FAR = zeros(sum(E_CMOS_FAR<E_range(2) & E_CMOS_FAR>E_range(1)), n_common);
waterfall.SYAG = zeros(971, n_common);
waterfall.ELANEX = zeros(734, n_common);

CMOS_FAR.Charge_at_QS = zeros(1, n_common);
CMOS_FAR.Transverse_Position = zeros(1, n_common);
CMOS_FAR.Transverse_Position2 = zeros(1, n_common);

%%

fig = figure(1);
set(fig, 'position', [500, 100, 1000, 900]);
set(fig, 'PaperPosition', [0.25, 2.5, 13, 12]);
set(fig, 'color', 'w');
clf();


for i=1:n_common
    % i=3;
%     if is_qsbend_scan; B5D36 = 20.35 + scan_info(i).Control_PV; end;
    
    if is_QS_PEXT_scan; E_ELANEX = get_ELANEX_axis(QS(i)); end;

    SYAG.img = double(imread([prefix '/' SYAG.dat{SYAG_index(i)}]))-double(SYAG.back);
    SYAG.img2 = SYAG.img;
    SYAG.img2(SYAG.img<1) = 1;
    waterfall.SYAG(:,i) = sum(SYAG.img(750:800,180:1150),1);
    
    CMOS_FAR.img = rot90(double(imread([prefix '/' CMOS_FAR.dat{CMOS_FAR_index(i)}])))-double(CMOS_FAR.back);
    CMOS_FAR.img = CMOS_FAR.img - mean(mean(CMOS_FAR.img(2300:2400, 100:200)));
    waterfall.CMOS_FAR(:,i) = sum(CMOS_FAR.img(E_CMOS_FAR<E_range(2) & E_CMOS_FAR>E_range(1),x_range(1):x_range(2)),2);
    CMOS_FAR.img2 = CMOS_FAR.img;
    CMOS_FAR.img2(CMOS_FAR.img<1) = 1;
    CMOS_FAR.Charge_at_QS(i) = sum(sum(CMOS_FAR.img(E_CMOS_FAR<20.35+QS(i)+0.5 & E_CMOS_FAR>20.35+QS(i)-0.5, x_range(1)+50:x_range(2)-50)));
    x_prof = sum(CMOS_FAR.img(E_CMOS_FAR<21 & E_CMOS_FAR>19, x_range(1)-100:x_range(2)+100),1);
    CMOS_FAR.Transverse_Position(i) = sum((x_range(1)-100:x_range(2)+100).*x_prof)/sum(x_prof);
    [~,tmp] = max(conv(x_prof,ones(1,10)/10.,'same'));
    CMOS_FAR.Transverse_Position2(i) = x_range(1)-100+tmp;
    
    ELANEX.img = double(imread([prefix '/' ELANEX.dat{ELANEX_index(i)}]))-double(ELANEX.back);
    ELANEX.img2 = ELANEX.img;
    ELANEX.img2(ELANEX.img<1) = 1;
    waterfall.ELANEX(:,i) = sum(ELANEX.img,2);
      
  
    if i==1
        figure(1)
        h_text = axes('Position', [0.3, 0.95, 0.2, 0.035], 'Visible', 'off');
%         if is_scan; STEP = text(0., 1., [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)], 'fontsize', 20); end;
        SHOT = text(0., 0., ['Shot UID: ' num2str(COMMON_UID(i))], 'fontsize', fs+10);
%         h_text2 = axes('Position', [0.58, 0.95, 0.2, 0.05], 'Visible', 'off');
%         if is_qs_scan; B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', 20); end;
%         if ~is_qs_scan && ~is_qsbend_scan;
%             QS_text = text(1., 0., ['QS = ' num2str(QS, '%.0f') ' GeV'], 'fontsize', 20);
%             B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', 20);
%         end;

        axes('position', [0.1, 0.08, 0.8, 0.2]);
        yy = 1:2559;
        yy = yy(E_CMOS_FAR<E_range(2) & E_CMOS_FAR>E_range(1));
        xx = x_range;
        imagesc(yy, xx, log10(CMOS_FAR.img2(E_CMOS_FAR<E_range(2) & E_CMOS_FAR>E_range(1),x_range(1):x_range(2))'));
        colormap(cmap.wbgyr);
        fig_CMOS_FAR = get(gca,'Children');
        axis xy;
        caxis(CMOS_FAR_caxis);
        cb = colorbar();
        set(cb, 'YTick', [0 1 2 3 4]);
        set(cb, 'YTickLabel', [1 10 100 1000 10000]);
        energy_ticks = [10, 12.5, 15, 17.5, 20, 25, 30, 35, 40, 45, 50, 55, 60];
        xticks = interp1(E_CMOS_FAR(yy), yy, energy_ticks);
        set(gca, 'XTick', xticks);
        set(gca, 'XTickLabel', energy_ticks);
        set(gca, 'fontsize', fs);
        title('CMOS FAR (log scale)');
        xlabel('Electron energy (GeV)', 'fontsize', fs+10);

        axes('position', [0.1, 0.64, 0.8, 0.2]);
        image(fliplr(SYAG.img2(600:end,180:1150)), 'CDataMapping', 'scaled');
        colormap(cmap.wbgyr);
        colorbar();
        fig_SYAG = get(gca,'Children');
        axis xy;
        caxis(SYAG_caxis);
        daspect([1 1 1]);
        set(gca, 'fontsize', fs);
        title('SYAG');
        
        axes('position', [0.3, 0.36, 0.4, 0.2]);
        pcolor(1:size(ELANEX.img2,2),E_ELANEX,ELANEX.img2); shading flat;
        colormap(cmap.wbgyr);
        cb = colorbar();
        fig_ELANEX = get(gca,'Children');
        caxis(ELANEX_caxis);
%         daspect([1 1 1]);
        set(gca, 'fontsize', fs);
        title('ELANEX');
        ylabel('Electron energy (GeV)', 'fontsize', fs);

        
    else
%         if is_scan; set(STEP, 'String', [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)]); end;
        set(SHOT, 'String', ['Shot UID: ' num2str(COMMON_UID(i))]);
        set(fig_CMOS_FAR,'CData',log10(CMOS_FAR.img2(E_CMOS_FAR<E_range(2) & E_CMOS_FAR>E_range(1),x_range(1):x_range(2))'));
        set(fig_ELANEX,'CData',ELANEX.img2);
        set(fig_ELANEX,'YData',E_ELANEX);
        set(get(fig_ELANEX,'Parent'),'YLim',[E_ELANEX(end) E_ELANEX(1)]);
        set(fig_SYAG,'CData',fliplr(SYAG.img2(600:end,180:1150)));
    end
    if do_save
        filename = ['frame_' num2str(COMMON_UID(i), '%d') '.png'];
        print('-f1', [save_path data_set '/frames/' filename], '-dpng', '-r100');
    else
        pause(0.1);
    end


    
end

%% Saving

if do_save
    data.user.scorde.waterfall = waterfall;
    data.processed.scalars.CMOS_FAR_Charge_at_QS.dat = CMOS_FAR.Charge_at_QS;
    data.processed.scalars.CMOS_FAR_Charge_at_QS.UID = COMMON_UID;
    data.processed.scalars.CMOS_FAR_Charge_at_QS.IDtype = CMOS_FAR.IDtype;
    data.processed.scalars.CMOS_FAR_Transverse_Position.dat = CMOS_FAR.Transverse_Position;
    data.processed.scalars.CMOS_FAR_Transverse_Position.UID = COMMON_UID;
    data.processed.scalars.CMOS_FAR_Transverse_Position.IDtype = CMOS_FAR.IDtype;
    data.processed.scalars.CMOS_FAR_Transverse_Position2.dat = CMOS_FAR.Transverse_Position2;
    data.processed.scalars.CMOS_FAR_Transverse_Position2.UID = COMMON_UID;
    data.processed.scalars.CMOS_FAR_Transverse_Position2.IDtype = CMOS_FAR.IDtype;
    save([save_path data_set '.mat'], '-struct', 'data');
end



%% ELANEX Waterfall Plot



%% CMOS Far Waterfall Plot










