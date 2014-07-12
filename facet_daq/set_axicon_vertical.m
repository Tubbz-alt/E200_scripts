

function set_axicon_vertical(y)

% Axicon vertical motor PV
AXICON_Y = 'XPS:LI20:PWFA:M4';

% Move Axicon to the desired vertical position
lcaPutSmart(AXICON_Y, y);
RBV = lcaGetSmart([AXICON_Y '.RBV']);
counter = 0;
while abs(y-RBV) >  0.01
    
    RBV = lcaGetSmart([AXICON_Y '.RBV']);
    if(isnan(RBV))
        lcaPutSmart(AXICON_Y, y);
    end
    display(['Delta Y = ' num2str(y-RBV)]);
    pause(0.1);

    counter = counter + 1;
    if counter > 50
        lcaPutSmart(AXICON_Y, y);
    end
end