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

for i = 1:trNums
    trVec = trMatrix(i, :);
    
    for j = 1:bgNums
        bgVec = bgMatrix(j, :);
        % aspect of optical flow
        
        
        % aspect of overlapping area ratio
        areaRatio = getAreaRatio(bgVec, trVec);
    end
end

end

