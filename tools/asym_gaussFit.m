function p = asym_gaussFit(x,y,p0)

% p(1) is the peak position of the asymetric gaussian function
% p(2) is the amplitude of the asymetric gaussian function
% p(3) is the left sigma of the asymetric gaussian function
% p(4) is the right sigma of the asymetric gaussian function
% p(5) is the baseline constant

options = optimset('MaxFunEval', 1e4);
p = fminsearch(@gaussError, p0, options);

    function residue = gaussError(p)
        f = zeros(size(x));
        f(x<=p(1)) = p(2)*exp(-(x(x<=p(1))-p(1)).^2/(2*p(3)^2)) + p(5);
        f(x>p(1)) = p(2)*exp(-(x(x>p(1))-p(1)).^2/(2*p(4)^2)) + p(5);
        residue = sum( ((f-y)).^2 );
    end
end



