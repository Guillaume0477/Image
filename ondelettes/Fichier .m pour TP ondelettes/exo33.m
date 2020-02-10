close all; clear variables;

%Classification: transformée en ondelettes continues

dx=2/64;
alpha=pi;
[X,Y]=meshgrid(-1:dx:+1);
T=exp((-1/2)*(X.^2+Y.^2));
Psi=(X*cos(alpha)+Y*sin(alpha)).*T;

figure(1);
%subplot(2,2,1);

surf(X,Y,Psi);

dx=4/64;
l=1;
dtheta=3.1415/4;
R_l_dtheta = [cos(l*dtheta) sin(l*dtheta);-sin(l*dtheta) cos(l*dtheta)];

[X,Y]=meshgrid(-1:dx:+1);
phi_j_l = zeros(1,length(X));
for l=0:1
   for j = -4:-1 
       %figure();
       subplot(4,2,(j+5)+(l*5));
       disp((j+5)*(l+1));
       scal=1/(2^j);
       
       T=exp((-1/2)*(scal*X.^2+scal*Y.^2));
       alpha=l*dtheta;
       Phi =(scal*X*cos(alpha)+scal*Y*sin(alpha)).*T;
       phi_j_l=(1/2^j)*Phi;
       surf(X,Y,phi_j_l);
       
       
       
   end
end
