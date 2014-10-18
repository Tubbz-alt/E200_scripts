function p = special_gaussFit(x,y,p0)

options = optimset('MaxFunEval', 1e4);
p = fminsearch(@gaussError, p0, options);

    function residue = gaussError(p)
        f = p(1)*exp(-x.^2/(2*p(2)^2));
        residue = sum( ((f-y)).^2 );
    end
end