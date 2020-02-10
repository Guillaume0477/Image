clear all;close all;

%% parametres
pas=0.001;
x_ini=5;
seuil=0.0001;
gamma=0.1;

%% descente de gradient 1d

x_min=-20;pas_x=0.01;x_max=20;
x=x_min:pas_x:x_max;

prox=@(x2)(x2-gamma).*((x2-gamma)>0)+(x2+gamma).*((x2+gamma)<0)+(x2).*((x2)==0);
moro=@(x3)abs(prox(x3))+(1/(2*gamma))*((-x3+prox(x3))^2);
f1=@(x3)abs(prox(x3))+(1/(2*gamma))*((-x3+prox(x3))^2);
f=zeros(1,length(x));
for i=1:length(x)
    f(i)=f1(x(i));
end
%f=x.*x;
gradf=gradient(f,x);
% plot(x,gradf);
hold on
plot(x,f)
hold on

%f1=@(x1) x1.*x1;
plot(x_ini,f1(x_ini),'r*')
x_bar=x_ini;
n=1;
diff=1;
while(abs(diff(n))>seuil)
    x_bar2=x_bar(n)-pas*gradf(round(length(x)/(x_max-x_min)*x_bar(n)+(length(x)-1)/2));
    x_bar=[x_bar,x_bar2];
    diff2=x_bar2-x_bar(n);
    diff=[diff,diff2];
    hold on
    plot(x_bar2,f1(x_bar2),'r*')
    n=n+1;
end
axis([x_min x_max -inf inf])