clear all; close all;

%% parametres
seuil=0.000001;
x_ini=-2.26;
y_ini=0;
gamma=0.1;

%% calcul de prox

x_min=-5;pas_x=0.01;x_max=5;
x=x_min:pas_x:x_max;
y_min=-5;pas_y=0.01;y_max=5;
x=y_min:pas_y:y_max;
%f=abs(x);
f=abs(x+y);
g=6*x+3*y;
hold on
%f1=@(x1)abs(x1);
f1=@(x1,y1) abs(x1+y1);
g1=@(x1,y1) 6*x+3*y;
% prox=@(x2)(x2-gamma).*((x2-gamma)>0)+(x2+gamma).*((x2+gamma)<0)+(x2).*((x2)==0);
%proxf=@(x2,y2)%TODO
[gradgx,gradgy]=gradient(g,x,y);
% proxi=zeros(1,length(x));
% for i=1:length(x)
%     proxi(i)=proxf(x(i));
% end
% grad=zeros(1,length(x));
% for i=1:length(x)
%     grad(i)=gradg(x(i));
% end
% hold on
% plot(x,proxi,'r')
% plot(x,gradg,'b')
% plot(x,f+g,'g')
% legend('proxi',

%% algorithme du point proximal

%plot(x_ini,(f1(x_ini)+g1(x_ini)),'r*')
x_k=x_ini;
y_k=x_ini;
n=1;
diff=1;
while(abs(diff(n))>seuil)
    x_k2=proxf(x_k(n),y_k(n));
    x_k=[x_k,x_k2];
    diff2=x_k2-x_k(n);
    diff=[diff,diff2];
    hold on
    plot(x_k2,(f1(x_k2)+g1(x_k2)),'r*')
    n=n+1;
end
axis([x_min x_max -inf inf])