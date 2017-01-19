clc;
clear;

% function: find duplicate imageName

txtPath = './object-methods/objRectInfos.txt';
fid = fopen(txtPath);

imgPath = './trainSet/all/';

abc = '';

while feof(fid) == 0
    textLine = fgetl(fid);
    
    if isempty(strfind(textLine, 'img')) == 0
        if isempty(strfind(abc, textLine)) == 0
            disp(textLine);
        else
            abc = strcat(abc, textLine);
        end
    end
    
end