imgExample = imread('0966.png');
boxes = runObjectness(imgExample,10);
% specialBoxes = boxes(95:99, :);
figure,imshow(imgExample),drawBoxes(boxes);