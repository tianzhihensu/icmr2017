function batchRename(fileDir)
% rename all files of fileDir batches
%
% Input:
%   fileDir: the directory of files to be renamed.
%


fileList = dir(fileDir);

len = length(fileList);
for i = 3:len
    system(['ren "' fileDir fileList(i).name '"' ' img_' num2str(i - 3) '.jpg']);
end

end