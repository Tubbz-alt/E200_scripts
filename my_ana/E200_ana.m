


%%
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/facet_daq/');

day = '20130427';
data_set = 'E200_10751';

%%

D = [1 1 1;
     0 0 1;
     0 1 0;
     1 1 0;
     1 0 0;];
F = [0 0.25 0.5 0.75 1];
G = linspace(0, 1, 256);
cmap = interp1(F,D,G);

path = ['/Volumes/PWFA 4big/nas/nas-li20-pm01/E200/2013/' day '/' data_set '/'];
prefix = '/Volumes/PWFA 4big';

BETAL_caxis = [0 1500];
CEGAIN_caxis = [0 3.6];
CELOSS_caxis = [0 3.6];


list = dir([path data_set '*_filenames.mat']);
[tmp, ind] = sort([list.datenum]);
list(:) = list(ind(:));
for i=1:size(list,1); filenames(i) = load([path list(i).name]); end;

list = dir([path data_set '*.mat']);
load([path list(1).name]);

fig = figure(1);
set(fig, 'position', [0, 70, 1000, 900]);
set(fig, 'color', 'w');


BETAL = cam_back.BETAL;
% CEGAIN = cam_back.CEGAIN;
CELOSS = cam_back.CELOSS;

BETAL.X_RTCL_CTR = 700;
BETAL.Y_RTCL_CTR = 500;
% CEGAIN.X_RTCL_CTR = 700;
% CEGAIN.Y_RTCL_CTR = 500;
CELOSS.X_RTCL_CTR = 700;
CELOSS.Y_RTCL_CTR = 500;

BETAL.xx = 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_X-BETAL.X_RTCL_CTR+1):(BETAL.ROI_X+BETAL.ROI_XNP-BETAL.X_RTCL_CTR) );
BETAL.yy = sqrt(2) * 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_Y-BETAL.Y_RTCL_CTR+1):(BETAL.ROI_Y+BETAL.ROI_YNP-BETAL.Y_RTCL_CTR) );
% CEGAIN.xx = 1e-3*CEGAIN.RESOLUTION * ( (CEGAIN.ROI_X-CEGAIN.X_RTCL_CTR+1):(CEGAIN.ROI_X+CEGAIN.ROI_XNP-CEGAIN.X_RTCL_CTR) );
% CEGAIN.yy = 1e-3*CEGAIN.RESOLUTION * ( (CEGAIN.ROI_Y-CEGAIN.Y_RTCL_CTR+1):(CEGAIN.ROI_Y+CEGAIN.ROI_YNP-CEGAIN.Y_RTCL_CTR) );
CELOSS.xx = 1e-3*CELOSS.RESOLUTION * ( (CELOSS.ROI_X-CELOSS.X_RTCL_CTR+1):(CELOSS.ROI_X+CELOSS.ROI_XNP-CELOSS.X_RTCL_CTR) );
CELOSS.yy = 1e-3*CELOSS.RESOLUTION * ( (CELOSS.ROI_Y-CELOSS.Y_RTCL_CTR+1):(CELOSS.ROI_Y+CELOSS.ROI_YNP-CELOSS.Y_RTCL_CTR) );



%%

clf()

BETAL.img = double(E200_readImages([prefix filenames(i).filenames.BETAL]));
% CEGAIN.img = double(E200_readImages([prefix filenames(i).CEGAIN]));
CELOSS.img = double(E200_readImages([prefix filenames(i).filenames.CELOSS]));

for j=1:size(BETAL.img,3); BETAL.img(:,:,j) = BETAL.img(:,:,j) - cam_back.BETAL.img(:,:); end;
% for j=1:size(CEGAIN.img,3); CEGAIN.img(:,:,j) = CEGAIN.img(:,:,j) - cam_back.CEGAIN.img(:,:); end;
for j=1:size(CELOSS.img,3); CELOSS.img(:,:,j) = CELOSS.img(:,:,j) - cam_back.CELOSS.img(:,:); end;

% CEGAIN.img(CEGAIN.img<1) = 1;
CELOSS.img(CELOSS.img<1) = 1;

for j=1:size(CELOSS.img,3)
    if i==1 && j==1
            h_text = axes('Position', [0.17, 0.82, 0.05, 0.05], 'Visible', 'off');
            SHOT = text(0.5, 0., ['Shot #' num2str(j)], 'fontsize', 20);
            ax_betal = axes('position', [0.05, 0.1, 0.45, 0.8]);
            image(BETAL.xx,BETAL.yy,BETAL.img(:,:,j),'CDataMapping','scaled');
            colormap(cmap);
            fig_betal = get(gca,'Children');
            daspect([1 1 1]);
            axis xy;
            caxis(BETAL_caxis);
            colorbar();
            xlabel('x (mm)'); ylabel('y (mm)');
            title('BETAL');
%             axes('position', [0.58, 0.1, 0.1, 0.8])
%             image(CEGAIN.yy,CEGAIN.xx,log10(CEGAIN.img(:,:,j)'),'CDataMapping','scaled');
%             colormap(cmap);
%             fig_cegain = get(gca,'Children');
%             axis xy;
%             caxis(CEGAIN_caxis);
%             xlabel('x (mm)'); ylabel('y (mm)');
%             axesPosition = get(gca, 'Position');
%             hNewAxes = axes('Position', axesPosition, 'Color', 'none', 'YAxisLocation', 'right', 'XTick', [], ...
%                 'Box', 'off','YLim', [1,1392], 'YTick', 50:100:1392, ...
%                 'YTickLabel', E200_cher_get_E_axis('20130423', 'CEGAIN', 0, 50:100:1392));
%             ylabel('E (GeV)');
%             title('CEGAIN (log scale)');
            axes('position', [0.8, 0.1, 0.1, 0.8])
            image(CELOSS.yy,CELOSS.xx,log10(CELOSS.img(:,:,j)'),'CDataMapping','scaled');
            colormap(cmap);
            fig_celoss = get(gca,'Children');
            axis xy;
            caxis(CELOSS_caxis);
            xlabel('x (mm)'); ylabel('y (mm)');
            axesPosition = get(gca, 'Position');
            hNewAxes = axes('Position', axesPosition, 'Color', 'none', 'YAxisLocation', 'right', 'XTick', [], ...
                'Box', 'off','YLim', [1,1392], 'YTick', 50:100:1392, ...
                'YTickLabel', E200_cher_get_E_axis('20130423', 'CELOSS', 0, 50:100:1392, 0, 11.));
            ylabel('E (GeV)');
            title('CELOSS (log scale)');
    else
            set(SHOT, 'String', ['Shot #' num2str(j)]);
            set(fig_betal,'CData',BETAL.img(:,:,j));
%             set(fig_cegain,'CData',log10(CEGAIN.img(:,:,j)'));
            set(fig_celoss,'CData',log10(CELOSS.img(:,:,j)'));  
    end
%     pause(0.2);
    pause;
end








