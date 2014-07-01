clear all;

% header = '';
header = '/Volumes/PWFA_4big';
nas  ='/nas/nas-li20-pm00/';
expt = 'E200';
year = '/2014/';
day  = '20140609/';
dataset = '13285';
pyro_cut = [0 15000];
pyro_cut = [5500 7000];


data_path = [nas expt year day expt '_' dataset '/' expt '_' dataset '.mat'];

%% load data
load([header data_path]);


n_step         = data.raw.metadata.n_steps;
step_num       = data.raw.scalars.step_num.dat;
step_val       = data.raw.scalars.step_value.dat;

EPICS_UID = data.raw.scalars.PATT_SYS1_1_PULSEID.UID;
PYRO = data.raw.scalars.BLEN_LI20_3014_BRAW;
PYRO_CUT_UID = PYRO.UID(PYRO.dat>pyro_cut(1) & PYRO.dat<pyro_cut(2));

[~,PYRO_CUT_index,~] = intersect(EPICS_UID,PYRO_CUT_UID);
step_num = step_num(PYRO_CUT_index);
step_val = step_val(PYRO_CUT_index);
PYRO_CUT_DAT = PYRO.dat(PYRO_CUT_index);

%% ELANEX chunk
ELANEX = data.raw.images.ELANEX;
ELANEX_bg = load([header ELANEX.background_dat{1}]);

[~,EPICS_index,ELANEX_index] = intersect(PYRO_CUT_UID,ELANEX.UID);
QS_VALS = step_val(EPICS_index);
STEPS = step_num(EPICS_index);
PYRO_CUT_DAT = PYRO_CUT_DAT(EPICS_index);

elanex_roi.top = 1;
elanex_roi.bottom = 734;
elanex_roi.left = 1;
elanex_roi.right = 1292;
elanex_roi.rot = 0;
elanex_roi.fliplr = 0;
elanex_roi.flipud = 0;

ELANEX_ANA = basic_image_ana(ELANEX,1,elanex_roi,header);

%% moving elanex window

vals = unique(QS_VALS);
steps = unique(STEPS);
PIXELS = [];
for i = 1:numel(vals)
    [EAX,FULL_AX,PIX] = get_ELANEX_axis(vals(i));
    PIXELS = [PIXELS; PIX];
end

ELANEX_SPECS = zeros(numel(FULL_AX),numel(ELANEX_index));
ANA_SPECS = ELANEX_ANA.y_profs(:,ELANEX_index);

for i = 1:numel(ELANEX_index)
    
    ELANEX_SPECS(PIXELS(STEPS(i),:),i)=ANA_SPECS(:,i);
    
    
end

cmap  = custom_cmap();

e_sub = FULL_AX(PIXELS(steps(end),1):PIXELS(1,734));

%% plotting below

figure(1)
set(gcf,'color','w');
set(gca,'fontsize',14);
subplot(3,1,[1 2]);
pcolor(1:numel(ELANEX_index),e_sub,ELANEX_SPECS(PIXELS(steps(end),1):PIXELS(1,734),:)); shading flat; box off; colorbar;
xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
XTick_position  = find(diff(step_num))+1;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num)])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list);
colormap(cmap.wbgyr);
% set(gca, 'YTick', []);
for i = 1:(n_step-1)
    line([XTick_position(i) XTick_position(i)],[e_sub(1) e_sub(end)],'color','k','linestyle','--');
end

ylabel('Energy [GeV]','fontsize',14);
title(['Dataset ' dataset '. QS scan with ELANEX.'],'fontsize',14);
% title(['Dataset ' dataset '. Phase ramp scan with ELANEX.'],'fontsize',14);
caxis([0 1000]);

subplot(313);
plot(PYRO_CUT_DAT);
for i = 1:(n_step-1)
    line([XTick_position(i) XTick_position(i)],[pyro_cut(1) pyro_cut(end)],'color','k','linestyle','--','linewidth',2);
end
box off;
set(gca, 'XTick', ([1 XTick_position]+[XTick_position length(step_num)])/2);
set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list);
xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',14);
% xlabel('Phase ramp','fontsize',14);
ylabel('Pyro [arb. u.]','fontsize',14);
xlim([0 length(step_num)]);
ylim(pyro_cut);

% saveas(1, ['/nas/nas-li20-pm00/' data.raw.metadata.param.dat{1}.tail_path '/' expt '_' dataset '_ELANEX_waterfall_Pyro_Cut_' num2str(pyro_cut(1)) '_' num2str(pyro_cut(2))], 'fig');




