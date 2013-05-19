% Usage :
%     function [m12, m34, M4] = E200_calc_QS(KQS1, KQS2, ds)

%% Changelog :
%% E. Adli, February 26, 2013
%%   First version!

function chi2 = E200_merit_function_QS(K)

KQS1 = K(1);
KQS2 = K(2);

% load ds and delta_E_E0
load -mat /tmp/QS_optim.temp

[m12, m34, M4] = E200_calc_QS_M(KQS1, KQS2, delta_E_E0, d_from_MIP);
chi2 = m12^2 + m34^2;

return;
