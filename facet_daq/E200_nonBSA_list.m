%-------------------------------------------------------------------------%
% Non BSA EPICS PVs
nonBSA_list = cell(0,1);

nonBSA_list{end+1,1} = 'PATT:SYS1:1:PULSEIDBR';      % Non BSA PulseID PV
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO007';       % Non BSA Pyro
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO028';       % Non BSA Pyro updating with spyro.m at 1 Hz
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO019';       % Non BSA S02 Gap monitor

nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO011';       % LI02-LI10 e_gain [MeV]
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO012';       % LI02-LI10 chirp [MeV]
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO013';       % LI02-LI10 eff. phase [deg]

nonBSA_list{end+1,1} = 'DR12:PHAS:61:VDES';          % Phase ramp set [deg]
nonBSA_list{end+1,1} = 'DR12:PHAS:61:VACT';          % Phase ramp read back [deg]
nonBSA_list{end+1,1} = 'DR13:AMPL:11:VDES';          % Compressor amplitude set [deg]
nonBSA_list{end+1,1} = 'DR13:AMPL:11:VACT';          % Compressor amplitude read back [deg]
nonBSA_list{end+1,1} = 'DR13:TORO:40:DATA';          % NRTL Charge
nonBSA_list{end+1,1} = 'DR13:KLYS:1:PDES';           % NRTL Phase Setting
nonBSA_list{end+1,1} = 'DR13:KLYS:1:PHAS';           % NRTL Phase Setting

nonBSA_list{end+1,1} = 'LI20:LGPS:3011:BDES';        % QFF 1 [kG]
nonBSA_list{end+1,1} = 'LI20:LGPS:3031:BDES';        % QFF 2 [kG]
nonBSA_list{end+1,1} = 'LI20:LGPS:3091:BDES';        % QFF 4 [kG]
nonBSA_list{end+1,1} = 'LI20:LGPS:3141:BDES';        % QFF 5 [kG]
nonBSA_list{end+1,1} = 'LI20:LGPS:3151:BDES';        % QFF 6 [kG]
nonBSA_list{end+1,1} = 'LI20:LGPS:3261:BDES';        % QS 1  [kG]
nonBSA_list{end+1,1} = 'LI20:LGPS:3311:BDES';        % QS 2  [kG]
nonBSA_list{end+1,1} = 'LI20:LGPS:3330:BDES';        % Spectromter dipole magnet [kG m]

nonBSA_list{end+1,1} = 'TCAV:LI20:2400:Q_ADJUST';       % TCAV desired Q
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:I_ADJUST';       % TCAV desired I
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML02:AO002';          % <-depreciated-> TCAV phase [deg]
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML02:AO003';          % <-depreciated-> TCAV amplitude [a.u.]
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML02:AO004';          % <-depreciated-> TCAV calculated power [MW]

nonBSA_list{end+1,1} = 'TCAV:LI20:2400:PDES';           % TCAV desired phase [deg]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:ADES';           % TCAV desired kick amp [MV]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:S_PV';           % TCAV "slow" avg. phase [deg]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:S_AV';           % TCAV "slow" avg. kick amp [MV]

nonBSA_list{end+1,1} = 'TCAV:LI20:2400:0:S_PACTUAL';    % TCAV PAD: XTCAV In - Phase [deg]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:0:S_AACTUAL';    % TCAV PAD: XTCAV In - Voltage [MV]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:0:S_WACTUAL';    % TCAV PAD: XTCAV In - Power[MW]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:1:S_PACTUAL';    % TCAV PAD: XTCAV Out - Phase [deg]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:1:S_AACTUAL';    % TCAV PAD: XTCAV Out - Voltage [MV]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:1:S_WACTUAL';    % TCAV PAD: XTCAV Out - Power[MW]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:2:S_PACTUAL';    % TCAV PAD: Waveguide Ref - Phase [deg]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:2:S_AACTUAL';    % TCAV PAD: Waveguide Ref - Voltage [MV]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:2:S_WACTUAL';    % TCAV PAD: Waveguide Ref - Power[MW]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:3:S_PACTUAL';    % TCAV PAD: X-Band Ref - Phase [deg]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:3:S_AACTUAL';    % TCAV PAD: X-Band Ref - Voltage [MV]
nonBSA_list{end+1,1} = 'TCAV:LI20:2400:3:S_WACTUAL';    % TCAV PAD: X-Band Ref - Power[MW]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:0:S_PACTUAL';      % KLY PAD: PAC Out - Phase [deg]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:0:S_AACTUAL';      % KLY PAD: PAC Out - Voltage [MV]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:0:S_WACTUAL';      % KLY PAD: PAC Out - Power [MW]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:1:S_PACTUAL';      % KLY PAD: Kly Drive - Phase [deg]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:1:S_AACTUAL';      % KLY PAD: Kly Drive - Voltage [MV]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:1:S_WACTUAL';      % KLY PAD: Kly Drive - Power [MW]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:2:S_SACTUAL';      % KLY PAD: Kly Beam V - Voltage[MV]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:3:S_PACTUAL';      % KLY PAD: Kly Fwd - Phase [deg]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:3:S_AACTUAL';      % KLY PAD: Kly Fwd - Voltage [MV]
nonBSA_list{end+1,1} = 'KLYS:LI20:K4:3:S_WACTUAL';      % KLY PAD: Kly Fwd - Power [MW]

nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO074';       % S20 Energy relative to 20.35 GeV readback [MeV]
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO079';       % S20 Energy relative to 20.35 GeV setpoint [MeV]
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO099';       % EP01 ENGY.MKB knob value [deg]
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO061';       % EP01 Energy relative to 20.35 GeV setpoint [MeV]
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO063';       % EP01 Energy relative to 20.35 GeV readback [MeV]

nonBSA_list{end+1,1} = 'COLL:LI20:2070:MOTR';        % Notch Jaw 2, Fine Y motion
nonBSA_list{end+1,1} = 'COLL:LI20:2071:MOTR';        % Notch Jaw 3, X motion
nonBSA_list{end+1,1} = 'COLL:LI20:2072:MOTR';        % Notch Jaw 4, Coarse Y motion
nonBSA_list{end+1,1} = 'COLL:LI20:2073:MOTR';        % Notch Jaw 5, Rotation [deg]

nonBSA_list{end+1,1} = 'COLL:LI20:2069:MOTR';             % Notch X motion
nonBSA_list{end+1,1} = 'COLL:LI20:2085:MOTR';             % Left Jaw
nonBSA_list{end+1,1} = 'COLL:LI20:2086:MOTR';             % Right Jaw
nonBSA_list{end+1,1} = 'COLL:LI20:2085:MOTR:GETGAP';      % Jaw Gap width
nonBSA_list{end+1,1} = 'COLL:LI20:2085:MOTR:GETCENTER';   % Jaw Gap Center

nonBSA_list{end+1,1} = 'EVNT:SYS1:1:INJECTRATE';     % Rate to Linac [Hz]
nonBSA_list{end+1,1} = 'EVNT:SYS1:1:SCAVRATE';       % Rate to scav line [Hz]
nonBSA_list{end+1,1} = 'EVNT:SYS1:1:BEAMRATE';       % Rate to FACET [Hz]

nonBSA_list{end+1,1} = 'YAGS:LI20:2434:MOTR';        % YAG Position
nonBSA_list{end+1,1} = 'OTRS:LI20:3070:MOTR';       % USTHz foil position
nonBSA_list{end+1,1} = 'OTRS:LI20:3075:MOTR';       % DSTHz foil position
nonBSA_list{end+1,1} = 'OTRS:LI20:3158:MOTR';       % USOTR foil position
nonBSA_list{end+1,1} = 'OTRS:LI20:3175:MOTR';        % Spoiler Foil position
nonBSA_list{end+1,1} = 'OTRS:LI20:3180:MOTR';       % IPOTR foil position
nonBSA_list{end+1,1} = 'OTRS:LI20:3206:MOTR';       % DSOTR foil position
nonBSA_list{end+1,1} = 'OTRS:LI20:3202:MOTR';       % IP2A foil position
nonBSA_list{end+1,1} = 'OTRS:LI20:3230:MOTR';       % IP2B foil position

nonBSA_list{end+1,1} = 'OVEN:LI20:3185:TC1';         % Oven Temp 1 [C]
nonBSA_list{end+1,1} = 'OVEN:LI20:3185:TC2';         % Oven Temp 2 [C]
nonBSA_list{end+1,1} = 'OVEN:LI20:3185:TC3';         % Oven Temp 3 [C]
nonBSA_list{end+1,1} = 'OVEN:LI20:3185:TC4';         % Oven Temp 4 [C]
nonBSA_list{end+1,1} = 'OVEN:LI20:3185:TC5';         % Oven Temp 5 [C]
nonBSA_list{end+1,1} = 'OVEN:LI20:3185:H2OTEMP1';    % Water jacket temp [C]
nonBSA_list{end+1,1} = 'OVEN:LI20:3185:H2OTEMP2';    % Water jacket temp [C]
nonBSA_list{end+1,1} = 'OVEN:LI20:3185:PWRSUPPLY_V2';% Oven Voltage [V]
nonBSA_list{end+1,1} = 'OVEN:LI20:3185:PWRSUPPLY_I2';% Oven Current [A]
nonBSA_list{end+1,1} = 'OVEN:LI20:3185:PWRSUPPLY_W2';% Oven Power [W]

nonBSA_list{end+1,1} = 'VGCM:LI20:M3201:PMONRAW';    % CM Gauge [1000 Torr]
nonBSA_list{end+1,1} = 'VGCM:LI20:M3202:PMONRAW';    % CM Gauge [100 Torr]

nonBSA_list{end+1,1} = 'OVEN:LI20:3185:MOTR';        % Oven motor position

nonBSA_list{end+1,1} = 'XPS:LI20:DWFA:M1';        % IP Box Turning Mirror
nonBSA_list{end+1,1} = 'XPS:LI20:DWFA:M2';        % Compressor Grating Separation
nonBSA_list{end+1,1} = 'XPS:LI20:DWFA:M3';        % IPOTR2 foil position
nonBSA_list{end+1,1} = 'XPS:LI20:DWFA:M4';        % ELANEX x position
nonBSA_list{end+1,1} = 'XPS:LI20:DWFA:M5';        % ELANEX y position

% Sextupole movers- GUI must be run for these to update
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO501';       % SEXT 2165 X setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO503';       % SEXT 2165 X pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO506';       % SEXT 2165 Y setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO508';       % SEXT 2165 Y pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO511';       % SEXT 2165 Roll setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO513';       % SEXT 2165 Roll pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO516';       % SEXT 2335 X setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO518';       % SEXT 2335 X pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO521';       % SEXT 2335 Y setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO523';       % SEXT 2335 Y pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO526';       % SEXT 2335 Roll setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO528';       % SEXT 2335 Roll pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO551';       % SEXT 2145 X setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO553';       % SEXT 2145 X pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO556';       % SEXT 2145 Y setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO558';       % SEXT 2145 Y pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO561';       % SEXT 2145 Roll setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO563';       % SEXT 2145 Roll pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO566';       % SEXT 2365 X setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO568';       % SEXT 2365 X pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO571';       % SEXT 2365 Y setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO573';       % SEXT 2365 Y pot val
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO576';       % SEXT 2365 Roll setpoint
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO578';       % SEXT 2365 Roll pot val
% Sextupole strengths
nonBSA_list{end+1,1} = 'LI20:LGPS:2145:BDES';        % SXTS 2145 [kG/m?]
nonBSA_list{end+1,1} = 'LI20:LGPS:2165:BDES';        % SXTS 2165 [kG/m?]
nonBSA_list{end+1,1} = 'LI20:LGPS:2195:BDES';        % SXTS 2195 [kG/m?]
nonBSA_list{end+1,1} = 'LI20:LGPS:2275:BDES';        % SXTS 2275 [kG/m?]
nonBSA_list{end+1,1} = 'LI20:LGPS:2335:BDES';        % SXTS 2335 [kG/m?]
nonBSA_list{end+1,1} = 'LI20:LGPS:2365:BDES';        % SXTS 2365 [kG/m?]

% Nate's EPICS -> AIDA TORO calibration
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO033';       % GADC CH0 -> TORO 2452 Slope
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO034';       % GADC CH0 -> TORO 2452 Offset
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO035';       % GADC CH2 -> TORO 3163 Slope
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO036';       % GADC CH2 -> TORO 3163 Offset
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO037';       % GADC CH3 -> TORO 3255 Slope
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO038';       % GADC CH3 -> TORO 3255 Offset

% Spencer's EPICS -> AIDA calibration
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO001';       % BPM 2445 X SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO002';       % BPM 2445 X OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO003';       % BPM 2445 Y SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO004';       % BPM 2445 Y OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO005';       % BPM 2445 TMIT SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO006';       % BPM 2445 TMIT OFFSET

nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO007';       % BPM 3156 X SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO008';       % BPM 3156 X OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO009';       % BPM 3156 Y SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO010';       % BPM 3156 Y OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO011';       % BPM 3156 TMIT SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO012';       % BPM 3156 TMIT OFFSET

nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO013';       % BPM 3265 X SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO014';       % BPM 3265 X OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO015';       % BPM 3265 Y SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO016';       % BPM 3265 Y OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO017';       % BPM 3265 TMIT SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO018';       % BPM 3265 TMIT OFFSET

nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO019';       % BPM 3315 X SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO020';       % BPM 3315 X OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO021';       % BPM 3315 Y SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO022';       % BPM 3315 Y OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO023';       % BPM 3315 TMIT SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO024';       % BPM 3315 TMIT OFFSET

nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO025';       % TORO 2452 TMIT SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO026';       % TORO 2452 TMIT OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO027';       % TORO 3163 TMIT SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO028';       % TORO 3163 TMIT OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO029';       % TORO 3255 TMIT SLOPE
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO030';       % TORO 3255 TMIT OFFSET

% Waist and beta info from Glen/Nate
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO351';       % X Waist Z
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO352';       % Beta X
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO353';       % Y Waist Z
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO354';       % Beta Y

% YAG Lineout Info
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO751';       % YAG Line Low
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO752';       % YAG Line High
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO753';       % YAG Line Left
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO754';       % YAG Line Right

% Notch and YAG Dispersion from dispersion scan
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO776';       % Notch z
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO777';       % Notch eta_x
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO778';       % Notch eta_x'
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO779';       % Notch eta_y
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO780';       % Notch eta_y'
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO781';       % SYAG z
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO782';       % SYAG eta_x
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO783';       % SYAG eta_x'
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO784';       % SYAG eta_y
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO785';       % SYAG eta_y'

% Dispersion at YAG
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO855';       % Dispersion at sYAG

% NDR Info
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO851';       % Last time measured
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO852';       % Gap Voltage
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO853';       % Charge
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO854';       % Bunch Length

% LiTrack Simulation Parameters
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO801';       % NDR Z0
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO802';       % NDR D0
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO803';       % NDR NPART
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO804';       % NDR ASYM
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO805';       % NRTL AMPL
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO806';       % NRTL PHAS
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO807';       % NRTL R56
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO808';       % NRTL T566
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO809';       % PHAS 2-10
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO810';       % PHAS 11-20
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO811';       % PHAS RAMP
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO812';       % LI20 BETA
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO813';       % LI20 R56
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO814';       % LI20 T166
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO835';       % LI20 HI E CUT

% LiTrack Bunch Parameters
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO816';       % YAG FWHM
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO817';       % YAG RMS
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO818';       % ENERGY OFFSET
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO819';       % Li YAG FWHM
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO820';       % Li YAG RMS
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO821';       % Li PROF FWHM/2.35
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO822';       % Li PROF RMS
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO823';       % Li PROF RMS w/15% FLOOR CUT
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:AO833';       % Li PEAK CURRENT

% LiTrack Calculations
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:CALC801';     % Calculated NDR bunch length
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:CALC805';     % Adjusted NRTL AMPL
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML00:CALC806';     % NRTL Phase offset

% E200 Display Info
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO061';       % E200 CEGAIN Max Energy 1
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO062';       % E200 CEGAIN Max Energy 2
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO063';       % E200 CEGAIN Max Energy 3
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO064';       % E200 CEGAIN Acc Charge
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO065';       % E200 CEGAIN Unaffected Charge
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO066';       % E200 CELOSS Min Energy
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO067';       % E200 CELOSS Dec Charge
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO068';       % E200 CELOSS Unaffected Charge
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO069';       % E200 BETAL Gamma Yield
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO070';       % E200 BETAL Gamma Max
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO071';       % E200 BETAL Gamma Div
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO072';       % E200 Excess Charge
nonBSA_list{end+1,1} = 'SIOC:SYS1:ML01:AO073';       % E200 Transformer

% Laser PVs
nonBSA_list{end+1,1} = 'PMTR:LA20:10:PWR1H';         % 1 Hz Laser Power
nonBSA_list{end+1,1} = 'PMTR:LA20:10:PWR_RAW';	     % RAW POWER
% nonBSA_list{end+1,1} = 'OSC:LA20:10:PHASE_LOCKED';   % Phase Locked Oscillator
nonBSA_list{end+1,1} = 'OSC:LA20:10:FREQ_SP'; 	     % Coarse Oscillator Frequency
nonBSA_list{end+1,1} = 'OSC:LA20:10:FREQ_RBCK';	     % Coarse Oscillator Readback
nonBSA_list{end+1,1} = 'OSC:LA20:10:PD_CH1_RF_PWR_AVG'; % Avg. RF power
nonBSA_list{end+1,1} = 'OSC:LA20:10:PD_CH1_RF_PWR_STD'; % RMS RF power
nonBSA_list{end+1,1} = 'OSC:LA20:10:PD_CH1_DIODE_PWR_AVG'; % Avg. Diode power
nonBSA_list{end+1,1} = 'OSC:LA20:10:PD_CH1_DIODE_PWR_STD'; % RMS Diode power
nonBSA_list{end+1,1} = 'UTIC:LA20:10:GetMeasMean';   % Mean time interval counter
nonBSA_list{end+1,1} = 'VGXX:LI20:L3185:P';	     % Pressure at compressor box
nonBSA_list{end+1,1} = 'PMTR:LA20:10:GETRANGE';	     % Measure range
nonBSA_list{end+1,1} = 'PMTR:LA20:10:GETAOSCALE';    % Analog full scale
nonBSA_list{end+1,1} = 'PMTR:LA20:10:QUERYDATA';     % Serial Port laser energy

nonBSA_list{end+1,1} = 'TRIG:LA20:LS24:TDES'; 	     % Pace Maker 10Hz
nonBSA_list{end+1,1} = 'TRIG:LA20:LS25:TDES';        % SDG Gate
nonBSA_list{end+1,1} = 'TRIG:LA20:LS26:TDES';        % Time Interval Counter
nonBSA_list{end+1,1} = 'TRIG:LA20:LS27:TDES';        % Legend 120 Hz
nonBSA_list{end+1,1} = 'TRIG:LA20:LS24:TWID'; 	     % Pace Maker 10Hz width
nonBSA_list{end+1,1} = 'TRIG:LA20:LS25:TWID';        % SDG Gate width
nonBSA_list{end+1,1} = 'TRIG:LA20:LS26:TWID';        % Time Interval Counter width
nonBSA_list{end+1,1} = 'TRIG:LA20:LS27:TWID';        % Legend 120 Hz width
nonBSA_list{end+1,1} = 'OSC:LA20:10:FS_TGT_TIME';    % Target time
nonBSA_list{end+1,1} = 'UTIC:LA20:10:GetOffsetInvMeasMean_ns';    % readback time

%-------------------------------------------------------------------------%
% String PVs - can't do a combined lcaGet with string PVs and number PVs
good_strings = cell(0,1);

good_strings{end+1,1} = 'PROF:LI20:45:TGT_STS';       % PMON IN/OUT
good_strings{end+1,1} = 'OTRS:LI20:3070:TGT_STS';     % USTHz foil IN/OUT
good_strings{end+1,1} = 'IP445:LI20:EX01:Bo0';        % USTHz splitter [High = out/Low = in]
good_strings{end+1,1} = 'OTRS:LI20:3075:TGT_STS';     % DSTHz foil IN/OUT
good_strings{end+1,1} = 'OTRS:LI20:3158:TGT_STS';     % USOTR foil IN/OUT
good_strings{end+1,1} = 'OTRS:LI20:3206:TGT_STS';     % DSOTR foil IN/OUT
good_strings{end+1,1} = 'MIRR:LI20:3202:TGT_STS';     % IP2A window IN/OUT
good_strings{end+1,1} = 'OTRS:LI20:3208:TGT_STS';     % Kraken foil IN/OUT
good_strings{end+1,1} = 'MIRR:LI20:3230:TGT_STS';     % IP2B window IN/OUT
good_strings{end+1,1} = 'OVEN:LI20:3185:POSITIONSUM'; % Oven IN/OUT
good_strings{end+1,1} = 'VVFL:LI20:M3200:GAS_TYPE';      % Gas type PV
good_strings{end+1,1} = 'VVFL:LI20:M3201:GAS_TYPE';      % Gas type PV
good_strings{end+1,1} = 'OSC:LA20:10:PHASE_LOCKED';   % Phase Locked Oscillator

%-------------------------------------------------------------------------%
% Cell array of PV descriptions
nonBSA_desc = cell(0,1);

nonBSA_desc{end+1,1} = 'Non BSA PulseID PV';
nonBSA_desc{end+1,1} = 'Non BSA Pyro';
nonBSA_desc{end+1,1} = 'Non BSA Pyro updating with spyro.m at 1 Hz';
nonBSA_desc{end+1,1} = 'Non BSA S02 Gap monitor';

nonBSA_desc{end+1,1} = 'LI02-LI10 e_gain [MeV]';
nonBSA_desc{end+1,1} = 'LI02-LI10 chirp [MeV]';
nonBSA_desc{end+1,1} = 'LI02-LI10 eff. phase [deg]';

nonBSA_desc{end+1,1} = 'Phase ramp set [deg]';
nonBSA_desc{end+1,1} = 'Phase ramp read back [deg]';
nonBSA_desc{end+1,1} = 'Compressor amplitude set [deg]';
nonBSA_desc{end+1,1} = 'Compressor amplitude read back [deg]';
nonBSA_desc{end+1,1} = 'NRTL Charge';
nonBSA_desc{end+1,1} = 'NRTL Phase Setting';
nonBSA_desc{end+1,1} = 'NRTL Phase Setting';

nonBSA_desc{end+1,1} = 'QFF 1 [kG]';
nonBSA_desc{end+1,1} = 'QFF 2 [kG]';
nonBSA_desc{end+1,1} = 'QFF 4 [kG]';
nonBSA_desc{end+1,1} = 'QFF 5 [kG]';
nonBSA_desc{end+1,1} = 'QFF 6 [kG]';
nonBSA_desc{end+1,1} = 'QS 1  [kG]';
nonBSA_desc{end+1,1} = 'QS 2  [kG]';
nonBSA_desc{end+1,1} = 'Spectromter dipole magnet [kG m]';

nonBSA_desc{end+1,1} = 'TCAV desired Q';
nonBSA_desc{end+1,1} = 'TCAV desired I';
nonBSA_desc{end+1,1} = '<-depreciated-> TCAV phase [deg]';
nonBSA_desc{end+1,1} = '<-depreciated-> TCAV amplitude [a.u.]';
nonBSA_desc{end+1,1} = '<-depreciated-> TCAV calculated power [MW]';

nonBSA_desc{end+1,1} = 'TCAV desired phase [deg]';
nonBSA_desc{end+1,1} = 'TCAV desired kick amp [MV]';
nonBSA_desc{end+1,1} = 'TCAV "slow" avg. phase [deg]';
nonBSA_desc{end+1,1} = 'TCAV "slow" avg. kick amp [MV]';

nonBSA_desc{end+1,1} = 'TCAV PAD: XTCAV In - Phase [deg]';
nonBSA_desc{end+1,1} = 'TCAV PAD: XTCAV In - Voltage [MV]';
nonBSA_desc{end+1,1} = 'TCAV PAD: XTCAV In - Power[MW]';
nonBSA_desc{end+1,1} = 'TCAV PAD: XTCAV Out - Phase [deg]';
nonBSA_desc{end+1,1} = 'TCAV PAD: XTCAV Out - Voltage [MV]';
nonBSA_desc{end+1,1} = 'TCAV PAD: XTCAV Out - Power[MW]';
nonBSA_desc{end+1,1} = 'TCAV PAD: Waveguide Ref - Phase [deg]';
nonBSA_desc{end+1,1} = 'TCAV PAD: Waveguide Ref - Voltage [MV]';
nonBSA_desc{end+1,1} = 'TCAV PAD: Waveguide Ref - Power[MW]';
nonBSA_desc{end+1,1} = 'TCAV PAD: X-Band Ref - Phase [deg]';
nonBSA_desc{end+1,1} = 'TCAV PAD: X-Band Ref - Voltage [MV]';
nonBSA_desc{end+1,1} = 'TCAV PAD: X-Band Ref - Power[MW]';
nonBSA_desc{end+1,1} = 'KLY PAD: PAC Out - Phase [deg]';
nonBSA_desc{end+1,1} = 'KLY PAD: PAC Out - Voltage [MV]';
nonBSA_desc{end+1,1} = 'KLY PAD: PAC Out - Power [MW]';
nonBSA_desc{end+1,1} = 'KLY PAD: Kly Drive - Phase [deg]';
nonBSA_desc{end+1,1} = 'KLY PAD: Kly Drive - Voltage [MV]';
nonBSA_desc{end+1,1} = 'KLY PAD: Kly Drive - Power [MW]';
nonBSA_desc{end+1,1} = 'KLY PAD: Kly Beam V - Voltage[MV]';
nonBSA_desc{end+1,1} = 'KLY PAD: Kly Fwd - Phase [deg]';
nonBSA_desc{end+1,1} = 'KLY PAD: Kly Fwd - Voltage [MV]';
nonBSA_desc{end+1,1} = 'KLY PAD: Kly Fwd - Power [MW]';

nonBSA_desc{end+1,1} = 'S20 Energy relative to 20.35 GeV readback [MeV]';
nonBSA_desc{end+1,1} = 'S20 Energy relative to 20.35 GeV setpoint [MeV]';
nonBSA_desc{end+1,1} = 'EP01 ENGY.MKB knob value [deg]';
nonBSA_desc{end+1,1} = 'EP01 Energy relative to 20.35 GeV setpoint [MeV]';
nonBSA_desc{end+1,1} = 'EP01 Energy relative to 20.35 GeV readback [MeV]';

nonBSA_desc{end+1,1} = 'Notch Jaw 2, Fine Y motion';
nonBSA_desc{end+1,1} = 'Notch Jaw 3, X% prof_list = prof_list(:,1); motion';
nonBSA_desc{end+1,1} = 'Notch Jaw 4, Coarse Y motion';
nonBSA_desc{end+1,1} = 'Notch Jaw 5, Rotation [deg]';

nonBSA_desc{end+1,1} = 'Notch X motion';
nonBSA_desc{end+1,1} = 'Left Jaw';
nonBSA_desc{end+1,1} = 'Right Jaw';
nonBSA_desc{end+1,1} = 'Jaw Gap width';
nonBSA_desc{end+1,1} = 'Jaw Gap Center';

nonBSA_desc{end+1,1} = 'Rate to Linac [Hz]';
nonBSA_desc{end+1,1} = 'Rate to scav line [Hz]';
nonBSA_desc{end+1,1} = 'Rate to FACET [Hz]';

nonBSA_desc{end+1,1} = 'YAG Position';
nonBSA_desc{end+1,1} = 'USTHz foil position';
nonBSA_desc{end+1,1} = 'DSTHz foil position';
nonBSA_desc{end+1,1} = 'USOTR foil position';
nonBSA_desc{end+1,1} = 'Spoiler Foil position';
nonBSA_desc{end+1,1} = 'IPOTR foil position';
nonBSA_desc{end+1,1} = 'DSOTR foil position';
nonBSA_desc{end+1,1} = 'IP2A foil position';
nonBSA_desc{end+1,1} = 'IP2B foil position';

nonBSA_desc{end+1,1} = 'Oven Temp 1 [C]';
nonBSA_desc{end+1,1} = 'Oven Temp 2 [C]';
nonBSA_desc{end+1,1} = 'Oven Temp 3 [C]';
nonBSA_desc{end+1,1} = 'Oven Temp 4 [C]';
nonBSA_desc{end+1,1} = 'Oven Temp 5 [C]';
nonBSA_desc{end+1,1} = 'Water jacket temp [C]';
nonBSA_desc{end+1,1} = 'Water jacket temp [C]';
nonBSA_desc{end+1,1} = 'Oven Voltage [V]';
nonBSA_desc{end+1,1} = 'Oven Current [I]';
nonBSA_desc{end+1,1} = 'Oven Power [W]';

nonBSA_desc{end+1,1} = 'CM Gauge [1000 Torr]';
nonBSA_desc{end+1,1} = 'CM Gauge [100 Torr]';

nonBSA_desc{end+1,1} = 'Oven motor position';

nonBSA_desc{end+1,1} = 'IP Box Turning Mirror';
nonBSA_desc{end+1,1} = 'Compressor Grating Separation';
nonBSA_desc{end+1,1} = 'IPOTR2 foil position';
nonBSA_desc{end+1,1} = 'ELANEX x position';
nonBSA_desc{end+1,1} = 'ELANEX y position';

% Sextupole movers- GUI must be run for these to update
nonBSA_desc{end+1,1} = 'SEXT 2165 X setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2165 X pot val';
nonBSA_desc{end+1,1} = 'SEXT 2165 Y setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2165 Y pot val';
nonBSA_desc{end+1,1} = 'SEXT 2165 Roll setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2165 Roll pot val';
nonBSA_desc{end+1,1} = 'SEXT 2335 X setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2335 X pot val';
nonBSA_desc{end+1,1} = 'SEXT 2335 Y setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2335 Y pot val';
nonBSA_desc{end+1,1} = 'SEXT 2335 Roll setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2335 Roll pot val';
nonBSA_desc{end+1,1} = 'SEXT 2145 X setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2145 X pot val';
nonBSA_desc{end+1,1} = 'SEXT 2145 Y setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2145 Y pot val';
nonBSA_desc{end+1,1} = 'SEXT 2145 Roll setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2145 Roll pot val';
nonBSA_desc{end+1,1} = 'SEXT 2365 X setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2365 X pot val';
nonBSA_desc{end+1,1} = 'SEXT 2365 Y setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2365 Y pot val';
nonBSA_desc{end+1,1} = 'SEXT 2365 Roll setpoint';
nonBSA_desc{end+1,1} = 'SEXT 2365 Roll pot val';
% Sextupole strengths
nonBSA_desc{end+1,1} = 'SXTS 2145 [kG/m?]';
nonBSA_desc{end+1,1} = 'SXTS 2165 [kG/m?]';
nonBSA_desc{end+1,1} = 'SXTS 2195 [kG/m?]';
nonBSA_desc{end+1,1} = 'SXTS 2275 [kG/m?]';
nonBSA_desc{end+1,1} = 'SXTS 2335 [kG/m?]';
nonBSA_desc{end+1,1} = 'SXTS 2365 [kG/m?]';

% Nate's EPICS -> AIDA TORO calibration
nonBSA_desc{end+1,1} = 'GADC CH0 -> TORO 2452 Slope';
nonBSA_desc{end+1,1} = 'GADC CH0 -> TORO 2452 Offset';
nonBSA_desc{end+1,1} = 'GADC CH2 -> TORO 3163 Slope';
nonBSA_desc{end+1,1} = 'GADC CH2 -> TORO 3163 Offset';
nonBSA_desc{end+1,1} = 'GADC CH3 -> TORO 3255 Slope';
nonBSA_desc{end+1,1} = 'GADC CH3 -> TORO 3255 Offset';

% Spencer's EPICS -> AIDA calibration
nonBSA_desc{end+1,1} = 'BPM 2445 X SLOPE';
nonBSA_desc{end+1,1} = 'BPM 2445 X OFFSET';
nonBSA_desc{end+1,1} = 'BPM 2445 Y SLOPE';
nonBSA_desc{end+1,1} = 'BPM 2445 Y OFFSET';
nonBSA_desc{end+1,1} = 'BPM 2445 TMIT SLOPE';
nonBSA_desc{end+1,1} = 'BPM 2445 TMIT OFFSET';

nonBSA_desc{end+1,1} = 'BPM 3156 X SLOPE';
nonBSA_desc{end+1,1} = 'BPM 3156 X OFFSET';
nonBSA_desc{end+1,1} = 'BPM 3156 Y SLOPE';
nonBSA_desc{end+1,1} = 'BPM 3156 Y OFFSET';
nonBSA_desc{end+1,1} = 'BPM 3156 TMIT SLOPE';
nonBSA_desc{end+1,1} = 'BPM 3156 TMIT OFFSET';

nonBSA_desc{end+1,1} = 'BPM 3265 X SLOPE';
nonBSA_desc{end+1,1} = 'BPM 3265 X OFFSET';
nonBSA_desc{end+1,1} = 'BPM 3265 Y SLOPE';
nonBSA_desc{end+1,1} = 'BPM 3265 Y OFFSET';
nonBSA_desc{end+1,1} = 'BPM 3265 TMIT SLOPE';
nonBSA_desc{end+1,1} = 'BPM 3265 TMIT OFFSET';

nonBSA_desc{end+1,1} = 'BPM 3315 X SLOPE';
nonBSA_desc{end+1,1} = 'BPM 3315 X OFFSET';
nonBSA_desc{end+1,1} = 'BPM 3315 Y SLOPE';
nonBSA_desc{end+1,1} = 'BPM 3315 Y OFFSET';
nonBSA_desc{end+1,1} = 'BPM 3315 TMIT SLOPE';
nonBSA_desc{end+1,1} = 'BPM 3315 TMIT OFFSET';

nonBSA_desc{end+1,1} = 'TORO 2452 TMIT SLOPE';
nonBSA_desc{end+1,1} = 'TORO 2452 TMIT OFFSET';
nonBSA_desc{end+1,1} = 'TORO 3163 TMIT SLOPE';
nonBSA_desc{end+1,1} = 'TORO 3163 TMIT OFFSET';
nonBSA_desc{end+1,1} = 'TORO 3255 TMIT SLOPE';
nonBSA_desc{end+1,1} = 'TORO 3255 TMIT OFFSET';

% Waist and beta info from Glen/Nate
nonBSA_desc{end+1,1} = 'IP GUI X Waist Z';
nonBSA_desc{end+1,1} = 'IP GUI Beta X';
nonBSA_desc{end+1,1} = 'IP GUI Y Waist Z';
nonBSA_desc{end+1,1} = 'IP GUI Beta Y';

% YAG Lineout Info
nonBSA_desc{end+1,1} = 'YAG Line Low';
nonBSA_desc{end+1,1} = 'YAG Line High';
nonBSA_desc{end+1,1} = 'YAG Line Left';
nonBSA_desc{end+1,1} = 'YAG Line Right';

% Notch and YAG Dispersion from dispersion scan
nonBSA_desc{end+1,1} = 'Notch z';
nonBSA_desc{end+1,1} = 'Notch eta_x';
nonBSA_desc{end+1,1} = 'Notch eta_x"';
nonBSA_desc{end+1,1} = 'Notch eta_y';
nonBSA_desc{end+1,1} = 'Notch eta_y"';
nonBSA_desc{end+1,1} = 'SYAG z';
nonBSA_desc{end+1,1} = 'SYAG eta_x';
nonBSA_desc{end+1,1} = 'SYAG eta_x"';
nonBSA_desc{end+1,1} = 'SYAG eta_y"';
nonBSA_desc{end+1,1} = 'SYAG eta_y"';

% Dispersion at YAG
nonBSA_desc{end+1,1} = 'Dispersion at sYAG';

% NDR Info
nonBSA_desc{end+1,1} = 'NDR Last time measured';
nonBSA_desc{end+1,1} = 'NDR Gap Voltage';
nonBSA_desc{end+1,1} = 'NDR Charge';
nonBSA_desc{end+1,1} = 'NDR Bunch Length';

% LiTrack Simulation Parameters
nonBSA_desc{end+1,1} = 'LiTrack NDR Z0';
nonBSA_desc{end+1,1} = 'LiTrack NDR D0';
nonBSA_desc{end+1,1} = 'LiTrack NDR NPART';
nonBSA_desc{end+1,1} = 'LiTrack NDR ASYM';
nonBSA_desc{end+1,1} = 'LiTrack NRTL AMPL';
nonBSA_desc{end+1,1} = 'LiTrack NRTL PHAS';
nonBSA_desc{end+1,1} = 'LiTrack NRTL R56';
nonBSA_desc{end+1,1} = 'LiTrack NRTL T566';
nonBSA_desc{end+1,1} = 'LiTrack PHAS 2-10';
nonBSA_desc{end+1,1} = 'LiTrack PHAS 11-20';
nonBSA_desc{end+1,1} = 'LiTrack PHAS RAMP';
nonBSA_desc{end+1,1} = 'LiTrack LI20 BETA';
nonBSA_desc{end+1,1} = 'LiTrack LI20 R56';
nonBSA_desc{end+1,1} = 'LiTrack LI20 T166';
nonBSA_desc{end+1,1} = 'LiTrack LI20 HI E CUT';

% LiTrack Bunch Parameters
nonBSA_desc{end+1,1} = 'YAG FWHM';
nonBSA_desc{end+1,1} = 'YAG RMS';
nonBSA_desc{end+1,1} = 'ENERGY OFFSET';
nonBSA_desc{end+1,1} = 'Li YAG FWHM';
nonBSA_desc{end+1,1} = 'Li YAG RMS';
nonBSA_desc{end+1,1} = 'Li PROF FWHM/2.35';
nonBSA_desc{end+1,1} = 'Li PROF RMS';
nonBSA_desc{end+1,1} = 'Li PROF RMS w/15% FLOOR CUT';
nonBSA_desc{end+1,1} = 'Li PEAK CURRENT';

% LiTrack Calculations
nonBSA_desc{end+1,1} = 'Calculated NDR bunch length';
nonBSA_desc{end+1,1} = 'Adjusted NRTL AMPL';
nonBSA_desc{end+1,1} = 'NRTL Phase offset';

% E200 Display Info
nonBSA_desc{end+1,1} = 'E200 CEGAIN Max Energy 1';
nonBSA_desc{end+1,1} = 'E200 CEGAIN Max Energy 2';
nonBSA_desc{end+1,1} = 'E200 CEGAIN Max Energy 3';
nonBSA_desc{end+1,1} = 'E200 CEGAIN Acc Charge';
nonBSA_desc{end+1,1} = 'E200 CEGAIN Unaffected Charge';
nonBSA_desc{end+1,1} = 'E200 CELOSS Min Energy';
nonBSA_desc{end+1,1} = 'E200 CELOSS Dec Charge';
nonBSA_desc{end+1,1} = 'E200 CELOSS Unaffected Charge';
nonBSA_desc{end+1,1} = 'E200 BETAL Gamma Yield';
nonBSA_desc{end+1,1} = 'E200 BETAL Gamma Max';
nonBSA_desc{end+1,1} = 'E200 BETAL Gamma Div';
nonBSA_desc{end+1,1} = 'E200 Excess Charge';
nonBSA_desc{end+1,1} = 'E200 Transformer';

% Laser Info
nonBSA_desc{end+1,1} = '1 Hz Laser Power';
nonBSA_desc{end+1,1} = 'RAW POWER';
% nonBSA_desc{end+1,1} = 'Phase Locked Oscillator';
nonBSA_desc{end+1,1} = 'Coarse Oscillator Frequency';
nonBSA_desc{end+1,1} = 'Coarse Oscillator Readback';
nonBSA_desc{end+1,1} = 'Avg. RF power';
nonBSA_desc{end+1,1} = 'RMS RF power';
nonBSA_desc{end+1,1} = 'Avg. Diode power';
nonBSA_desc{end+1,1} = 'RMS Diode power';
nonBSA_desc{end+1,1} = 'Mean time interval counter';
nonBSA_desc{end+1,1} = 'Pressure at compressor box';
nonBSA_desc{end+1,1} = 'Measure Range';
nonBSA_desc{end+1,1} = 'Analog Full Scale';
nonBSA_desc{end+1,1} = 'Serial Port laser energy';

nonBSA_desc{end+1,1} = 'Pace Maker 10Hz';
nonBSA_desc{end+1,1} = 'SDG Gate';
nonBSA_desc{end+1,1} = 'Time Interval Counter';
nonBSA_desc{end+1,1} = 'Legend 120 Hz';
nonBSA_desc{end+1,1} = 'Pace Maker 10Hz width';
nonBSA_desc{end+1,1} = 'SDG Gate width';
nonBSA_desc{end+1,1} = 'Time Interval Counter width';
nonBSA_desc{end+1,1} = 'Legend 120 Hz width';
nonBSA_desc{end+1,1} = 'Target time';
nonBSA_desc{end+1,1} = 'Measure time';



%-------------------------------------------------------------------------%
% string descriptions
desc_strings = cell(0,1);

desc_strings{end+1,1} = 'PMON IN/OUT';
desc_strings{end+1,1} = 'USTHz foil IN/OUT';
desc_strings{end+1,1} = 'USTHz splitter [High = out/Low = in]';
desc_strings{end+1,1} = 'DSTHz foil IN/OUT';
desc_strings{end+1,1} = 'USOTR foil IN/OUT';
desc_strings{end+1,1} = 'DSOTR foil IN/OUT';
desc_strings{end+1,1} = 'IP2A window IN/OUT';
desc_strings{end+1,1} = 'Kraken foil IN/OUT';
desc_strings{end+1,1} = 'IP2B window IN/OUT';
desc_strings{end+1,1} = 'Oven IN/OUT';
desc_strings{end+1,1} = 'Gas type PV';
desc_strings{end+1,1} = 'Gas type PV';
desc_strings{end+1,1} = 'Phase Locked Oscillator';

if length(nonBSA_list) ~= length(nonBSA_desc)
    error('Each PV in "nonBSA_list" needs a description in "nonBSA_desc"');
end

if length(good_strings) ~= length(desc_strings)
    error('Each PV in "good_strings" needs a description in "desc_strings"');
end
