function binaryImgArray = image_to_bin(imagePath)
    % Load the image
    img = imread(imagePath);
    % Resize the image to 1280x800
    resizedImg = imresize(img, [800, 1280]);

    % Convert to grayscale if the image is in color
    if size(resizedImg, 3) == 3
        grayImg = rgb2gray(resizedImg);
    else
        grayImg = resizedImg;
    end

    % Binarize the image using a global threshold
    threshold = graythresh(grayImg); % Calculate global threshold using Otsu's method
    binaryImg = im2bw(grayImg, threshold);
    % Flatten the binary image to a 1D array
    binaryImg1D = binaryImg(:)';
    %binaryImgArray = uint8(binaryImg1D);
    
    % Ensure the length of binaryImg1D is a multiple of 8
    numPixels = size(binaryImg1D);
    paddedLength = ceil(numPixels(2) / 8) * 8;
    binaryImg1D(paddedLength) = 0;  % Pad with zeros if necessary

    % Reshape to 8 rows for byte conversion
    binaryImgMatrix = reshape(binaryImg1D, 8, [])';
    binaryImgArray = uint8(binaryVectorToDecimal(binaryImgMatrix));
    % Display the original, resized, and binary images
    
%    figure;
%     subplot(1, 3, 1);
%     imshow(img);
%     title('Original Image');
% 
%     subplot(1, 3, 2);
%     imshow(resizedImg);
%     title('Resized Image (1280x800)');
% 
%     subplot(1, 3, 3);
%     imshow(binaryImg);
%     title('Binary Image');
end
