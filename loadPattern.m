function loadPattern(rowData, length, DMDType, deviceNumber)
    
    calllib('D4100_usb', 'SetBlkMd', 0, deviceNumber); % DMD Block Operations -- NOP
    calllib('D4100_usb', 'LoadControl', deviceNumber); % DMD Block Operations -- Execute!
    
    % Clear FIFO buffers before sending data
    calllib('D4100_usb', 'ClearFifos', deviceNumber);
    %load first half of the screen
    chunk = rowData(1:length);
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
    chunk = rowData(length+1:end);
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
end

