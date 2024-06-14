function binaryImgArray = image_to_bin(imagePath)
    % Load the image
    img = imread(imagePath);
    %img = imread('Test Images/ironmaiden.JPG');

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
    uint8binaryImg = reshape(binaryImg',8,[])';
    
    % Display the original, resized, and binary images
    binaryImgArray = uint8(uint8binaryImg * (2.^(7:-1:0))')';
    figure;
     subplot(1, 3, 1);
     imshow(img);
     title('Original Image');
 
     subplot(1, 3, 2);
     imshow(resizedImg);
     title('Resized Image (1280x800)');
 
     subplot(1, 3, 3);
     imshow(binaryImg);
     title('Binary Image');
end
