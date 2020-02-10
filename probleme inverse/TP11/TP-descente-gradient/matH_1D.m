function H = matH_1D(n,supp,type,std)
% n     = length(x)
% type  : 'none', 'gaussian' ou 'uniform'
% std   : ecart type
% supp  : taille du masque

H  = [];
sh = (supp+1)/2;
        
switch type
    case 'gaussian'
        h  = [fspecial('gaussian',[supp,1],std)', zeros(1,n-supp)];
        
        for k = 1:n
            H = [H; circshift(h,[0,k-sh])];
        end
        H = H/sum(h);
        
    case 'uniform'
        h  = [ones(1,supp), zeros(1,n-supp)];
        
        for k = 1:n
            H = [H; circshift(h,[0,k-sh])];
        end
        H = H/sum(h);
        
    case  'none'
        H = eye(n);
end
end