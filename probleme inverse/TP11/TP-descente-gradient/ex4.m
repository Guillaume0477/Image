clear all;close all;

%% parametres
pas=0.01;
x_ini=-2;
seuil=0.01;
lambda=0.1;

%% descente de gradient 1d

Img=imread('Image.png');
[h,w]=size(Img);
%H=eye(l);
b=2*randn(h,w)';
% z=H(Img,ker)+b; %H*x=H(x) et H'*x=Hadj(x) 
% x1=ones(l,1);
% x0=zeros(l,1);
% while(norm(x1-x0)>seuil)
%     x0=x1;
%     x1=x0-pas*(2*H'*(H*x0-z)+2*lambda*(gamma)'*gamma*x0);
% end
% x_chapeau=inv(H'*H+lambda*(gamma)'*gamma)*H'*z;
% plot(x,x_chapeau,'b',x,x1,'r',x,z,'g',x,x_trait,'m')
% legend('chapeau','reconstruit','observe','xtrait')