function [ similarity ] = getOptiFlowSimilarity( block1, block2 )
%GETOPTIFLOWSIMILARITY compute the similarity of two data sets.
%   
% Input:
%   block1: a struct containing optical flow value of both x and y axis.
%   block2: the same to block1
%
% Output:
%   similarity: the sum of mean value from x and y axis.

block1X = block1.vx;
block1Y = block1.vy;

block2X = block2.vx;
block2Y = block2.vy;

subtractX = block1X - block2X;
meanX = mean(subtractX(:));

subtractY = block1Y - block2Y;
meanY = mean(subtractY(:));

similarity = meanX + meanY;

end

