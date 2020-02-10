

%% 2eme methode


clear;
close all;

%%lecture des images
I2 = im2double(imread('i0002.png'));
I4 = im2double(imread('i0004.png'));

hauteur=size(I2,1);
largeur=size(I2,2);

%%definition des paramÃ¨tres de l'algorithme
n=7;
ecart=(n-1)/2;

%% calcul des gradients
It = I4-I2;
[Ix,Iy]=gradient(I2);


w=(1/(n ^2))*ones(n,n);
W=diag(w(:));

%algo

u=zeros(480,640);
v=zeros(480,640);
for i=(1+ecart):hauteur-ecart
   for j=1+ecart:largeur-ecart
       
       Ax=Ix(i-ecart:i+ecart,j-ecart:j+ecart);
       Ay=Iy(i-ecart:i+ecart,j-ecart:j+ecart);
       A=[Ax(:),Ay(:)];
       
       btemp=-It(i-ecart:i+ecart,j-ecart:j+ecart);
       b=btemp(:);
       
       Ma=0;
       Mb=0;
       Md=0;
       for ii=1:n
           for jj=1:n
                Ma=Ma+ w(ii,jj)^2 * Ax(ii,jj)^2;
                Mb=Mb+ w(ii,jj)^2 * Ax(ii,jj) * Ay(ii,jj);
                Md=Md+ w(ii,jj)^2 * Ay(ii,jj)^2;
                                                
           end
       end
       M=[Ma,Mb;Mb,Md];
       R=A' * W.^2 * b;
       flux=M\R;
       u(i,j)=flux(1);
       v(i,j)=flux(2);
   end
end

% echantillonage des vecteurs (1/16)
for i=1:hauteur
   for j=1:largeur
        if( mod(i,4)~=0 || mod(j,4)~=0 ) 
            u(i,j)=0;
            v(i,j)=0;
        end
   end
end



figure(5);
imshow(I2,[]);
title('Image d''origine supreposé aux vecteurs de flux')
hold on;
quiver(1:640,1:480,u,v,20);














 
 
 