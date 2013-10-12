function Nist_ref = get_NIST_cross_sections()  
%    Script to get the NIST datas on copper and tungsten cross-sections.
%    Needs the data stored by default in a "NIST_cross_sections" directory

%    Nist_ref . copper :     1 : Copper Energy Axis
%                            2 : Copper Cross Section
%             . tungsten :   1 : Tungsten Energy Axis
%                            2 : Tungsten Cross Section
%

path_nist = '~/Dropbox/SeB/Postdoc/Projects/BetaRad/NIST_cross_sections/';

Nist_ref = struct();
Nist_ref.copper=load([path_nist 'Copper_nist.txt']);
Nist_ref.copper(:,[2:6,8])=[]; 

Nist_ref.tungsten=load([path_nist 'Tungsten_nist.txt']);
Nist_ref.tungsten(:,[2:6,8])=[]; 

Nist_ref.tungsten90=load([path_nist 'Tungsten90_nist.txt']);
Nist_ref.tungsten90(:,[2:6,8])=[]; 

end