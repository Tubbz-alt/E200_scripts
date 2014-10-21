function [im_struct, image] = image_ana(im_struct,use_bg,roi,header,i)

x1 = linspace(-2^16,2^16,20000);
dx1 = x1(2)-x1(1);

    function bg_average = Background_Error(p)
        tmp = image - p*bg;
%         tmp(roi.mask==0) = -1e6;
        tmp_2 = tmp(roi.mask==1);
        %     numel(tmp_2)
        %     N_bg(i)
        noise = hist(tmp_2, x1)/dx1;
        p = gaussFit(x1, noise, [50, 0, 100, 0]);
        bg_average = p(2)^2;
        
        %         tmp_2 = tmp;
        %         tmp_2(roi.mask) = 0;
        %         figure(20); imagesc(tmp_2); colorbar(); caxis([0 2^12]);
        %         bg_average = mean(tmp(roi.mask))^2;
    end


display(i);

image = double(imread([header im_struct.dat_common{i}]));

if roi.rot; image = rot90(image,roi.rot); end;
if roi.fliplr; image = fliplr(image); end;
if roi.flipud; image = flipud(image); end;

image = image(roi.top:roi.bottom,roi.left:roi.right);
if use_bg==1
    bg = rot90(double(im_struct.ana.bg.img),2);
    bg = bg(roi.top:roi.bottom,roi.left:roi.right);
    p = 2;
%     p = 2.027;  % good for E200_13450 Shot 1345000050032
elseif use_bg==2
    bg = rot90(double(im_struct.ana.bg.img),2);
    bg = bg(roi.top:roi.bottom,roi.left:roi.right);
    options = optimset('MaxFunEval', 1e4);
    p = fminsearch(@Background_Error, 2, options);
elseif use_bg==3
    bg = double(im_struct.ana.bg.img);
    bg = bg(roi.top:roi.bottom,roi.left:roi.right);
    p = 1;
elseif use_bg==4
    bg = double(im_struct.ana.bg.img);
    bg = bg(roi.top:roi.bottom,roi.left:roi.right);
    options = optimset('MaxFunEval', 1e4);
    p = fminsearch(@Background_Error, 1, options);    
else
    bg = 0;
    p = 0;
end
image = image - p*bg;
im_struct.ana.bg.p(i) = p;

x_prof = sum(image);
y_prof = sum(image,2);

[~,ix] = max(x_prof);
[~,iy] = max(y_prof);

xc = wm(im_struct.ana.x_axis,x_prof,1);
xrms = wm(im_struct.ana.x_axis,x_prof,2); % standard deviation, not rms...?

yc = wm(im_struct.ana.y_axis,y_prof,1);
yrms = wm(im_struct.ana.y_axis,y_prof,2); % standard deviation, not rms...?

im_struct.ana.x_max(i) = im_struct.ana.x_axis(ix);
im_struct.ana.y_max(i) = im_struct.ana.y_axis(iy);

im_struct.ana.x_cent(i) = xc;
im_struct.ana.x_rms(i) = xrms;

im_struct.ana.y_cent(i) = yc;
im_struct.ana.y_rms(i) = yrms;

im_struct.ana.x_profs(:,i) = x_prof;
im_struct.ana.y_profs(:,i) = y_prof;

im_struct.ana.x_maxs(:,i) = max(image,[],1);
im_struct.ana.y_maxs(:,i) = max(image,[],2);

im_struct.ana.sum(i) = sum(image(:));



end


