x=logspace(-1,2,200);
figure(3);
% loglog(x,Filter_transparency(Nist_ref,x,'Cu', 1),'k',x,Filter_transparency(Nist_ref,x,'Cu', 3),'m' ...
% ,x, Filter_transparency(Nist_ref,x,'Cu', 10),'c',x,Filter_transparency(Nist_ref,x,'W', 3),'bl' ...
% ,x, Filter_transparency(Nist_ref,x,'W', 1),'r',x,Filter_transparency(Nist_ref,x,'Cu', 0.3),'g'); 

plot(x,Filter_transparency(Nist_ref,x,'Cu', 1),'k',x,Filter_transparency(Nist_ref,x,'Cu', 3),'m' ...
,x, Filter_transparency(Nist_ref,x,'Cu', 10),'c',x,Filter_transparency(Nist_ref,x,'W', 3),'bl' ...
,x, Filter_transparency(Nist_ref,x,'W', 1),'r',x,Filter_transparency(Nist_ref,x,'Cu', 0.3),'g'); 
    legend('Cu1 mm', 'Cu 3mm', 'Cu 10mm', 'W 3mm', 'W 1mm', 'Cu 0.3mm', 'NF');

        xlabel('Photon Energy (MeV)'); ylabel('Transmission');

xi=100;
T(1)=Filter_transparency(Nist_ref,xi,'Cu', 1);
T(2)=Filter_transparency(Nist_ref,xi,'Cu', 3);
T(3)=Filter_transparency(Nist_ref,xi,'Cu', 10);
T(4)=Filter_transparency(Nist_ref,xi,'W', 3);
T(5)=Filter_transparency(Nist_ref,xi,'W', 1);
T(6)=Filter_transparency(Nist_ref,xi,'Cu', 0.3);


T