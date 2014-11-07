function sigma = transport(energy,QS,p)

gamma = energy*1e3/0.511;

% Quadrupoles
% Conversion using f = gamma*m*c / (e * Leff*B/a ), or f [m] = E [GeV] / (Leff*B/a [kG] * 0.0299792)
QS_BDES = [261.72, -167.95] * (1 + QS/20.35); % Imaging condition for E200 IP to long plasma exit PEXT, Apr. 22 2014. Value of Leff*B/a in kG
f1 = abs ( energy ./ (QS_BDES(1) * 0.0299792) ); % QS1 focal length in m
f2 = abs ( energy ./ (QS_BDES(2) * 0.0299792) ); % QS2 focal length in m
Leff = 1; % QS 1 & 2 effective length in meter

% Distances
z_PEXT = 1994.97;    % linac z location of plasma exit in meter
z_QS1 = 1999.206665; % linac z location of QS1 (middle of quad) in meter
z_QS2 = 2004.206665; % linac z location of QS2 (middle of quad) in meter
z_CFAR = 2016.04;    % linac z location of Cherenkov Far gap in meter
D1 = z_QS1 - z_PEXT;
D2 = z_QS2 - z_QS1;
D3 = z_CFAR - z_QS2;
% Drift Transport Matrixes
M2_D1 = [1 D1-Leff/2; 0 1];
M2_D2 = [1 D2-Leff; 0 1];
M2_D3 = [1 D3-Leff/2; 0 1];

% Initialisation of R11 and R12 (energy-dependent transport matrix components)
R11 = zeros(size(energy));
R12 = zeros(size(energy));

% Calculation of R11 and R12 as a function of energy
for i=1:numel(energy)
    % QS1 & 2 Transport Matrix
    k = abs(1/(Leff*f1(i)));
    phi = Leff*sqrt(k);
    M2_QS1 = [cos(phi)             (1/sqrt(k))*sin(phi)
        -sqrt(k)*sin(phi)    cos(phi)];
    k = abs(1/(Leff*f2(i)));
    phi = Leff*sqrt(k);
    M2_QS2 = [cosh(phi)             (1/sqrt(k))*sinh(phi)
        sqrt(k)*sinh(phi)    cosh(phi)];
    % Transport Matrix from PEXT to Cherenkov
    M2 = M2_D3 * M2_QS2 * M2_D2 * M2_QS1 * M2_D1;
    % R11 and R12 components of the Transport Matrix
    R11(i) = M2(1,1);
    R12(i) = M2(1,2);
end

eps = p(1)./gamma;
alpha = p(3)/p(2);
xx = p(2) * (1+alpha^2) * eps;
xxp = - alpha * eps;
xpxp = eps / p(2);
sigma =  sqrt( R11.^2 .* xx + 2*R11.*R12 .* xxp + R12.^2 .* xpxp );

end
