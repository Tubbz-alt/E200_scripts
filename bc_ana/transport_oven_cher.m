function [ xcher ] = transport_oven_cher( gamma, gamma0, sigmax, sigmaxprime1, percent1, sigmaxprime2 )

N = 10000;

D1 = 5.93; D2 = 5; D3 = 12.12;
f1 = 3.46; f2 = 4.51;

xoven = sigmax*randn(1,N);
xprimeoven = [sigmaxprime1*randn(1,percent1*N), sigmaxprime2*randn(1,N-percent1*N)];
Xoven = [xoven;xprimeoven];

R11 = 1 - gamma0*D2/(gamma*f1) + gamma0*D3/(gamma*f2) - gamma0*D3/(gamma*f1) - D2*D3*gamma0^2/(f1*f2*gamma^2);
R12 = D1 + D2 + D3 - D1*D2*gamma0/(gamma*f1) + D1*D3*gamma0/(gamma*f2) - D1*D3*gamma0/(gamma*f1) + D2*D3*gamma0/(gamma*f2) - D1*D2*D3*gamma0^2/(f1*f2*gamma^2);
R21 = gamma0/(gamma*f2) - gamma0/(gamma*f1) - D2*gamma0^2/(f1*f2*gamma^2);
R22 = 1 + gamma0*D1/(gamma*f2) + gamma0*D2/(gamma*f2) - gamma0*D1/(gamma*f1) - D1*D2*gamma0^2/(f1*f2*gamma^2);

R = [R11,R12;R21,R22];

Xcher = R*Xoven;
xcher = Xcher(1,:);

end

