function [  ] = getOpticalFlowBatch_3( sourceDir, postfix, destiDir )
%GETOPTICALFLOWBATCH get the optical flow of each frame of all videos under
% a specific directory, and save the result into .mat file with the same
% name.
%
% Input: 
%   sourceDir: directory of files, which will be taken to compute
%   the optical flow for each frame.
%   postfix:
%   destiDir: directory of .mat files
%
% Output:
%   no output
%
%

% filesStruct = dir(strcat(sourceDir, '*', postfix));

 filesStruct = {
'Video_40_2_3'
'Video_41_2_3'
'Video_42_2_3'
'Video_45_6_4'
'Video_46_6_4'
'Video_47_6_4'
'Video_51_7_4'
'Video_52_7_4'
'Video_54_7_4'
};

len = length(filesStruct);
fixStr1 = 'image_';
fixStr2 = '.png';

% add the path of optical flow function 
addpath('../OpticalFlow/');

% traverse each video
for i = 1:len
    videoName = char(filesStruct(i));
    framesStruct = dir(strcat(sourceDir, videoName, '\*'));
    frameLen = length(framesStruct);
    
    mkdir(strcat(destiDir, videoName, '\'));
    
    % traverse each frame under a specific video
    for j = 0 : frameLen - 4  % start from 0 index
        curFrameName = strcat(fixStr1, num2str(j), fixStr2);
        curFilePath = strcat(sourceDir, videoName, '\', curFrameName);
        im1 = imread(curFilePath);
        % get next frame(adjcent frame) from the current frame
        curSerial = j;
        nextSerial = curSerial + 1;
        nextFrameName = strcat(fixStr1, num2str(nextSerial), fixStr2);
        nextFilePath = strcat(sourceDir, videoName, '\', nextFrameName);
        im2 = imread(nextFilePath);
        
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
        
        % save results to '.mat' file
        name = strcat(fixStr1, num2str(j), '_opti_flow');
        save(strcat(destiDir, videoName, '\', name, '.mat'), 'vx', 'vy');
        
        % print info
        info = sprintf('videoName:%s,\n frameName:%s', videoName, curFrameName);
        info
    end
end


end

