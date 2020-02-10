function [Dx Dy] = D(im)

Dx = [im(:,2:end) - im(:,1:end-1) , zeros(size(im,1),1)] ./ 2.;
Dy = [im(2:end,:) - im(1:end-1,:) ; zeros(1,size(im,2))] ./ 2.;

end