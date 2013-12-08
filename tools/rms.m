% Calcul le RMS d'une fonction.

function x_rms = rms(f, x, p)

if nargin<3; p=0; end;
if nargin<2; x=1:length(f); end;

f_max = max(f);
f(f<p*f_max) = 0;

x_mean = sum(x.*f)/sum(f);
x_rms = sqrt(sum((x-x_mean).^2.*f)/sum(f));

end