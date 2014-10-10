




function p = linFit(x,y,p0)

options = optimset('MaxFunEval', 1e4);
p = fminsearch(@linError, p0, options);

    function residue = linError(p)
        f = p(1)*x;
        residue = sum( ((f-y)).^2 );
    end
end