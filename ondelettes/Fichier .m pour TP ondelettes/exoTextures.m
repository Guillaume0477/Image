%exoTextures
close all; clear variables;
Texture1 = im2double(imread('Texture1.png'));
Texture2 = im2double(imread('Texture2.png'));
Texture3 = im2double(imread('Texture3.png'));
Texture4 = im2double(imread('Texture4.png'));
Texture5 = im2double(imread('Texture5.png'));
Texture6 = im2double(imread('Texture6.png'));
Texture7 = im2double(imread('Texture7.png'));

Image1 = im2double(imread('Image1.png'));
Image2 = im2double(imread('Image2.png'));

% déclaration des paramètres des ondelettes
alpha=pi;
dtheta=pi/4;
dx=2/64;
[X,Y]=meshgrid(-1:dx:+1);

% vect contient la valeur de la norme au carré du résultat de conv2(), pour un jeu de paramètres donné.
vect=zeros(9,1); 

% matrice_caract contient les 16 vecteurs vect concaténés (car on utilise
% 16 paramètre différents)
matrice_caract=zeros(9,16);
loop_count=0;
for l=0:3
   for j = -4:-1
       loop_count=loop_count+1;
       scal=1/(2^j);
       alpha=l*dtheta;
       T=exp((-1/2)*(X.^2+Y.^2));
       psi = scal*(scal*X*cos(alpha)+scal*Y*sin(alpha)).*T;
       
       
       vect(1)= norm(conv2(Texture1,psi)).^2;
       vect(2)= norm(conv2(Texture2,psi)).^2;
       vect(3)= norm(conv2(Texture3,psi)).^2;
       vect(4)= norm(conv2(Texture4,psi)).^2;
       vect(5)= norm(conv2(Texture5,psi)).^2;
       vect(6)= norm(conv2(Texture6,psi)).^2;
       vect(7)= norm(conv2(Texture7,psi)).^2;
       vect(8)= norm(conv2(Image1,psi)).^2;
       vect(9)= norm(conv2(Image2,psi)).^2;
       matrice_caract(:,loop_count) = vect;
       
   end
end

% on fabrique deux matrices : une matrice des vecteurs correspondant à
% chaque texture mais centrée sur la texture de l'image 1, et l'autre 
% centrée sur la texture de l'image 2.
matrice_caract_diff1 = zeros(7,16);
matrice_caract_diff2 = zeros(7,16);
for texture=1:7
    for coord=1:16
        matrice_caract_diff1(texture,coord) = matrice_caract(texture,coord) - matrice_caract(8,coord);
        matrice_caract_diff2(texture,coord) = matrice_caract(texture,coord) - matrice_caract(9,coord);
    end
end

% il suffit alors de calculer la distance à l'origine de chaque vecteur
% (grâce à la fonction norm() et de stocker ces normes dans deux tableaux
% différents, un pour l'image 1, l'autre pour l'image 2.
dist_image1=zeros(7,1);
dist_image2=zeros(7,1);
for texture=1:7
    dist_image1(texture) = norm(matrice_caract_diff1(texture,:)); 
    dist_image2(texture) = norm(matrice_caract_diff2(texture,:)); 
end


% On cherche puis on affiche l'indice du vecteur le plus proche de
% l'origine pour chaque image.
min1 = find(dist_image1==min(dist_image1));
min2 = find(dist_image2==min(dist_image2));

disp(min1);
disp(min2);