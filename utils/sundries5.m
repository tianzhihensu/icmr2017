clc;
clear;

% function: find missing image

txtPath = './object-methods/objRectInfos.txt';
fid = fopen(txtPath);

imgPath = './trainSet/all/';

while feof(fid) == 0
    textLine = fgetl(fid);
    if isempty(strfind(textLine, 'img')) == 0
        filesList = dir(strcat(imgPath, textLine));
        if size(filesList, 1) == 0
            disp(textLine);
        end
    end
end