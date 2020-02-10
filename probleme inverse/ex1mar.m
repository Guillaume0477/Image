clear all
close all
clc

%% Forward-Backward algorithm
% Solves LASSO/TV model
%       argmin  f(x) + lam.R(Dx)
%          x
%
% where . f(x) = ||x-z||_2^2 / 2
%       . R(x) = ||x||_1        
%         where D models a diff. operator
%            (e.g. D = grad => Dadj = -div)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       


%% Initialisation
% diff operators
operator = 'laplacian';  % 'gradient' / 'laplacian' / 'identity'
switch operator
    case 'identity',  D    = @(x) x;
                      Dadj = @(x) x;
    
    case 'gradient',  D    = @(x) ( [x(:,2:end) - x(:,1:end-1) , zeros(size(x,1),1)] );
                      Dadj = @(x) (-[x(:,1) , x(:,2:end-1) - x(:,1:end-2) , -x(:,end-1)] ); 
        
    case 'laplacian', l    = [1 -2 1];    % V4
                      D    = @(x) real(ifft2(psf2otf(l,size(x)).*fft2(x)));
                      Dadj = @(x) real(ifft2(conj(psf2otf(l,size(x))).*fft2(x)));
end

% generate ground truth xbar
dom  = 1:100;
xbar = zeros(1,100);
xbar(25:50) =  1.5;
xbar(60:70) = -1.;
xbar(75:90) =  1.;

% generate data z corrupted by white gaussian noise with std sig
sig = .1;
z   = xbar + sig*randn(size(xbar));

% cost functions
f = @(x) sum(x(:).^2)/2;         
R = @(x) sum(abs(x(:)));
E = @(x,lam) f(x-z) + lam*R(D(x));

% proximity operator
prox_L1 = @(x,gam) x - max(min(x,gam),-gam);


%% Algorithm
% parameters
lam   = 1.5;        % smoothing parameter
gam   = .5;         % descent step
Niter = 1000;       % max number of iterations

% initialize variables
En = zeros(1,Niter,'double');
un = randn(1,length(z));

% main loop
for i = 1 : Niter
	yn = un + gam.*D(-Dadj(un)+z);              % forward step
    un = yn - gam.*prox_L1(yn/gam,lam/gam);     % backward step
    
    xn    = -Dadj(un) + z; 
    En(i) = E(xn,lam);
end

xhat = -Dadj(un) + z; 

% plot results
figure(3); clf;
subplot(211); 
    plot(dom,xbar,'-',dom,z,'-',dom,xhat,':','LineWidth',2);
    legend('ground truth xbar','data z','estimate xhat');
    title('signals');
subplot(212); 
    loglog(En,'LineWidth',2);
    title('cost function');
    xlabel('iterations');

