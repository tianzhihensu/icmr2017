function [ areaRatio ] = getAreaRatio( bgVec, textRegionVec )
%GETAREARATIO calculate the ratio of common area of background Region and
%text region on the latter.
%   
% Input: 
%   bgVec: cordinate of background region. eg. (topLeftX, topLeftY, width, height)
%   textRegionVec: same to bgVec, the cordinate of text region
% 
% Output:
%   areaRatio: ratio of sharing area on text region

bgTopLeftX = bgVec(1);
bgTopLeftY = bgVec(2);
bgWidth = bgVec(3);
bgHeight = bgVec(4);

trTopLeftX = textRegionVec(1);
trTopLeftY = textRegionVec(2);
trWidth = textRegionVec(3);
trHeight = textRegionVec(4);

% the overlap length on axis X, if no more than 0, then no sharing area,
% return 0
overLapX = (bgWidth + trWidth) - (max(bgTopLeftX + bgWidth, trTopLeftX + trWidth) - min(bgTopLeftX, trTopLeftX));
if(overLapX <= 0)
    areaRatio = 0;
else
    % the overlap length on axis Y
    overLapY = (bgHeight + trHeight) - (max(bgTopLeftY + bgHeight, trTopLeftY + trHeight) - min(bgTopLeftY, trTopLeftY));
    if(overLapY <= 0)
        areaRatio = 0;
    else
        areaRatio = (overLapX * overLapY) / (trWidth * trHeight);
    end
end
end

