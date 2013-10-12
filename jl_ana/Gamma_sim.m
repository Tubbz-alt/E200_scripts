function S_sim = Gamma_sim(Ec, Synchro_ref, Lanex_ref, Nist_ref)
% S_sim = Gamma_num(Ec, Synchro_ref, Lanex_ref, Nist_ref)
% For a given critical energy, Gamma_num simulates the values
% of the gamma-ray signal  that would be observed at BETA1 and BETA2
% behind each filter.
% - "Ec" is the critical energy.
% - "Synchro_ref" is gotten from get_gsl_sf_synchrotron_1.m.
% - "Lanex_ref" is gotten from get_lanexresponse.m.
% - "Nist_ref" is gotten from get_NIST_cross_sections.m.
% - S_sim is the simulated gamma-ray signal as observed at BETA1 and BETA2
% behind each filter, normalized by the gamma-ray signal obserbed at BETAL.
% It is a 1*14 vector.
% S_sim(1:7) is the normalized signal behind Cu 1 mm, Cu 3 mm, Cu 10 mm,
% W 3 mm, W 1 mm, Cu 0.3 mm, No filter at BETA1.
% S_sim(8:14) is the normalized signal behind Cu 1 mm, Cu 3 mm, Cu 10 mm,
% W 3 mm, W 1 mm, Cu 0.3 mm, No filter at BETA2.


E = logspace(-2, min(log10(700*Ec),4), 500);
sync_1 = synchrotron1(Synchro_ref, E/Ec);
lanex_response = zeros(size(E,2), 7);
for i=1:7; lanex_response(:,i) = interp1(Lanex_ref(:,1), Lanex_ref(:,i+1), E); end;
filter_transparency = ones(size(E,2), 7);
filter_transparency(:,1) = Filter_transparency(Nist_ref, E, 'Cu', 1);
filter_transparency(:,2) = Filter_transparency(Nist_ref, E, 'Cu', 3);
filter_transparency(:,3) = Filter_transparency(Nist_ref, E, 'Cu', 10);
filter_transparency(:,4) = Filter_transparency(Nist_ref, E, 'W', 3);
filter_transparency(:,5) = Filter_transparency(Nist_ref, E, 'W', 1);
filter_transparency(:,6) = Filter_transparency(Nist_ref, E, 'Cu', 0.3);

SL = trapz(E, sync_1.*lanex_response(:,5)', 2);
S1(1) = trapz(E, sync_1.*lanex_response(:,1)'.*filter_transparency(:,5)', 2);
S1(2) = trapz(E, sync_1.*lanex_response(:,2)'.*filter_transparency(:,5)', 2);
S1(3) = trapz(E, sync_1.*lanex_response(:,3)'.*filter_transparency(:,5)', 2);
S1(4) = trapz(E, sync_1.*lanex_response(:,4)'.*filter_transparency(:,5)', 2);
S1(5) = trapz(E, sync_1.*lanex_response(:,5)'.*filter_transparency(:,5)', 2);
S1(6) = trapz(E, sync_1.*lanex_response(:,6)'.*filter_transparency(:,5)', 2);
S1(7) = trapz(E, sync_1.*lanex_response(:,7)'.*filter_transparency(:,5)', 2);
S2(1) = trapz(E, sync_1.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,1)', 2);
S2(2) = trapz(E, sync_1.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,2)', 2);
S2(3) = trapz(E, sync_1.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,3)', 2);
S2(4) = trapz(E, sync_1.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,4)', 2);
S2(5) = trapz(E, sync_1.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,5)', 2);
S2(6) = trapz(E, sync_1.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,6)', 2);
S2(7) = trapz(E, sync_1.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,7)', 2);

S_sim = [S1/SL S2/SL];

end





