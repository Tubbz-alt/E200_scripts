

function set_axicon_horizontal(x)

% Axicon horizontal motor PV
AXICON_X = 'XPS:LI20:PWFA:M6';

% Move Axicon to the desired horizontal position
lcaPutSmart(AXICON_X, x);
RBV = lcaGetSmart([AXICON_X '.RBV']);
counter = 0;
while abs(x-RBV) >  0.01
    
    RBV = lcaGetSmart([AXICON_X '.RBV']);
    if(isnan(RBV))
        lcaPutSmart(AXICON_Y, y);
    end
    display(['Delta X = ' num2str(x-RBV)]);
    pause(0.1);

    counter = counter + 1;
    if counter > 50
        lcaPutSmart(AXICON_X, x);
    end
end