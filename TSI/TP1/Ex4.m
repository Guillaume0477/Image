clear all; close all;

m1=0.3; %Valeurs initiales pour le seuillage
m2=0.7;
limite=0.05; % Valeur limiant le nombre de réitérations de la mise à jour des seuils

%On prépare l'image sous forme de matrice pouvant être affiché
A=imread('flower.png'); 
I=im2double(A); 
[h,w]=size(I); %On récupert les dimensions de la matrice de l'image



labels=zeros(w,h); %On initialise la matrice des labels

labels=(abs(I-m2) > abs(I-m1))+2*(abs(I-m2) <= abs(I-m1)); %On place des 1 ou 2 selon si chaque pixel est d intensite plus proche de m1 ou m2

m1_old=m1; %On initialise les valeurs de la boucle
m2_old=m2;
m1_new=0;
m2_new=1;

while((m1_new-m1_old>limite) | (m2_new-m2_old>limite)) %On répète l'opération jusqu'à que les nouveaux seuils soient suffisament proche des derniers
    m1_old=m1_new; %Ces variables prennent les valeurs des derniers seuils
    m2_old=m2_new;
    m1_new=mean2(I(labels==1));  %Les noubeaux seuils prennent la valeur de la moyenne des intensités 
    m2_new=mean2(I(labels==2));  %des points de leur label respectif
end

I2=zeros(h,w); %On initialise la matrice de l'image seuillée
I2=(labels==1)*m1+(labels==2)*m2; %On associe à chaque pixel le seuil qui correspond à son label

figure(1)
subplot(121)
imshow(I)
title('image originale')
subplot(122)
imshow(I2)
title('image segmentée')


            