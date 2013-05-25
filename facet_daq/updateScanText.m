function updateScanText(handles,units)
    set(handles.Scanstarttext,'String',['Scan Start [' units ']'])
    set(handles.Scanendtext,'String',['Scan End [' units ']'])
    set(handles.Scanvaluestext,'String',['Scan Values [' units ']:'])
end