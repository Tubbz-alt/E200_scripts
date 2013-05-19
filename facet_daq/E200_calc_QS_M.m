% Usage :
%     function [m12, m34, M4] = E200_calc_QS_M(KQS1, KQS2, ds)
% calc's imaging terms of FACET spectrometer

%% Changelog :
%% E. Adli, February 26, 2013
%%   First version!

function [m12, m34, M4] = E200_calc_QS_M(KQS1, KQS2, delta_E_E0, ds)
% K1, K2 [/m2] 
% delta_E_E0 [-], i.e. QS=+1, delta_E_E0 = +1/20.35

% length KS1
l = 1.0;

k1 =  abs(KQS1) / (1+delta_E_E0);
k2 =  abs(KQS2) / (1+delta_E_E0);

OO = zeros(2,2);

% Thick lens

% QS1 full
k = abs(k1);
phi = l*sqrt(k);
M_F = [cos(phi)             (1/sqrt(k))*sin(phi)
       -sqrt(k)*sin(phi)    cos(phi)];
M_D = [cosh(phi)             (1/sqrt(k))*sinh(phi)
       sqrt(k)*sinh(phi)    cosh(phi)];
M4_F = [M_F OO; OO M_D];

% QS2 full
k = abs(k2);
phi = l*sqrt(k);
M_F = [cos(phi)             (1/sqrt(k))*sin(phi)
       -sqrt(k)*sin(phi)    cos(phi)];
M_D = [cosh(phi)             (1/sqrt(k))*sinh(phi)
       sqrt(k)*sinh(phi)    cosh(phi)];
M4_D = [M_D OO; OO M_F];

% QS1 half
l05 = l/2;
k = abs(k1);
phi05 = l05*sqrt(k);
phi05 = l05*sqrt(k);
M_F05 = [cos(phi05)             (1/sqrt(k))*sin(phi05)
       -sqrt(k)*sin(phi05)    cos(phi05)];
M_D05 = [cosh(phi05)             (1/sqrt(k))*sinh(phi05)
       sqrt(k)*sinh(phi05)    cosh(phi05)];
M4_F05 = [M_F05 OO; OO M_D05];

% QS2 half
k = abs(k2);
phi05 = l05*sqrt(k);
phi05 = l05*sqrt(k);
M_F05 = [cos(phi05)             (1/sqrt(k))*sin(phi05)
       -sqrt(k)*sin(phi05)    cos(phi05)];
M_D05 = [cosh(phi05)             (1/sqrt(k))*sinh(phi05)
       sqrt(k)*sinh(phi05)    cosh(phi05)];
M4_D05 = [M_D05 OO; OO M_F05];

% B5D36 (as extracted from elegant, i.e. only correct of for nominal E)

M4_DIP = [
   0.999983104334567   0.977899999985955  -0.000000000000003   0.000000000000001
  -0.000034554704370   0.999983104334567  -0.000000000000007  -0.000000000000003
  -0.000000000000003   0.000000000000001   1.000000000000000   0.977894132610565
  -0.000000000000007  -0.000000000000003  -0.000000000000000   1.000000000000000];

LIPOTR2QS1 = 5.706600;
LQS12QS2 = 4.0;
LQS22DIP = 0.742799;
LDIP2CHER = 9.9;

d1 = LIPOTR2QS1 - ds; % postive ds, start downstream MIP
M_01 = [1 d1; 0 1];
M4_01 = [M_01 OO; OO M_01];

d2 = LQS12QS2;
M_02 = [1 d2; 0 1];
M4_02 = [M_02 OO; OO M_02];

d3 =  LQS22DIP;
M_03 = [1 d3; 0 1];
M4_03 = [M_03 OO; OO M_03];

d4 =  LDIP2CHER;
M_04 = [1 d4; 0 1];
M4_04 = [M_04 OO; OO M_04];


% dump line optics, ignoring bend

M4 = M4_04*M4_DIP*M4_03*M4_D*M4_02*M4_F*M4_01;

m12 = M4(1,2);
m34 = M4(3,4);

return;
