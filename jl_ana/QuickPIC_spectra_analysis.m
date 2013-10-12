%% Script used to evaluate the datas for the Beta_spectrum simulations

Lanex_ref = get_lanexresponse();
Nist_ref = get_NIST_cross_sections();

path_qpic_spec = '~/Dropbox/SeB/PostDoc/Projects/2013_E200_Data_Analysis/Ar_qpic_exp/qpic_spec/';
S_qpic_2T = S_eval([path_qpic_spec 'qpic_226_bet_spec_radius-15mm.txt'], Lanex_ref, Nist_ref);
S_qpic_4T = S_eval([path_qpic_spec 'qpic_227_bet_spec_radius-15mm.txt'], Lanex_ref, Nist_ref);
S_qpic_8T= S_eval([path_qpic_spec 'qpic_228_bet_spec_radius-15mm.txt'], Lanex_ref, Nist_ref);
S_qpic_8T_noacc = S_eval([path_qpic_spec 'qpic_228_bet_spec_no-acc_radius-15mm.txt'], Lanex_ref, Nist_ref);
S_qpic_16T = S_eval([path_qpic_spec 'qpic_220_bet_spec_radius-15mm.txt'], Lanex_ref, Nist_ref);
S_qpic_16T_noacc = S_eval([path_qpic_spec 'qpic_220_bet_spec_no-acc_radius-15mm.txt'], Lanex_ref, Nist_ref);
S_qpic_32T = S_eval([path_qpic_spec 'qpic_229_bet_spec_radius-15mm.txt'], Lanex_ref, Nist_ref);
S_qpic_32T_noacc = S_eval([path_qpic_spec 'qpic_229_bet_spec_no-acc_radius-15mm.txt'], Lanex_ref, Nist_ref);



%%
load('sextufilter.mat');
pick = 1:7;
[Ec_qpic_2T, Errmin_qpic_2T] = fminsearch(@(z) energy_fit_2(z, 1, 1, S_qpic_2T, pick, sextufilter), 10);
[Ec_qpic_4T, Errmin_qpic_4T] = fminsearch(@(z) energy_fit_2(z, 1, 1, S_qpic_4T, pick, sextufilter), 10);
[Ec_qpic_8T, Errmin_qpic_8T] = fminsearch(@(z) energy_fit_2(z, 1, 1, S_qpic_8T, pick, sextufilter), 10);
[Ec_qpic_8T_noacc, Errmin_qpic_8T_noacc] = fminsearch(@(z) energy_fit_2(z, 1, 1, S_qpic_8T_noacc, pick, sextufilter), 10);
[Ec_qpic_16T, Errmin_qpic_16T] = fminsearch(@(z) energy_fit_2(z, 1, 1, S_qpic_16T, pick, sextufilter), 10);
[Ec_qpic_16T_noacc, Errmin_qpic_16T_noacc] = fminsearch(@(z) energy_fit_2(z, 1, 1, S_qpic_16T_noacc, pick, sextufilter), 10);
[Ec_qpic_32T, Errmin_qpic_32T] = fminsearch(@(z) energy_fit_2(z, 1, 1, S_qpic_32T, pick, sextufilter), 10);
[Ec_qpic_32T_noacc, Errmin_qpic_32T_noacc] = fminsearch(@(z) energy_fit_2(z, 1, 1, S_qpic_32T_noacc, pick, sextufilter), 10);



%%
load('sextufilter.mat');
pick = 1:7;
[z_qpic_2T, Errmin_qpic_2T_2]= fminsearch(@(z) energy_fit_1(z, S_qpic_2T, pick, sextufilter), [10 1]);
[z_qpic_4T, Errmin_qpic_4T_2]= fminsearch(@(z) energy_fit_1(z, S_qpic_4T, pick, sextufilter), [10 1]);
[z_qpic_8T, Errmin_qpic_8T_2]= fminsearch(@(z) energy_fit_1(z, S_qpic_8T, pick, sextufilter), [10 1]);
[z_qpic_8T_noacc, Errmin_qpic_8T_noacc_2]= fminsearch(@(z) energy_fit_1(z, S_qpic_8T_noacc, pick, sextufilter), [10 1]);
[z_qpic_16T, Errmin_qpic_16T_2]= fminsearch(@(z) energy_fit_1(z, S_qpic_16T, pick, sextufilter), [10 1]);
[z_qpic_16T_noacc, Errmin_qpic_16T_noacc_2]= fminsearch(@(z) energy_fit_1(z, S_qpic_16T_noacc, pick, sextufilter), [10 1]);
[z_qpic_32T, Errmin_qpic_32T_2]= fminsearch(@(z) energy_fit_1(z, S_qpic_32T, pick, sextufilter), [10 1]);
[z_qpic_32T_noacc, Errmin_qpic_32T_noacc_2]= fminsearch(@(z) energy_fit_1(z, S_qpic_32T_noacc, pick, sextufilter), [10 1]);



%%

figure(11)
set(11, 'color', 'w');
set(gca, 'fontsize', 30);
bar([S_qpic_2T(1:7); S_qpic_4T(1:7); S_qpic_8T(1:7); S_qpic_16T(1:7); S_qpic_32T(1:7)]');
% bar([S_qpic_2T(1:7); S_qpic_4T(1:7); S_qpic_8T_noacc(1:7); S_qpic_16T_noacc(1:7); S_qpic_32T_noacc(1:7)]');
name = {'Cu 1' ; 'Cu 3' ; 'Cu 10' ; 'W 3' ;'W 1' ; 'Cu 0.3'; 'None'};
set(gca, 'xticklabel', name);
title('S BETA1 / S BETAL')
h_legend = legend('2 Torr', '4 Torr', '8 Torr', '16 Torr', '32 Torr');



%%

figure(12)
set(12, 'color', 'w');
set(gca, 'fontsize', 30);
% semilogx([2 4 8 16 32], [Ec_qpic_2T Ec_qpic_4T Ec_qpic_8T Ec_qpic_16T Ec_qpic_32T], 'sr', 'MarkerFaceColor', 'r', 'Markersize', 15);
% semilogx([2 4 8 16 32], [Ec_qpic_2T Ec_qpic_4T Ec_qpic_8T_noacc Ec_qpic_16T_noacc Ec_qpic_32T_noacc], 'sr', 'MarkerFaceColor', 'r', 'Markersize', 15);
semilogx([2 4 8 16 32], [z_qpic_2T(1) z_qpic_4T(1) z_qpic_8T(1) z_qpic_16T(1) z_qpic_32T(1)], 'sr', 'MarkerFaceColor', 'r', 'Markersize', 15);
% semilogx([2 4 8 16 32], [z_qpic_2T(1) z_qpic_4T(1) z_qpic_8T_noacc(1) z_qpic_16T_noacc(1) z_qpic_32T_noacc(1)], 'sr', 'MarkerFaceColor', 'r', 'Markersize', 15);
ylim([0 50]);
xlim([1 100]);
xlabel('Pressure (Torr)')
ylabel('Fitted Critical Energy (MeV)')
title('QuickPIC simulation results')



%%

S_fit = interp1(sextufilter.Ec, sextufilter.S_sim, z_qpic_4T(1));
S_qpic = z_qpic_4T(2)*S_qpic_4T;

figure(13)
set(13, 'color', 'w');
set(gca, 'fontsize', 30);
bar([S_qpic(1:7); S_fit(1:7); S_qpic(1:7)-S_fit(1:7)]');
fig13 = get(gca, 'Children');
set(fig13(1), 'FaceColor', 'r');
set(fig13(2), 'FaceColor', 'b');
set(fig13(3), 'FaceColor', 'g');
name = {'Cu 1' ; 'Cu 3' ; 'Cu 10' ; 'W 3' ;'W 1' ; 'Cu 0.3'; 'None'};
set(gca, 'xticklabel', name);
title('S BETA1 / S BETAL')
h_legend = legend('Qpic Signal', 'Sync Fit', 'Diff');
ylim([-0.2 1.4]);



