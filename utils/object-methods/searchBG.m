clc;
clear;

% function: find the Regions of images of a specific file folder

folderPath = 'E:\研究生\研三上\icmr2017\code\utils\trainSet\all\';
savePath = 'E:\研究生\研三上\icmr2017\code\utils\trainSet\detectMSER_Result\';

filesList = dir(folderPath);

for i=3:length(filesList)
    imgName = filesList(i).name;
    imgNameTemp = regexp(imgName, '\.', 'split');
    im = imread(strcat(folderPath, imgName));
    imGray = rgb2gray(im);
    regions = detectMSERFeatures(imGray, 'MaxAreaVariation', 0.2, 'RegionAreaRange', [40, 10000]);
    figure(1);imshow(imGray);
    hold on;
    plot(regions, 'showPixelList', true, 'showEllipses', false);
    print(1, '-dpng', strcat(savePath, imgNameTemp{1}));
end
