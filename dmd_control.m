% This file must be run with matlab R2015a of below, cause D4100_usb.dll is
% 32 bit compiled library

% Generate data to simulate the row data
% Example data for DLP650LNIR, assuming 16 blocks of 50 rows each (total 800 rows)
% and 1280 micromirrors per row. Total data size is 800 * 1280 bits = 1,024,000 bits.
totalRows = 16 * 50;
rowSize = 1280;
rowData0 = uint8(0 * ones(1, totalRows * rowSize/8));
rowData1 = uint8(31 * ones(1, totalRows * rowSize/8));
rowData2 = image_to_bin('Test Images/che.JPG');

% initialize
[length, deviceNumber, DMDType] = initializeDMD();
version = calllib('D4100_usb', 'GetDLLRev');
% loadPattern
loadPattern(rowData2,length,DMDType,deviceNumber);

%calllib('D4100_usb', 'SetPWRFLOAT', 0, deviceNumber);
% Unload the library
unloadlibrary('D4100_usb');
