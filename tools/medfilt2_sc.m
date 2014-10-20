


function img2 = medfilt2_sc(img, r, k)

% Usage: img2 = medfilt2_sc(img, r, k)
% r is the desired window size (r = 3 for a 3 by 3 window),
% k selects the element in the ordered list (from smallest to highest count) of 
% pixels in the r by r window,
% For example, (r=3, k=5) or (r=5, k=13) are true median.

A = zeros([size(img), r^2]);
for i=1:r^2
    w = zeros(r);
    w(i) = 1;
    A(:,:,i) = filter2(w, img);
end
B = sort(A,3);
img2 = squeeze(B(:,:,k));

end