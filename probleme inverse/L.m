function [lap] = L(im)

ker = [0 1 0; 1 -4 1; 0 1 0]; % V4
%ker = [1 1 1; 1 -8 1; 1 1 1]; % V8

lap = real(ifft2(psf2otf(ker,size(im)).*fft2(im)));

end