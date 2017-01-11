function [ result ] = computeFactors( cue, windowInfo, LabSpaceImg, integralEdgeMap, theta )
%COMPUTEFACTORS compute the score of CC/ED/SS
% 
% Input: 
%   cue: string of CC/ED/SS
%   windowInfo: information of window, including topLeftX, topLeftY, width
%   and height
%   LabSpaceImg:  image with LAB color space converted from RGB, if cue is
%   not 'CC', then this parameter can be set to ''
%   integralEdgeMap: result of canny detector, used for 'ED', if cue is not 'ED',
%   just set this parameter to ''
%   theta:
%
% Output:
%   result: the score

topLeftX = windowInfo.x;
topLeftY = windowInfo.y;
width = windowInfo.width;  % has considered the border of image
height = windowInfo.height;

[imgHeight, imgWidth, imgLayer] = size(LabSpaceImg);

switch(cue)
    case 'CC'  % color contrast
        metric = 'chisq';
        thetaCC = theta;
        enlargedStep = width / 2;  % discuss later
        
        % get surrounding window information
        topLeftX_CC = max(topLeftX - enlargedStep, 0);
        topLeftY_CC = max(topLeftY - enlargedStep, 0);
        width_CC = min(width + 2 * enlargedStep, imgWidth - topLeftX_CC);
        height_CC = min(height + 2 * enlargedStep, imgHeight - topLeftY_CC);
        
        % convert sRGB to LAB, do this out of this function
%         cform = makecform('srgb2lab');
%         LabSpace = applycform(srcImg, cform);
%         LabSpace = lab2double(LabSpace);

        % get the index of surrounding area and window
        tempImg = ones(imgHeight, imgWidth);
        % set the value of outer rectangle to 2
        tempImg(topLeftY:topLeftY + height, topLeftX:topLeftX + width) = 2;
        % set the value of inner rectangle to 1 repeatly
        tempImg(topLeftY_CC:topLeftY_CC + height_CC, topLeftX_CC:topLeftX_CC + width_CC) = 1;
        % subtract 1
        tempImg = tempImg - 1; % after this step, only the surround area  has the value 1, others are 0 value.
        indexSur = find(tempImg);
        % index of window
        tempImg = ones(imgHeight, imgWidth);
        tempImg(topLeftY:topLeftY + height, topLeftX:topLeftX + width) = 2;
        tempImg = tempImg - 1;
        indexWin = find(tempImg);
        
        % after get the index, we can easily get the LAB space of target
        % surrounding area.
        LImg = LabSpaceImg(:, :, 1);
        aImg = LabSpaceImg(:, :, 2);
        bImg = LabSpaceImg(:, :, 3);
        LSur = LImg(indexSur);  % range: [0, 100]
        LSur = LSur';
        LWin = LImg(indexWin);
        LWin = LWin';
        aSur = aImg(indexSur);  % range: [-128, 127]
        aSur = aSur';
        aWin = aImg(indexWin);
        aWin = aWin';
        bSur = bImg(indexSur);  % range: [-128, 127]
        bSur = bSur';
        bWin = bImg(indexWin);
        bWin = bWin';
        
        % L
        LStep = 5;
        LBinRange = 0:LStep:100;
        LBinCountsSur = histc(LSur, LBinRange);
        LBinCountsWin = histc(LWin, LBinRange);
        LScore = new_pdist2(LBinCountsSur, LBinCountsWin, metric);
        
        % a
        aStep = 16;
        aBinRange = -128:aStep:127;
        aBinCountsSur = histc(aSur, aBinRange);
        aBinCountsWin = histc(aWin, aBinRange);
        aScore = new_pdist2(aBinCountsSur, aBinCountsWin, metric);
        
        % b, same to a
        bBinCountsSur = histc(bSur, aBinRange);
        bBinCountsWin = histc(bWin, aBinRange);
        bScore = new_pdist2(bBinCountsSur, bBinCountsWin, metric);
        
        % final resut
        result = LScore + aScore + bScore;
        
    case 'ED'
        shrinkStep = min(width, height) / 2;  % discuss later
        
        % get the cordinate of inner ring
        topLeftX_Inn = topLeftX + shrinkStep;
        topLeftY_Inn = topLeftY + shrinkStep;
        width_Inn = width - 2 * shrinkStep;
        height_Inn = height - 2 * shrinkStep;
        
        % calculate the edge numbers of inner-box and outer-box, then the
        % subtract of them are the result of inner-ring
        edgeNumsWin = integralEdgeMap(topLeftY + height, topLeftX + width) - integralEdgeMap(topLeftY, topLeftX);
        edgeNumsInnBox = integralEdgeMap(topLeftY_Inn + height_Inn, topLeftX_Inn + width_Inn) - integralEdgeMap(topLeftY_Inn, topLeftX_Inn);
        edgeNumsInnRing = edgeNumsWin - edgeNumsInnBox;
        
        
        
end

end

