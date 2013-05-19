
function epics_data = getEPICS(myeDefNumber)

E200_BSA_list;

eDefOff(myeDefNumber);

pid = lcaGetSmart(sprintf('PATT:SYS1:1:PULSEIDHST%d',myeDefNumber));
% disp(pid);
pulses = lcaGetSmart(sprintf('PATT:SYS1:1:PULSEIDHST%d.NUSE',myeDefNumber));
for j = 1:length(BSA_list)
    temp = lcaGetSmart(sprintf('%sHST%d',char(BSA_list(j)),myeDefNumber));
    name = regexprep(BSA_list(j), ':', '_');
    for i = 1:pulses
        epics_data(i).(char(name)) = temp(i);
    end
end
eDefRelease(myeDefNumber);

end