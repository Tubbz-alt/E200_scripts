function [im_struct, filt_img] = Ana_Energy(im_struct, E, img, box_width, ishot)

r = 5;     % Adjust for desired window size
k = 13;     % Select the kth largest element

A = zeros([size(img), r^2]);
for i=1:r^2
    w = zeros(r);
    w(i) = 1;
    A(:,:,i) = filter2(w, img);
end
% B = median(A,3);
% img2 = squeeze(B);
B = sort(A,3);
img2 = squeeze(B(:,:,k));


% [M,N] = size(img);
% img2 = zeros(size(img));
% 
% r = 1;     % Adjust for desired window size
% 
% % for n = 1+r:N-r
% %     for m = 1+r:M-r
% %         % Extract a window of size (2r+1)x(2r+1) around (m,n)
% % %         w = img(m+(-r:r),n+(-r:r));
% % %         img2(m,n) = median(w(:));
% %         img2(m,n) = img(m,n);
% %     end
% % end
% img2 = img;

% band = mean(img2(E>(E(end)-2),:),1);
% for i=1:size(img2,1); img2(i,:) = img2(i,:) - band; end;

band_left = mean(img2(:,1:51),2);
band_right = mean(img2(:,end-50:end),2);

a = (band_right-band_left)/(size(img2,2)-51);
b = band_left - a*26;
for i=1:size(img2,1); img2(i,:) = img2(i,:) - (a(i)*(1:size(img2,2)) + b(i)); end;

% base = mean(mean(img(1:100,1:100)));
% img = img-base;



filt_img = filter2(ones(15,40)/(15*40), img2);
filt_img(filt_img<10)=0;
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

for i=1:size(filt_img,1)
    i1 = max(1,ind_max(i)-box_width/2);
    i2 = min(size(filt_img,2),ind_max(i)+box_width/2);
    im_struct.ana.y_profs_small_box(i,ishot) = sum(filt_img(i,i1:i2));
end



im_struct.ana.Q_acc(ishot) = 36*sum(im_struct.ana.y_profs(E>21.35 & E<30,ishot)) * 1.6e-7; % Accelerated charge in pC
im_struct.ana.Q_dec(ishot) = 36*sum(im_struct.ana.y_profs(E<19.35,ishot)) * 1.6e-7; % Decelerated charge in pC
im_struct.ana.Q_unaffected(ishot) = 36*sum(im_struct.ana.y_profs(E>19.35 & E<21.35,ishot)) * 1.6e-7; % Unaffected charge in pC
im_struct.ana.eloss(ishot) = 36*1.6e-10*sum((20.35-E(E<20.35)').*im_struct.ana.y_profs(E<20.35,ishot)); % Total energy gained by accelerated particles in J
im_struct.ana.egain(ishot) = 36*1.6e-10*sum((E(E>20.35 & E<30)'-20.35).*im_struct.ana.y_profs(E>20.35 & E<30,ishot)); % Total energy lost by decelerated particles in J
im_struct.ana.efficiency(ishot) = im_struct.ana.egain(ishot)/im_struct.ana.eloss(ishot); % Single shot wake-to-bunch transfer efficiency

im_struct.ana.energy_spectrum(1,:) = 36 * 1.6e-7 * im_struct.ana.y_profs(1,:)/(E(2)-E(1)); % Energy spectrum in pC/GeV
im_struct.ana.energy_spectrum_2(1,:) = 36 * 1.6e-7 * im_struct.ana.y_profs_small_box(1,:)/(E(2)-E(1)); % Energy spectrum in pC/GeV with transverse integration over small box
for i=2:(size(im_struct.ana.y_profs,1)-1)
im_struct.ana.energy_spectrum(i,:) = 36 * 1.6e-7 * 2 * im_struct.ana.y_profs(i,:)/(E(i+1)-E(i-1)); % Energy spectrum in pC/GeV
im_struct.ana.energy_spectrum_2(i,:) = 36 * 1.6e-7 * 2 * im_struct.ana.y_profs_small_box(i,:)/(E(i+1)-E(i-1)); % Energy spectrum in pC/GeV with transverse integration over small box
end
im_struct.ana.energy_spectrum(end,:) = 36 * 1.6e-7 * im_struct.ana.y_profs(end,:)/(E(end)-E(end-1)); % Energy spectrum in pC/GeV
im_struct.ana.energy_spectrum_2(end,:) = 36 * 1.6e-7 * im_struct.ana.y_profs_small_box(end,:)/(E(end)-E(end-1)); % Energy spectrum in pC/GeV with transverse integration over small box


end



