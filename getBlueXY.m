function out = getBlueXY

% read in a photo, find blue object and detect centroid 

[centers, radii] = imfindcircles(findBlue, [25 70]);

centers = centers((1:end), :);
radii = radii(1:end);

%viscircles(centers, radii, 'EdgeColor', 'b');

%if three circles detected
if (6 == numel(centers))
    [coordx, coordy] = mn2xy(centers(1), centers(1,2));
    [coordx2, coordy2] = mn2xy(centers(2), centers(2,2));
    [coordx3, coordy3] = mn2xy(centers(3), centers(3,2));
    disp([coordx, coordy; coordx2, coordy2; coordx3, coordy3]);
    out = [coordx, coordy; coordx2, coordy2; coordx3, coordy3];

%if two circles detected
elseif (4 == numel(centers))
    [coordx, coordy] = mn2xy(centers(1), centers(1,2));
    [coordx2, coordy2] = mn2xy(centers(2), centers(2,2));
    disp([coordx, coordy; coordx2, coordy2]);
    out = [coordx, coordy; coordx2, coordy2];

    %if only one circle
elseif (2 == numel(centers))
    [coordx, coordy] = mn2xy(centers(1), centers(1,2));
    disp([coordx, coordy]);
    out = [coordx, coordy];
    
%No circles
else disp("There are no blue objects");
      out = NaN;
end

end

%gets image and converts to HSV then black and white
function BW = findBlue
%% Instantiate hardware (turn on camera)
if ~exist('cam', 'var') % connect to webcam iff not connected
    cam = webcam();
    pause(1); % give the camera time to adjust to lighting
end

%get image and adjust to screen and within workspace
img = snapshot(cam);

% Convert RGB image to chosen color space
I = rgb2hsv(img);
imshow(I);
disp('Press a key!');
pause;

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.492;
channel1Max = 0.715;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.144;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

imshow(BW);
disp('Press a key!');
pause;

% Initialize output masked image based on input image.
maskedRGBImage = img;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

BW = im2bw(maskedRGBImage, 0);

imshow(BW);
disp('Press a key!');
pause;

BW = BW;
end 
