clear all;close all;

%%
%----------------------------------Image originale------------------------

%On prepare l'image sous forme de matrice pouvant être affichee
A=imread('flower.png'); 
I=im2double(A); 
[h,w]=size(I); %On recupert les dimensions de la matrice de l'image

lissage=[1,2,1]; %Vecteur de lissage
gradient=[-1,0,1]; %Vecteur du gradient

sob_x=lissage'*gradient; %Matrice de Sobel horizontale
sob_y=gradient'*lissage; %Matrice de Sobel verticale

Gh=imfilter(I,sob_x); %Approximation du gradient horizontal
Gv=imfilter(I,sob_y); %Approximation du gradient vertical
G=sqrt(Gv.^2+Gh.^2);  %Approximation du gradient

% figure(2)
% subplot(221)
% imshow(I)
% title('Image originale')
% subplot(222)
% imshow(imcomplement(Gh))
% title('Image passée par le filtre de sobel horizontal')
% subplot(223)
% imshow(imcomplement(Gv))
% title('Image passée par le filtre de sobel vertical')
% subplot(224)
% imshow(imcomplement(G))
% title('Image passée par le filtre de sobel')

%%
%----------------------------------Image bruitée---------------------------

M=0; %Moyenne du bruit gaussien
V=0.01; %Variance du bruit gaussien


I_b=imnoise(I,'gaussian',M,V);

Gh_b=imfilter(I_b,sob_x); %Approximation du gradient horizontal
Gv_b=imfilter(I_b,sob_y); %Approximation du gradient vertical
G_b=sqrt(Gv_b.^2+Gh_b.^2);  %Approximation du gradient

% figure(3)
% subplot(221)
% imshow(I_b)
% title('Image originale bruitée')
% subplot(222)
% imshow(imcomplement(Gh_b))
% title('Image bruitée passée par le filtre de sobel horizontal')
% subplot(223)
% imshow(imcomplement(Gv_b))
% title('Image bruitée passée par le filtre de sobel vertical')
% subplot(224)
% imshow(imcomplement(G_b))
% title('Image bruitée passée par le filtre de sobel')

%%
%---------------------------Gradient normalisé bruit-----------------------

d=2; %distance des points p1 et p2 par rapport à p
eps=0.5; %condition à partir de laquelle p est un point du contour
min=1; % Valeur minimale des coordonnées de p1 et p2
max=255; % Valeur maximale des coordonnées de p1 et p2

Gv_b_n=Gv_b./G_b; %On normalise le gradient vertical
Gh_b_n=Gh_b./G_b; %On normalise le gradient horizontal

M_p1_x=zeros(h,w); % Initialisation des matrices qui vont accueillir 
M_p2_x=zeros(h,w); % les coordonnées des points p1 et p2
M_p1_y=zeros(h,w);
M_p2_y=zeros(h,w);


[X,Y]=meshgrid(1:w,1:h); %X est la matrice des coordonnées horizontale de chaque point
                         %Y est la matrice des coordonnées verticale de chaque point
       
M_p1_x=ceil(X+d*Gh_b_n); %On détermine les coordonnées de p1 et p2 à partir
M_p2_x=ceil(X-d*Gh_b_n); %des coordonnées de p puis on va dans la direction
M_p1_y=ceil(Y+d*Gv_b_n); %du gradient à la distance chosie, dans un sens 
M_p2_y=ceil(Y-d*Gv_b_n); %puis dans l'autre

M_p1_x(M_p1_x<min)=min; %On décide que si la distance est trop grand et que
M_p1_y(M_p1_y<min)=min; %l'on sort de l'image, alors on prend la coordonnée 
M_p2_x(M_p2_x<min)=min; %minimale (1) et maximale (255) de l'image.
M_p2_y(M_p2_y<min)=min;
M_p1_x(M_p1_x>max)=max;
M_p1_y(M_p1_y>max)=max;
M_p2_x(M_p2_x>max)=max;
M_p2_y(M_p2_y>max)=max;


C=zeros(h,w); %Initialisation du tableau des contours

% On parcourt tous les points de l'image et s'ils répondent aux conditions
% G(p)-G(p1)<eps et G(p)-G(p2)<eps, alors ils prennent la valeur de leur
% gradient, sinon on les rend blanc.
for i=1:h 
    for j=1:w
        dif_p1=G_b(i,j)-G_b(M_p1_x(i,j),M_p1_y(i,j));
        dif_p2=G_b(i,j)-G_b(M_p2_x(i,j),M_p2_y(i,j));
        if (dif_p1 < eps) & (dif_p2 < eps)
            C(i,j)=G_b(i,j);
        else
            C(i,j)=1;
        end
    end
end
    
figure(4)
subplot(121)
imshow(I)
title('Image originale bruitée')
subplot(122)
imshow(imcomplement(C))
title('Image après filtrage')

%%
%---------------------------Gradient normalisé-----------------------------

d=2; %distance des points p1 et p2 par rapport à p
eps=0.5; %
min=1;
max=255;

G(G==0)=1*10^-16;%On ne peut pas diviser par 0 il faut donc une valeur minimale
Gv_n=Gv./G; %On normalise le gradient vertical
Gh_n=Gh./G; %On normalise le gradient horizontal

M_p1_x2=zeros(h,w); % Initialisation des matrices qui vont accueillir 
M_p2_x2=zeros(h,w); % les coordonnées des points p1 et p2
M_p1_y2=zeros(h,w);
M_p2_y2=zeros(h,w);


[X2,Y2]=meshgrid(1:w,1:h); %X est la matrice des coordonnées horizontale de chaque point
                           %Y est la matrice des coordonnées verticale de chaque point

                           
M_p1_x=ceil(X2+d*Gh_b_n); %On détermine les coordonnées de p1 et p2 à partir
M_p2_x=ceil(X2-d*Gh_b_n); %des coordonnées de p puis on va dans la direction
M_p1_y=ceil(Y2+d*Gv_b_n); %du gradient à la distance chosie, dans un sens 
M_p2_y=ceil(Y2-d*Gv_b_n); %puis dans l'autre

M_p1_x2(M_p1_x2<min)=min; %On décide que si la distance est trop grand et que
M_p1_y2(M_p1_y2<min)=min; %l'on sort de l'image, alors on prend la coordonnée
M_p2_x2(M_p2_x2<min)=min; %minimale (1) et maximale (255) de l'image.
M_p2_y2(M_p2_y2<min)=min;
M_p1_x2(M_p1_x2>max)=max;
M_p1_y2(M_p1_y2>max)=max;
M_p2_x2(M_p2_x2>max)=max;
M_p2_y2(M_p2_y2>max)=max;


C2=zeros(w,h); %Initialisation du tableau des contours

% On parcourt tous les points de l'image et s'ils répondent aux conditions
% G(p)-G(p1)<eps et G(p)-G(p2)<eps, alors ils prennent la valeur de leur
% gradient, sinon on les rend blanc. 
for i=1:h
    for j=1:w
        dif_p12=G(i,j)-G(M_p1_x2(i,j),M_p1_y2(i,j));
        dif_p22=G(i,j)-G(M_p2_x2(i,j),M_p2_y2(i,j));
        if (dif_p12 < eps) & (dif_p22 < eps)
            C2(i,j)=G(i,j);
        else
            C2(i,j)=1;
        end
    end
end
    
figure(5)
subplot(121)
imshow(I)
title('Image originale')
subplot(122)
imshow(imcomplement(C2))
title('Image après filtrage')



