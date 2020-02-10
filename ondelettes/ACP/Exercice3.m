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

Y=zeros(n,m);
for i=1:m
    %Y(:,i)=reshape(I(:,:,i),[n,1]);
    A=I(:,:,i);
    Y(:,i)=A(:);
end

[n,m]=size(Y); %Nombres de donnees et de variables statistiques

X=zeros(n,m); %initialisation de la matrice des donnees centrees
moy=mean(Y); %Vecteur des moyennes de chaque colonne
for i = (1:m) %Calcul de la matrice des donnees centrees
    X(:,i)=Y(:,i)-moy(i);
end

M=1/n*(X'*X); %Calcul de la matrice de covariance
[V,D]=eig(M); %Diagonalisation de M

lambda=flipud(diag(D));  %Valeurs propres dans l'ordre décroissant
P=fliplr(V); %Rangement des vecteurs propres dans l'ordre des valeurs propres

figure(2)
plot(lambda,'b-*') %Affichage des valeurs propres
%axis equal

tau=zeros(1,m); %Initialisation du vecteur des taux d'inertie
for i=1:3 %Calcul des taux d'inertie
    tau(i)=lambda(i)/sum(lambda); 
end
Xstar=X*P;

Irec=reshape(Xstar(:,1),[H,W]);

figure(3)
plot(Xstar(:,1),Xstar(:,2),'bo');
axis equal
grid()

figure(4)
imshow(Irec,[])

figure(5)
imshow(I(:,:,1),[]);