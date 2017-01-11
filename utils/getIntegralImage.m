function [ integralImg ] = getIntegralImage( eleMatrix )
%GETINTEGRALIMAGE compute the integral image of an matrix
%
% Input:
%   eleMatrix: normal matrix
%
% Output:
% integralImage: integral image map

[height, width, layer] = size(eleMatrix);

integralImg = zeros(height, width);
integralImg(1, 1) = eleMatrix(1, 1);

% the first row
for j=2:width
    integralImg(1, j) = eleMatrix(1, j) + integralImg(1, j - 1);
end

% the first column
for i=2:height
    integralImg(i, 1) = eleMatrix(i, 1) + integralImg(i - 1, 1);
end

% the rest of integralImage
for i=2:height
    for j=2:width
        integralImg(i, j) = integralImg(i, j - 1) + integralImg(i - 1, j) - integralImg(i - 1, j - 1) + eleMatrix(i, j);
    end
end

end

