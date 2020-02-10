# coding=utf-8
import numpy as np
import cv2
import scipy.sparse as sc
from math import *
import matplotlib.pyplot as plt

#Parametre de l'equation
alpha=1 #parametre qui resserre le cercle
beta=1 #parametre qui fait ressembler le snake à un cercle raideur
gamma=1 #Parametre qui donne à quel point le snake se colle aux contours

T=100 #Nombre d'iteration

#coordonnees du centre du snake initial et rayon
centre_x=112
centre_y=125
r=80
K=100 #Nombre de points du snake

#Import et affichage de l'image de la goutte
img_goutte=cv2.imread('goutte.png',0)
height, width = img_goutte.shape
print(height,width)
print(img_goutte)

s=np.linspace(0,1,K) #Echantillonnage du snake
teta=2*pi*s #Paramètre du cercle
#Initialisation des listes contenant les coordonnées des points du snake
x_snake=[]
y_snake=[]
for teta1 in teta: #Calcul des coordonnées des points du snake
    x_snake.append(r*cos(teta1)+centre_x)
    y_snake.append(r*sin(teta1)+centre_y)

gradient_x=cv2.Sobel(img_goutte,cv2.CV_64F,1,0,ksize=3) #Création du gradient en x de l'image
gradient_y=cv2.Sobel(img_goutte,cv2.CV_64F,0,1,ksize=3) #Création du gradient en y de l'image

gradient_norme=np.zeros([height,width])  #initialisation du gradient en y de l'image
for x in range(0,height): #On parcourt les lignes et les colonnes de la matrice
    for y in range(0,width):
        gradient_norme[x,y]=sqrt(gradient_x[x,y]**2+gradient_y[x,y]**2) #Et on calcule les valeurs

D2=sc.diags([1,1,-2,1,1],[-K+1,-1,0,1,K-1], shape = (K,K)).todense() #Création de la matrice de dérivée seconde
D4=sc.diags([-4,1,1,-4,6,-4,1,1,-4],[-K+1,-K+2,-2,-1,0,1,2,K-2,K-1],shape = (K,K)).todense()  #Création de la matrice de dérivée quatrième
D=alpha*D2-beta*D4  #Création de la matrice D selon la formule
A=np.linalg.inv(np.eye(K,K)-D)  #Création de la matrice A selon la théorie

for t in range(T):
    x_snake=np.dot(A,x_snake-gamma*gradient_x[y_snake.astype(int),x_snake.astype(int)])
    y_snake=np.dot(A,y_snake-gamma*gradient_y[y_snake.astype(int),x_snake.astype(int)])

plt.subplot(2,2,1),plt.imshow(img_goutte,cmap = 'gray')
plt.title('Original'), plt.xticks([]), plt.yticks([])
plt.subplot(2,2,2),plt.imshow(gradient_norme,cmap = 'gray')
plt.title('Norme'), plt.xticks([]), plt.yticks([])
plt.plot(x_snake,y_snake,'black') #Affichage du cercle
plt.subplot(2,2,3),plt.imshow(gradient_x,cmap = 'gray')
plt.title('Sobel X'), plt.xticks([]), plt.yticks([])
plt.subplot(2,2,4),plt.imshow(gradient_y,cmap = 'gray')
plt.title('Sobel Y'), plt.xticks([]), plt.yticks([])

plt.show() #Affichage


