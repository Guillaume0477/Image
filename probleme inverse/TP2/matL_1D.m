function L = matL_1D(n)
% n = length(x)

L  =  diag(   ones(n-1,1),-1) ... 
    + diag(-2*ones(n,1)  , 0)  ...   
    + diag(   ones(n-1,1), 1);

end