function [Him] = H(im,ker)
% ker : noyau de convolution, créé avec fspecial()

Him = real(ifft2(psf2otf(ker,size(im)).*fft2(im)));

end