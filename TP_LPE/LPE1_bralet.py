import cv2 as cv2
from math import *
import matplotlib.pyplot as mp
import scipy.sparse as sc
import numpy as np

Cafe = cv2.imread("Image.png",0)

mp.subplot(331)
mp.imshow(Cafe, cmap="gray")
mp.title("Image initiale")

#Parametre initiaux
seuil = 30
seuilMarq = 100

##Determination des marqueurs
#Seuillage

nombre,CafeSeuil = cv2.threshold(Cafe, seuil, 1, cv2.THRESH_BINARY_INV)

mp.subplot(332)
mp.imshow(CafeSeuil, cmap="gray")
mp.title("Image seuillee")


CafeSeuil = CafeSeuil.astype(np.uint8)

CafeDist = cv2.distanceTransform(CafeSeuil,cv2.DIST_L1,3)

CafeDist = CafeDist.astype(np.uint8)*14

CafeDistOK = cv2.multiply(255-CafeDist,CafeSeuil)

mp.subplot(333)
mp.imshow(CafeDistOK, cmap="gray")
mp.title("Carte de distances")

Marqueurs = cv2.adaptiveThreshold(255-CafeDist,1,cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY_INV,25,30)

mp.subplot(334)

mp.imshow(Marqueurs, cmap="gray")
mp.title("Obtention des marqueurs par seuillage adaptatif")

Ouverture = cv2.morphologyEx(Marqueurs,cv2.MORPH_OPEN,cv2.getStructuringElement(cv2.MORPH_RECT,(4,4)))
mp.subplot(335)
mp.imshow(Ouverture, cmap="gray")
mp.title("Ouverture de l'image precedente")

nombre,Marqs = cv2.connectedComponents(Ouverture)
mp.subplot(336)
mp.imshow(Marqs, cmap="jet")
mp.title("Attribution des labels")

nombre,FondSeuil = cv2.threshold(Cafe, seuil, 1, cv2.THRESH_BINARY)
mp.subplot(337)
mp.imshow(FondSeuil, cmap="gray")
mp.title("Obtention des marqueurs de fond")

Erode = cv2.erode(FondSeuil,cv2.getStructuringElement(cv2.MORPH_RECT,(3,3)))
mp.subplot(338)
mp.imshow(Erode, cmap="gray")
mp.title("Erosion de l'image precedente")

maxi = Marqs.max()+1
MarqFond = Erode*maxi
MarqFin = MarqFond + Marqs
mp.subplot(339)
mp.imshow(MarqFin, cmap="jet")
mp.title("Ensemble des labels")

FAH_x = [[] for k in range(256)]
FAH_y = [[] for k in range(256)]

mp.show()


def regarde_sans_label(x,y):
    ret = False
    if MarqFin[y,x] == 0:
        ret = True
    return ret

def change_label(x,y,label):
    MarqFin[y,x] = label

def ajoute_FAH(x,y,teintemil):
    teinte = CafeDistOK[y,x]
    if teinte >= teintemil :	 #Cas ou la teinte du pixel central est plus noire que les pixels latéraux
        FAH_x[teinte].append(x)
        FAH_y[teinte].append(y)
    else :		    	#Si le pixel central est plus noir que le pixel central alors il doit etre traite en priorite
        FAH_x[teintemil].append(x)
        FAH_y[teintemil].append(y)

def trame(x,y,label,teinte):
    if regarde_sans_label(x,y):
       labelFond = MarqFin.max()
       if label == labelFond:   #Si le pixel central est dans le fond
            if CafeDistOK[y,x] == teinte: #Si le pixel a classer est dans le fond  
                change_label(x,y,label)
                ajoute_FAH(x,y,teinte)
       else:
            change_label(x,y,label)
            ajoute_FAH(x,y,teinte)
       

print(len(Cafe))
print(len(Cafe[0]))
mp.ion() #Turn interactive mode on
fig = mp.figure(2) 
plotFig = mp.imshow(MarqFin, "jet") #img is the image to display
def go():
    for k in range(len(Cafe)):
        for l in range(len(Cafe[0])):
            pixel = MarqFin[k, l]
            if pixel != 0:
                teinte = CafeDistOK[k, l]
                FAH_x[teinte].append(l)
                FAH_y[teinte].append(k)

    for indice in range(256):
        while len(FAH_x[indice]) != 0 :
            x = FAH_x[indice].pop()
            y = FAH_y[indice].pop()
            if x == len(Cafe[0])-1:
                trame(x-1,y,MarqFin[y,x],CafeDistOK[y,x])
                if y == len(Cafe)-1:
                    trame(x,y-1,MarqFin[y,x],CafeDistOK[y,x])
                elif y == 0:
                    trame(x,y+1,MarqFin[y,x],CafeDistOK[y,x])
                else:
                    trame(x,y+1,MarqFin[y,x],CafeDistOK[y,x])
                    trame(x,y-1,MarqFin[y,x],CafeDistOK[y,x])
            elif x == 0:
                trame(x+1, y, MarqFin[y, x], CafeDistOK[y, x])
                if y == len(Cafe)-1:
                    trame(x, y - 1,MarqFin[y,x],CafeDistOK[y,x])
                elif y == 0:
                    trame(x, y + 1,MarqFin[y,x],CafeDistOK[y,x])
                else:
                    trame(x, y + 1,MarqFin[y,x],CafeDistOK[y,x])
                    trame(x, y - 1,MarqFin[y,x],CafeDistOK[y,x])
            else:
                trame(x-1,y,MarqFin[y,x],CafeDistOK[y,x])
                trame(x + 1, y, MarqFin[y, x], CafeDistOK[y, x])
                if y == len(Cafe)-1:
                    trame(x, y - 1, MarqFin[y, x], CafeDistOK[y, x])
                elif y == 0:
                    trame(x, y + 1, MarqFin[y, x], CafeDistOK[y, x])
                else:
                    trame(x, y + 1, MarqFin[y, x], CafeDistOK[y, x])
                    trame(x, y - 1, MarqFin[y, x], CafeDistOK[y, x]) 
        plotFig.set_data(MarqFin)
        mp.show()
        mp.pause(0.001)

#while MarqFin.min() == 0:
go()
mp.ioff()

LPE = [[0 for k in range(len(Cafe[0]))] for l in range(len(Cafe))]
LPE = np.asarray(LPE)
for x in range(len(LPE[0])-1) :
	for y in range(len(LPE)-1):
		if MarqFin[y,x] != MarqFin[y+1,x] :
			LPE[y,x] = 255 - Cafe[y,x]
			LPE[y+1,x] = 255 - Cafe[y+1,x]
		
		if MarqFin[y,x] != MarqFin[y,x+1] :
			LPE[y,x] = 255 - Cafe[y,x]
			LPE[y,x+1] = 255 - Cafe[y,x+1]

mp.figure(3)
mp.imshow(LPE)
mp.show()

mp.figure(4)
mp.imshow(Cafe+LPE,"gray")
mp.show()

		












