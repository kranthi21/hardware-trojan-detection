function[xCircles] = getCirclesXRay(XRay)
%     layer = imread(gerberLayer,"tif");
%     layerGray = im2gray(layer);

img = XRay;
% img = img(200:400,200:400);
% imshow(img); %------------------  1
% pause(4);

se = strel("sphere",2);
background = imopen(img,se);
% imshow(background); %------------------  2
% pause(4);

I2 = img - background;
% imshow(I2); %------------------  3
% pause(4);

I3 = imadjust(I2);
% imshow(I3); %------------------  4
% pause(4);

I3 = im2gray(I3);
% imshow(I3); %------------------- 5
% pause(4);


% bw = imbinarize(I3,"global");
% imshow(bw); %------------------  6
% pause(4);

%------------------binarization alternative----------------
gray = I3;%rgb2gray(img);

% Apply median filtering to remove noise
filtered = medfilt2(gray);

% Threshold the image to separate foreground and background
level = graythresh(filtered);

% imshow(level)
% pause(4)

binary = imbinarize(filtered, level);

% output_filename = 'After_PreP_Xray.jpg';
% imwrite(binary, output_filename);

% imshow(binary)
% pause(4)
%---------------------------

%     bw =  bwareaopen(bw, 10);
%     imshow(bw);
%     pause(4);
% % 
%     imgGray = im2gray(img);
%     imshow(imgGray);
%     pause(3);

% Fill small holes in the binary image
binary_filled = imfill(binary,"holes");

% imshow(binary_filled)
% pause(4)

% Remove small objects from the image
% binary_cleaned = bwareaopen(binary_filled, 100);
% imshow(binary_cleaned)
% pause(4)

% output_filename = 'After_PreP_Xray.jpg';
% imwrite(binary_filled, output_filename);


% [centers, radii] = imfindcircles(binary_filled, [2,5], "ObjectPolarity",'bright',"Sensitivity",0.8, "EdgeThreshold", 0.7,"Method","TwoStage");

% Perform circle detection for the first radius range
[radiusRange1] = [2, 5];
[centers1, radii1] = imfindcircles(binary_filled, radiusRange1,"Method","TwoStage","EdgeThreshold",0.7,"ObjectPolarity","bright",'Sensitivity',0.8);

% Perform circle detection for the second radius range
[radiusRange2] = [6, 10];
[centers2, radii2] = imfindcircles(binary_filled, radiusRange2, "ObjectPolarity",'bright', "Sensitivity",0.85,"EdgeThreshold",0.9,"Method","TwoStage");
% circles2 = [centers2, radii2];

% Perform circle detection for the third radius range
[radiusRange3] = [10, 26];
[centers3, radii3] = imfindcircles(binary_filled, radiusRange3,"ObjectPolarity",'bright', "Sensitivity",0.85,"EdgeThreshold",0.9,"Method","TwoStage");
% circles3 = [centers3, radii3];

% Combine the circle data with radius range information
centers = [centers1; centers2; centers3];
radii = [radii1; radii2; radii3];

xCircles = [centers, radii];

% N = length(radii);
% for i =1:N
%     disp(centers(i,[1 2]))
%     disp(radii(i))
% end
% h = viscircles(centers, radii);

% centertest = centers3(1,:);
% centertest(1, 1) = 215.1487872;
% 
% centertest(1, 2) = 218.5629677;
% radiitest = 4;
% imshow(XRay);
% h = viscircles(centertest, radiitest);
% 
% saveas(gcf,"correct_XRay_2.png");

end