% Loads 3d joint locations (skeleton) and rotates the skeleton around base 
% of the spine such that the hips are perpendicular to the kinect
% Jonathan Murphy 03/08/2016

% skeleton.csv is loaded as an array <1x101, double> named skeleton
% NOTE all angles are in radians (rad)
% x = w, y = h, z = d

% importing csv data and initilzing it to skeleton array
dataFile = 'skeleton.csv';
skeleton = csvread(dataFile, 1, 0); % loading 2nd row of dataset

Joints = 25; % No of joint locations
Samples = 4; % No of samples per joint location

% Getting hip locations to be used in calculating its angle to the kinect
leftHipX = skeleton(50); 
leftHipZ = skeleton(52);
RightHipX = skeleton(66);
RightHipZ = skeleton(68);

% Note as we are rotating around the Y/H axis, the Y/H values aren't 
% needed for the calculation

% calculating array size to save rotated locations to
arraySize = (0.75*(size(skeleton)-1));
% creating new array to save rotated skeleton locations
RotatedSkeleton = zeros(arraySize);

% calculating angle between hips and front of kinect
phi = atan((leftHipZ-RightHipZ)/(leftHipX-RightHipX));

% Rotational Matrix Y-axis %         
RY = [cos(phi) 0  sin(phi); ...
             0 1         0; ...
     -sin(phi) 0 cos(phi)];

%*** Calculating rotated joint locations ***%
for i = 0:1:Joints-1

    % skeleton joint locations to be rotated 
    x = (i*Samples)+2; % w = x
    y = (i*Samples)+3; % h = y
    z = (i*Samples)+4; % d = z
    
    % array positions for saving rotated locations
    Rx = (i*3)+1;
    Ry = (i*3)+2;
    Rz = (i*3)+3; 

    % rotating location by RY
    rotated = RY*[skeleton(x);skeleton(y);skeleton(z)];
  
    % Saving rotated locations to rotatedSkeleton
    RotatedSkeleton(Rx) = rotated(1);
    RotatedSkeleton(Ry) = rotated(2);
    RotatedSkeleton(Rz) = rotated(3);

end

