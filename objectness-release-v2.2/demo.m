imgExample = imread('002502.png');
boxes = runObjectness(imgExample,100);
specialBoxes = boxes(95:99, :);
figure,imshow(imgExample),drawBoxes(specialBoxes);