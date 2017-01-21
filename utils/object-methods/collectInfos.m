function [ info ] = collectInfos( winScale, winNums, imgName, im, objInfos )
%GETPRIORPROB collect the information of current image
%   detail: generate winNums windows randomly on the current image, then
%   statistics the positive and negative windows, after that, the values of
%   cues (eg, CC, ED, optical_flow) of windows can be got.
% 
% Input:
%   scale: the list of window size
%   winNums: 
%   im: image
%   objInfos: the information of rectangles covering objects in image "im"
%
% Output:
%   info: a struct, including: 
%       pWinNums: positive windows' number
%       nWinNums: negative windows' number
%       CCObj: CC value list of positive windows (obj)
%       CCBg: CC value list of negative windows (bg)
%       EDObj:
%       EDBg:
%       OFObj: optical flow value list of obj
%       OFBg: 

% initialize output
pWinNums = 0;
nWinNums = 0;
CCObj = [];
CCBg = [];
EDObj = [];
EDBg = [];
OFObj = [];
OFBg = [];

objNums = size(objInfos, 1);

scaleNums = round(winNums / objNums);
[imgHeight, imgWidth, imgLayer] = size(im);

% get the Lab space
cform = makecform('srgb2lab');
LabSpaceImg = applycform(im, cform);
LabSpaceImg = lab2double(LabSpaceImg);
% compute the edgeMap by using canny detector
edgeMap = edge(rgb2gray(im), 'canny');
% load the optical flow map(thetaMap) by imgName
tempStr1 = regexp(imgName, '\.', 'split');
% get vx and vy
load(strcat('../trainSet/optical_flow_mat/', tempStr1{1}, '_opti_flow.mat'));
thetaMap = atan2(vy, vx);

% tranverse each scale
for i=1:objNums
    % compute the valid width, namely making sure the generated rectangle
    % is totally covered by the current image
    objWidth = objInfos(i, 3);
    objHeight = objInfos(i, 4);
    validWidth = imgWidth - objWidth;
    validHeight = imgHeight - objHeight;
    topLeftX = 1 + round((validWidth - 1) .* rand(scaleNums, 1));
    topLeftY = 1 + round((validHeight - 1) .* rand(scaleNums, 1));
    topLeftList = [topLeftX, topLeftY]; 
    
    % collect the information under a specific scale, details see this
    % function.
    result = classifyWindow(topLeftList, objWidth, objHeight, objInfos, LabSpaceImg, edgeMap, thetaMap);
    
    % collect each data under a specific scale
    pWinNums = pWinNums + result.positiveNums;
    nWinNums = nWinNums + result.negativeNums;
    CCObj = [CCObj, result.CCObj];
    CCBg = [CCBg, result.CCBg];
    EDObj = [EDObj, result.EDObj];
    EDBg = [EDBg, result.EDBg];
    OFObj = [OFObj, result.OFObj];
    OFBg = [OFBg, result.OFBg];
    
end

info.pWinNums = pWinNums;
info.nWinNums = nWinNums;
info.CCObj = CCObj;
info.CCBg  = CCBg;
info.EDObj = EDObj;
info.EDBg = EDBg;
info.OFObj = OFObj;
info.OFBg = OFBg;

end

function [result] = classifyWindow(topLeftList, width, height, objInfos, LabSpaceImg, edgeMap, thetaMap)
%GETPRIORPROB  judge a window is positive sample or negative sample under a
% specific scale of a specific image.
% 
% Input:
%   topLeftList: a list of cordinate of windows, each row represents
%   the left-top-pint cordinate of a window.
%   width: 
%   height:
%   objInfos: a list of cordinate of ground truth rectangles.
%   LabSpaceImg: the Lab color space of current image.
%   edgeMap: the canny map of current image.
%   thetaMap: computed by optical flow of current image.
%
% Output:
%   result: struct containing the following information:
%             positiveNums
%             negativeNums
%             CCObj
%             CCBg 
%             EDObj
%             EDBg 
%             OFObj
%             OFBg 



    % initialize
    positiveNums = 0;
    negativeNums = 0;
    CCObj = [];
    CCBg = [];
    EDObj = [];
    EDBg = [];
    OFObj = [];
    OFBg = [];
    
    addpath('../');
    
    windowInfo.thetaMap = thetaMap;
    integralEdgeMap = getIntegralImage(edgeMap);
    
    winNums = size(topLeftList, 1);
    objNums = size(objInfos, 1);
    
    % tranverse each window generated randomly
    for i=1:winNums
        x1 = topLeftList(i, 1);
        y1 = topLeftList(i, 2);
        winVec = [x1, y1, width, height];
        % tranverse each obj rectangle
        positiveFlag = false;
        for j=1:objNums
            objVec = objInfos(j, :);
            areaRatio = getAreaRatio(winVec, objVec);
            if areaRatio
                commonArea = areaRatio * (objVec(1, 3) * objVec(1, 4));
                totalArea = winVec(1, 3) * winVec(1, 4) + (1 - areaRatio) * (objVec(1, 3) * objVec(1, 4));
                commonRatio = commonArea / totalArea;
                if(commonRatio > 0.5)
                    positiveNums = positiveNums + 1;
                    positiveFlag = true;
                    break;
                end
            end
        end
        
        % the situation of negative sample
        if ~positiveFlag
            negativeNums = negativeNums + 1;
        end
        
        %%%%%%%%%%%%%
        % compute CC, ED, optical flow(OF) of current window of a specific
        % scale of a specific image
        windowInfo.x = x1;
        windowInfo.y = y1;
        windowInfo.width = width;
        windowInfo.height = height;
        
        % compute CC
        cue = 'CC';
        theta = 0;  %%%%%%%%%%%%%%%%%%%%%%%%% need to be discussed later
        CCValue = computeFactors(cue, windowInfo, LabSpaceImg, integralEdgeMap, theta);
        
        % compute ED
        cue = 'ED';
        theta = 0;  %%%%%%%%%%%%%%%%%%%%%%%%% need to be discussed later
        EDValue = computeFactors(cue, windowInfo, LabSpaceImg, integralEdgeMap, theta);
        
        % compute OF(optical flow)
        cue = 'OF';
        theta = 0;  %%%%%%%%%%%%%%%%%%%%%%%%% need to be discussed later
        OFValue = computeFactors(cue, windowInfo, LabSpaceImg, integralEdgeMap, theta);
        
        if positiveFlag
            CCObj = [CCObj, CCValue];
            EDObj = [EDObj, EDValue];
            OFObj = [OFObj, OFValue];
        else
            CCBg = [CCBg, CCValue];
            EDBg = [EDBg, EDValue];
            OFBg = [OFBg, OFValue];
        end
    end
    
    result.positiveNums = positiveNums;
    result.negativeNums = negativeNums;
    result.CCObj = CCObj;
    result.CCBg = CCBg;
    result.EDObj = EDObj;
    result.EDBg = EDBg;
    result.OFObj = OFObj;
    result.OFBg = OFBg;
    
end

