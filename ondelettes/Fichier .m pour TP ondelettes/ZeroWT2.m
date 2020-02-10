function Wout = ZeroWT2(W,L,zeroind)

% Wout = ZeroWT2(W,L,zeroind)
% ZeroWT2 : mise a zero de certains quadrants de coef d'ondelette (ou d'approx) 
% W output matrix of a FTW-2d (e.g. FWT2_PO.m)\
% zeroind : Quadrant indices of zeroed coeffs
%   format zeroind : [approx_L det_vert_L det_horiz_L det_diag_L ...]
% Wout : output zeroed wavelet matrix

N = size(W,1) ;
J = log2(N) ;

switch nargin 
    case 1 
        L = 0 
        zeroind = ones(1,1+3*(J-L)) ;
    case 2
        zeroind = ones(1,1+3*(J-L)) ;
end        

x = 1:2^L ;
Wout = W(x,x).*zeroind(1); 

ind = 2 ;
for j = L:J-1
    x = [1:2^j]+2^j ; y = 1:2^j ;
    Wout(x,y) = W(x,y).*zeroind(ind) ; 
    ind = ind+1 ;
    x = [1:2^j] ; y = [1:2^j] + 2^j ;
    Wout(x,y) = W(x,y).*zeroind(ind) ; 
    ind = ind+1 ; ; 
    x = [1:2^j]+2^j ; y = [1:2^j] + 2^j ;
    Wout(x,y) = W(x,y).*zeroind(ind) ; 
    ind = ind+1 ; ; 
end