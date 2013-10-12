function S= S_eval(spec_file, Lanex_ref, Nist_ref)

% Function used to compute the expected signals on BETA1 and BETA2 
% for a given spectrum contained in the file spec_file.

tmp = load(spec_file);

E = 1e-6 * tmp(:,1)';
beta_spec = tmp(:,2)';
lanex_response = zeros(size(E,2), 7);
for i=1:7; lanex_response(:,i) = interp1(Lanex_ref(:,1), Lanex_ref(:,i+1), E); end;
filter_transparency = ones(size(E,2), 7);
filter_transparency(:,1) = Filter_transparency(Nist_ref, E, 'Cu', 1);
filter_transparency(:,2) = Filter_transparency(Nist_ref, E, 'Cu', 3);
filter_transparency(:,3) = Filter_transparency(Nist_ref, E, 'Cu', 10);
filter_transparency(:,4) = Filter_transparency(Nist_ref, E, 'W', 3);
filter_transparency(:,5) = Filter_transparency(Nist_ref, E, 'W', 1);
filter_transparency(:,6) = Filter_transparency(Nist_ref, E, 'Cu', 0.3);

SL = trapz(E, beta_spec.*lanex_response(:,5)', 2);
S1(1) = trapz(E, beta_spec.*lanex_response(:,1)'.*filter_transparency(:,5)', 2);
S1(2) = trapz(E, beta_spec.*lanex_response(:,2)'.*filter_transparency(:,5)', 2);
S1(3) = trapz(E, beta_spec.*lanex_response(:,3)'.*filter_transparency(:,5)', 2);
S1(4) = trapz(E, beta_spec.*lanex_response(:,4)'.*filter_transparency(:,5)', 2);
S1(5) = trapz(E, beta_spec.*lanex_response(:,5)'.*filter_transparency(:,5)', 2);
S1(6) = trapz(E, beta_spec.*lanex_response(:,6)'.*filter_transparency(:,5)', 2);
S1(7) = trapz(E, beta_spec.*lanex_response(:,7)'.*filter_transparency(:,5)', 2);
S2(1) = trapz(E, beta_spec.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,1)', 2);
S2(2) = trapz(E, beta_spec.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,2)', 2);
S2(3) = trapz(E, beta_spec.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,3)', 2);
S2(4) = trapz(E, beta_spec.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,4)', 2);
S2(5) = trapz(E, beta_spec.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,5)', 2);
S2(6) = trapz(E, beta_spec.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,6)', 2);
S2(7) = trapz(E, beta_spec.*lanex_response(:,5)'.*filter_transparency(:,5)'.*filter_transparency(:,7)', 2);

S = [S1/SL S2/SL];


 
end

