% This file must be run with matlab R2015a of below, cause D4100_usb.dll is
% 32 bit compiled library
% Load the DLL
dllPath = 'D4100_usb.dll';
headerPath = 'D4100_usb.h';
loadlibrary(dllPath, headerPath);

% Check the number of connected devices
numDevices = calllib('D4100_usb', 'GetNumDev');
disp(['Number of connected devices: ', num2str(numDevices)]);
% Define the device number
deviceNumber = int16(numDevices-1);

if numDevices < 1
    error('No DLP Discovery 4100 Development Platforms connected.');
end
version = calllib('D4100_usb', 'GetDLLRev');

% Clear FIFO buffers before sending data
calllib('D4100_usb', 'ClearFifos', deviceNumber);

% Example data for DLP650LNIR, assuming 16 blocks of 50 rows each (total 800 rows)
% and 1280 micromirrors per row. Total data size is 800 * 1280 bits = 1,024,000 bits.
totalRows = 16 * 50;
rowSize = 1280;
% a chunk should be at most 640000bits
chunkSize = 512000/8;  % 640 kilobits chunks for DLP650LNIR
length = uint32(chunkSize);

% Generate data to simulate the row data
rowData0 = uint8(0 * ones(1, totalRows * rowSize/8));
rowData1 = uint8(31 * ones(1, totalRows * rowSize/8));
rowData2 = image_to_bin('Test Images/image.jpg');

% Get DMD type
DMDType = calllib('D4100_usb', 'GetDMDTYPE', deviceNumber);  % Example value for DLP650LNIR, replace with actual DMD type
calllib('D4100_usb', 'SetWDT', 0, deviceNumber); % Disable watchdog timmer, atached to interrupcions

calllib('D4100_usb', 'SetTPGEnable', 0, deviceNumber); % Disable the internal pattern generation

calllib('D4100_usb', 'SetBlkMd', 0, deviceNumber); % DMD Block Operations -- NOP
calllib('D4100_usb', 'LoadControl', deviceNumber); % DMD Block Operations -- Execute!


i=1;

%load first half of the screen
chunk = rowData2(1:chunkSize);
calllib('D4100_usb', 'SetRowMd', 3, deviceNumber); % Set First row address
calllib('D4100_usb', 'SetNSFLIP', 0, deviceNumber); % Causes the DLPC410 to reverse order of row loading, effectively flipping the image
calllib('D4100_usb', 'LoadControl', deviceNumber); % DMD Block Operations -- Execute!

calllib('D4100_usb', 'SetRowMd', 1, deviceNumber); %If RowMd==1 and NSFLIP==0 Increment internal row address by '1' - write concurrent data into that row
calllib('D4100_usb', 'SetNSFLIP', 0, deviceNumber);
calllib('D4100_usb', 'LoadControl', deviceNumber); % DMD Block Operations -- Execute!

calllib('D4100_usb', 'ClearFifos', deviceNumber);
calllib('D4100_usb', 'LoadData', chunk, length, DMDType, deviceNumber);
calllib('D4100_usb', 'SetBlkMd', int16(3), deviceNumber); 
calllib('D4100_usb', 'SetBlkAd', int16(8), deviceNumber);
calllib('D4100_usb', 'LoadControl', deviceNumber);


calllib('D4100_usb', 'SetBlkMd', 0, deviceNumber); % DMD Block Operations -- NOP
calllib('D4100_usb', 'LoadControl', deviceNumber); % DMD Block Operations -- Execute!

%calllib('D4100_usb', 'SetRowMd', 3, deviceNumber); % Set First row address
%calllib('D4100_usb', 'SetNSFLIP', 0, deviceNumber); % Causes the DLPC410 to reverse order of row loading, effectively flipping the image
%calllib('D4100_usb', 'LoadControl', deviceNumber); % DMD Block Operations -- Execute!

%load second half of the screen
chunk = rowData2(chunkSize+1:end);
calllib('D4100_usb', 'SetRowMd', 2, deviceNumber); %If RowMd==1 and NSFLIP==0 Increment internal row address by '1' - write concurrent data into that row
calllib('D4100_usb', 'SetRowAddr', 400, deviceNumber);
calllib('D4100_usb', 'LoadControl', deviceNumber); % DMD Block Operations -- Execute!

calllib('D4100_usb', 'SetRowMd', 1, deviceNumber); %If RowMd==1 and NSFLIP==0 Increment internal row address by '1' - write concurrent data into that row
calllib('D4100_usb', 'SetNSFLIP', 0, deviceNumber);
calllib('D4100_usb', 'LoadControl', deviceNumber); % DMD Block Operations -- Execute!

calllib('D4100_usb', 'ClearFifos', deviceNumber);
calllib('D4100_usb', 'LoadData', chunk, length, DMDType, deviceNumber);
calllib('D4100_usb', 'SetBlkMd', int16(3), deviceNumber); 
calllib('D4100_usb', 'SetBlkAd', int16(8), deviceNumber);
calllib('D4100_usb', 'LoadControl', deviceNumber);

%calllib('D4100_usb', 'SetPWRFLOAT', 0, deviceNumber);
% Unload the library
unloadlibrary('D4100_usb');
