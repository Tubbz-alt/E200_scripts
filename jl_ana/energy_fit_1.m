function [Res] = energy_fit_1(z, S_exp, pick, sextufilter)
%% Fit function for the critical energy
%%% - "Ec" is the fitted critical energy
%%% - "S_BETA1/2/L" are the measurements of the betatron signal on the
%%%    respective cameras
%%% - "Synchro/Lanex/Nist_ref/" and "pick" are needed for Gamma_num, see
%%%    its description for further details.
%%% - "K_B1L" and "K_B2L" are the fitted values of the ratio of the number 
%%%   of particles per count in the cameras for various critical energies
%%% - [Res] is the residual of the fit. It consists in the rms of the
%%% difference between the simulated value and the measured value of signal
%%% on each selected filter (and camera). 

Ec = z(1);
k1 = z(2);
% k2 = z(3);
k2 = 0.97;

S_exp = [k1*S_exp(1:7) k2*S_exp(8:14)];
S_sim = interp1(sextufilter.Ec, sextufilter.S_sim, Ec);

Res = sqrt(sum((S_exp(pick) - S_sim(pick)).^2)/size(pick,2));

end


