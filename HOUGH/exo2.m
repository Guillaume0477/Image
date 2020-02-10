


%% image 1

Image2 = rgb2gray(im2double(imread('braille1.png')));
figure(1)
imshow(Image2)
title('Image originale')
Struct1 = strel('disk',10);
TopHat = imtophat(Image2,Struct1);


figure(2)
imshow(TopHat,[])
title('Image tophat')


Seuil1 = imbinarize(TopHat,0.1);

figure(3)
imshow(Seuil1,[])
title('Image tophat seuillé')


%permet de detecter les cercle de rayans entre 1 et 10
Rmin = 1;
Rmax = 10;
[centersBright, radiiBright] = imfindcircles(Seuil1,[Rmin Rmax]);
viscircles(centersBright, radiiBright, 'Color', 'b','LineWidth',0.1);



%% image 2

Image3 = rgb2gray(im2double(imread('braille2.png')));

figure(4)
imshow(Image3)
title('Image originale')

Struct1 = strel('rectangle',[1,2]);
Dil1 = imdilate(Image3, Struct1);
figure(5)
imshow(Dil1)
title('Image dilaté')

Struct2 = strel('disk',2);
BottomHat = imbothat(Dil1,Struct2);
Seuil3 = imbinarize(BottomHat,0.05);
figure(6)
imshow(Seuil3,[])
title('Image botttomhat seuillé')

Struct3 = strel('disk',3);
Seuil3 = imclose(Seuil3, Struct3);
Seuil3 = imclose(Seuil3, Struct3);
Seuil3 = imclose(Seuil3, Struct3);
figure(7)
imshow(Seuil3,[])
title('fermeture Image Bottomhat seuillé ')

%permet de detecter les cercle de rayans entre 1 et 7
Rmin = 1;
Rmax = 7;
[centersBright, radiiBright] = imfindcircles(Seuil3,[Rmin Rmax]);
viscircles(centersBright, radiiBright, 'Color', 'b','LineWidth',0.1);





































