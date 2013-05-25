function set_phase_ramp(phase)

try
    SET_VDES('PHAS','DR12',61,phase,'TRIM');
catch
    display('Unable to set phase ramp');
end