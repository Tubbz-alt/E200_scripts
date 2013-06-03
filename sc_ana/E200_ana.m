
% Script to analyze E200 2013 data

% Sebastien Corde
% Create: May 6, 2013
% Last edit: June 2, 2013

%%
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/facet_daq/');
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/sc_ana/');
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/tools/');

prefix = '/Volumes/PWFA 4big';
day = '20130428';
data_set = 'E200_10850';
do_save = 1;
save_path = ['~/Dropbox/SeB/PostDoc/Projects/2013_E200_Data_Analysis/' day '/'];


%%

cmap = custom_cmap();

BETAL_caxis = [0 1000];
CEGAIN_caxis = [0.8 3.2];
CELOSS_caxis = [0.8 3.2];


path = [prefix '/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/'];
if(~exist([save_path data_set], 'dir')); mkdir([save_path data_set '/frames/']); end;


scan_info_file = dir([path '*scan_info*']);
if size(scan_info_file,1) == 1
    load([path scan_info_file.name]);
    n_step = size(scan_info,2);
    is_qsbend_scan = strcmp(scan_info(1).Control_PV_name, 'set_QSBEND_energy');
    is_qs_scan = strcmp(scan_info(1).Control_PV_name, 'set_QS_energy');
    is_scan = 1;
elseif size(scan_info_file,1) == 0
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
mat_filenames = {mat_filenames{1:2:end}};
load([path mat_filenames{1}]);
n_shot = param.n_shot;


BETAL = cam_back.BETAL;
CEGAIN = cam_back.CEGAIN;
CELOSS = cam_back.CELOSS;

BETAL.X_RTCL_CTR = 700;
BETAL.Y_RTCL_CTR = 500;
CEGAIN.X_RTCL_CTR = 700;
CEGAIN.Y_RTCL_CTR = 500;
CELOSS.X_RTCL_CTR = 700;
CELOSS.Y_RTCL_CTR = 500;

BETAL.xx = 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_X-BETAL.X_RTCL_CTR+1):(BETAL.ROI_X+BETAL.ROI_XNP-BETAL.X_RTCL_CTR) );
BETAL.yy = sqrt(2) * 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_Y-BETAL.Y_RTCL_CTR+1):(BETAL.ROI_Y+BETAL.ROI_YNP-BETAL.Y_RTCL_CTR) );
CEGAIN.xx = 1e-3*CEGAIN.RESOLUTION * ( (CEGAIN.ROI_X-CEGAIN.X_RTCL_CTR+1):(CEGAIN.ROI_X+CEGAIN.ROI_XNP-CEGAIN.X_RTCL_CTR) );
CEGAIN.yy = 1e-3*CEGAIN.RESOLUTION * ( (CEGAIN.ROI_Y-CEGAIN.Y_RTCL_CTR+1):(CEGAIN.ROI_Y+CEGAIN.ROI_YNP-CEGAIN.Y_RTCL_CTR) );
CELOSS.xx = 1e-3*CELOSS.RESOLUTION * ( (CELOSS.ROI_X-CELOSS.X_RTCL_CTR+1):(CELOSS.ROI_X+CELOSS.ROI_XNP-CELOSS.X_RTCL_CTR) );
CELOSS.yy = 1e-3*CELOSS.RESOLUTION * ( (CELOSS.ROI_Y-CELOSS.Y_RTCL_CTR+1):(CELOSS.ROI_Y+CELOSS.ROI_YNP-CELOSS.Y_RTCL_CTR) );

clear processed;
processed.scalars.GAMMA_MAX = zeros(n_step, n_shot);
processed.scalars.GAMMA_YIELD = zeros(n_step, n_shot);
processed.scalars.GAMMA_DIV = zeros(n_step, n_shot);
processed.scalars.E_ACC = zeros(n_step, n_shot);
processed.scalars.E_DECC = zeros(n_step, n_shot);
processed.scalars.E_UNAFFECTED = zeros(n_step, n_shot);
processed.scalars.E_UNAFFECTED2 = zeros(n_step, n_shot);
processed.scalars.E_EMIN = zeros(n_step, n_shot);
processed.scalars.E_EMIN_ind = zeros(n_step, n_shot);
processed.scalars.E_EMAX = zeros(n_step, n_shot);
processed.scalars.E_EMAX2 = zeros(n_step, n_shot);
processed.scalars.E_EMAX3 = zeros(n_step, n_shot);
processed.scalars.E_EMAX_ind = zeros(n_step, n_shot);
processed.scalars.E_EMAX2_ind = zeros(n_step, n_shot);
processed.scalars.E_EMAX3_ind = zeros(n_step, n_shot);
processed.scalars.PYRO = zeros(n_step, n_shot);
processed.scalars.EX_CHARGE = zeros(n_step, n_shot);

clear waterfall;
waterfall.CEGAIN = zeros(1392, n_shot, n_step);
waterfall.CEGAIN2 = zeros(1392, n_shot, n_step);
waterfall.CELOSS = zeros(1392, n_shot, n_step);

B5D36 = getB5D36(E200_state);
QS = getQS(E200_state);
E_EGAIN = E200_cher_get_E_axis('20130423', 'CEGAIN', 0, 1:1392, 0, B5D36);
E_ELOSS = E200_cher_get_E_axis('20130423', 'CELOSS', 0, 1:1392, 0, B5D36);

%%

fig = figure(1);
set(fig, 'position', [500, 100, 1000, 900]);
set(fig, 'PaperPosition', [0.25, 2.5, 13, 12]);
set(fig, 'color', 'w');
clf();


for i=1:n_step
% i=3;
data = load([path mat_filenames{i}]);
if is_qsbend_scan; B5D36 = 20.35 + scan_info(i).Control_PV; end;

[BETAL.img, ~, BETAL.pid] = E200_readImages([prefix scan_info(i).BETAL]);
[CEGAIN.img, ~, CEGAIN.pid] = E200_readImages([prefix scan_info(i).CEGAIN]);
[CELOSS.img, ~, CELOSS.pid] = E200_readImages([prefix scan_info(i).CELOSS]);

BETAL.img = double(BETAL.img);
CEGAIN.img = double(CEGAIN.img);
CELOSS.img = double(CELOSS.img);

for j=1:size(BETAL.img,3); BETAL.img(:,:,j) = BETAL.img(:,:,j) - cam_back.BETAL.img(:,:); end;
for j=1:size(CEGAIN.img,3); CEGAIN.img(:,:,j) = CEGAIN.img(:,:,j) - cam_back.CEGAIN.img(:,:); end;
for j=1:size(CELOSS.img,3); CELOSS.img(:,:,j) = CELOSS.img(:,:,j) - cam_back.CELOSS.img(:,:); end;

pid = [data.epics_data.PATT_SYS1_1_PULSEID];
[C, IA, IB] = intersect(BETAL.pid, pid', 'stable');
USTORO = E200_state.SIOC_SYS1_ML01_AO028 + E200_state.SIOC_SYS1_ML01_AO027*[data.epics_data.GADC0_LI20_EX01_AI_CH2_];
DSTORO = E200_state.SIOC_SYS1_ML01_AO030 + E200_state.SIOC_SYS1_ML01_AO029*[data.epics_data.GADC0_LI20_EX01_AI_CH3_];
processed.scalars.EX_CHARGE(i,:) = 1.6e-7*(DSTORO(IB) - USTORO(IB));
PYRO = [data.epics_data.BLEN_LI20_3014_BRAW];
processed.scalars.PYRO(i,:) = PYRO(IB);

for j=1:n_shot
    fprintf('\n%d \t %d \t %d\n', BETAL.pid(j), CEGAIN.pid(j), CELOSS.pid(j));
    
    [BETAL.img2, BETAL.ana.img, BETAL.ana.GAMMA_YIELD, BETAL.ana.GAMMA_MAX, BETAL.ana.GAMMA_DIV] = Ana_BETAL_img(BETAL.xx, BETAL.yy, BETAL.img(:,:,j));
    [CEGAIN.ana, CEGAIN.ana.img] = Ana_CEGAIN_img(E_EGAIN, CEGAIN.img(:,:,j));
    CELOSS.ana = Ana_CELOSS_img(E_ELOSS, CELOSS.img(:,:,j));
    
    processed.scalars.GAMMA_MAX(i,j) = BETAL.ana.GAMMA_MAX;
    processed.scalars.GAMMA_YIELD(i,j) = BETAL.ana.GAMMA_YIELD;
    processed.scalars.GAMMA_DIV(i,j) = BETAL.ana.GAMMA_DIV;
    processed.scalars.E_ACC(i,j) = CEGAIN.ana.E_ACC;
    processed.scalars.E_UNAFFECTED(i,j) = CEGAIN.ana.E_UNAFFECTED;
    processed.scalars.E_EMAX(i,j) = CEGAIN.ana.E_EMAX;
    processed.scalars.E_EMAX2(i,j) = CEGAIN.ana.E_EMAX2;
    processed.scalars.E_EMAX3(i,j) = CEGAIN.ana.E_EMAX3;
    processed.scalars.E_EMAX_ind(i,j) = CEGAIN.ana.E_EMAX_ind;
    processed.scalars.E_EMAX2_ind(i,j) = CEGAIN.ana.E_EMAX2_ind;
    processed.scalars.E_EMAX3_ind(i,j) = CEGAIN.ana.E_EMAX3_ind;
    processed.scalars.E_DECC(i,j) = CELOSS.ana.E_DECC;
    processed.scalars.E_UNAFFECTED2(i,j) = CELOSS.ana.E_UNAFFECTED2;
    processed.scalars.E_EMIN(i,j) = CELOSS.ana.E_EMIN;
    processed.scalars.E_EMIN_ind(i,j) = CELOSS.ana.E_EMIN_ind;
    
    processed.vectors.CEGAIN_SPEC = CEGAIN.ana.spec;
    processed.vectors.CEGAIN_SPEC2 = CEGAIN.ana.spec2;
    processed.vectors.CELOSS_SPEC = sum(CELOSS.img(:,:,j),1);
    
    waterfall.CEGAIN(:,j,i) = processed.vectors.CEGAIN_SPEC;
    waterfall.CEGAIN2(:,j,i) = processed.vectors.CEGAIN_SPEC2;
    waterfall.CELOSS(:,j,i) = processed.vectors.CELOSS_SPEC;
    
    CEGAIN.ana.img(CEGAIN.ana.img<1) = 1;
    CEGAIN.img2 = CEGAIN.img(:,:,j);
    CEGAIN.img2(CEGAIN.img2<1) = 1;
    CELOSS.img2 = CELOSS.img(:,:,j);
    CELOSS.img2(CELOSS.img2<1) = 1;
    
    if i==1 && j==1
%     if j==1
        h_text = axes('Position', [0.17, 0.8, 0.3, 0.035], 'Visible', 'off');
        if is_scan; STEP = text(0., 1., [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)], 'fontsize', 20); end;
        SHOT = text(0., 0., ['Shot #' num2str(j)], 'fontsize', 20);
        h_text2 = axes('Position', [0.58, 0.95, 0.2, 0.05], 'Visible', 'off');
        if is_qs_scan; B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', 20); end;
        if ~is_qs_scan && ~is_qsbend_scan; 
            QS_text = text(1., 0., ['QS = ' num2str(QS, '%.0f') ' GeV'], 'fontsize', 20);
            B5D36_text = text(0., 0., ['B5D36 = ' num2str(B5D36, '%.2f') ' GeV'], 'fontsize', 20);
        end;
        ax_betal = axes('position', [0.05, 0.1, 0.45, 0.8]);
        image(BETAL.xx,BETAL.yy,BETAL.img2,'CDataMapping','scaled');
%         image(BETAL.xx,BETAL.yy,BETAL.ana.img,'CDataMapping','scaled');
        colormap(cmap.wbgyr);
        fig_betal = get(gca,'Children');
        daspect([1 1 1]);
        axis xy;
        if BETAL.ana.GAMMA_MAX > BETAL_caxis(1)
            caxis([BETAL_caxis(1) BETAL.ana.GAMMA_MAX]);
        else
            caxis(BETAL_caxis);
        end
        colorbar();
        xlabel('x (mm)'); ylabel('y (mm)');
        title('BETAL');
        axes('position', [0.58, 0.1, 0.1, 0.8])
        image(CEGAIN.yy,1:1392,log10(CEGAIN.img2'),'CDataMapping','scaled');
%         image(CEGAIN.yy,1:1392,log10(CEGAIN.ana.img'),'CDataMapping','scaled');
        colormap(cmap.wbgyr);
        fig_cegain = get(gca,'Children');
        axis xy;
        caxis(CEGAIN_caxis);
        xlabel('x (mm)'); ylabel('y (mm)'); ylim([49 1392]);
        set(gca, 'YTick', 50:100:1392);
        set(gca, 'YTickLabel', CEGAIN.xx(50:100:1392));
        axesPosition = get(gca, 'Position');
        hNewAxes = axes('Position', axesPosition, 'Color', 'none', 'YAxisLocation', 'right', 'XTick', [], ...
            'Box', 'off','YLim', [49,1392], 'YTick', 50:100:1392, ...
            'YTickLabel', E_EGAIN(50:100:1392));
        ylabel('E (GeV)');
        title('CEGAIN (log scale)');
        axes('position', [0.8, 0.1, 0.1, 0.8])
        image(CELOSS.yy,1:1392,log10(CELOSS.img2'),'CDataMapping','scaled');
        colormap(cmap.wbgyr);
        fig_celoss = get(gca,'Children');
        axis xy;
        caxis(CELOSS_caxis);
        xlabel('x (mm)'); ylabel('y (mm)'); ylim([49 1392]);
        set(gca, 'YTick', 50:100:1392);
        set(gca, 'YTickLabel', CELOSS.xx(50:100:1392));
        axesPosition = get(gca, 'Position');
        hNewAxes = axes('Position', axesPosition, 'Color', 'none', 'YAxisLocation', 'right', 'XTick', [], ...
            'Box', 'off','YLim', [49,1392], 'YTick', 50:100:1392, ...
            'YTickLabel', E_ELOSS(50:100:1392));
        ylabel('E (GeV)');
        title('CELOSS (log scale)');
    else
        if is_scan; set(STEP, 'String', [char(regexprep(scan_info(i).Control_PV_name, '_', '\\_')) ' = ' num2str(scan_info(i).Control_PV)]); end;
        set(SHOT, 'String', ['Shot #' num2str(j)]);
        set(fig_betal,'CData',BETAL.img2);
%         set(fig_betal,'CData',BETAL.ana.img);
        if BETAL.ana.GAMMA_MAX > BETAL_caxis(1)
            set(ax_betal, 'CLim', [BETAL_caxis(1) BETAL.ana.GAMMA_MAX]);
        else
            set(ax_betal, 'CLim', BETAL_caxis);
        end
%         set(fig_cegain,'CData',log10(CEGAIN.ana.img'));
        set(fig_cegain,'CData',log10(CEGAIN.img2'));
        set(fig_celoss,'CData',log10(CELOSS.img2'));
    end
     if do_save
         filename = ['frame_' num2str(i, '%.2d') '_' num2str(j, '%.3d') '.png'];
         print('-f1', [save_path data_set '/frames/' filename], '-dpng', '-r100');
     else
         pause(0.1);
     end
end




end

%% Saving

clear tmp;
if do_save
    if exist([save_path data_set '.mat'], 'file'); tmp = load([save_path data_set]); end;
    tmp.data.user.scorde.processed = processed;
    tmp.data.user.scorde.waterfall = waterfall;
    save([save_path data_set '.mat'], '-struct', 'tmp');
end














