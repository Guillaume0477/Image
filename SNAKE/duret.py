



# coding=utf-8
import numpy as np
import cv2
import scipy.sparse as sc
from math import *
import matplotlib.pyplot as plt


#Parametre de l equation
alpha = 50#parametre qui resserre le cercle %50goutte
beta = 10 #parametre qui fait ressembler le snake a un cercle raideur #10goutte
gamma = 0.6#Parametre qui donne a quel point le snake se colle aux contours #0.6goutte

I = 3000 #Nombre d iteration #1000goutte

#coordonnees du centre du snake initial et rayon
centre_x = 112
centre_y = 125
r = 100
K = 1000 #Nombre de points du snake

#Import et affichage de l image de la goutte
img_goutte = cv2.imread('goutte.png',0)
height, width = img_goutte.shape

s=np.linspace(0, 1, K) #Echantillonnage du snake
teta = 2*pi*s #Parametre du cercle
#Initialisation des listes contenant les coordonnees des points du snake
x_snake = np.zeros((K, 1))
y_snake = np.zeros((K, 1))
for teta1 in range(len(teta)): #Calcul des coordonnees des points du snake
        x_snake.itemset(teta1, int(floor(r*cos(teta[teta1])+centre_x)))
        y_snake.itemset(teta1, int(floor(r*sin(teta[teta1])+centre_y)))

gradient_x = cv2.Sobel(img_goutte, cv2.CV_64F, 1, 0, ksize=3) #Creation du gradient en x de l image
gradient_y = cv2.Sobel(img_goutte, cv2.CV_64F, 0, 1, ksize=3) #Creation du gradient en y de l image

gradient_norme = np.zeros([height,width])  #initialisation du gradient en y de l image
for x in range(0, height): #On parcourt les lignes et les colonnes de la matrice
    for y in range(0, width):
        gradient_norme[x, y]=sqrt(gradient_x[x, y]**2+gradient_y[x, y]**2) #Et on calcule les valeurs

D2 = sc.diags([1, 1, -2, 1, 1], [-K+1, -1, 0, 1, K-1], shape = (K, K)).toarray() #Creation de la matrice de derivee seconde
D4 = sc.diags([-4, 1, 1, -4, 6, -4, 1, 1, -4], [-K+1, -K+2, -2, -1, 0, 1, 2, K-2, K-1], shape=(K, K)).toarray()  #Creation de la matrice de derivee quatrieme
D = alpha*D2-beta*D4  #Creation de la matrice D selon la formule
ID=sc.diags([1], [0], shape = (K, K)).toarray()
A = np.linalg.inv(ID-D)  #Creation de la matrice A selon la theorie

gradient_Eimage_x = cv2.Sobel(gradient_norme, cv2.CV_64F, 1, 0, ksize=3) #Creation du gradient en x de l energie de l image
gradient_Eimage_y = cv2.Sobel(gradient_norme, cv2.CV_64F, 0, 1, ksize=3) #Creation du gradient en y de l energie de l image

#!!! revoir la def de la normalisation du gradient !!!#
gradient_Eimage_x = gradient_Eimage_x/np.amax(gradient_Eimage_x) #normalisation
gradient_Eimage_y = gradient_Eimage_y/np.amax(gradient_Eimage_y)
gradxx = np.zeros((K,1))
gradyy = np.zeros((K,1))

plt.subplot(2, 2, 1)
Plotfig = plt.imshow(img_goutte, cmap='gray')
plt.title('Original'), plt.xticks([]), plt.yticks([])
plt.plot(x_snake, y_snake,  r )
plt.subplot(2, 2, 2), plt.imshow(gradient_norme, cmap='gray')
plt.title('Norme'), plt.xticks([]), plt.yticks([])
plt.subplot(2, 2, 3), plt.imshow(gradient_x, cmap='gray')
plt.title('Sobel X'), plt.xticks([]), plt.yticks([])
plt.subplot(2, 2, 4), plt.imshow(gradient_y, cmap='gray')
plt.title('Sobel Y'), plt.xticks([]), plt.yticks([])

plt.show()  # Affichage

#!!! rajout de l affichage dynamique !!!#
plt.ion()
plt.figure(2)
plt.imshow(img_goutte, cmap='gray')
for i in range (I):

    for k in range (K):
        gradxx[k, 0]=gamma*gradient_Eimage_x[int(y_snake[k]), int(x_snake[k])]
        gradyy[k, 0]=gamma*gradient_Eimage_y[int(y_snake[k]), int(x_snake[k])]
    x_snake = np.around(np.dot(A, x_snake+gradxx), decimals=0)
    y_snake = np.around(np.dot(A, y_snake+gradyy), decimals=0)

    # !!! affichaqe dynamique !!!#
    plt.clf()
    plt.imshow(img_goutte, cmap='gray')
    plt.plot(x_snake, y_snake, 'r')
    plt.pause(0.001)

    #plt.subplot(2, 2, 1), plt.imshow(img_goutte, cmap='gray')
    #plt.title('Original'), plt.xticks([]), plt.yticks([])
    #plt.plot(x_snake, y_snake, 'r')
    #plt.subplot(2, 2, 2), plt.imshow(gradient_norme, cmap='gray')
    #plt.title('Norme'), plt.xticks([]), plt.yticks([])
    #plt.subplot(2, 2, 3), plt.imshow(gradient_x, cmap='gray')
    #plt.title('Sobel X'), plt.xticks([]), plt.yticks([])
    #plt.subplot(2, 2, 4), plt.imshow(gradient_y, cmap='gray')
    #plt.title('Sobel Y'), plt.xticks([]), plt.yticks([])

    plt.show() #Affichage
plt.ioff()

plt.figure(3)
plt.subplot(2, 2, 1), plt.imshow(img_goutte, cmap='gray')
plt.title('Original'), plt.xticks([]), plt.yticks([])
plt.plot(x_snake, y_snake,  r )
plt.subplot(2, 2, 2), plt.imshow(gradient_norme, cmap='gray')
plt.title('Norme'), plt.xticks([]), plt.yticks([])
plt.subplot(2, 2, 3), plt.imshow(gradient_x, cmap='gray')
plt.title('Sobel X'), plt.xticks([]), plt.yticks([])
plt.subplot(2, 2, 4), plt.imshow(gradient_y, cmap='gray')
plt.title('Sobel Y'), plt.xticks([]), plt.yticks([])



plt.show()  # Affichage






























