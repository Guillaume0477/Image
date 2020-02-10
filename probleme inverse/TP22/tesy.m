clear all;close all;

x=-1:0.1:1;
for i=1:length(x);
    hold on
    plot(i,x(i),'r*');
end