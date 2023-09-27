function [gCircles] = gBrightLayer(~)%GerberBinary)
    img = imread("../ChatGpt/HRNG_CRL1084_L2.tif");
    GerberBinary = rgb2gray(img);

    % Apply median filtering to remove noise
    filtered = medfilt2(GerberBinary);
    
    % Threshold the image to separate foreground and background
    level = graythresh(filtered);
    
    % imshow(level)
    % pause(4)

    binary = imbinarize(filtered, level);
    
    % imshow(binary)
    % pause(4)


    % Fill small holes in the binary image
    binary_filled = imfill(binary, 8);

    % imshow(binary_filled)
    % pause(4)
    
    % Remove small objects from the image
    binary_cleaned = bwareaopen(binary_filled, 100);
    imshow(binary_cleaned)
    % pause(4)
    
    % output_filename = 'After_PreP_gBright.jpg';
    % imwrite(binary_filled, output_filename);

    % Perform circle detection for the first radius range
    [radiusRange1] = [2, 4];
    [centers1, radii1] = imfindcircles(binary_filled, radiusRange1,"Method","TwoStage","EdgeThreshold",0.75,"ObjectPolarity","bright",'Sensitivity',0.85);
    
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
    

    gCircles = [centers, radii];

    disp(gCircles)
    disp(size(gCircles, 1))
    % Display the original image with circles overlayed
    %figure; 

    % fig = imshow(img);
    % viscircles(centers, radii, 'Color', 'b');

    % disp(length(centers))
    % imwrite(fig,'Layer2n.png')
    % saveas(fig,"Layer2",'png');

    
end