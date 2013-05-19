%
% get init values           
%
[BACT_init, BDES_init] = control_magnetGet({'BNDS:LI20:3330'}); 


%E200_gen_scan(@set_QFF6_BDES, BDES_init*0.75, BDES_init*1.25, 7, 7, 20);


%
% re-set init values           
%
% control_magnetSet({'BNDS:LI20:3330'}, BDES_init,  'action', 'TRIM'); 
