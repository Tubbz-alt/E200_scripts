function set_slit(x) % x is the slit position on sYAG in mm.

notch_x        = 'COLL:LI20:2069:MOTR';
notch_y        = 'COLL:LI20:2072:MOTR';
notch_rotation = 'COLL:LI20:2073:MOTR';
left_jaw       = 'COLL:LI20:2085:MOTR';
right_jaw      = 'COLL:LI20:2086:MOTR';


slit_width = lcaGetSmart('SIOC:SYS1:ML01:AO075');
if abs(slit_width)>2; slit_width = 0; disp('Use slit width between -2 and 2 mm. Set to 0 instead.');end;

% slit_width = -0.3;%0.3-0.5; % in mm 

% Calibration factors for left jaw (Nov 22, 3am):
% x = -2.29 mm corresponds to left_jaw = -1.8 mm
% x = -0.71 mm corresponds to left_jaw = -1.0 mm
a = 0.5063; % in motor mm per YAG mm
b = -0.64;
% spencer edit (Dec 16 5 am)
%a = 0.7063; % in motor mm per YAG mm
%b = -0.64;

% Calibration factors for notch x motion (Nov 22, 3am):
% x = -1.84 mm corresponds to notch_x = -3500 um
% x = -0.51 mm corresponds to notch_x = -2500 um
% c = 751.88; % in motor um per YAG mm
% d = -2116.54;
% spencer edit (Dec 16 5 am)
c = 751.88; % in motor um per YAG mm
d = -2116.54;

offset_notch = -1500;
offset_right_jaw = 0;

if x<0
    left_jaw_VAL = a*(x-slit_width/2) + b;
    notch_x_VAL = c*(x+slit_width/2) + d;
    if x<-0.6; right_jaw_VAL = 0; else right_jaw_VAL = a*(0.6+x); end;
elseif x>=0
    notch_x_VAL = c*(x-slit_width/2) + d + offset_notch;
    right_jaw_VAL = a*(x+slit_width/2) + b + offset_right_jaw;
    if x>0.6; left_jaw_VAL = 0; else left_jaw_VAL = a*(x-0.6); end;
end
    
notch_y_VAL = -2600; %-15000;
notch_rotation_VAL = 5;

% Move notch and jaws to the desired positions
lcaPutSmart(notch_y, notch_y_VAL);
lcaPutSmart(notch_rotation, notch_rotation_VAL);
lcaPutSmart(notch_x, notch_x_VAL);
lcaPutSmart(left_jaw, left_jaw_VAL);
lcaPutSmart(right_jaw, right_jaw_VAL);

% Wait they reach their desired positions
while abs( lcaGetSmart([notch_y '.RBV'])-notch_y_VAL ) > 10; end;
while abs( lcaGetSmart([notch_rotation '.RBV'])-notch_rotation_VAL ) > 0.02; end;
while abs( lcaGetSmart([notch_x '.RBV'])-notch_x_VAL ) > 2; end;
while abs( lcaGetSmart([left_jaw '.RBV'])-left_jaw_VAL ) > 0.05; end;
while abs( lcaGetSmart([right_jaw '.RBV'])-right_jaw_VAL ) > 0.05; end;

end


