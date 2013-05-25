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
        try
            handles=rmfield(handles,'func');
        end
        setdefaults(handles,-150,150,7);
        updateScanText(handles,'MeV');
end


        

guidata(hObject,handles)

Setscanval(handles);

end

function setdefaults(handles,start,scanend,steps)
set(handles.Scanstartval,'String',num2str(start));
set(handles.Scanendval,'String',num2str(scanend));
set(handles.Scanstepsval,'String',num2str(steps));
end