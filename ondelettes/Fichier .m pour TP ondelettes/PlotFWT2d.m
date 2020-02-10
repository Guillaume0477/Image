function PlotFWT2d(W,L,couleur)

N = size(W,1) ;
J = log2(N) ;

switch nargin
    case 1
        L = 0 ;
        couleur = 'w' ;
    case 2
        couleur = 'w' ;
end

Wsc = [] ;

clf
x = 1:2^L ;
minloc = min(min(W(x,x))) ;
maxloc = max(max(W(x,x))) ;
Wsc = (W(x,x)-minloc)./(maxloc-minloc) ; 

for j = L:J-1
    x = [1:2^j]+2^j ; y = 1:2^j ;
    minloc = min(min(W(x,y))) ;
    maxloc = max(max(W(x,y))) ;
    Wsc(x,y) = (W(x,y)-minloc)./(maxloc-minloc) ; 
    x = [1:2^j] ; y = [1:2^j] + 2^j ;
    minloc = min(min(W(x,y))) ;
    maxloc = max(max(W(x,y))) ;
    Wsc(x,y) = (W(x,y)-minloc)./(maxloc-minloc) ; 
    x = [1:2^j]+2^j ; y = [1:2^j] + 2^j ;
    minloc = min(min(W(x,y))) ;
    maxloc = max(max(W(x,y))) ;
    Wsc(x,y) = (W(x,y)-minloc)./(maxloc-minloc) ; 
end

imagesc(Wsc) ;
axis square
hold on
for j=J:-1:L+1
    eval(['plot([1 2^j],[2^(j-1) 2^(j-1)],''',couleur,''',''linewidth'',4)'])
    eval(['plot([2^(j-1) 2^(j-1)],[1 2^j],''',couleur,''',''linewidth'',4)'])
end 
eval(['plot([1 2^(J) 2^(J) 1 1],[1 1 2^J 2^J 1],''',couleur,''',''linewidth'',4)'])
axis off