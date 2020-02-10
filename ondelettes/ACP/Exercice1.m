clear all;close all;

P1=[2,-1,1]; %Points du nuage
P2=[-1,1,-1];
P3=[3,1,0];
P4=[-2,-4,1];
P5=[-2,3,-1];

Y=[P1;P2;P3;P4;P5]; %Creation de la matrice des donnees
xp=Y(:,1);
yp=Y(:,2);
zp=Y(:,3);

figure(1)
plot3(xp,yp,zp,'r*'); %Affichage du nuage de points
xlabel('x')
ylabel('y')
zlabel('z')
grid();

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
axis([0,4,0,7])

tau=zeros(1,m); %Initialisation du vecteur des taux d'inertie
for i=1:3 %Calcul des taux d'inertie
    tau(i)=lambda(i)/sum(lambda); 
end
disp(P)
Xstar=X*P;

figure(3)
plot(Xstar(:,1),Xstar(:,2),'bo');
axis([-8,10,-6,8])
grid()

n=P(:,3);
a=n(1);
b=n(2);
c=n(3);

figure(4)
hold on;
xx=min(Y(:,1)):0.1:max(Y(:,1));
yy=min(Y(:,2)):0.1:max(Y(:,2));
[x,y]=meshgrid(xx,yy);
z=-(a*x+b*y)/c;
surf(x,y,z)
plot3(xp,yp,zp,'r*'); %Affichage du nuage de points
xlabel('x')
ylabel('y')
zlabel('z')
grid();