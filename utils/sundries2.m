clc;
clear;

% function: copy file
basePath = 'E:\研究生\研三上\icmr2017\optical_flow_dat_file\';

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
    
%     curImgName
%     preImgName
    
    srcTotalPath = strcat(basePath, subDir, '\', preImgName, '_opti_flow.mat');
    destiTotalPath = strcat(destiPath, curImgName, '_opti_flow.mat');
    copyfile(srcTotalPath, destiTotalPath);
end