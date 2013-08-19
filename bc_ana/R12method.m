
do_save = 1;

fig = figure(1);        % positionnement de la figure
set(fig, 'position', [20, 50, 1340, 630]);
set(fig, 'PaperPosition', [0.25, 2.5, 35, 17]);
set(fig, 'color', 'w');
clf();

%%
N = 10000;
gamma0 = 16.35/5.11;
gammamin = 10/5.11;
gammamax = 24/5.11;
step = 0.005;
nb_energypoint = floor((gammamax - gammamin)/step + 1);

D1 = 5.93; D2 = 5; D3 = 12.12;
f1 = 3.46; f2 = 4.51;

sigmax = 150e-6;
sigmaxprime1 = 50e-6;
percent1 = 0.5;
sigmaxprime2 = 500e-6;

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

% C = 0.5*A + 10 +4*randn(size(A));
A = 0.5*A  +4*randn(size(A));
C = 0.5*A  +4*randn(size(A));
C(C<1)=1;

YScale = -28:(56/(nb_energypoint-1)):28;
EScale = 5.11*gammamin:5.11*step:5.11*gammamax;

%%
order_fit=2;
nb_slice = 1;

[~,ind]=ismember(min((EScale-(12.35)).^2),(EScale-(12.35)).^2);
xzoom_min = ind - 5;
xzoom_max = ind + 5;
yzoom_min = 400;
yzoom_max = 575;

CELOSS.yyzoom = 1000*xout(yzoom_min:yzoom_max);
CELOSS.xxzoom = YScale(xzoom_min:xzoom_max);
    
CELOSS.zoom = A(yzoom_min:yzoom_max, xzoom_min:xzoom_max);

CELOSS.slice = slice(CELOSS.zoom, nb_slice);
CELOSS.slice2 = CELOSS.slice;
CELOSS.slice2(CELOSS.slice2<1)=1;

h = floor((xzoom_max - xzoom_min +1)/nb_slice);
    
% CELOSS.reduc = reduc(CELOSS.slice, nb_slice);
% 
% CELOSS.reduc1 = CELOSS.reduc(:,1);
% CELOSS.reduc2 = CELOSS.reduc(:,h*0.5*nb_slice + 1);
% CELOSS.reduc3 = CELOSS.reduc(:,1+h*(nb_slice-1));

% yparabole=[];
% for k=0:(nb_slice - 1); yparabole = [yparabole, CELOSS.xxzoom(1,1+k*h)];end;
%     
% F = sigmacarre(CELOSS.slice', CELOSS.yyzoom, nb_slice);
x=-20:0.1:20;
[a,b,c]=mygaussfit(CELOSS.yyzoom,CELOSS.slice);

   
% p = polyfit(yparabole, F,order_fit);
% x2 = yparabole;
% y2 = polyval(p,x2);
     
% eta = 0.001*61*20.35/12.35;   % en m
% theta = sqrt(0.25*p(order_fit - 1)*(eta^2)/(23.05^2));    % en rad
% y0 = -p(order_fit)/(2*p(order_fit - 1));
% sigma0 =  sqrt(p(order_fit + 1)-p(order_fit - 1)*y0^2)/(5.6);
% emit = sigma0*1000*theta*10000*gamma0;

R12 = @(gamma) D1 + D2 + D3 - D1*D2*gamma0/(gamma*f1) + D1*D3*gamma0/(gamma*f2) - D1*D3*gamma0/(gamma*f1) + D2*D3*gamma0/(gamma*f2) - D1*D2*D3*gamma0^2/(f1*f2*gamma^2);
thetaR12 = a/(1000*abs(R12(12.35/5.11)));



%%

h_tex3 = axes('Position', [0.65, 0.1, 0.2, 0.8], 'Visible', 'off'); 
        energy0 = text(0.1,.9,['E_0 = ' num2str(5.11*gamma0) ' GeV' ], 'fontsize',15);
        sigx = text(0.1,0.8,['\sigma_x = ' num2str(1000000*sigmax) ' \mum' ], 'fontsize',15);
        sigxprime1 = text(0.1,0.7,['\sigma_{x^{''}1} = ' num2str(1000000*sigmaxprime1) ' \murad  Percentage : ' num2str(100*percent1) '%' ], 'fontsize',15);
        sigxprime2 = text(0.1,0.6,['\sigma_{x^{''}2} = ' num2str(1000000*sigmaxprime2) ' \murad  Percentage : ' num2str(100*(1-percent1)) '%' ], 'fontsize',15);
        ssigma0 = text(0.1,0.3,['\sigma_0 =' num2str(a) ' mm'],'fontsize', 15, 'color', 'b');
        ineq = text(0.1,0.2,['R_{12} Method : \Theta <= \sigma_x(\delta) / R_{12}(\delta)' ], 'fontsize', 17, 'color', 'b');
        div = text(0.1,0.1,['\Theta <= ' num2str(1000000*thetaR12) ' \murad' ], 'fontsize', 22, 'color', 'b');
%         ssigma0 = text(0.1,1.8,['\sigma_0 = ' num2str(1000*sigma0) ' \mum' ], 'fontsize', 17, 'color', 'b');
%         yy0 = text(0.1,0.8,['y_0 = ' num2str(y0) ' mm' ], 'fontsize', 17, 'color', 'b');
%         emittance = text(0.1,0.,['\epsilon < ' num2str(emit) ' microns' ], 'fontsize', 20, 'color', 'b'); 
 
 left = axes('position', [0.065, 0.565, 0.22, 0.39]) ;
    hist(xprimeoven,100);
    histo = get(gca,'Children');
    title('Superposition of two Gaussian Distributions');
    xlabel('x^{''}_{oven} (rad)'); ylabel('Number of Counts');       
        
LeftAxes1 = axes('position', [0.37, 0.565, 0.22, 0.39]) ;  
    img1 = image(1000*xout(200:800),EScale,log10(C(200:800,:)'),'CDataMapping','scaled');
%     img = newplot(log10(A(150:850,:)'));
    set(gca,'YDir','normal');
%     y=get(gca,'YDir');
    title('Homemade Butterfly (log scale)');
    xlabel('x_{cher} (mm)'); ylabel('E (GeV)');
    cmap = custom_cmap();
    colorbar();
    colormap(cmap.wbgyr);
    caxis([0.9 3.2]);
    
LeftAxes2 = axes('position', [0.37, 0.065, 0.22, 0.39]);  
    img2 = image(CELOSS.yyzoom,EScale(xzoom_min:xzoom_max),log10(CELOSS.slice2'),'CDataMapping','scaled');
%     img = newplot(log10(A(150:850,:)'));
    set(gca,'YDir','normal');
%     y=get(gca,'YDir');
    title('Homemade Butterfly (log scale)');
    xlabel('x_{cher} (mm)'); ylabel('E (GeV)');
    cmap = custom_cmap();
    colorbar();
    colormap(cmap.wbgyr);
    caxis([0.9 3.2]);
    
 axes('position', [0.065, 0.065, 0.22, 0.39])  % affichage des gaussiennes décrites par CELOSS.reduc
%         hold all;
%         axis([-12 12 0 1500]);
%         celossreduc3 = plot(CELOSS.yyzoom,CELOSS.slice);
        hold all;
        plot(CELOSS.yyzoom,CELOSS.slice(:,1))
        plot(x,c*exp(-(x-b).^2/(2*a^2)))
        
 %         hleg2 = legend('First Slice','Middle Slice', 'Last Slice');
%         set(hleg2,'Location','Best')
        xlabel('x (mm)'); ylabel('nombre de comptes');
        title('LINE-OUT');
%        
% axes('position', [0.7, 0.565, 0.22, 0.39])  % affichage du vecteur A
%         hold all;
% %         axis([-1 8 0 2.7]);
%         parabola = plot(yparabole, F, 'x');  
% %         parabola_fit = plot(x2,y2);
% %         hleg1 = legend('Calculations','Parabolic Fit');
% %         set(hleg1,'Location','Best')
%         xlabel('y (mm)'); ylabel('\sigma_x^2 (mm^2)'); 
%         title('PARABOLIC FIT');

        
%%    
    
if do_save           
    filename = ['Homemade_Butterfly_50urad=' num2str(100*percent1) 'percent_E0=' num2str(5.11*gamma0) 'GeV_2.png'];
    print('-f1', ['C:/Users/Bastien/Desktop/PRE/Matlab/2013_E200_Data_Analysis/Homemade_Butterfly_Analysis/R12Method/' filename], '-dpng', '-r100');
% else
%     pause(0.05);
end;