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
chunkSize = 50 * rowSize;  % 64 Kilobits chunks for DLP650LNIR

% Generate random data to simulate the row data
%rowData = uint8(randi([0, 255], totalRows * rowSize, 1));
rowData0 = uint8(0 * ones(1, totalRows * rowSize));
rowData1 = uint8(240 * ones(1, totalRows * rowSize));
% Get DMD type
DMDType = calllib('D4100_usb', 'GetDMDTYPE', deviceNumber);  % Example value for DLP650LNIR, replace with actual DMD type
length = uint32(chunkSize);
calllib('D4100_usb', 'SetWDT', 0, deviceNumber);

%calllib('D4100_usb', 'SetPWRFLOAT', 0, deviceNumber);
calllib('D4100_usb', 'SetTPGEnable', 0, deviceNumber);

%chunk = rowData1(1:min(1 + chunkSize/8 - 1, end));
%length = uint32(chunkSize);
%calllib('D4100_usb', 'LoadData', chunk, length, DMDType, deviceNumber);
%calllib('D4100_usb', 'SetBlkAd', int16(8), deviceNumber);
%calllib('D4100_usb', 'SetBlkMd', int16(3), deviceNumber); 
%calllib('D4100_usb', 'LoadControl', deviceNumber);

calllib('D4100_usb', 'SetBlkMd', 0, deviceNumber);
calllib('D4100_usb', 'LoadControl', deviceNumber);

%calllib('D4100_usb', 'SetRowMd', 3, deviceNumber);
%calllib('D4100_usb', 'SetNSFLIP', 0, deviceNumber);
%calllib('D4100_usb', 'LoadControl', deviceNumber);

%calllib('D4100_usb', 'SetRowMd', 1, deviceNumber);
%calllib('D4100_usb', 'SetNSFLIP', 0, deviceNumber);
%calllib('D4100_usb', 'LoadControl', deviceNumber);

calllib('D4100_usb', 'ClearFifos', deviceNumber);
for i = 1:chunkSize:rowSize*totalRows
    chunk = rowData1(i:min(i + chunkSize - 1, end));
    length = uint32(chunkSize);
    %calllib('D4100_usb', 'ClearFifos', deviceNumber);
    calllib('D4100_usb', 'LoadData', chunk, length, DMDType, deviceNumber);
end
calllib('D4100_usb', 'SetBlkMd', int16(3), deviceNumber); 
calllib('D4100_usb', 'SetBlkAd', int16(8), deviceNumber);
calllib('D4100_usb', 'LoadControl', deviceNumber);
% Unload the library
unloadlibrary('D4100_usb');