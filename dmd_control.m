% This file must be run with matlab R2015a of below, cause D4100_usb.dll is
% 32 bit compiled library
% Load the DLL
dllPath = 'D4100_usb.dll';
headerPath = 'D4100_usb.h';
loadlibrary(dllPath, headerPath);
%%
% Check the number of connected devices
numDevices = calllib('D4100_usb', 'GetNumDev');
disp(['Number of connected devices: ', num2str(numDevices)]);

if numDevices < 1
    error('No DLP Discovery 4100 Development Platforms connected.');
end
version = calllib('D4100_usb', 'GetDLLRev');

% Define the device number
deviceNumber = int16(0);

% Clear FIFO buffers before sending data
result = calllib('D4100_usb', 'ClearFifos', deviceNumber);
if result == 1
    disp('FIFO buffers cleared successfully.');
else
    disp('Failed to clear FIFO buffers.');
end

% Load control flags
result = calllib('D4100_usb', 'LoadControl', deviceNumber);
if result == 1
    disp('Control flags loaded successfully.');
else
    disp('Failed to load control flags.');
end

% Example data for DLP650LNIR, assuming 16 blocks of 50 rows each (total 800 rows)
% and 1280 micromirrors per row. Total data size is 800 * 1280 bytes = 1,024,000 bytes.
totalRows = 16 * 50;
rowSize = 1280;
chunkSize = 50 * rowSize;  % 64 KB chunks for DLP650LNIR

% Generate random data to simulate the row data
rowData = uint8(randi([0, 255], 1, totalRows * rowSize));

% Get DMD type
DMDType = calllib('D4100_usb', 'GetDMDTYPE', deviceNumber);  % Example value for DLP650LNIR, replace with actual DMD type

% Load data into the DMD in chunks of 64 KB
for i = 1:chunkSize:length(rowData)
    chunk = rowData(i:min(i + chunkSize - 1, end));
    length = uint32(length(chunk));
    
    result = calllib('D4100_usb', 'LoadData', chunk, length, DMDType, deviceNumber);
    if result == 1
        disp(['Data chunk starting at index ', num2str(i), ' loaded successfully.']);
    else
        disp(['Failed to load data chunk starting at index ', num2str(i)]);
    end
end
% Unload the library
unloadlibrary('D4100_usb');