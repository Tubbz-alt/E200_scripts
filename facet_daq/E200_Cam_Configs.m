function par = E200_Cam_Configs(par)

if par.camera_config == 1
    % General E200 Config for plasma studies
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'DSTHz',    'OTRS:LI20:3075';
            'USOTR',    'OTRS:LI20:3158';
            'IP2A',     'MIRR:LI20:3202';
            'CELOSS',    'PROF:LI20:3483';
            'CEGAIN',    'PROF:LI20:3485';
            'BETAL',    'PROF:LI20:3486';
            'BETA1',    'PROF:LI20:3487';
            'BETA2',    'PROF:LI20:3488'};
        
elseif par.camera_config == 2
    % Plasma emittance studies
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'DSTHz',    'OTRS:LI20:3075';
            'USOTR',    'OTRS:LI20:3158';
            'IP2A',     'MIRR:LI20:3202';
            'CELOSS',    'PROF:LI20:3483';
            'CNEAR',    'PROF:LI20:3484';
            'BETAL',    'PROF:LI20:3486';
            'BETA1',    'PROF:LI20:3487';
            'BETA2',    'PROF:LI20:3488'};

elseif par.camera_config == 3
    % CTM studies
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'DSTHz',    'OTRS:LI20:3075';
            'USOTR',    'OTRS:LI20:3158';
            'IP2A',     'MIRR:LI20:3202';
            'IP2B',     'MIRR:LI20:3230';
            'CELOSS',    'PROF:LI20:3483';
            'CEGAIN',    'PROF:LI20:3485';
            'BETAL',    'PROF:LI20:3486';
            'BETA1',    'PROF:LI20:3487'};

elseif par.camera_config == 4
    % OTR config (no plasma)
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'USOTR',    'OTRS:LI20:3158';
            'IPOTR',    'OTRS:LI20:3180';
            'DSOTR',    'OTRS:LI20:3206';
            'IP2A',    'MIRR:LI20:3202';
            'IP2B',    'MIRR:LI20:3230';
            'CELOSS',    'PROF:LI20:3483';
            'CEGAIN',    'PROF:LI20:3485';
            'BETAL',    'PROF:LI20:3486'};
            
elseif par.camera_config == 5
    % Beta studies
    par.cams = {'BETAL',    'PROF:LI20:3486';
            'BETA1',    'PROF:LI20:3487';
            'BETA2',    'PROF:LI20:3488'};
        
elseif par.camera_config == 6
    % Config for testing purpose
    par.cams = {'YAG',     'YAGS:LI20:2432';};
    
elseif par.camera_config == 7
    % Cher studies: ELOSS and EGAIN
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'CELOSS',    'PROF:LI20:3483';
            'CEGAIN',    'PROF:LI20:3485'};

elseif par.camera_config == 8
    % Cher studies: ELOSS and NEAR
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'CELOSS',    'PROF:LI20:3483';
            'CNEAR',    'PROF:LI20:3484'};

elseif par.camera_config == 9
    % Foil USOTR
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'USOTR',    'OTRS:LI20:3158';
            'BETAL',    'PROF:LI20:3486'};
        
elseif par.camera_config == 10
    % Foil IPOTR
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'IPOTR',    'OTRS:LI20:3180';
            'BETAL',    'PROF:LI20:3486'};
        
elseif par.camera_config == 11
    % Foil DSOTR
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'DSOTR',    'OTRS:LI20:3206';
            'BETAL',    'PROF:LI20:3486'};
        
elseif par.camera_config == 12
    % Foil IP2A
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'IP2A',    'MIRR:LI20:3202';
            'BETAL',    'PROF:LI20:3486'};
        
elseif par.camera_config == 13
    % Foil IP2B
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'IP2B',    'MIRR:LI20:3230';
            'BETAL',    'PROF:LI20:3486'};
        

 
elseif par.camera_config == 14
    % Cher studies: ELOSS and EGAIN
    par.cams = {
            'CELOSS',    'PROF:LI20:3483';
            'CEGAIN',    'PROF:LI20:3485'};

elseif par.camera_config == 15
  % TCAV, plasma in
    par.cams = {
  'YAG',     'YAGS:LI20:2432';
  'DSTHz',    'OTRS:LI20:3075';
  'USOTR',    'OTRS:LI20:3158'
};

elseif par.camera_config == 16
  % TCAV, plasma out, IPOTR FOIL IN
  par.cams = {
  'YAG',     'YAGS:LI20:2432';
  'DSTHz',    'OTRS:LI20:3075';
  'USOTR',    'OTRS:LI20:3158'
  'IPOTR',    'OTRS:LI20:3180';
};

elseif par.camera_config == 17
  %
  par.cams = {
  'YAG',     'YAGS:LI20:2432';
  'CELOSS',    'PROF:LI20:3483';
  'BETAL',    'PROF:LI20:3486'};

elseif par.camera_config == 18
  %
  par.cams = {
  'YAG',     'YAGS:LI20:2432';
  'CELOSS',    'PROF:LI20:3483';
  'BETAL',    'PROF:LI20:3486';
  'IPOTR',    'OTRS:LI20:3180';
  'DSOTR',    'OTRS:LI20:3206';
  'IP2B',    'MIRR:LI20:3230'};

elseif par.camera_config == 19
    % Ar study
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'DSTHz',    'OTRS:LI20:3075';
            'USOTR',    'OTRS:LI20:3158';
            'IP2A',     'MIRR:LI20:3202';
            'CELOSS',    'PROF:LI20:3483';
            'CNEAR',    'PROF:LI20:3484';
            'BETAL',    'PROF:LI20:3486';
            'DSOTR',    'OTRS:LI20:3206';
            'BETA2',    'PROF:LI20:3488'};

elseif par.camera_config == 20
    % Ar study
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'IPOTR',    'OTRS:LI20:3180';
            'USOTR',    'OTRS:LI20:3158';
            'IP2A',     'MIRR:LI20:3202';
            'CELOSS',    'PROF:LI20:3483';
            'CNEAR',    'PROF:LI20:3484';
            'BETAL',    'PROF:LI20:3486';
            'DSOTR',    'OTRS:LI20:3206';
            'BETA2',    'PROF:LI20:3488'};
        
elseif par.camera_config == 21
    % Ar study
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'ODROTR',    'OTRS:LI20:3175';
            'USOTR',    'OTRS:LI20:3158';
            'IP2A',     'MIRR:LI20:3202';
            'CELOSS',    'PROF:LI20:3483';
            'CNEAR',    'PROF:LI20:3484';
            'BETAL',    'PROF:LI20:3486';
            'DSOTR',    'OTRS:LI20:3206';
            'BETA2',    'PROF:LI20:3488'};

elseif par.camera_config == 22
    % Ar study
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'IPOTR',    'OTRS:LI20:3180';
            'CELOSS',    'PROF:LI20:3483';
            'CEGAIN',    'PROF:LI20:3485';
            'BETAL',    'PROF:LI20:3486';
            'DSOTR',    'OTRS:LI20:3206';
            'BETA2',    'PROF:LI20:3488'};
        
elseif par.camera_config == 23
    % minimal intrusion config for testing
    par.cams = {'HALO', 'EXPT:LI20:3203'};
    
elseif par.camera_config == 24
    % Erik fix me!
    par.cams = {'CELOSS',    'PROF:LI20:3483'};
    
elseif par.camera_config == 25
    % Erik fix me!
    par.cams = {'CELOSS',    'PROF:LI20:3483'};
     
elseif par.camera_config == 26
    % Erik fix me!
    par.cams = {'CELOSS',    'PROF:LI20:3483'};
    
elseif par.camera_config == 27
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'IPOTR',    'OTRS:LI20:3180';
            'CELOSS',    'PROF:LI20:3483';
            'CEGAIN',    'PROF:LI20:3485';
            'BETAL',    'PROF:LI20:3486';
            'BETA1',    'PROF:LI20:3487';
            'BETA2',    'PROF:LI20:3488'};
        
elseif par.camera_config == 28
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'IPOTR',    'OTRS:LI20:3180';
            'CELOSS',    'PROF:LI20:3483';
            'CEGAIN',    'PROF:LI20:3485';
            'BETAL',    'PROF:LI20:3486';
            'IP2A',     'MIRR:LI20:3202';
            'BETA2',    'PROF:LI20:3488'};

elseif par.camera_config == 29
    par.cams = {'YAG',     'YAGS:LI20:2432';
            'CELOSS',    'PROF:LI20:3483';
            'BETAL',    'PROF:LI20:3486';
            'BREAKDOWN', 'EXPT:LI20:3208';
            'IP2B',     'MIRR:LI20:3230'};
else
    error('Camera config %d does not exist',par.camera_config);
        
end
