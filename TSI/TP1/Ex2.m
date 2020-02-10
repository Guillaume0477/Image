clear all; close all;

n=2; %parametres du filtre
fc=3;

%On prépare l'image sous forme de matrice pouvant être affiché
A=imread('ngc2175.png'); 
I=im2double(A); 
[h,w]=size(I); %On récupert les dimensions de la matrice de l'image

%On récupert les coordonnees des points en prenant le point central de
%l'image à (0,0)
[U,V] = meshgrid(-w/2+1/2:w/2-1/2,-h/2+1/2:h/2-1/2); 
D=sqrt(U.^2+V.^2); %Matrice de la norme des points
H=1./(1+(fc./D).^2*n); %Calcul de la matrice filtre
figure(1)
imshow(H)
title(['représentation en 2D du filtre de butterworth pour d=',num2str(n),' et pour fc=',num2str(fc)])

I_Four=fft2(I); %Transformee de Fourier de l'image
I_Four=fftshift(I_Four); %Pour que la frequence nulle soit au centre de l'image

I_filt_Four=I_Four.*H; %Filtrage de l'image

I_filt_Four=ifftshift(I_filt_Four); %On remet les frequences dans l'ordre original
I_filt=ifft2(I_filt_Four); %On repasse l'image dans le domaine temporel

figure(2)
subplot(121)
imshow(I)
title('Image originale')
subplot(122)
imshow(I_filt)
title('Image filtrée par le filtre de Butterworth')

