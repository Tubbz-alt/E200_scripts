function set_slit(x) % x is the slit position on sYAG in mm.

notch_x        = 'COLL:LI20:2069:MOTR';
notch_y        = 'COLL:LI20:2072:MOTR';
notch_rotation = 'COLL:LI20:2073:MOTR';
left_jaw       = 'COLL:LI20:2085:MOTR';
right_jaw      = 'COLL:LI20:2086:MOTR';

slit_width = 0.3; % in mm 

% Calibration factors for left jaw:
a = 0.5;
b = -0.55;

% Calibration factors for notch x motion:
c = 1000;
d = -1700;

left_jaw_VAL = a*(x-slit_width/2) + b;
notch_x_VAL = c*(x+slit_width/2) + d;

if x<-0.6; right_jaw_VAL = -0.48; else right_jaw_VAL = 4; end;

notch_y_VAL = -15000;
notch_rotation_VAL = 5;

% Move notch and jaws to the desired positions
lcaPutSmart(notch_y, notch_y_VAL);
while abs( lcaGetSmart([notch_y '.RBV'])-notch_y_VAL ) > 10; end;

lcaPutSmart(notch_rotation, notch_rotation_VAL);
while abs( lcaGetSmart([notch_rotation '.RBV'])-notch_rotation_VAL ) > 0.01; end;

lcaPutSmart(notch_x, notch_x_VAL);
while abs( lcaGetSmart([notch_x '.RBV'])-notch_x_VAL ) > 0.005; end;

lcaPutSmart(left_jaw, left_jaw_VAL);
while abs( lcaGetSmart([left_jaw '.RBV'])-left_jaw_VAL ) > 0.005; end;

lcaPutSmart(right_jaw, right_jaw_VAL);
while abs( lcaGetSmart([right_jaw '.RBV'])-right_jaw_VAL ) > 0.005; end;




end