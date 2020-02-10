% tp HOUGH
close all;
clear;
clear variables;
%%lecture de l'image
I=im2double(imread('circuit.tif'));
figure(1);
imshow(I);
title('image d''origine');

%%
[Gmag, ~] = imgradient(I,'prewitt');
figure(2);
imshow(Gmag);
title('image du gradient');

% seuillage de Gmax pour élimiiner le bruit
I_grad_seuil = im2bw(Gmag,0.19);
figure(3);
imshow(I_grad_seuil);
title('image du gradient seuill�');

%fermeture du seuil


SE=strel('square',3); 

% pour hello.png
%I_seuil_propre=I_grad_seuil;

% pour circuit.tif
I_seuil_propre = imerode(I_grad_seuil,SE);
figure(4);
imshow(I_seuil_propre,[]);

imshow(I_seuil_propre,[]);
title('image dues contours finaux');


%% Calcul de la matrice d'accumulation
Ro_max=ceil(sqrt(size(I,1)^2+size(I,2)^2));
dtheta=0.01;
theta=0:dtheta:pi-dtheta;
H = zeros(ceil(2*Ro_max),ceil(pi/dtheta));

%boucle sur les points du contour
for i=1:size(I_seuil_propre,1) %verticalement
   for j=1:size(I_seuil_propre,2) %horizontalement
       if(I_seuil_propre(i,j)==1)
           sinusoide=j*cos(theta) + i*sin(theta);
           for t=1:1:length(sinusoide)
               H(ceil(sinusoide(t))+Ro_max,t) = 1 + H(ceil(sinusoide(t))+Ro_max,t);
           end
       end
   end
end

figure(5);
imagesc(H);
title('image de la matrice d''accumulation');

%% seuillage de H


max(max(H))

H_seuil = imbinarize(H,80);
figure(6);
imagesc(H_seuil);
title('image des maximaux de la mtrice d''accumulation');
pause(1);
%% reconstitution
figure(7);
pause(1);

imshow(I);
hold on ;

theta=0:dtheta:pi-dtheta;
I_recons=zeros(size(I,1)+1,size(I,2)+1);
nb_droites=0;

figure(8);

imshow(I_seuil_propre,[]);
hold on ;



for ro_h=1:size(H_seuil,1)
   for theta_h=1:size(H_seuil,2)
       if(H_seuil(ro_h,theta_h)==1)
           %construire droite de paramètre (ro_h,theta_h) dans le plan xy
           x=1:272;
           vrai_theta=theta_h/100;
           figure(7);
           plot(x,((ro_h-Ro_max)-x*cos(vrai_theta))/sin(vrai_theta));%tracé de la droite
           axis([0 size(I,2) 0 size(I,1)]);
           figure(8);
           plot(x,((ro_h-Ro_max)-x*cos(vrai_theta))/sin(vrai_theta));%tracé de la droite
           axis([0 size(I,2) 0 size(I,1)]);
           
        end
    end
end
figure(7);
title('image d''origine avec les lignes reconstruites');
figure(8);
title('image du gradient avec les lignes reconstruites'); 

   
% figure(7);
% imshow(I_recons);
% 
% figure(8);
% plot(X,Y,'.');



% W=2;
% SE=strel('diamond',W);
% 
% W_o=10;
% SE_open=strel('square',W_o);
% 
% Im_open = I;
% Im_dilate=imdilate(Im_open,SE);
% Im_erode=imerode(Im_open,SE);
% Im_grad=Im_dilate-Im_erode;
% 
% figure(4);
% imshow(Im_grad);
