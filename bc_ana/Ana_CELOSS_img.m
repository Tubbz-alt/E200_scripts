function [output, filt_img] = Ana_CELOSS_img(E, img)

%%
% tic;
% band = mean(img(:,E<11.5),2);
% for i=1:size(img,2); img(:,i) = img(:,i) - band; end;
% toc;

% tic;
r = 3;     % Adjust for desired window size
k = 5;     % Select the kth largest element

A = zeros([size(img), r^2]);
for i=1:r^2
    w = zeros(r);
    w(i) = 1;
    A(:,:,i) = filter2(w, img);
end
% toc;
% B = median(A,3);
% img2 = squeeze(B);
B = sort(A,3);
img2 = squeeze(B(:,:,k));
% toc;

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

filt_img = filter2(ones(25,10)/250, img2);

%%

output.E_DECC = sum(sum(img(:,E<19)));
output.E_UNAFFECTED2 = sum(sum(img(:,E<22 & E>19)));

a = cumsum(sum(img(:,51:1392),1));
ind = find(a<0.01*max(a), 1, 'last');
if isempty(ind)
    output.E_EMIN = 20.35;
    output.E_EMIN_ind = 1;
else
    output.E_EMIN = E(50+ind);
    output.E_EMIN_ind = 50+ind;
end

end


