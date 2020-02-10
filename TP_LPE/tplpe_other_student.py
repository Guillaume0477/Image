"author Pallas leo & Abrial julie"
import numpy as np
import scipy.sparse
import matplotlib.pyplot as plt

import cv2

#telechargement de l'image
image = cv2.imread('Image.png', 0)

#seuillage
ret,thresh2= cv2.threshold(image,0,255,cv2.THRESH_BINARY_INV)

plt.imshow(thresh2,'gray')
#plt.show()
#carte des distance
distance = cv2.distanceTransform(thresh2,cv2.DIST_L2,3)
#mise au noir du fond
for i in range(0, len(thresh2)):
    for j in range (0, len(thresh2[1])):
        if thresh2[i,j] >= 100:
            thresh2[i,j] = thresh2[i,j]-16*distance[i,j]
        else:
            thresh2[i,j]=0

plt.imshow(thresh2,'gray')
plt.show()



#seuillage adaptatif

thresh3= cv2.adaptiveThreshold((np.max(distance)-distance).astype(np.uint8),255,cv2.ADAPTIVE_THRESH_MEAN_C,cv2.THRESH_BINARY_INV,35,2)
plt.imshow(thresh3,'gray')
#plt.show()

#ouverture par erotion puis dilatation pour obtenir marqueur grains

kernel = np.ones((4,4),np.uint8)
ouverture = cv2.morphologyEx(thresh3, cv2.MORPH_OPEN, kernel)


plt.imshow(ouverture,'gray')
#plt.show()

#seuillage puis erosion pour obtenir marqueur fond
kernel1 = np.ones((3,3),np.uint8)
ret2,thresh4 = cv2.threshold(image,10,255,cv2.THRESH_BINARY_INV)
thresh4=255-thresh4
erosion = cv2.erode(thresh4,kernel1,iterations = 1)

plt.imshow(erosion,'gray')
#plt.show()

#fusion des deux marqueurs
ret, marqueur = cv2.connectedComponents(ouverture)

unknown = cv2.subtract(erosion,ouverture)


marqueur[unknown==255] = np.max(marqueur) + 1

plt.imshow(marqueur,'jet')
plt.show()

#initialisation de la FAH
FAH_x = []
FAH_y = []
for i in range(0,256):
    FAH_x.append([])
    FAH_y.append([])


for i in range(0, len(marqueur)):
    for j in range (0, len(marqueur[1])):
        if marqueur[i,j]!=0:
            FAH_x[thresh2[i,j]].append(i)
            FAH_y[thresh2[i,j]].append(j)



vide=0
com=0
plt.ion()
while vide != 1:
    for i in range(0,256):
        if len(FAH_x[i])!=0:
            x=FAH_x[i][0]
            y=FAH_y[i][0]
            del FAH_x[i][0]
            del FAH_y[i][0]
            for k in range(-1,2):
                for l in range(-1,2):
                    if x+k<len(thresh2[1]) and x+k>=0 and y+l<len(thresh2) and y+l>=0:
                        if marqueur[x+k,y+l]==0:
                            marqueur[x+k,y+l]=marqueur[x,y]
                            FAH_x[thresh2[x+k, y+l]].append(x+k)
                            FAH_y[thresh2[x+k, y+l]].append(y+l)
                            com+=1
                            if com%500==0:
                                plt.imshow(marqueur, 'jet')
                                plt.show()
                                plt.pause(0.001)

            break
    vide=1
    for i in range (0,256):
        if len(FAH_x[i])!=0:
            vide=0
plt.ioff()
plt.imshow(marqueur,'jet')
plt.show()
print "Nombre de grains de cafe: "
print (np.max(marqueur)-1) #On retranche 1 car le marqueur 1 correspond au fond et non a un grain de cafe