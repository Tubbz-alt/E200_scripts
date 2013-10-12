function [Res] = k_fit(z, Ec, S_exp, pick, sextufilter)
% Fit function for the factor k1, given a critical energy Ec.

% k1 = 0.82;
k1 = z(1);
% k2 = z(3);
k2 = 0.97;

S_exp = [k1*S_exp(1:7) k2*S_exp(8:14)];
S_sim = interp1(sextufilter.Ec, sextufilter.S_sim, Ec);

Res = sqrt(sum((S_exp(pick) - S_sim(pick)).^2)/size(pick,2));

end


