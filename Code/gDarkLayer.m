function[gCircles]  = gDarkLayer(GerberBinary)
    
    % output_filename = 'After_PreP_gDark.jpg';
    % imwrite(GerberBinary, output_filename);

    % Perform circle detection for the first radius range
    [radiusRange1] = [2, 4];
    [centers1, radii1] = imfindcircles(GerberBinary, radiusRange1,"ObjectPolarity",'bright', "Sensitivity",0.85,"EdgeThreshold",0.75,"Method","TwoStage");
    % circles1 = [centers1, radii1];


    % Perform circle detection for the second radius range
    [radiusRange2] = [6, 10];
    [centers2, radii2] = imfindcircles(GerberBinary, radiusRange2, "ObjectPolarity",'bright', "Sensitivity",0.85,"EdgeThreshold",0.9,"Method","TwoStage");
    % circles2 = [centers2, radii2];

    % Perform circle detection for the third radius range
    [radiusRange3] = [10, 26];
    [centers3, radii3] = imfindcircles(GerberBinary, radiusRange3,"ObjectPolarity",'bright', "Sensitivity",0.85,"EdgeThreshold",0.9,"Method","TwoStage");
    % circles3 = [centers3, radii3];

    % Combine the circle data with radius range information
    centers = [centers1; centers2; centers3];
    radii = [radii1; radii2; radii3];

    gCircles = [centers, radii];

    % centertest = centers3(1,:);
    % centertest(1, 1) = 216.7763869;
    % 
    % centertest(1, 2) = 220.8599473;
    % 
    % radiitest = 4;
    % imshow(GerberBinary);
    % h = viscircles(centertest, radiitest);
    % 
    % saveas(gcf,"correct_Gerber_2.png");
    
end