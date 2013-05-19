function output = Ana_CELOSS_img(E, img)

output.E_DECC = sum(sum(img(:,E<19)));
output.E_UNAFFECTED2 = sum(sum(img(:,E<22 & E>19)));

a = cumsum(sum(img(:,51:1392),1));
ind = find(a<0.01*max(a), 1, 'last');
output.E_EMIN = E(ind);

end


