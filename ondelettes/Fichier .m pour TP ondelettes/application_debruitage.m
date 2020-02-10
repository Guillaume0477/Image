% application au debruitage d'une image

%Lecture puis bruitage de l'image d'origine
Ingrid = ReadImage('Daubechies');
NoisyIngrid = Ingrid + 5*WhiteNoise(Ingrid);


% Transformation ondelettes
L_i = 3; %imposÃ© par l'Ã©noncÃ©
CoifQMF = MakeONFilter('Coiflet',3);
transfo_ingrid = FWT2_PO(NoisyIngrid,L_i,CoifQMF);


% seuillage de la transformation
seuil=10; %imposÃ© par l'Ã©noncÃ©
transfo_ingrid_seuil = zeros(256,256);
for i=1:256
   for j=1:256
      pixel=transfo_ingrid(i,j);
      if (pixel > 0) 
        transfo_ingrid_seuil(i,j) = max(0 ,transfo_ingrid(i,j)-seuil);
      else 
        transfo_ingrid_seuil(i,j) = min(0 ,transfo_ingrid(i,j)+seuil);
      end
   end
end

%reconstruction Ã  partir de l'image bruitÃ©e grÃ¢ce Ã  la transfo seuillÃ©e
reconstruct_seuil = IWT2_PO(transfo_ingrid_seuil,L_i,CoifQMF);
reconstruct = IWT2_PO(transfo_ingrid,L_i,CoifQMF);

% affichage
% figure(1);
% subplot(231);
% imshow(uint8(Ingrid),[]);
% title('image originale')
% subplot(232);
% imshow(uint8(NoisyIngrid),[]);
% title('image bruitée')
% subplot(233);
% imshow(uint8(transfo_ingrid),[]);
% title('transphormation image bruitée')
% subplot(234);
% imshow(uint8(transfo_ingrid_seuil),[]);
% title('transphormation image bruitée seillée')
% subplot(235);
% imshow(uint8(reconstruct),[]);
% title('transphormation image bruitée sans seuil')
% subplot(236);
% axis([110 160 110 160]); axis square;
% imshow(uint8(reconstruct_seuil),[]);
% title('transphormation image bruitée avec seuil')
% 
% 

% affichage
figure(1);
imshow(uint8(Ingrid),[]);
title('image originale')
figure(2);
imshow(uint8(NoisyIngrid),[]);
title('image bruitée')
figure(3);
imshow(uint8(transfo_ingrid),[]);
title('transphormation image bruitée')
figure(4);
imshow(uint8(transfo_ingrid_seuil),[]);
title('transphormation image bruitée seillée')
figure(5);
imshow(uint8(reconstruct),[]);
title('transphormation image bruitée sans seuil')
figure(6);
axis([110 160 110 160]); axis square;
imshow(uint8(reconstruct_seuil),[]);
title('transphormation image bruité e avec seuil')




% 
% 
% 
% CoifQMF = MakeONFilter('Coiflet',3);
% figure(1);
% subplot(231);
% J = 8;
% L = 5;
% dirac=zeros(1,2^J);
% dirac(17)=1;
% transfo_inverse = IWT_PO(dirac,L,CoifQMF);
% plot(transfo_inverse);
% title('Transfo inverse d un dirac en 1D');
% 
% 
% J_i=8;
% L_i=7;
% dirac2D = zeros(256,256);
% dirac2D(100,:)=1;
% dirac2D(:,100)=1;
% transfo_inverse_2D = IWT2_PO(dirac2D,L_i,CoifQMF);
% subplot(232);
% imshow(transfo_inverse_2D,[]);
% title('Transfo inverse d un dirac en 2D');
% 
% 
% subplot(233);
% I_entier=imread('cameraman.tiff');
% I=double(I_entier);
% imshow(I_entier,[]);
% title('image originale');
% 
% transfo_img = FWT2_PO(I,L_i,CoifQMF);
% 
% transfo_inv_img = IWT2_PO(transfo_img,L_i,CoifQMF);
% subplot(234);
% transfo_inv_img_int = uint8(transfo_inv_img);
% imshow(transfo_inv_img_int,[]);
% 
% diff = I_entier - transfo_inv_img_int;
% 
% 



