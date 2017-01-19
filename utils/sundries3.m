clc;
clear;

% function: generate the optical flow of those specific images

addpath('../OpticalFlow');

basePath = 'E:\研究生\研二下\ICPR\experiments\spit_frames\ch3_train_frames\';

destiPath = './trainSet/optical_flow_mat/';

fid = fopen('./trainSet/imgMapping.txt');

while feof(fid) == 0
    textLine = fgetl(fid);
    tempSplit1 = regexp(textLine, ' ', 'split');
    curImgNameTemp = tempSplit1{1};
    tempSplit1 = regexp(curImgNameTemp, '\.', 'split');
    curImgName = tempSplit1{1};
    tempSplit2 = regexp(textLine, '>', 'split');
    subPath = tempSplit2{2};
    tempSplit3 = regexp(subPath, '\', 'split');
    % get sub directory and previous image names
    subDir = tempSplit3{1};
    preImgNameTemp = tempSplit3{2};
    tempSplit4 = regexp(preImgNameTemp, '\.', 'split');
    preImgName = tempSplit4{1};
    
    % get the serial number
    tempSplit5 = regexp(preImgName, '_', 'split');
    serial = str2num(tempSplit5{2});
    nextImgNameTemp = strcat(tempSplit5{1}, '_', num2str(serial + 1), '.', tempSplit4{2});
    
    destiTotalPath = strcat(destiPath, curImgName, '_opti_flow.mat');
    disp(destiTotalPath);
    
    im1 = imread(strcat(basePath, subPath));
    im2 = imread(strcat(basePath, subDir, '\', nextImgNameTemp));
    % call optical flow function, get the 'vx' and 'vy' results
    % set optical flow parameters (see Coarse2FineTwoFrames.m for the definition of the parameters)
    alpha = 0.012;
    ratio = 0.75;
    minWidth = 20;
    nOuterFPIterations = 7;
    nInnerFPIterations = 1;
    nSORIterations = 30;
    para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];
    [vx,vy,~] = Coarse2FineTwoFrames(im1,im2,para);
    
    save(destiTotalPath, 'vx', 'vy');
    disp('saved!');
end