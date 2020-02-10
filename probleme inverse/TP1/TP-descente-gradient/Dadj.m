function [y] = Dadj(x1,x2)

y = - [x1(:,1), x1(:,2:end-1) - x1(:,1:end-2), -x1(:,end-1)] ./ 2. ...
    - [x2(1,:); x2(2:end-1,:) - x2(1:end-2,:); -x2(end-1,:)] ./ 2.;

end