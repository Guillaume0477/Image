% débruitage
close all;
clear variables;


CoifQMF = MakeONFilter('Coiflet',3);

figure(1);
J = 8;
L = 5;
dirac=zeros(1,2^J);
dirac(200)=1;
transfo_inverse = IWT_PO(dirac,L,CoifQMF);
plot(transfo_inverse);
title('Transfo inverse d un dirac en 1D');


J_i=8;
L_i=3;
dirac2D = zeros(256,256);
dirac2D(100,:)=1;
dirac2D(:,100)=1;
transfo_inverse_2D = IWT2_PO(dirac2D,L_i,CoifQMF);
figure(2);
imshow(transfo_inverse_2D,[]);
title('Transfo inverse d un dirac en 2D');


figure(3);
I_entier=imread('cameraman.tiff');
I=double(I_entier);
imshow(I_entier,[]);
title('image originale');

transfo_img = FWT2_PO(I,L_i,CoifQMF);

figure(4);
for i=64:256
   for j=1:127
      
       transfo_img(i,j) = 0;
       transfo_img(j,i)=0;
       
   end
end

transfo_inv_img = IWT2_PO(transfo_img,L_i,CoifQMF);


transfo_img(127,127)=0;
imshow(uint8(transfo_img),[]);
title('transphormation de l image');



figure(5);
transfo_inv_img_int = uint8(transfo_inv_img);
imshow(transfo_inv_img_int,[]);
title('transphormation inverse de l image');

diff = I_entier - transfo_inv_img_int;






