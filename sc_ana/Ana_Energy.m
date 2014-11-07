function [im_struct, filt_img, filt_img2] = Ana_Energy(im_struct, E, filt_img, ishot)

charge_calib = im_struct.ana.charge_calib; % Camera charge calibration, in number of e-/e+ per count
box_width = im_struct.ana.roi.box_width;

% Image filtering

% r = 5;     % Adjust for desired window size
% k = 13;     % Select the kth largest element
% img2 = medfilt2_sc(img, r, k);

% band = mean(img2(E>(E(end)-2),:),1);
% for i=1:size(img2,1); img2(i,:) = img2(i,:) - band; end;

% band_left = mean(img2(:,1:51),2);
% band_right = mean(img2(:,end-50:end),2);
% 
% a = (band_right-band_left)/(size(img2,2)-51);
% b = band_left - a*26;
% for i=1:size(img2,1); img2(i,:) = img2(i,:) - (a(i)*(1:size(img2,2)) + b(i)); end;

% base = mean(mean(img(1:100,1:100)));
% img = img-base;

% filt_img = filter2(ones(15,40)/(15*40), img2);
% filt_img(filt_img<10)=0;


% x1 = linspace(-2^16,2^16,20000); dx1 = x1(2)-x1(1);
% noise = hist(filt_img(im_struct.ana.roi.mask), x1)/dx1;
% p = gaussFit(x1, noise, [50, 0, 100, 0]);
% filt_img = filt_img - p(2);
% filt_img = filt_img - mean(filt_img(im_struct.ana.roi.mask));

% Image processing

base = mean(filt_img(im_struct.ana.roi.mask));
filt_img = filt_img - base;

spec = sum(filt_img,2);
[spec2, ind_max] = max(filt_img,[],2);

a = cumsum(spec);
ind = find(a>0.99*max(a), 1);
if isempty(ind)
    im_struct.ana.E_EMAX(ishot) = 20.35;
else
    im_struct.ana.E_EMAX(ishot) = E(ind);
end
ind = find(a>0.01*max(a), 1);
if isempty(ind)
    im_struct.ana.E_EMIN(ishot) = 20.35;
else
    im_struct.ana.E_EMIN(ishot) = E(ind);
end

b = cumsum(spec2);
ind = find(b>0.99*max(b), 1);
if isempty(ind)
    im_struct.ana.E_EMAX2(ishot) = 20.35;
else
    im_struct.ana.E_EMAX2(ishot) = E(ind);
end
ind = find(b>0.01*max(b), 1);
if isempty(ind)
    im_struct.ana.E_EMIN2(ishot) = 20.35;
else
    im_struct.ana.E_EMIN2(ishot) = E(ind);
end

ind = find(spec2>150., 1, 'last');
if isempty(ind)
    im_struct.ana.E_EMAX3(ishot) = 20.35;
else
    im_struct.ana.E_EMAX3(ishot) = E(ind);
end
ind = find(spec2>150., 1);
if isempty(ind)
    im_struct.ana.E_EMIN3(ishot) = 20.35;
else
    im_struct.ana.E_EMIN3(ishot) = E(ind);
end

im_struct.ana.y_profs(:,ishot) = spec;
im_struct.ana.y_maxs(:,ishot) = spec2;

subtraction_level = 0.9; % Allows one not to subtract 100% of the defocused background, but a fraction of the background

pix_E0_y = find(abs(E-20.35)<0.015, 1) ;
x_prof = filt_img(pix_E0_y,:);
p0 = [5e4 240 30 0];
p_x = gaussFit(1:size(filt_img,2), x_prof, p0);
pix_E0_x = p_x(2);


[X,Y] = meshgrid(1:size(filt_img,2),1:size(filt_img,1));
r_min = 100;
r_max = 300;
w = 0.;
lineout = zeros([1,r_max]);
for r=linspace(1, r_max, r_max)
    x1 = pix_E0_x + r*cos(45*pi/180);
    y1 = pix_E0_y + r*sin(45*pi/180);
    x2 = pix_E0_x - r*cos(45*pi/180);
    y2 = pix_E0_y + r*sin(45*pi/180);
%     x3 = pix_E0_x + r*cos(45*pi/180);
%     y3 = pix_E0_y - r*sin(45*pi/180);
%     x4 = pix_E0_x - r*cos(45*pi/180);
%     y4 = pix_E0_y - r*sin(45*pi/180);
    tmp_1 = mean(filt_img((X-x1).^2+(Y-y1).^2<2^2));
    tmp_2 = mean(filt_img((X-x2).^2+(Y-y2).^2<2^2));
%     tmp_3 = mean(filt_img((X-x3).^2+(Y-y3).^2<2^2));
%     tmp_4 = mean(filt_img((X-x4).^2+(Y-y4).^2<2^2));
%     lineout(r) = 0.25 * ( tmp_1 + tmp_2 + tmp_3 + tmp_4 );
    lineout(r) = ( w*tmp_1 + (1-w)*tmp_2 );
end

r=linspace(1, r_max, r_max);
p0 = [1500 100];
p_bg = special_gaussFit(r(r_min:r_max), lineout(r_min:r_max), p0);

% pix_E0_x = im_struct.ana.gaussian_bg.pix_E0_x(ishot);
% pix_E0_y = im_struct.ana.gaussian_bg.pix_E0_y(ishot);
% p_bg(1) = im_struct.ana.gaussian_bg.gaussian_height(ishot);
% p_bg(2) = im_struct.ana.gaussian_bg.gaussian_width(ishot);

R = sqrt( (X-pix_E0_x).^2 + (Y-pix_E0_y).^2 );
background = subtraction_level * p_bg(1)*exp(-R.^2/(2*p_bg(2)^2)); % For radial gaussian subtraction

filt_img2 = filt_img - background;
filt_img2(filt_img2<0) = 0;

dE = diff(E);
dE = (dE(1:end-1) + dE(2:end))/2;
dE = [E(2)-E(1) dE E(end)-E(end-1)];

for i=1:size(filt_img,1)
    if spec2(i)>150.;
        i1 = max(1,floor(ind_max(i)-box_width/2));
        i2 = min(size(filt_img,2),floor(ind_max(i)+box_width/2));
    else
        i1 = max(1,floor((size(filt_img,2) - box_width)/2));
        i2 = min(size(filt_img,2),floor((size(filt_img,2) + box_width)/2));
    end
    im_struct.ana.y_profs_small_box(i,ishot) = sum(filt_img(i,i1:i2));
    im_struct.ana.energy_spectrum(i,ishot) = charge_calib * 1.6e-7 * im_struct.ana.y_profs(i,ishot)/dE(i); % Energy spectrum in pC/GeV
    im_struct.ana.energy_spectrum_2(i,ishot) = charge_calib * 1.6e-7 * im_struct.ana.y_profs_small_box(i,ishot)/dE(i); % Energy spectrum in pC/GeV with transverse integration over small box
    im_struct.ana.energy_spectrum_3(i,ishot) = charge_calib * 1.6e-7 * sum(filt_img2(i,i1:i2))/dE(i); % Energy spectrum in pC/GeV with Gaussian subtraction
end

im_struct.ana.Q_acc(ishot) = charge_calib*sum(im_struct.ana.y_profs(E>21.35 & E<30,ishot)) * 1.6e-7; % Accelerated charge in pC
im_struct.ana.Q_dec(ishot) = charge_calib*sum(im_struct.ana.y_profs(E<19.35,ishot)) * 1.6e-7; % Decelerated charge in pC
im_struct.ana.Q_unaffected(ishot) = charge_calib*sum(im_struct.ana.y_profs(E>19.35 & E<21.35,ishot)) * 1.6e-7; % Unaffected charge in pC
im_struct.ana.eloss(ishot) = charge_calib*1.6e-10*sum((20.35-E(E<20.35)').*im_struct.ana.y_profs(E<20.35,ishot)); % Total energy gained by accelerated particles in J
im_struct.ana.egain(ishot) = charge_calib*1.6e-10*sum((E(E>20.35 & E<30)'-20.35).*im_struct.ana.y_profs(E>20.35 & E<30,ishot)); % Total energy lost by decelerated particles in J
im_struct.ana.efficiency(ishot) = im_struct.ana.egain(ishot)/im_struct.ana.eloss(ishot); % Single shot wake-to-bunch transfer efficiency

im_struct.ana.energy_axis(:,ishot) = E;
im_struct.ana.dE(:,ishot) = dE;



display(pix_E0_x);
display(pix_E0_y);
display(p_bg(1));
display(p_bg(2));


end



