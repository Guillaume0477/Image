function Hsub = subsampling(H,r)
% H : matrice � d�cimer
% r : taux de sous-�chantillonnage (ie, on garde un point sur r)

Hsub = H(1:r:end,:);

end