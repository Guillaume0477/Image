clear all
close all
clc

matsum = @(M) sum(M(:));

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
    
    case 'gradient',  D    = @(x) cat(3,[x(:,2:end) - x(:,1:end-1) , zeros(size(x,1),1)] ./ 2., ...
                                        [x(2:end,:) - x(1:end-1,:) ; zeros(1,size(x,2))] ./ 2.); 
                      Dadj = @(x) - [x(:,1,1), x(:,2:end-1,1) - x(:,1:end-2,1), -x(:,end-1,1)] ./ 2. ...
                                  - [x(1,:,2); x(2:end-1,:,2) - x(1:end-2,:,2); -x(end-1,:,2)] ./ 2.;
        
    case 'laplacian', l    = [0 1 0; 1 -4 1; 0 1 0];    % V4
                      D    = @(x) real(ifft2(psf2otf(l,size(x)).*fft2(x)));
                      Dadj = @(x) real(ifft2(conj(psf2otf(l,size(x))).*fft2(x)));

end

% generate ground truth xbar
xbar = im2double(imread('cameraman.tif'));

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
lam   = .1;        % smoothing parameter
gam   = .5;        % descent step
Niter = 1000;      % max number of iterations

% initialize variables
En = zeros(1,Niter,'double');
un = randn([size(z),2]);

% main loop
for i = 1 : Niter
	yn = un + gam.*D(-Dadj(un)+z);              % forward step
    un = yn - gam.*prox_L1(yn/gam,lam/gam);     % backward step
    
    xn    = -Dadj(un) + z; 
    En(i) = E(xn,lam);
end

xhat = -Dadj(un) + z; 

% plot results
figure(4); clf;
subplot(221), imshow(xbar,[]);            title('ground truth xbar');
subplot(222), imshow(z,[]);               title('data z');
subplot(223), imshow(xhat,[]);            title('estimate xhat');
subplot(224), loglog(En,'LineWidth',2);   title('cost function');
                                          xlabel('iterations');