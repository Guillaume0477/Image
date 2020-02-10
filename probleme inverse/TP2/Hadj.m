function [Hadjdim] = Hadj(im,ker)
% ker : noyau de convolution, créé avec fspecial()

Hadjdim = real(ifft2(conj(psf2otf(ker,size(im))).*fft2(im)));

end