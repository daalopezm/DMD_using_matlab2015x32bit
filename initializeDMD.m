function [ length, deviceNumber, DMDType] = initializeDMD( )
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
    
    % a chunk should be at most 640000bits
    chunkSize = 512000/8;  % 640 kilobits chunks for DLP650LNIR
    length = uint32(chunkSize);

    % Get DMD type
    DMDType = calllib('D4100_usb', 'GetDMDTYPE', deviceNumber);  % Example value for DLP650LNIR, replace with actual DMD type
    calllib('D4100_usb', 'SetWDT', 0, deviceNumber); % Disable watchdog timmer, atached to interrupcions
    calllib('D4100_usb', 'SetTPGEnable', 0, deviceNumber); % Disable the internal pattern generation
end

