% function E200_display()


%% Restart stip plot
PYRO = [];
ex_charge = [];
gamma_yield = [];
gamma_max = [];

%% Take new background images
cams = {'YAG',     'YAGS:LI20:2432';
            'CELOSS',    'PROF:LI20:3483';
            'CNEAR',    'PROF:LI20:3484';
            'CEGAIN',    'PROF:LI20:3485';
            'BETAL',    'PROF:LI20:3486';
            'BETA1',    'PROF:LI20:3487';
            'BETA2',    'PROF:LI20:3488'};
cam_back = E200_takeBackground(cams);

%% Run E200_display
addpath('./addaxis5/');
BETAL_caxis = [0,1000];
CEGAIN_caxis = [0,3.6];
CELOSS_caxis = [0,3.6];
CNEAR_caxis = [0,3.6];

D = [1 1 1;
     0 0 1;
     0 1 0;
     1 1 0;
     1 0 0;];
F = [0 0.25 0.5 0.75 1];
G = linspace(0, 1, 256);
cmap = interp1(F,D,G);


counter = 0;
% close(1);
clf();
fig = figure(1);
set(fig, 'position', [0, 70, 1195, 1800]);
set(fig, 'color', 'w');
set(fig,'CurrentCharacter', 'a');
while double(get(gcf,'CurrentCharacter'))==97
% while 1
    BETAL = getProfMon('PROF:LI20:3486');
    CEGAIN = getProfMon('PROF:LI20:3485');
    CNEAR = getProfMon('PROF:LI20:3484');
    CELOSS = getProfMon('PROF:LI20:3483');
    PYRO(end+1) = lcaGetSmart('BLEN:LI20:3014:BRAW');
    USTORO = lcaGetSmart('SIOC:SYS1:ML01:AO028') + lcaGetSmart('SIOC:SYS1:ML01:AO027')*lcaGetSmart('GADC0:LI20:EX01:AI:CH2');
    DSTORO = lcaGetSmart('SIOC:SYS1:ML01:AO030') + lcaGetSmart('SIOC:SYS1:ML01:AO029')*lcaGetSmart('GADC0:LI20:EX01:AI:CH3');
    ex_charge(end+1) = DSTORO - USTORO;
    BETAL.xx = 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_X-BETAL.X_RTCL_CTR+1):(BETAL.ROI_X+BETAL.ROI_XNP-BETAL.X_RTCL_CTR) );
    BETAL.yy = sqrt(2) * 1e-3*BETAL.RESOLUTION * ( (BETAL.ROI_Y-BETAL.Y_RTCL_CTR+1):(BETAL.ROI_Y+BETAL.ROI_YNP-BETAL.Y_RTCL_CTR) );
    CEGAIN.xx = 1e-3*CEGAIN.RESOLUTION * ( (CEGAIN.ROI_X-CEGAIN.X_RTCL_CTR+1):(CEGAIN.ROI_X+CEGAIN.ROI_XNP-CEGAIN.X_RTCL_CTR) );
    CEGAIN.yy = 1e-3*CEGAIN.RESOLUTION * ( (CEGAIN.ROI_Y-CEGAIN.Y_RTCL_CTR+1):(CEGAIN.ROI_Y+CEGAIN.ROI_YNP-CEGAIN.Y_RTCL_CTR) );
    CELOSS.xx = 1e-3*CELOSS.RESOLUTION * ( (CELOSS.ROI_X-CELOSS.X_RTCL_CTR+1):(CELOSS.ROI_X+CELOSS.ROI_XNP-CELOSS.X_RTCL_CTR) );
    CELOSS.yy = 1e-3*CELOSS.RESOLUTION * ( (CELOSS.ROI_Y-CELOSS.Y_RTCL_CTR+1):(CELOSS.ROI_Y+CELOSS.ROI_YNP-CELOSS.Y_RTCL_CTR) );
    CNEAR.xx = 1e-3*CNEAR.RESOLUTION * ( (CNEAR.ROI_X-CNEAR.X_RTCL_CTR+1):(CNEAR.ROI_X+CNEAR.ROI_XNP-CNEAR.X_RTCL_CTR) );
    CNEAR.yy = 1e-3*CNEAR.RESOLUTION * ( (CNEAR.ROI_Y-CNEAR.Y_RTCL_CTR+1):(CNEAR.ROI_Y+CNEAR.ROI_YNP-CNEAR.Y_RTCL_CTR) );
    BETAL.img = BETAL.img - cam_back.BETAL.img;
    CEGAIN.img = CEGAIN.img - cam_back.CEGAIN.img;
    CELOSS.img = CELOSS.img - cam_back.CELOSS.img;
    CNEAR.img = CNEAR.img - cam_back.CNEAR.img;
    CEGAIN.img(CEGAIN.img<1) = 1;
    CELOSS.img(CELOSS.img<1) = 1;
    CNEAR.img(CNEAR.img<1) = 1;
    BETAL = AnaBETAL(BETAL);
    gamma_yield(end+1) = BETAL.gamma_yield;
    gamma_max(end+1) = BETAL.gamma_max;
    %     CEGAIN = AnaCEGAIN(CEGAIN);
%     CELOSS = AnaCELOSS(CELOSS);
    if counter==0
%     if 1
            ax_betal = axes('position', [0.05, 0.55, 0.45, 0.45]);
            image(BETAL.xx,BETAL.yy,BETAL.img,'CDataMapping','scaled');
            colormap(cmap);
            fig_betal = get(gca,'Children');
            daspect([1 1 1]);
            axis xy;
%             cmax = max(BETAL.img((xx.^2+yy.^2)<30^2));
            if BETAL.gamma_max > BETAL_caxis(1)
                caxis([BETAL_caxis(1) BETAL.gamma_max]);
            else
                caxis(BETAL_caxis);
            end
            colorbar();
            xlabel('x (mm)'); ylabel('y (mm)');
            title('BETAL');
            axes('position', [0.58, 0.6, 0.1, 0.35])
            image(CEGAIN.yy,CEGAIN.xx,log10(CEGAIN.img'),'CDataMapping','scaled');
            colormap(cmap);
            fig_cegain = get(gca,'Children');
            axis xy;
            caxis(CEGAIN_caxis);
            xlabel('x (mm)'); ylabel('y (mm)');
            title('CEGAIN (log scale)');
            axes('position', [0.73, 0.6, 0.1, 0.35])
            image(CELOSS.yy,CELOSS.xx,log10(CELOSS.img'),'CDataMapping','scaled');
            colormap(cmap);
            fig_celoss = get(gca,'Children');
            axis xy;
            caxis(CELOSS_caxis);
            xlabel('x (mm)'); ylabel('y (mm)');
            title('CELOSS (log scale)');
            axes('position', [0.88, 0.6, 0.1, 0.35])
            image(CNEAR.yy,CNEAR.xx,log10(fliplr(flipud(CNEAR.img))'),'CDataMapping','scaled');
            colormap(cmap);
            fig_cnear = get(gca,'Children');
            axis xy;
            caxis(CNEAR_caxis);
            xlabel('x (mm)'); ylabel('y (mm)');
            title('CNEAR (log scale)');
            axes('position', [0.05, 0.05, 0.2, 0.2])
            plot(1:length(PYRO), PYRO, 'k');
            ylim([0 1e5]);
            title('Pyro (arb. u.)');
            fig_pyro = get(gca,'Children');
%             fig_ex_charge = addaxis(1:length(ex_charge), ex_charge*1.6e-7, [0 200], 'r');
%             fig_gamma = addaxis(1:length(gamma_yield), gamma_yield/1e6, [0 300], 'g');
%             test = get(gca, 'Children');
%             hold on;
            axes('position', [0.05, 0.3, 0.2, 0.2])
            plot(1:length(ex_charge), ex_charge*1.6e-7, 'r');
            ylim([0 1000]);
            title('Excess charge (pC)');
            fig_ex_charge2 = get(gca, 'Children');
            axes('position', [0.3, 0.05, 0.2, 0.2])
            plot(1:length(gamma_yield), gamma_yield/1e6, 'b'); hold on;
            plot(1:length(gamma_max), gamma_max, 'g'); hold off;
            ylim([0 1000]);
            legend('Total count (MC)', 'Peak count');
            title('Gamma-rays'); 
            fig_gamma2 = get(gca, 'Children');
	else
            set(fig_betal,'CData',BETAL.img);
            if BETAL.gamma_max > BETAL_caxis(1)
            	set(ax_betal, 'CLim', [BETAL_caxis(1) BETAL.gamma_max]);
            else
            	set(ax_betal, 'CLim', BETAL_caxis);              
            end
            set(fig_cegain,'CData',log10(CEGAIN.img'));
            set(fig_celoss,'CData',log10(CELOSS.img'));
            set(fig_cnear,'CData',log10(fliplr(flipud(CNEAR.img))'));
            if length(PYRO)>1000
                set(fig_pyro,'XData', 1:1000, 'YData', PYRO(end-999:end));
            else
                set(fig_pyro,'XData', 1:length(PYRO), 'YData', PYRO);
            end
            if length(ex_charge)>1000
                set(fig_ex_charge2,'XData', 1:1000, 'YData', ex_charge(end-999:end)*1.6e-7);
            else
                set(fig_ex_charge2,'XData', 1:length(ex_charge), 'YData', ex_charge*1.6e-7);
            end
            if length(gamma_yield)>1000
                set(fig_gamma2(1),'XData', 1:1000, 'YData', gamma_yield(end-999:end)/1e6);
                set(fig_gamma2(2),'XData', 1:1000, 'YData', gamma_max(end-999:end));
            else
                set(fig_gamma2(1),'XData', 1:length(gamma_yield), 'YData', gamma_yield/1e6);
                set(fig_gamma2(2),'XData', 1:length(gamma_max), 'YData', gamma_max);
            end
%             set(fig_pyro,'XData', 1:length(ex_charge), 'YData', ex_charge*1.6e-7 * 1e5/200);
%             set(fig_ex_charge,'XData', 1:length(ex_charge), 'YData', ex_charge*1.6e-7 * 1e5/200);
%             set(fig_ex_charge2,'XData', 1:length(ex_charge), 'YData', ex_charge*1.6e-7);
%             set(test(3),'XData', 1:length(gamma_yield), 'YData', gamma_yield/1e6 * 1e5/300);
%             set(fig_gamma,'XData', 1:length(gamma_yield), 'YData', gamma_yield/1e6 * 1e5/300);
%             set(fig_gamma2,'XData', 1:length(gamma_yield), 'YData', gamma_yield/1e6);
%             fig_gamma = addaxis(1:length(gamma_yield), gamma_yield/1e6, 'g');
%             set(fig_strip(2),'YData',ex_charge*1.6e-7);
%             set(fig_strip(3),'YData',gamma_yield/1e7);
%             set(fig_bar,'YData',[PYRO/1e3, ex_charge*1.6e-7, BETAL.gamma_yield/1e7]);

    end
    counter = counter + 1; 
    pause(0.1);
end


%% Print2elog

set(fig, 'PaperPosition', [0.25, 2.5, 12, 18]);
util_printLog(fig);










