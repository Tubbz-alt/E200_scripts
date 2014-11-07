
%%
% path = '/nas/nas-li20-pm03/E200/2013/20131110/E200_11513/E200_11513_CEGAIN-11-10-2013-20-52-44';
% path ='/nas/nas-li20-pm03/E200/2013/20131109/E200_11474/E200_11474_CEGAIN-11-09-2013-01-11-54'; % Data set with 50x500 cm2 betas.
path = '/nas/nas-li20-pm03/E200/2013/20131108/E200_11469/E200_11469_CEGAIN-11-08-2013-23-49-13'; % Data set with 10x100 cm2 betas.

img = E200_readImages(path);



%%
sig_0 = zeros(49,1);
theta_0 = zeros(49,1);
emit_x = zeros(49,1);
beta_x = zeros(49,1);

% for i = 2:50;
% i = 18; % for E200_11474
% i = 41; % for E200_11469
i = 17; % for E200_11469
image = img(:,:,i);

lineouts = {};
p_fit = {};
x_pixels = 500:800;
% y_start = 410;
y_start = 350; % For dataset 11469s
for j=1:20;
    y = sum(image(y_start+10*(j-1):y_start-1+10*j, x_pixels),1);
%     figure(2);
%     plot(x_pixels, y, 'b'); hold on;
    p = gaussFit(x_pixels, y, [1e4, 550, 30, 2000]);
%     f = p(1)*exp(-(x_pixels-p(2)).^2/(2*p(3)^2)) + p(4);
%     plot(x_pixels, f, 'r'); hold off;
    p_fit{end+1} = p;
    lineouts{end+1} = y;
%     pause(0.01);
end




cal = 10.39; % um/pix

fig = figure(3);
set(fig, 'color', 'w');
set(gca, 'fontsize', 20);
sig_x = [];
for j=1:size(p_fit, 2); sig_x(end+1) = p_fit{j}(3); end;

y = ((1:size(p_fit, 2))) * 10*1e-3*cal;
sig_x = sig_x*cal/sqrt(2);

% selec = 6:13;
selec = 8:size(p_fit,2)-4;
% selec = 1:size(p_fit,2);
y = y(selec);
sig_x = sig_x(selec);

plot(y, sig_x.^2, 'bs'); hold on;

p = polyfit(y, sig_x.^2, 2);
yy = y(1):0.01:y(end);
plot(yy, p(1)*yy.^2+p(2)*yy+p(3), 'r-', 'linewidth', 3); hold off;

xlabel('y (mm)');
ylabel('\sigma ^2 (\mu m^2)');
title('Butterfly parabola at ELANEX')


% R11 = 5.6;
% T126 = 23; % in m
R11 = 5.0444;
T126 = 21.935; % in m
eta_y = 56; % in mm
E0 = 20.35; % in GeV

y0 = -p(2)/(2*p(1));

theta_0(i-1) = eta_y*sqrt(p(1))/(2*T126);
sig_0(i-1) = sqrt(p(1)*y0^2 + p(2)*y0 + p(3))/R11;

emit_x(i-1) = (E0*1e3/0.511)*1e-6*sig_0(i-1)*theta_0(i-1);
beta_x(i-1) = sig_0(i-1)/theta_0(i-1);


disp(emit_x(i-1))
disp(beta_x(i-1))
disp(theta_0(i-1))
disp(sig_0(i-1))

% pause;
% end



%%
D = [1 1 1;
     0 0 1;
     0 1 0;
     1 1 0;
     1 0 0;];
F = [0 0.25 0.5 0.75 1];
G = linspace(0, 1, 256);
cmap = interp1(F,D,G);


fig = figure(4);
set(fig, 'color', 'w');
set(gca, 'fontsize', 20);
baseline = mean(mean(image(280:380,300:400)));
imagesc(image(260:680, 400:900)-baseline);
title('ELANEX Profile Monitor');
colorbar()
caxis([0 3500])
colormap(cmap)

