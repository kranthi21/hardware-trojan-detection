function[newCircles] = GenerateProp(BL, gCircles)
% Given end points A and B
A = BL(1,:);
B = BL(2,:);

% Calculate the distance from each circle center to point A
n = size(gCircles, 1);
distances = zeros(n, 1);
angles = zeros(n, 1);

for i = 1:n
    circle_center = [gCircles(i, 1), gCircles(i, 2)]; % [x, y]
    
    % Calculate the distance from Ci to A
    distances(i) = norm(circle_center - A);
    
    % Calculate the angle between CiA and AB
    vector_AB = B - A;
    vector_CiA = circle_center - A;
    angle_CiA_AB = atan2(vector_CiA(2), vector_CiA(1)) - atan2(vector_AB(2), vector_AB(1));
    
    % Convert the angle to the range [0, 2*pi)
    if angle_CiA_AB < 0
        angle_CiA_AB = angle_CiA_AB + 2*pi;
    end
    
    angles(i) = rad2deg(angle_CiA_AB);
end

newCircles = [gCircles(:,1:3),distances, angles];
% The 'distances' variable contains the distances from each circle center to point A
% The 'angles' variable contains the angles between each CiA and AB
end