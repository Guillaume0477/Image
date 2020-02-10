import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt

plt.clf()

#Variables
Seuil=20

#Import de l'image
img_grains = cv.imread('Image.png',cv.CV_8UC1)

#Seuillage
ret,img_seuil=cv.threshold(img_grains,Seuil,1,cv.THRESH_BINARY_INV)

#Carte des distances
img_distance=cv.distanceTransform(img_seuil,cv.DIST_L2, cv.DIST_MASK_PRECISE) #Calcul de la carte des distances
img_distance_inv=(np.amax(img_distance)-img_distance) #Inversion de la carte des distances
img_distance_final=cv.multiply(img_distance_inv.astype(np.uint8),img_seuil)

#Obtention des marqueurs des grains deimg_grains
img_dist_seuil_adapt=cv.adaptiveThreshold(img_distance_inv.astype(np.uint8),np.amax(img_distance_final),cv.ADAPTIVE_THRESH_GAUSSIAN_C,cv.THRESH_BINARY_INV,19,2)
kernel_open = np.ones((2,2),np.uint8)
img_dist_open=cv.morphologyEx(img_dist_seuil_adapt,cv.MORPH_OPEN,kernel_open)
kernel_dilate = np.ones((3,3),np.uint8)
img_dist_open=cv.dilate(img_dist_open,kernel_dilate,10)

#Obtention des marqueurs du fond
kernel_erode = np.ones((3,3),np.uint8)
ret,img_seuil_inv=cv.threshold(img_grains,Seuil,255,cv.THRESH_BINARY)
img_marq_fond=cv.erode(img_seuil_inv,kernel_erode,15)

#attribution des labels des grains
ret, labels_grains = cv.connectedComponents(img_dist_open)
#labels_grains=labels_grains+10

#Fusion avec le fond
img_final=labels_grains+((img_marq_fond/255)*(np.amax(labels_grains)+1))


#Affichage
plt.figure(1)
plt.subplot(2,2,1),plt.imshow(img_grains,cmap = 'gray')
plt.title('Original'), plt.xticks([]), plt.yticks([])
plt.subplot(2,2,2),plt.imshow(img_seuil,cmap = 'gray')
plt.title('Seuillee'), plt.xticks([]), plt.yticks([])
plt.subplot(2,2,3),plt.imshow(img_distance_inv,cmap = 'gray')
plt.title('Distance'), plt.xticks([]), plt.yticks([])
plt.subplot(2,2,4),plt.imshow(img_distance_final,cmap = 'gray')
plt.title('Distance_final'), plt.xticks([]), plt.yticks([])

plt.figure(2)
plt.subplot(2,3,1),plt.imshow(img_dist_seuil_adapt,cmap = 'gray')
plt.title('Seuillage adaptatif'), plt.xticks([]), plt.yticks([])
plt.subplot(2,3,2),plt.imshow(img_dist_open,cmap = 'gray')
plt.title('Ouverture'), plt.xticks([]), plt.yticks([])
plt.subplot(2,3,3),plt.imshow(img_marq_fond,cmap = 'gray')
plt.title('Obtention des marqueurs de fond'), plt.xticks([]), plt.yticks([])
plt.subplot(2,3,4),plt.imshow(labels_grains)
plt.title('Marqueurs fusionnes'), plt.xticks([]), plt.yticks([])
plt.subplot(2,3,5),plt.imshow(img_final,'jet')
plt.title('Marqueurs labelisé'), plt.xticks([]), plt.yticks([])


#plt.figure(3)
#plt.subplot(2,2,1),plt.imshow(img_dist_seuil_adapt,cmap = 'gray')
#plt.title('Seuillage adaptatif'), plt.xticks([]), plt.yticks([])



plt.show()


#initialisation de la FAH
FAH_x = []
FAH_y = []
for i in range(0,256):
    FAH_x.append([])
    FAH_y.append([])


for i in range(0, len(img_final)):
    for j in range (0, len(img_final[1])):
        if img_final[i,j]!=0:
            FAH_x[img_distance_final[i,j]].append(i)
            FAH_y[img_distance_final[i,j]].append(j)



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
                    if x+k<len(img_distance_final[1]) and x+k>=0 and y+l<len(img_distance_final) and y+l>=0:
                        if img_final[x+k,y+l]==0:
                            img_final[x+k,y+l]=img_final[x,y]
                            FAH_x[img_distance_final[x+k, y+l]].append(x+k)
                            FAH_y[img_distance_final[x+k, y+l]].append(y+l)
                            com+=1
                            if com%500==0:
                                plt.imshow(img_final, 'jet')
                                plt.show()
                                plt.pause(0.00001)

            break
    vide=1
    for i in range (0,256):
        if len(FAH_x[i])!=0:
            vide=0
plt.ioff()
plt.imshow(img_final,'jet')
plt.show()
print ("Nombre de grains de cafe: ")
print (np.max(img_final)-1) #On retranche 1 car le marqueur 1 correspond au fond et non a un grain de cafe


# def ajoute_FAH(x, y, teintemil):
#     teinte = img_distance_final[y, x]
#     if teinte >= teintemil:  # Cas ou la teinte du pixel central est plus noire que les pixels latéraux
#         FAH_x[teinte].append(x)
#         FAH_y[teinte].append(y)
#     else:  # Si le pixel central est plus noir que le pixel central alors il doit etre traite en priorite
#         FAH_x[teintemil].append(x)
#         FAH_y[teintemil].append(y)
#
#
# def modification(x, y, label, teinte):
#     if img_final[y, x] == 0: # si sans label
#         labelFond = img_final.max()
#         if label == labelFond:  # Si le pixel central est dans le fond
#             if img_distance_final[y, x] == teinte:  # Si le pixel a classer est dans le fond
#                 img_final[y, x] = label
#                 ajoute_FAH(x, y, teinte)
#         else:
#             img_final[y, x] = label
#             ajoute_FAH(x, y, teinte)
#
#
# plt.ion()  # Turn interactive mode on
# fig = plt.figure(3)
# plotFig = plt.imshow(img_final, "jet")  # img is the image to display
#
#
#
# for k in range(len(img_grains)):
#     for l in range(len(img_grains[0])):
#         pixel = img_final[k, l]
#         if pixel != 0:
#             teinte = img_distance_final[k, l]
#             FAH_x[teinte].append(l)
#             FAH_y[teinte].append(k)
#
# for indice in range(256):
#     while len(FAH_x[indice]) != 0:
#         x = FAH_x[indice].pop() #abscisse du point
#         y = FAH_y[indice].pop()
#         # on distingue tout les cas des positions de l'image
#         if x == len(img_grains[0]) - 1:
#             modification(x - 1, y, img_final[y, x], img_distance_final[y, x])
#             if y == len(img_grains) - 1:
#                 modification(x, y - 1, img_final[y, x], img_distance_final[y, x])
#             elif y == 0:
#                 modification(x, y + 1, img_final[y, x], img_distance_final[y, x])
#             else:
#                 modification(x, y + 1, img_final[y, x], img_distance_final[y, x])
#                 modification(x, y - 1, img_final[y, x], img_distance_final[y, x])
#         elif x == 0:
#             modification(x + 1, y, img_final[y, x], img_distance_final[y, x])
#             if y == len(img_grains) - 1:
#                 modification(x, y - 1, img_final[y, x], img_distance_final[y, x])
#             elif y == 0:
#                 modification(x, y + 1, img_final[y, x], img_distance_final[y, x])
#             else:
#                 modification(x, y + 1, img_final[y, x], img_distance_final[y, x])
#                 modification(x, y - 1, img_final[y, x], img_distance_final[y, x])
#         else:
#             modification(x - 1, y, img_final[y, x], img_distance_final[y, x])
#             modification(x + 1, y, img_final[y, x], img_distance_final[y, x])
#             if y == len(img_grains) - 1:
#                 modification(x, y - 1, img_final[y, x], img_distance_final[y, x])
#             elif y == 0:
#                 modification(x, y + 1, img_final[y, x], img_distance_final[y, x])
#             else:
#                 modification(x, y + 1, img_final[y, x], img_distance_final[y, x])
#                 modification(x, y - 1, img_final[y, x], img_distance_final[y, x])
#     plotFig.set_data(img_final)
#     plt.show()
#     plt.pause(0.001)
#
#
# # while img_final.min() == 0:
#
# plt.ioff()

Contours = [[0 for k in range(len(img_grains[0]))] for l in range(len(img_grains))]
Contours = np.asarray(Contours)
for x in range(len(Contours[0]) - 1):
    for y in range(len(Contours) - 1):
        if img_final[y, x] != img_final[y + 1, x]:
            Contours[y, x] = 255 - img_grains[y, x]
            Contours[y + 1, x] = 255 - img_grains[y + 1, x]

        if img_final[y, x] != img_final[y, x + 1]:
            Contours[y, x] = 255 - img_grains[y, x]
            Contours[y, x + 1] = 255 - img_grains[y, x + 1]

plt.figure(4)
plt.imshow(Contours)
plt.show()

plt.figure(5)
plt.imshow(img_grains + Contours, 'jet')
plt.show()


