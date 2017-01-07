function [ transiProbMatrix1, transiProbMatrix2 ] = computeTransiProb( trMatrix, bgMatrix, videoName, fileName )
%UNTITLED compute transition probablity matrix by text regions and
%background regions.
% 
% avaliable aspect: overlapping area ratio, optical flow
%
% Input:
%   trMatrix: text region matrix, each row represents the cordinate of text
%   regions with the form: [topLeftX, topLeftY, width, height]
%   bgMatrix: background region matrix, similar to trMatrix
%   videoName: 
%   fileName: is used to get the pre-saved optical flow file
%
% Output:
%   transiProbMatrix1: transition probability matrix from text regions to
%   background regions
%   transiProbMatrix2: background regions to text regions


baseDir = '../optical_flow_dat_file/';
opticalFlowFileDir = baseDir + fileName + '_opti_flow.mat'; 
load(opticalFlowFileDir);

trNums = size(trMatrix, 1); % number of text regions
bgNums = size(bgMatrix, 1); % number of background regions
transiProbMatrix1 = zeros(trNums, bgNums);
transiProbMatrix2 = zeros(bgNums, trNums);

similarityMatrix = zeros(trNums, bgNums);
areaRatioMatrix = zeros(trNums, bgNums);

for i = 1:trNums
    trVec = trMatrix(i, :);
    trX = trVec(1, 1);
    trY = trVec(1, 2);
    trWidth = trVec(1, 3);
    trHeight = trVec(1, 4);
    
    for j = 1:bgNums
        bgVec = bgMatrix(j, :);
        bgX = bgVec(1, 1);
        bgY = bgVec(1, 2);
        bgWidth = bgVec(1, 3);
        bgHeight = bgVec(1, 4);
        % aspect of optical flow
        trBlock.blockX = vx(trY : trY + trHeight, trX: trX + trWidth);
        trBlock.blockY = vy(trY : trY + trHeight, trX: trX + trWidth);
        bgBlock.blockX = vx(bgY : bgY + bgHeight, bgX : bxX + bgWidth);
        bgBlock.blockY = vy(bgY : bgY + bgHeight, bgX : bxX + bgWidth);
        
        similarityMatrix(i, j) = getOptiFlowSimilarity(trBlock, bgBlock);
        
        % aspect of overlapping area ratio
        areaRatioMatrix(i, j) = getAreaRatio(bgVec, trVec);
    end
end

% normalize similarityMatrix or use e^{similarity}
maxVal = max(similarityMatrix(:));
minVal = min(similarityMatrix(:));
similarityMatrix = (similarityMatrix - minVal) ./ (maxVal - minVal);  % more samll, more similar

% normalize areaRatioMatrix
maxVal = max(areaRatioMatrix(:));
minVal = min(areaRatioMatrix(:));
areaRatioMatrix = (areaRatioMatrix - minVal) ./ (maxVal - minVal);

% may be revised 
transiProbMatrix1 = exp(-similarityMatrix) .* areaRatioMatrix;
transiProbMatrix2 = transiProbMatrix1';
end

