function[] = Comparison()
% This function should take 2 inputs one gerber file and its corresponding
% X Ray image

%============================== GERBER IMAGE ===================================

% Read Gerber file
imgGerber = imread("../Gerber/HRNG_CRL1084_L1.tif");
GerberGray = im2gray(imgGerber);
GerberBinary = imbinarize(GerberGray, "global");

% disp(size(imgGerber));
% pause(5);

% ----------------------Identify holes------------------------

%Process Gerber file based on the background of the file
if sum(GerberBinary(:) == 0) > sum(GerberBinary(:) == 1)
    % Dark Background
    % CALL radiusRange takes input GERBER BINARY file
    % returns all the circles detected with there Centers and radii
    gCircles = gDarkLayer(GerberBinary);
else
    % Light Background
    % CALL otherLayers
    gCircles = gBrightLayer(GerberBinary);
end

disp(gCircles)
disp((size(gCircles, 1)))
% ------------------------------------------------------------

% -------------------Selection of Baseline---------------------
% Sort the circles of gerber file 3 - radius, 2 - X , 1 - Y
sortedCircles = sortrows(gCircles, [-3, 1, 2]);
disp(sortedCircles);

disp(sortedCircles(1, 2:3))
% Baseline Selection (Row, Col)
BL = [sortedCircles(1:2, 1), sortedCircles(1:2, 2)];
BL = sortrows(BL,1); 
disp(BL);

%---------------------------------------------------------------

% transulation and Axis rotation (changes all the values in coordinates) 
% newCircles = Transulate(gCircles, BL);
% newCircles = sortrows(newCircles, [-3, 2, 1]);
% disp(newCircles)
% disp(size(newCircles,1))

%-----------------Generate Properties GERBER ---------------------

% Generate Distance and angle

newCircles = GenerateProp(BL, gCircles);
newCircles = sortrows(newCircles, [-3, 4, 5]);

% filename = 'output_Gerber.xlsx';  % Specify the Excel file name
% writematrix(newCircles, filename);

disp(newCircles)
disp(size(newCircles,1))


%============================== X RAY IMAGE ===================================

% based on the Generated Distance and angle look of the hole in the XRay
% Image

XRay = imread("../report_3/front_crop_22.tif");

% disp("XRay")
% disp(size(XRay))
% pause(5);

XRay = imresize(XRay, size(GerberGray));

% disp("XRay after resize")
% disp(size(XRay))
% pause(5);

% ----------------------Identify holes------------------------
xCircles = getCirclesXRay(XRay);
% ------------------------------------------------------------

disp("-------------XRay image--------------")

% -------------------Selection of Baseline---------------------
% Sort the circles of XRay file 3 - radius, 1 - X , 2 - Y
sortedXCircles = sortrows(xCircles, [-3, 1, 2]);
disp(sortedXCircles);

% disp(sortedXCircles(1, 2:3))
% Baseline Selection (Row, Col)
xBL = [sortedXCircles(1:2, 1), sortedXCircles(1:2, 2)];
xBL = sortrows(xBL,1);
disp(xBL);
% --------------------------------------------------------------

%-----------------Generate Properties X Ray ---------------------
newXCircles = GenerateProp(xBL,xCircles);

newXCircles = sortrows(newXCircles,[-3, 4, 5]);

% filename = 'output_Xray.xlsx';  % Specify the Excel file name
% writematrix(newXCircles, filename);

disp(newXCircles);
disp(size(newXCircles,1));

%============================ MATCHING the HOLES =================================

% MATCHING THE HOLE OF GERBER TO XRAY.

% Set the threshold values 
coordThreshold = 20;    % Adjust according to your needs
radiusThreshold = 3; % Adjust according to your needs
distanceThreshold = 13; % Adjust according to your needs
angleThreshold = 2;   % Adjust according to your needs

% Initialize a logical vector to store the presence of holes in Gerber but not in XRay
nG = height(newCircles); 
holesInGerber = false(nG, 1);
holesInXray = false(height(newXCircles),1);
count = 0;

% Threshold to be compared for each iteration
angle = 0;
distance = 0;

% Threshold incrementing values
aTincrement = 0.154;
dTincrement = 1;

% Initialize a cell array to store matching coordinates
matchingCoordinates = cell(height(newCircles), 2);
k = 1;
while angleThreshold > angle && distanceThreshold > distance
   
    % Iterate over each hole in the Gerber data
    for i = 1:size(newCircles, 1)
        if holesInGerber(i) == true
            continue;
        end
        gerberX = newCircles(i, 1);
        gerberY = newCircles(i, 2);
        gerberRadius = newCircles(i, 3);
        gerberDistance = newCircles(i, 4);
        gerberAngle = newCircles(i, 5);
    
        % Initialize a flag to indicate if the hole is found in XRay
        flag = false;
    
        %Iterate over each hole in Xray data
    
        for j = 1:size(newXCircles, 1)
            if holesInXray(j) == true
                continue;
            end
            xrayX = newXCircles(j, 1);
            xrayY = newXCircles(j, 2);
            xrayRadius = newXCircles(j, 3);
            xrayDistance = newXCircles(j, 4);
            xrayAngle = newXCircles(j, 5);
            
            % Compare the hole properties and check if it matches within the thresholds
            if abs(gerberX - xrayX) <= coordThreshold && ...
                abs(gerberY - xrayY) <= coordThreshold && ...
                abs(gerberRadius - xrayRadius) <= radiusThreshold && ...
                abs(gerberDistance - xrayDistance) <= distance && ...
                abs(gerberAngle - xrayAngle) <= angle
                flag = true;
                disp(gerberAngle);
                disp(xrayAngle);
                count = count + 1;
                holesInXray(j) = flag;
                matchingCoordinates{k, 1} = newCircles(i);
                matchingCoordinates{k, 2} = newCircles(j);
                k = k + 1;
                break;
            end
        end
        
        % Update the logical vector based on the hole's presence in XRay
        holesInGerber(i) = flag;
    
    end
    
    angle = angle + aTincrement;
    distance = distance + dTincrement;


end 



%======================== Output Stored in Excel Files ==============================

filename = 'output_Approx_Match.xlsx';  % Specify the Excel file name
writecell(matchingCoordinates, filename);
disp(count);
