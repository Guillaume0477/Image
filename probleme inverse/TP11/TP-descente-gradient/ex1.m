clear all;close all;

%% parametres
pas=0.001;
x_ini=5;
seuil=0.0001;

%% descente de gradient 1d

x_min=-20;pas_x=0.01;x_max=20;
x=x_min:pas_x:x_max;
f=x.*x;
gradf=gradient(f,x);
% plot(x,gradf);
hold on
plot(x,f)
hold on
f1=@(x1) x1.*x1;
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