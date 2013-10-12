%% Generation of the structure "sextufilter"

Synchro_ref = get_gsl_sf_synchrotron_1();
Lanex_ref = get_lanexresponse();
Nist_ref = get_NIST_cross_sections();

sextufilter = struct();
sextufilter.Ec = logspace(-2,4,500);
sextufilter.S_sim = zeros(size(sextufilter.Ec,2), 14);
for m=1:size(sextufilter.Ec,2)
    sextufilter.S_sim(m,:)= Gamma_sim(sextufilter.Ec(m), Synchro_ref, Lanex_ref, Nist_ref);
end

save('sextufilter.mat', 'sextufilter');
