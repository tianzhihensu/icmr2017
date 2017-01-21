clc;
clear;

% function: remove some annotated object rectangles which has width or
% height less than 40.

txtPath = 'E:\研究生\研三上\icmr2017\code\utils\object-methods\objRectInfos.txt';

fid = fopen(txtPath);

count = 0;
while feof(fid) == 0
    count = count + 1;
    textLine = fgetl(fid);
    % if it's data
    if isempty(strfind(textLine, 'img'))
        rowData = str2num(textLine);
        if rowData(1, 3) < 30 || rowData(1, 4) < 30
            disp(count);
        end
    end
end