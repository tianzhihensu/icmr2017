function [ objData ] = getObjRect( filePath )
%GETOBJRECT read the information of rectangle covering the objects.
%   
% Input: 
%   filePath: path of txt file
% Output:
%   objData: the array of struct

fid = fopen(filePath, 'r');
textLine = fgetl(fid);
imgName = textLine;

count = 1;
objInfos = [];
while feof(fid) == 0
    textLine = fgetl(fid);
    index = strfind(textLine, 'img');
    if isempty(index)   % this line is data
       objInfos = [objInfos; str2num(textLine)];
    else
        % save the previous result
        imgInfo.imgName = imgName;
        imgInfo.objInfos = objInfos;
        objData(count) = imgInfo;
        
        count = count + 1;
        imgName = textLine;
        objInfos = [];
    end
end

imgInfo.imgName = imgName;
imgInfo.objInfos = objInfos;
objData(count) = imgInfo;

end

