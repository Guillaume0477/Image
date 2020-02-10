function D = matD_1D(n)
% n = length(x)

D = diag(-ones(n,1),0) + diag(ones(n-1,1),1);

end