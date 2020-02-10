clear all;close all;

%% parametres
pas=0.001;
x_ini=1.5;
seuil=0.0001;
pas_sous_gra=0.1;

%% descente de gradient 1d

x_min=-5;pas_x=0.01;x_max=5;
x=x_min:pas_x:x_max;
% x1=x_min:pas_x:1;
% x2=1:pas_x:x_max;
% f=[x1.*x1,x2];
f=abs(x-1)+abs(-2*x+5);
gradf=gradient(f,x);
% plot(x,gradf);
hold on
plot(x,f)
hold on
f1=@(x1) abs(x-1) + abs(-2*x+5);
plot(x_ini,f1(x_ini),'r*')
x_bar=x_ini;
n=1;
diff=1;
while(abs(diff(n))>seuil)
    if (round(length(x)/(x_max-x_min)*x_bar(n)+(length(x)-1)/2)==1)
        min=(round(length(x)/(x_max-x_min)*x_bar(n)+(length(x)-1)/2))-1;
        max=(round(length(x)/(x_max-x_min)*x_bar(n)+(length(x)-1)/2))+1;
        vec=min:pas_sous_grad:max;
        for i=vec
            if (i<seuil)
                x_bar2=x_bar(n)+seuil+0.000000000000000000000000000001;
            else
                x_bar2=tamere;
            end
        end
    else
        x_bar2=x_bar(n)-pas*gradf(round(length(x)/(x_max-x_min)*x_bar(n)+(length(x)-1)/2));
        x_bar=[x_bar,x_bar2];
    end
        diff2=x_bar2-x_bar(n);
        diff=[diff,diff2];
        hold on
        plot(x_bar2,f1(x_bar2),'r*')
        n=n+1;
end
axis([x_min x_max -inf inf])
