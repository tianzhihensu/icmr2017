clc;
clear;

winScale = [32 64 128 256];
imgDir = 'E:\研究生\研三上\icmr2017\code\utils\trainSet\all\';  % parent directory of images
winNums = 10000;

objData = getObjRect('./objRectInfos.txt');
imgNums = length(objData);

pWinNums = 0;
nWinNums = 0;
CCObj = [];
CCBg = [];
EDObj = [];
EDBg = [];
OFObj = [];
OFBg = [];

% tranverse every image by the objData, and record information.
for i=1:imgNums
    i
    imgInfo = objData(i);
    imgName = imgInfo.imgName;
    objInfos = imgInfo.objInfos;
    im = imread(strcat(imgDir, imgName));
    info = collectInfos(winScale, winNums, imgName, im, objInfos);
    
    pWinNums = pWinNums + info.pWinNums;
    nWinNums = nWinNums + info.nWinNums;
    CCObj = [CCObj, info.CCObj];
    CCBg = [CCBg, info.CCBg];
    EDObj = [EDObj, info.EDObj];
    EDBg = [EDBg, info.EDBg];
    OFObj = [OFObj, info.OFObj];
    OFBg = [OFBg, info.OFBg];
end

binNums = 20; %%%%%%%%%%%%%%%%% revise later

%%%% CC
max_CCObj = max(CCObj);
min_CCObj = min(CCObj);
binRanges = min_CCObj:binNums:max_CCObj;
binCounts_CCObj = histc(CCObj, binRanges);

max_CCBg = max(CCBg);
min_CCBg = min(CCBg);
binRanges = min_CCBg:binNums:max_CCBg;
binCounts_CCBg = histc(CCBg, binRanges);

%%%% ED

