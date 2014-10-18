function [im_struct, image] = image_ana(im_struct,use_bg,roi,header,i)

display(i);

image = double(imread([header im_struct.dat_common{i}]));

if roi.rot; image = rot90(image,roi.rot); end;
if roi.fliplr; image = fliplr(image); end;
if roi.flipud; image = flipud(image); end;
if use_bg==1; image = image - 2.027*rot90(double(im_struct.ana.bg.img),2); end;
if use_bg==2; image = image - double(im_struct.ana.bg.img); end;

image = image(roi.top:roi.bottom,roi.left:roi.right);

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
