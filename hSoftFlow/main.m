% close all;
% clear all;
clc;
n=13;

raw=zeros(720,1280,3,n);
for i=1:n
    filename=strcat('./frames/image_', int2str(i),'.png');
    raw(:,:,:,i)=imread(filename);
end

for i=1:n-1
    V=HSoptflow(raw,i);
end