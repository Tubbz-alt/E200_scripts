function output = Ana_BETAL_img(xx, yy, img)




% mask_lower_left = [-23, 5]; % position in mm
% mask_upper_right = [18, 15]; % position in mm

[X, Y] = meshgrid(xx, yy);
new_img = img;
new_img((X-3).^2 + (Y-8).^2 > 45^2) = 0;
new_img(X > 36) = 0;
new_img(Y < -25) = 0;

mask_lower_left = [-10, 5]; % position in mm
mask_upper_right = [25, 15]; % position in mm
new_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
    Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

mask_lower_left = [0, -25]; % position in mm
mask_upper_right = [5, -15]; % position in mm
new_img(X>mask_lower_left(1) & X<mask_upper_right(1) & ...
    Y>mask_lower_left(2) & Y<mask_upper_right(2)) = 0;

output.GAMMA_YIELD = sum(new_img(:));
filt_img = filter2(ones(5)/5^2, new_img);
output.GAMMA_MAX = max(filt_img(:));
tmp = filt_img>output.GAMMA_MAX/2.;
output.GAMMA_DIV = 2*sqrt( sum(tmp(:))*(xx(2)-xx(1))*(yy(2)-yy(1))/pi );
output.img = filt_img;

end











