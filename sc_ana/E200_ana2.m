
% Script to analyze E200 2013 data with the new processed data structure.

% Sebastien Corde
% Create: May 6, 2013
% Last edit: June 7, 2013

%%
addpath(genpath('~/Dropbox/SeB/Codes/sources/E200_scripts'));
addpath('~/Dropbox/SeB/Codes/sources/E200_data');

user = 'corde';
is_ana_local = 0;
local_data = '~/test/saved.mat';
prefix = '/Volumes/PWFA_4big';
day = '20130428';
experiment = 'E200';
data_set_num = 10849;
do_save = 1;
save_path = ['~/Dropbox/SeB/PostDoc/Projects/2013_E200_Data_Analysis/' day '/'];
data_set = [experiment '_' num2str(data_set_num)];


%%

if is_ana_local
    load(local_data);
else
    if exist(prefix)
        data = E200_load_data([prefix '/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/']);
    else
        system(['mkdir ' prefix]);
        system(['/usr/local/bin/sshfs ' user '@quickpicmac3.slac.stanford.edu:' prefix ' ' prefix]);
        data = E200_load_data([prefix '/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/']);
        data = E200_gather_data([prefix '/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/']);
    end
end

%%

cmap = custom_cmap();

BETAL_caxis = [0 1000];
CEGAIN_caxis = [0.8 3.2];
CELOSS_caxis = [0.8 3.2];

if(~exist([save_path data_set], 'dir')); mkdir([save_path data_set '/frames/']); end;

is_scan = isfield(data.raw.metadata, 'scan_info');
n_step = data.raw.scalars.step_num.dat(end);
n_shot = data.raw.metadata.param.dat{1}.n_shot;

is_qsbend_scan = 0;
is_qs_scan = 0;
if is_scan
    is_qsbend_scan = strcmp(data.raw.metadata.scan_info.dat{1}.Control_PV_name, 'set_QSBEND_energy');
    is_qs_scan = strcmp(data.raw.metadata.scan_info.dat{1}.Control_PV_name, 'set_QS_energy');
end


cam_back.BETAL.img = load(data.raw.images.BETAL.background_dat{1});
cam_back.CEGAIN.img = load(data.raw.images.CEGAIN.background_dat{1});
cam_back.CELOSS.img = load(data.raw.images.CELOSS.background_dat{1});

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
processed.scalars.GAMMA_MAX.dat = [];
processed.scalars.GAMMA_YIELD.dat = [];
processed.scalars.GAMMA_DIV.dat = [];
processed.scalars.E_ACC.dat = [];
processed.scalars.E_DECC.dat = [];
processed.scalars.E_UNAFFECTED.dat = [];
processed.scalars.E_UNAFFECTED2.dat = [];
processed.scalars.E_EMIN.dat = [];
processed.scalars.E_EMIN_ind.dat = [];
processed.scalars.E_EMAX.dat = [];
processed.scalars.E_EMAX2.dat = [];
processed.scalars.E_EMAX3.dat = [];
processed.scalars.E_EMAX_ind.dat = [];
processed.scalars.E_EMAX2_ind.dat = [];
processed.scalars.E_EMAX3_ind.dat = [];

processed.scalars.PYRO.dat = [];
processed.scalars.EX_CHARGE.dat = [];
    
processed.vectors.CEGAIN_SPEC.dat = {};
processed.vectors.CEGAIN_SPEC2.dat = {};
processed.vectors.CELOSS_SPEC.dat = {};

processed.scalars.GAMMA_MAX.UID = [];
processed.scalars.GAMMA_YIELD.UID = [];
processed.scalars.GAMMA_DIV.UID = [];
processed.scalars.E_ACC.UID = [];
processed.scalars.E_DECC.UID = [];
processed.scalars.E_UNAFFECTED.UID = [];
processed.scalars.E_UNAFFECTED2.UID = [];
processed.scalars.E_EMIN.UID = [];
processed.scalars.E_EMIN_ind.UID = [];
processed.scalars.E_EMAX.UID = [];
processed.scalars.E_EMAX2.UID = [];
processed.scalars.E_EMAX3.UID = [];
processed.scalars.E_EMAX_ind.UID = [];
processed.scalars.E_EMAX2_ind.UID = [];
processed.scalars.E_EMAX3_ind.UID = [];

processed.scalars.PYRO.UID = [];
processed.scalars.EX_CHARGE.UID = [];

processed.vectors.CEGAIN_SPEC.UID = [];
processed.vectors.CEGAIN_SPEC2.UID = [];
processed.vectors.CELOSS_SPEC.UID = [];

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
PYRO = [data.epics_data.BLEN_LI20_3014_BRAW];


for j=1:n_shot
    fprintf('\n%d \t %d \t %d\n', BETAL.pid(j), CEGAIN.pid(j), CELOSS.pid(j));
    
    [BETAL.img2, BETAL.ana.img, BETAL.ana.GAMMA_YIELD, BETAL.ana.GAMMA_MAX, BETAL.ana.GAMMA_DIV] = Ana_BETAL_img(BETAL.xx, BETAL.yy, BETAL.img(:,:,j));
    [CEGAIN.ana, CEGAIN.ana.img] = Ana_CEGAIN_img(E_EGAIN, CEGAIN.img(:,:,j));
    CELOSS.ana = Ana_CELOSS_img(E_ELOSS, CELOSS.img(:,:,j));
    
    processed.scalars.GAMMA_MAX.dat(end+1) = BETAL.ana.GAMMA_MAX;
    processed.scalars.GAMMA_YIELD.dat(end+1) = BETAL.ana.GAMMA_YIELD;
    processed.scalars.GAMMA_DIV.dat(end+1) = BETAL.ana.GAMMA_DIV;
    processed.scalars.E_ACC.dat(end+1) = CEGAIN.ana.E_ACC;
    processed.scalars.E_UNAFFECTED.dat(end+1) = CEGAIN.ana.E_UNAFFECTED;
    processed.scalars.E_EMAX.dat(end+1) = CEGAIN.ana.E_EMAX;
    processed.scalars.E_EMAX2.dat(end+1) = CEGAIN.ana.E_EMAX2;
    processed.scalars.E_EMAX3.dat(end+1) = CEGAIN.ana.E_EMAX3;
    processed.scalars.E_EMAX_ind.dat(end+1) = CEGAIN.ana.E_EMAX_ind;
    processed.scalars.E_EMAX2_ind.dat(end+1) = CEGAIN.ana.E_EMAX2_ind;
    processed.scalars.E_EMAX3_ind.dat(end+1) = CEGAIN.ana.E_EMAX3_ind;
    processed.scalars.E_DECC.dat(end+1) = CELOSS.ana.E_DECC;
    processed.scalars.E_UNAFFECTED2.dat(end+1) = CELOSS.ana.E_UNAFFECTED2;
    processed.scalars.E_EMIN.dat(end+1) = CELOSS.ana.E_EMIN;
    processed.scalars.E_EMIN_ind.dat(end+1) = CELOSS.ana.E_EMIN_ind;    
    
    processed.scalars.EX_CHARGE.dat(end+1) = 1.6e-7*(DSTORO(IB(j)) - USTORO(IB(j)));
    processed.scalars.PYRO.dat(end+1) = PYRO(IB(j));

    processed.vectors.CEGAIN_SPEC.dat{end+1} = CEGAIN.ana.spec;
    processed.vectors.CEGAIN_SPEC2.dat{end+1} = CEGAIN.ana.spec2;
    processed.vectors.CELOSS_SPEC.dat{end+1} = sum(CELOSS.img(:,:,j),1);

    processed.scalars.GAMMA_MAX.UID(end+1) = getUID(data_set_num, i, BETAL.pid(j), pid);
    processed.scalars.GAMMA_YIELD.UID(end+1) = getUID(data_set_num, i, BETAL.pid(j), pid);
    processed.scalars.GAMMA_DIV.UID(end+1) = getUID(data_set_num, i, BETAL.pid(j), pid);
    processed.scalars.E_ACC.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.scalars.E_UNAFFECTED.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.scalars.E_EMAX.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.scalars.E_EMAX2.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.scalars.E_EMAX3.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.scalars.E_EMAX_ind.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.scalars.E_EMAX2_ind.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.scalars.E_EMAX3_ind.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.scalars.E_DECC.UID(end+1) = getUID(data_set_num, i, CELOSS.pid(j), pid);
    processed.scalars.E_UNAFFECTED2.UID(end+1) = getUID(data_set_num, i, CELOSS.pid(j), pid);
    processed.scalars.E_EMIN.UID(end+1) = getUID(data_set_num, i, CELOSS.pid(j), pid);
    processed.scalars.E_EMIN_ind.UID(end+1) = getUID(data_set_num, i, CELOSS.pid(j), pid);
    
    processed.scalars.EX_CHARGE.UID(end+1) = getUID(data_set_num, i, pid(IB(j)), pid);
    processed.scalars.PYRO.UID(end+1) = getUID(data_set_num, i, pid(IB(j)), pid);
    
    processed.vectors.CEGAIN_SPEC.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.vectors.CEGAIN_SPEC2.UID(end+1) = getUID(data_set_num, i, CEGAIN.pid(j), pid);
    processed.vectors.CELOSS_SPEC.UID(end+1) = getUID(data_set_num, i, CELOSS.pid(j), pid);

    waterfall.CEGAIN(:,j,i) = processed.vectors.CEGAIN_SPEC.dat{end};
    waterfall.CEGAIN2(:,j,i) = processed.vectors.CEGAIN_SPEC2.dat{end};
    waterfall.CELOSS(:,j,i) = processed.vectors.CELOSS_SPEC.dat{end};
    
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














