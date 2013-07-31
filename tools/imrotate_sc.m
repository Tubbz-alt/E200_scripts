function imOutput = imrotate_sc(imInput, angle)

Z = double(imInput);
sz = size(Z);
[X,Y] = meshgrid(1:sz(2), 1:sz(1));
% Center
c = sz(end:-1:1)/2;
% Angle
t = angle*pi/180;
% Rotation
ct = cos(t);
st = sin(t);
Xi = c(1) + ct*(X-c(1))-st*(Y-c(2));
Yi = c(2) + st*(X-c(1))+ct*(Y-c(2));
% Rotation
imOutput = interp2(X, Y, Z, Xi, Yi);

end