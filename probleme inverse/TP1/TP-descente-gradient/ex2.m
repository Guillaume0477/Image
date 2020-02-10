clear all;close all;

%% parametres
pas=0.01;
x_ini=-2;
seuil=0.0001;

%% descente de gradient 1d

x_min=-5;pas_x=0.1;x_max=5;
x=x_min:pas_x:x_max;
l=length(x); 
H=matH_1D(l,3,'gaussian',10);
%H=eye(l);
b=randn(1,l)';
x_trait=(2*(x.*x)+3)';
z=H*x_trait+b;
x1=ones(l,1);
x0=zeros(l,1);
while(norm(x1-x0)>seuil)
    x0=x1;
    x1=x0-pas*(2*H'*(H*x0-z));
end
x_chapeau=inv(H'*H)*H'*z;
plot(x,x_chapeau,'b',x,x1,'r',x,z,'g',x,x_trait,'m')
legend('chapeau','reconstruit','observe','xtrait')