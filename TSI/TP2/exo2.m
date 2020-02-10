clear variables;
close all;

%question 1
Im = imread ('pieces.png');
[h,w]=size(Im);

Im2 = im2double(Im);

figure(1);
%imshow(Im,[]);
title 'Image origine'

%question2
m1 = 50;
m2 = 180;

M1 = 0;
M2 = 0;

eps = 1;

while ((abs(M1-m1)>eps) ||  (abs(M2-m2)>eps))
	Labels = zeros(h,w);
	M1 = m1;
	M2 = m2;
	L1 = 0;
	L2 = 0;
	P1 = 0;
	P2 = 0;
	for i=1:h;
    	for j =1:w;
        	if (abs(M1 - 255*Im2(i,j)) < abs(M2-255*Im2(i,j)));
            	Labels(i,j) = 1;
            	L1 = L1 + Im2(i,j)*255;
            	P1 = P1 + 1;
        	else
            	Labels(i,j) = 2;
            	L2 = L2 + Im2(i,j)*255;
            	P2 = P2 +1;
        	end
    	end
	end
	m1 = L1/P1;
	m2 = L2/P2;
    
    
	M1 - m1;
	M2 - m2;
    
end


Labels = Labels-1;
figure(2);
%imshow(Labels, []);
title 'image segmenté en 2 regions'

%question 3
[HistIm,y]=imhist(Im2);
figure(3);
%bar(y,HistIm)
title 'histogrammme image origine'

%question 4
HistNorm=HistIm/(h*w);
figure(4);
%bar(y,HistNorm)
title 'histogrammme normalisé image origine'

%question 5
HistCum=zeros(1,256);
HistCum(1)=HistNorm(1);
for i = 2:256
	HistCum(i)=HistNorm(i)+HistCum(i-1);
end
figure(5);
%stairs(y,HistCum)
title 'histogrammme cumulé image origine'

%question 6
ImEga=HistCum(Im2.*255+1);
figure(6)
%imshow(ImEga,[])
title 'image égalisée'


%question 7
[HistEga,x]=imhist(ImEga);
figure(7)
%bar(x,HistEga)
title 'histogrammme image égalisée'

%question 8
HistNormEga=HistEga/(h*w);

figure(8);
HistCumEga=zeros(1,256);
HistCumEga(1)=HistNormEga(1);
for i = 2:256
	HistCumEga(i)=HistNormEga(i)+HistCumEga(i-1);
end
subplot(131)
%imshow(ImEga,[])
title('Image égalisée')
subplot(132)
%bar(x,HistNormEga,'b')
title('Histogramme normalisé')
subplot(133)
%stairs(x,HistCumEga,'b')
title('Histogramme cumulé')

%question 9
m1 = 150;
m2 = 180;

M1 = 0;
M2 = 0;

eps = 1;

while ((abs(M1-m1)>eps) ||  (abs(M2-m2)>eps))
	Labels2 = zeros(h,w);
	M1 = m1;
	M2 = m2;
	L1 = 0;
	L2 = 0;
	P1 = 0;

	P2 = 0;
	for i=1:h;
    	for j =1:w;
        	if (abs(M1 - 255*ImEga(i,j)) < abs(M2-255*ImEga(i,j)));
            	Labels2(i,j) = 1;
            	L1 = L1 + ImEga(i,j)*255;
            	P1 = P1 + 1;
        	else
            	Labels2(i,j) = 2;
            	L2 = L2 + ImEga(i,j)*255;
            	P2 = P2 +1;
        	end
    	end
	end
	m1 = L1/P1;
	m2 = L2/P2;
    
    
	M1 - m1;
	M2 - m2;
    
end


Labels2 = Labels2-1;
figure(9)
imshow(Labels2, []);
title 'image egalisée segmentée en 2 regions'




%question 1
SE= strel('disk',3);
SE2= strel('disk',2);
ImDilate= imdilate(Labels2,SE);
ImErode=imerode(ImDilate,SE);
figure(10);
imshow(ImDilate)
title 'image dilaté'
figure(11);
imshow(ImErode)
title 'image dilaté puis érodé'


%question 2
Marqu=zeros(h,w);
Marqu(1,:)=1;
Marqu(:,1)=1;
Marqu(h,:)=1;
Marqu(:,w)=1;

%question 3
Pieces_a_enlever=Marqu.*ImErode;
ImRe1=imreconstruct (Pieces_a_enlever,ImErode);
figure(12)
imshow(ImRe1)
title 'image des pièces à enlever'

figure(13)
Tuveuxpascreerunenouvelleimage =ImErode-ImRe1;
imshow(Tuveuxpascreerunenouvelleimage)
title 'image des pièces completes'

%question 4
bweuler(Tuveuxpascreerunenouvelleimage)

SE2 = [0,1,0;1,1,1;0,1,0];
rayon=1;
nb_pieces = zeros(1, floor(max(h, w)/2));
i = 1;
while ~(isequal(Tuveuxpascreerunenouvelleimage, zeros(h,w)))
	nb_pieces(i) = bweuler(Tuveuxpascreerunenouvelleimage);
	Tuveuxpascreerunenouvelleimage =imerode(Tuveuxpascreerunenouvelleimage,SE2);
	rayon=rayon+1;
	i = i+1;
end
figure;
tailles = nb_pieces(1:end-1)-nb_pieces(2:end);
bar(1:length(tailles), tailles);
title 'histogramme des rayons de l image'
