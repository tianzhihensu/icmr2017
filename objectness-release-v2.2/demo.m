imgExample = imread('img_213.jpg');
boxes = runObjectness(imgExample,10);
figure,imshow(imgExample),drawBoxes(boxes);