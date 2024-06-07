%% Step 1: Load the ALP DLL

dllPath = 'C:\Users\dalop\Desktop\ALP-4.1\ALP-4.1 high-speed API';
headerFile = fullfile(dllPath, 'alp.h');
libFile = fullfile(dllPath, '\x64\alpD41.dll');
loadlibrary(libFile,headerFile);

% Step 2: Initialize the ALP Device
alp_id_ptr = libpointer('uint32Ptr', 0);% Define constants
ALP_DEFAULT = 0;

% Call the DLL function to allocate an ALP device
[ret, ~] = calllib('alpD41', 'AlpDevAlloc', ALP_DEFAULT, ALP_DEFAULT, alp_id_ptr);

% Check the return value to ensure the function call was successful
if ret == 0  % ALP_OK
    disp('ALP device allocated successfully.');
else
    error('Failed to allocate ALP device. Error code: %d', ret);
end
%%
% Retrieve the device ID from the pointer
alp_id = alp_id_ptr.Value;
disp(['Allocated ALP device ID: ', num2str(alp_id)]);

% Step 3: Create a Sequence
seq_id_ptr = libpointer('uint32Ptr', 0);
num_frames = 1;  % Number of frames in the sequence
frame_rate = 60;  % Display frame rate (in Hz)
[ret, ~] = calllib('alpD41', 'AlpSeqAlloc', alp_id, 8, num_frames, seq_id_ptr);
if ret ~= 0
    error('Failed to allocate sequence');
end
seq_id = seq_id_ptr.Value;

% Step 4: Prepare the Image Data
% Define the path to the image file
imagePath = 'ALP basic GUI/Samples 4x3/ALP.png';

% Read the image
image = imread(imagePath);
% If the max value is 1, assume the image is normalized and scale it to [0, 255]
if maxVal <= 1
    image = image * 255;
end
% Convert the image to 8-bit if it is not already
image = im2uint8(image);

% Ensure the image dimensions match the ALP device resolution (e.g., 1920x1080)
image = imresize(image, [768, 1024]);  % Resize to match resolution
imshow(image);

% Reshape the image data to a single column vector
image = reshape(image', [], 1);

% Check the range of pixel values
minVal = min(image(:));
maxVal = max(image(:));
disp(['Min pixel value: ', num2str(minVal)]);
disp(['Max pixel value: ', num2str(maxVal)]);

% Call the AlpSeqPut function
picOffset = 0;
picLoad = 1;  % Load one image for this example

% Note: 'image' is the UserArrayPtr, which is a pointer to the user data to be loaded
[ret] = calllib('alp41basic', 'AlpSeqPut', alp_id, seq_id, picOffset, picLoad, image);
if ret ~= 0
    error('Failed to load sequence into ALP RAM. Error code: %d', ret);
end
%%
% Step 6: Control the Display
% Set the sequence timing (optional)
[ret] = calllib('alpD41', 'AlpSeqTiming', alp_id, seq_id, frame_rate, 0, 0, 0, 0);
if ret ~= 0
    error('Failed to set sequence timing');
end

% Start the sequence
[ret] = calllib('alpD41', 'AlpProjStart', alp_id, seq_id);
if ret ~= 0
    error('Failed to start sequence');
end

% Cleanup: Free the allocated resources
calllib('alpD41', 'AlpSeqFree', alp_id, seq_id);
calllib('alpD41', 'AlpDevFree', alp_id);

% Unload the library
unloadlibrary('alpD41');
