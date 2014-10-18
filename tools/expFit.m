function p = expFit(x,y,p0)

% Usage: p = expFit(x,y,p0)
% p is the returned fitted parameters
% x and y is the data to fit
% p0 is the initial guess for the parameters
% Fit with exponential function a*exp(-k*x) + b
% p(1) is a
% p(2) is k
% p(4) is b

options = optimset('MaxFunEval', 1e4);
p = fminsearch(@expError, p0, options);

    function residue = expError(p)
        f = p(1)*exp(-p(2)*x);
        residue = sum( ((f-y)).^2 );
    end
end



