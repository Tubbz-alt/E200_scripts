

%%
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/facet_daq/');
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/sc_ana/');
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/tools/');

day = '20140526';

save_path = ['~/Dropbox/SeB/PostDoc/Projects/2014_E200_Data_Analysis/' day '/'];

%%
data_set = {'E200_12967'};



%% Loading

clear waterfall;

for i=1:length(data_set)
    load([save_path data_set{i}]);
    waterfall.(data_set{i}) = data.user.scorde.waterfall;
end







%%

cmap = custom_cmap();
water_type_list = [{'SYAG'}, {'CMOS_FAR'}];

QS = data.raw.scalars.step_value.dat(EPICS_CMOS_FAR);

Q_WB = sum(waterfall.(char(data_set{1})).SYAG(520:590,:),1);
Q_DB = sum(waterfall.(char(data_set{1})).SYAG(40:380,:),1);

x_WB = zeros(1,300);
for i=1:300; x_WB(i) = sum((520:590)'.*waterfall.(char(data_set{1})).SYAG(520:590,i))/Q_WB(i); end;

toro_2452_tmit = data.raw.scalars.GADC0_LI20_EX01_AI_CH0_.dat(EPICS_CMOS_FAR);
toro_3163_tmit = data.raw.scalars.GADC0_LI20_EX01_AI_CH2_.dat(EPICS_CMOS_FAR);
toro_3255_tmit = data.raw.scalars.GADC0_LI20_EX01_AI_CH3_.dat(EPICS_CMOS_FAR);
bpms_2445_x    = data.raw.scalars.BPMS_LI20_2445_X.dat(EPICS_CMOS_FAR);
bpms_2445_y    = data.raw.scalars.BPMS_LI20_2445_Y.dat(EPICS_CMOS_FAR);
bpms_2445_tmit = data.raw.scalars.BPMS_LI20_2445_TMIT.dat(EPICS_CMOS_FAR);
bpms_3156_x    = data.raw.scalars.BPMS_LI20_3156_X.dat(EPICS_CMOS_FAR);
bpms_3156_y    = data.raw.scalars.BPMS_LI20_3156_Y.dat(EPICS_CMOS_FAR);
bpms_3156_tmit = data.raw.scalars.BPMS_LI20_3156_TMIT.dat(EPICS_CMOS_FAR);
bpms_3265_x    = data.raw.scalars.BPMS_LI20_3265_X.dat(EPICS_CMOS_FAR);
bpms_3265_y    = data.raw.scalars.BPMS_LI20_3265_Y.dat(EPICS_CMOS_FAR);
bpms_3265_tmit = data.raw.scalars.BPMS_LI20_3265_TMIT.dat(EPICS_CMOS_FAR);
bpms_3315_x    = data.raw.scalars.BPMS_LI20_3315_X.dat(EPICS_CMOS_FAR);
bpms_3315_y    = data.raw.scalars.BPMS_LI20_3315_Y.dat(EPICS_CMOS_FAR);
bpms_3315_tmit = data.raw.scalars.BPMS_LI20_3315_TMIT.dat(EPICS_CMOS_FAR);
laser          = data.raw.scalars.PMTR_LA20_10_PWR.dat(EPICS_CMOS_FAR);
laser_on = laser > 5;
laser_off = laser < 5;




% for data_step=1:length(data_set)
% for water_type_step = 1:length(water_type_list)


% water_type = water_type_list(water_type_step);
% water_type = char(water_type);
% water_type = 'CEGAIN2';
% data_step = 7;
% qs_step = 3;

[~, ind1] = sort(PYRO);
[~, ind2] = sort(Q_WB);
[~, ind3] = sort(Q_DB);
[~, ind4] = sort(CMOS_FAR.Charge_at_QS);
[~, ind5] = sort(x_WB, 'descend');
[~, ind6] = sort(CMOS_FAR.Transverse_Position);
[~, ind7] = sort(CMOS_FAR.Transverse_Position2);
[~, ind8] = sort(bpms_3156_x);
[~, ind9] = sort(bpms_3265_x);
[~, ind10] = sort(bpms_3315_x);
[~, ind11] = sort(bpms_3265_x-bpms_3156_x);
[~, ind12] = sort(bpms_3315_x-bpms_3156_x);

% b = waterfall.(data_set{data_step}).(char(water_type))(:,ind(:),qs_step);
% b = waterfall.(data_set{data_step}).(char(water_type));


b = waterfall.(char(data_set{1})).CMOS_FAR';
c = waterfall.(char(data_set{1})).SYAG';

d = b([1:160 210:280],:);

ind_sort = ind5;

b_sort = b(ind_sort,:);
c_sort = c(ind_sort,:);
QS_sort = QS(ind_sort);
[~, ind] = sort(QS_sort);


b(b<1)=1;
figure(2);
set(gcf, 'color', 'w');
set(gcf, 'paperposition', [0 0 4 10]);
clf();
yy = 1:2559;
yy = yy(E_CMOS_FAR<E_range(2) & E_CMOS_FAR>E_range(1));
xx = 1:n_CMOS_FAR;
imagesc(yy, xx, b_sort(ind,:));
% imagesc(yy, 1:size(d,1), d);
set(gca, 'fontsize', 22);
axis xy;
colormap(cmap.wbgyr);
caxis([0 1.2e5])
energy_ticks = [17.5, 20, 25, 30, 35, 40, 45, 50, 55, 60];
xticks = interp1(E_CMOS_FAR(1:2400), 1:2400, energy_ticks);
set(gca, 'XTick', xticks);
set(gca, 'XTickLabel', energy_ticks);
title('CMOS FAR Waterfall Plot, Sorted by SYAG Witness Position ');
xlabel('Electron energy (GeV)', 'fontsize', fs+10);

figure(3);
set(gcf, 'color', 'w');
set(gcf, 'paperposition', [0 0 4 10]);
clf();
imagesc(fliplr(c_sort(ind,:)));
set(gca, 'fontsize', 22);
axis xy;
colormap(cmap.wbgyr);
caxis([0 1.2e4])
title('SYAG Waterfall Plot, Sorted by PYRO ');



% if strcmp(water_type, 'CMOS_FAR')
%     caxis([0 5000])
% else
%     caxis([0 400])
% end
% set(gca, 'YTick', 50:100:1392);
% E = E200_cher_get_E_axis('20130423', water_type(1:6), 0, 1:1392);
% set(gca, 'YTickLabel', E(50:100:1392));
% xlabel('Shot #');
% ylabel('E (GeV)');


% % xlabel('Shots sorted by Pyro');
% print('-f2', ['~/Dropbox/SeB/PostDoc/Conf-Pres-etc/2013_05_30_PWFA-Meeting_SCorde/' data_set{data_step} '_qs_step=' num2str(qs_step) '_waterfall_' water_type '_3.png'], '-dpng', '-r100');

% hold on;
% for i=1:50; ind(i) = find(E_EGAIN==E_EMAX(i), 1); end;
% axesPosition = get(gca, 'Position');
% hNewAxes = axes('Position', axesPosition, 'Color', 'none');
% plot(hNewAxes, 1:50, 501:550, 's-');
% plot(hNewAxes, 1:50, 31:80, 's-');


% figure(3)
% plot(derived.E200_10794.E_EMAX(QS,:), 'b-');
% hold on;
% plot(derived.E200_10794.E_EMAX2(QS,:), 'r-');
% plot(derived.E200_10794.E_EMAX3(QS,:), 'g-');
% hold off;

% QS_val = -8:4:8;
% print('-f2', ['~/Desktop/waterfall4/' data_set{data_step} '_qs_step=' num2str(qs_step) '_waterfall_' water_type '.png'], '-dpng', '-r100');

% 
% end
% end


