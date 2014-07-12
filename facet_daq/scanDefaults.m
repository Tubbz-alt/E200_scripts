function handles=scanDefaults(hObject,handles)
funcind=get(handles.Scanfunction,'Value');
switch funcind
	case 1
		handles.func=@set_QSBEND_energy;
		setdefaults(handles,-8,8,3);
		updateScanText(handles,'GeV');
	case 2
		handles.func=@set_QS_energy;
		setdefaults(handles,-8,8,3);
		updateScanText(handles,'GeV');
	case 3
		handles.func=@set_phase_ramp;
		setdefaults(handles,60,62,7);
		updateScanText(handles,'deg');
	case 4
        handles.func=@set_ep01_energy;
		setdefaults(handles,-75,75,7);
		updateScanText(handles,'MeV');
	case 5
		handles.func=@set_QS_energy_ELANEX;
		setdefaults(handles,-2,2,5);
		updateScanText(handles,'GeV');
	case 6
		handles.func=@set_slit;
		setdefaults(handles,-1.5,1.5,10);
		updateScanText(handles,'mm');
    case 7
		handles.func=@set_laser_phase;
		setdefaults(handles,550,600,10);
		updateScanText(handles,'ns');
    case 8
        handles.func=@set_YCOR_LI20_3147_BDES;
        setdefaults(handles,-0.1,0.1,4);
        updateScanText(handles,'BDES');
    case 9
        handles.func=@set_XCOR_LI20_3116_BDES;
        setdefaults(handles,-0.1,0.1,4);
        updateScanText(handles,'BDES');
    case 10
        handles.func=@set_argon_pressure;
        setdefaults(handles,10,20,5);
        updateScanText(handles,'Torr');
    case 11
        handles.func=@set_grating_position;
        setdefaults(handles,20,25,5);
        updateScanText(handles,'mm');
    case 12
		handles.func=@set_QS_energy_PEXT;
		setdefaults(handles,-8,8,3);
		updateScanText(handles,'GeV');
    case 13
		handles.func=@set_QS_energy_ELANEX_PEXT;
		setdefaults(handles,-8,8,3);
		updateScanText(handles,'GeV');
    case 14
		handles.func=@set_phase_ramp_tcav;
		setdefaults(handles,-21,-19,7);
		updateScanText(handles,'deg');
	case 15
		handles.func=@set_jaw_collimation;
		setdefaults(handles,0.5,2.5,6);
		updateScanText(handles,'mm');
    case 16
		handles.func=@set_left_jaw;
		setdefaults(handles,-1.5,0.5,6);
		updateScanText(handles,'mm');
    case 17
		handles.func=@set_right_jaw;
		setdefaults(handles,-0.5,1.5,6);
		updateScanText(handles,'mm');
    case 18
		handles.func=@set_phase_ramp_positron;
		setdefaults(handles,-75,-73,7);
		updateScanText(handles,'deg');
    case 19
        handles.func=@set_B5D36_BDES;
        setdefaults(handles,10,20,3);
        updateScanText(handles,'GeV');
    case 20
        handles.func=@set_axicon_horizontal;
        setdefaults(handles,-2,0,5);
        updateScanText(handles,'mm');
    case 21
        handles.func=@set_axicon_vertical;
        setdefaults(handles,-1,1,5);
        updateScanText(handles,'mm');
	case 22
		handles.func=@set_dummy;
		setdefaults(handles,-1,1,3);
		updateScanText(handles,'unitless');
end

guidata(hObject,handles)

Setscanval(handles);

end

function setdefaults(handles,start,scanend,steps)
set(handles.Scanstartval,'String',num2str(start));
set(handles.Scanendval,'String',num2str(scanend));
set(handles.Scanstepsval,'String',num2str(steps));
end
