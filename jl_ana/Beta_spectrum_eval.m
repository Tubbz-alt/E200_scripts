%% Script used to evaluate the datas for the Beta_spectrum simulations

S_2tsim= Beta_spectrum(Lanex_ref, Nist_ref, 1:14, 2, 1);
S_4tsim= Beta_spectrum(Lanex_ref, Nist_ref, 1:14, 4, 1);
S_8tsim= Beta_spectrum(Lanex_ref, Nist_ref, 1:14, 8, 1);
S_16tsim= Beta_spectrum(Lanex_ref, Nist_ref, 1:14, 16, 1);
S_32tsim= Beta_spectrum(Lanex_ref, Nist_ref, 1:14, 32, 1);

%%
[Ec_2t, dmin_2t]= fminsearch(@(z) Gamma_num_ratio(z, 200, Synchro_ref, Lanex_ref, Nist_ref, ratioteur(S_2tsim(1:7)), 1:14, 1), 1)
[Ec_4t, dmin_4t]= fminsearch(@(z) Gamma_num_ratio(z, 200, Synchro_ref, Lanex_ref, Nist_ref, ratioteur(S_4tsim(1:7)), 1:14, 1), 1)
[Ec_8t, dmin_8t]= fminsearch(@(z) Gamma_num_ratio(z, 200, Synchro_ref, Lanex_ref, Nist_ref, ratioteur(S_8tsim(1:7)), 1:14, 1), 1)
[Ec_16t, dmin_16t]= fminsearch(@(z) Gamma_num_ratio(z, 200, Synchro_ref, Lanex_ref, Nist_ref, ratioteur(S_16tsim(1:7)), 1:14, 1), 1)
[Ec_32t, dmin_32t]= fminsearch(@(z) Gamma_num_ratio(z, 200, Synchro_ref, Lanex_ref, Nist_ref, ratioteur(S_32tsim(1:7)), 1:14, 1), 1)

%%

