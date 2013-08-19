

%%
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/facet_daq/');
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/sc_ana/');
addpath('~/Dropbox/SeB/Codes/sources/E200_scripts/tools/');

day = '20130428';

save_path = ['~/Dropbox/SeB/PostDoc/Projects/2013_E200_Data_Analysis/' day '/'];

D = [1 1 1;
     0 0 1;
     0 1 0;
     1 1 0;
     1 0 0;];
F = [0 0.25 0.5 0.75 1];
G = linspace(0, 1, 256);
cmap = interp1(F,D,G);


%%
data_set = {'E200_10791', 'E200_10792', 'E200_10793', 'E200_10794', 'E200_10796'};
P = [2, 4, 8, 16, 32];


%%
data_set = {'E200_10800', 'E200_10801', 'E200_10803', 'E200_10806', 'E200_10809', 'E200_10810', 'E200_10812', 'E200_10813'};

%%
data_set = {'E200_10787', 'E200_10788', 'E200_10789'};

%%
data_set = {'E200_10787', 'E200_10788', 'E200_10789', 'E200_10791', 'E200_10792', 'E200_10793', 'E200_10794', 'E200_10796',...
    'E200_10800', 'E200_10801', 'E200_10803', 'E200_10806', 'E200_10809', 'E200_10810', 'E200_10812', 'E200_10813'};


%% Loading

clear waterfall;
clear derived;

for i=1:length(data_set)
    tmp = load([save_path data_set{i}]);
    derived.(data_set{i}) = tmp.derived.(data_set{i});
    derived.(data_set{i}).GAMMA_MAXDIV2 = derived.(data_set{i}).GAMMA_MAX .* derived.(data_set{i}).GAMMA_DIV.^2;
    waterfall.(data_set{i}) = tmp.waterfall.(data_set{i});
end







%%
water_type_list = [{'CEGAIN2'}, {'CEGAIN'}, {'CELOSS'}];

for data_step=1:length(data_set)
for qs_step = 1:size(waterfall.(data_set{data_step}).CEGAIN2,3)
for water_type_step = 1:length(water_type_list)


water_type = water_type_list(water_type_step);
water_type = char(water_type);
% water_type = 'CEGAIN2';
% data_step = 7;
% qs_step = 3;

% [A, ind] = sort(derived.(data_set{data_step}).PYRO(qs_step,:));

% b = waterfall.(data_set{data_step}).(char(water_type))(:,ind(:),qs_step);
b = waterfall.(data_set{data_step}).(char(water_type))(:,:,qs_step);

b(b<1)=1;
figure(2);
set(gcf, 'color', 'w');
set(gcf, 'paperposition', [0 0 4 10]);
clf();
imagesc(1:50, 1:1392, log10(b));
set(gca, 'fontsize', 22);
axis xy;
colormap(cmap);
if strcmp(water_type, 'CEGAIN2')
    caxis([0.3 3.2])
else
    caxis([1. 5.5])
end
set(gca, 'YTick', 50:100:1392);
E = E200_cher_get_E_axis('20130423', water_type(1:6), 0, 1:1392);
set(gca, 'YTickLabel', E(50:100:1392));
xlabel('Shot #');
ylabel('E (GeV)');


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
print('-f2', ['~/Desktop/waterfall4/' data_set{data_step} '_qs_step=' num2str(qs_step) '_waterfall_' water_type '.png'], '-dpng', '-r100');


end
end
end


