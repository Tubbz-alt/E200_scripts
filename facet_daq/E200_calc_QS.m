% Usage :
%     [isok, BDES1, BDES2, K1, K2, m12, m34, M4] = E200_calc_QS(QS_setting, d_from_MIP, E0);
% Calc's imaging quad setting for FACET spectrometer
%
%    Example usage: 
% QS_setting = +0; % [GeV]
% d_from_MIP = +0.28;% [m], positive is downstream of MIP
% E0 = 20.35; % [GeV]
% [isok, BDES1, BDES2, K1, K2, m12, m34, M4] = E200_calc_QS(QS_setting, d_from_MIP, E0);
% if(isok), BDES1, BDES2, end% if
%
%% Changelog :
%% E. Adli, February 26, 2013
%%   First version!

function [isok, BDESQS1, BDESQS2, KQS1, KQS2, m12, m34, M4] = E200_calc_QS(QS_setting, d_from_MIP, E0)
%%% input
% QS_setting = +0; [GeV]
% d_from_MIP = 0.0;% [m], positive is downstream of MIP
% E0 = 20.35; [GeV]

delta_E_E0 = QS_setting / E0;

save -mat /tmp/QS_optim.temp delta_E_E0 d_from_MIP

% initial guesses (2012 values)
KQS1_0 = 0.3;
KQS2_0 = -0.23;

mytol = (0.01^2 + 0.01^2);

[fit_result, chi2] = fminsearch('E200_merit_function_QS', [KQS1_0 KQS2_0]);

if(chi2 < mytol)

  KQS1 = fit_result(1);
  KQS2 = fit_result(2);
  isok = 1;
  [m12, m34, M4] = E200_calc_QS_M(KQS1, KQS2, delta_E_E0, d_from_MIP);
else
  KQS1 = NaN;
  KQS2 = NaN;
  isok = 0;
  warning('EA: error, could not converge to solution');
  m12 = NaN;
  m34 = NaN;
  M4 = NaN;
end% if

LEFF = 1.0;
kG2T = 0.1;

BDESQS1 =  KQS1 * E0 * LEFF / kG2T / 0.299792;
BDESQS2 =  KQS2 * E0 * LEFF / kG2T / 0.299792;

BMAX = 385; % max value, from SCP
if( BDESQS1 > BMAX || BDESQS2 > BMAX)
  isok = 0;
  warning('EA: error, solution is outside QS range');
end% if