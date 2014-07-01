function moment = wm(x,y,n)

if nargin < 3; n = 1; end

if numel(x) ~= numel(y); error('x and y vectors must have same length'); end
if size(x,1) == 1; x = x'; end
if size(y,1) == 1; y = y'; end

if n == 1
    
    moment = sum(x.*y)/sum(y);
    
end

if n == 2
    
    cent = sum(x.*y)/sum(y);
    moment = sqrt(sum(y.*(x-cent).^2)/sum(y));
    
end

    
    