clear all; close all;

d=0.5; %densite du bruit
N=7; %taille du voisinage du point à partir duquel on filtre

%On prépare l'image sous forme de matrice pouvant être affiché
A=imread('flower.png'); 
I=im2double(A); 
[h,w]=size(I); %On récupert les dimensions de la matrice de l'image

I_b=imnoise(I,'salt & pepper',d); %Ajout du bruit sel et poivre

I_b_med=ordfilt2(I_b,(N^2-1)/2+1,ones(N,N)); %Filtrage de l'image bruitée

figure(1)
subplot(131)
imshow(I)
title('image originale')
subplot(132)
imshow(I_b)
title('Image bruitée')
subplot(133)
imshow(I_b_med)
title('Image filtrée')