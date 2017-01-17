clc;
clear;

% function: find best matching image, as current image has renamed.

path1 = 'E:\研究生\研三上\icmr2017\code\utils\trainSet\all\';
fileList1 = dir(path1);

basePath = 'E:\研究生\研二下\ICPR\experiments\spit_frames\ch3_train_frames\';
dirList = dir(basePath);

% traverse each img, to find its best match image in original directory
for i=3:length(fileList1)
    im1 = imread(strcat(path1, fileList1(i).name));
    
    % traverse each sub directory
    for j=3:length(dirList);
        subDir = dirList(j).name;
        fileList2 = dir(strcat(basePath, subDir, '\'));
        flag1 = false;
        for k=3:length(fileList2)
            im2 = imread(strcat(basePath, subDir, '\', fileList2(k).name));
            if isequal(im1, im2)
                disp(strcat(fileList1(i).name, ' --> ', subDir, '\', fileList2(k).name));
                flag1 = true;
                break;
            end
        end
        % has found
        if flag1
            break;
        end
    end
end
