function Hsub = subsampling(H,r)
% H : matrice à décimer
% r : taux de sous-échantillonnage (ie, on garde un point sur r)

Hsub = H(1:r:end,:);

end