
clear variables;
close all;

% fichiers images
tab_images={'i1.tif','i2.tif','i3.tif','i4.tif','i5.tif','i6.tif'};
m=length(tab_images);

% taille des image
tmp=imread(char(tab_images(1)));
[H,W]=size(tmp);

% matrice de m images
I=zeros(H,W,m);

% affichage des images satellitaires
for k=1:m
    I(:,:,k)=im2double(imread(char(tab_images(k))));
    subplot(2,3,k);
    imshow(I(:,:,k));
end

% matrice des donnees
% rearrangement dans une matrice de n=H*W lignes et 6 colonnes
n=H*W;