%%

do_save=0;

fig = figure(1);        % positionnement de la figure
set(fig, 'position', [20, 50, 1340, 630]);
set(fig, 'PaperPosition', [0.25, 2.5, 35, 17]);
set(fig, 'color', 'w');
clf();

N = 10000;
gamma0 = 12.35/5.11;
gammamin = 10/5.11;
gammamax = 24/5.11;
step = 0.005;
nb_energypoint = floor((gammamax - gammamin)/step + 1);

sigmax = 150e-6;
sigmaxprime1 = 50e-6;
percent1 = 0.2;
sigmaxprime2 = 500e-6;

% for percent1=0.1:0.1:0.9

xoven = sigmax*randn(1,N);
xprimeoven = [sigmaxprime1*randn(1,percent1*N), sigmaxprime2*randn(1,N-percent1*N)];
Xoven = [xoven;xprimeoven];

B=[];
 for i=gammamin:step:gammamax  
B = [transport_oven_cher(10000*i,10000*gamma0,sigmax,sigmaxprime1,percent1,sigmaxprime2);B];
end;

[n,xout]=hist(B',1000);

 A=[];
for i=1:nb_energypoint
A(:,i)= n(:,nb_energypoint+1-i);
end;

C = 0.3*A + 10 +4*randn(size(A));
A = 0.3*A + 10 +4*randn(size(A));
A(A<1)=1;

%%


% EScale = [28,26,24,22,20,18,16,14,12];
% YScale = -28:28;
YScale = -28:(56/(nb_energypoint-1)):28;
EScale = 5.11*gammamin:5.11*step:5.11*gammamax;
% EScale = [6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36];
% EScale = E_ELOSS;

% if percent1 == 0.1

h_text = axes('Position', [0., 0.85, 0.8, 0.1], 'Visible', 'off');     
    energy0 = text(0.07,0.7,['E_0 = ' num2str(5.11*gamma0) ' GeV' ], 'fontsize',18);
    sigx = text(0.3,0.7,['\sigma_x = ' num2str(1000000*sigmax) ' \mum' ], 'fontsize',18);
    sigxprime1 = text(0.48,0.7,['\sigma_{x^{''}1} = ' num2str(1000000*sigmaxprime1) ' \murad  Percentage : ' num2str(100*percent1) '%' ], 'fontsize',18);
    sigxprime2 = text(0.85,0.7,['\sigma_{x^{''}2} = ' num2str(1000000*sigmaxprime2) ' \murad  Percentage : ' num2str(100*(1-percent1)) '%' ], 'fontsize',18);

left = axes('position', [0.1, 0.15, 0.35, 0.65]) ;
    hist(xprimeoven,100);
    histo = get(gca,'Children');
    title('Superposition of two Gaussian Distributions');
    xlabel('x^{''}_{oven} (rad)'); ylabel('Number of Counts');

right = axes('position', [0.57, 0.15, 0.35, 0.65]) ; 
    img = image(1000*xout(200:800),EScale,log10(A(200:800,:)'),'CDataMapping','scaled');
%     img = newplot(log10(A(150:850,:)'));
    set(gca,'YDir','normal');
%     y=get(gca,'YDir');
    title('Homemade Butterfly (log scale)');
    xlabel('x_{cher} (mm)'); ylabel('E (GeV)');
    cmap = custom_cmap();
    colorbar();
    colormap(cmap.wbgyr);
    caxis([0.9 3.2]);
    
    
% else
%     
%     set(energy0,'String',['E_0 = ' num2str(5.11*gamma0) ' GeV' ]);
%     set(sigx,'String',['\sigma_x = ' num2str(1000000*sigmax) ' \mum' ]);
%     set(sigxprime1,'String',['\sigma_{x^{''}1} = ' num2str(1000000*sigmaxprime1) ' \murad  Percentage : ' num2str(100*percent1) '%' ]);
%     set(sigxprime2,'String',['\sigma_{x^{''}2} = ' num2str(1000000*sigmaxprime2) ' \murad  Percentage : ' num2str(100*(1-percent1)) '%' ]);
%     set(histo,'CData',xprimeoven);
%     set(img,'CData',log10(A(150:850,:)'));
%     
% end;
    
%%    
    
if do_save           
    filename = ['Homemade_Butterfly_50urad=' num2str(100*percent1) 'percent_E0=' num2str(5.11*gamma0) 'GeV.png'];
    print('-f1', ['C:/Users/Bastien/Desktop/PRE/Matlab/2013_E200_Data_Analysis/Homemade_Butterfly/' filename], '-dpng', '-r100');
% else
%     pause(0.05);
end;


% end







