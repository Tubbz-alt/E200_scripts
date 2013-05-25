function Setscanval(handles)
% Validate
scanstartval=validatescanvals(handles.Scanstartval,'Scan Start',handles);
scanendval=validatescanvals(handles.Scanendval,'Scan End',handles);
scanstepsval=validatestepval(handles.Scanstepsval,'Scan Number of Steps',handles);

strlist=[scanstartval:(scanendval-scanstartval)/(scanstepsval-1):scanendval];
strlist=[num2str(strlist(1:end-1),'%G, ') ' ' num2str(strlist(end))];

set(handles.Scanvaluesstr,'String',strlist);
end
 
function out=validatescanvals(hObject,str,handles)
out=str2double(get(hObject,'String'));
if ~(~isnan(out) && isnumeric(out) && (size(out,2)==1) && (size(out,2)==1) )
    set(handles.Scanvaluesstr,'String','');
    error([str ' needs to be a number.']);
end
end

function out=validatestepval(hObject,str,handles)
out=str2double(get(hObject,'String'));
if ~(~isnan(out) && isnumeric(out) && (size(out,2)==1) && (size(out,2)==1) )
    set(handles.Scanvaluesstr,'String','');
    error([str ' needs to be an integer.']);
else
    out=round(out);
    set(hObject,'String',num2str(out));
end
end