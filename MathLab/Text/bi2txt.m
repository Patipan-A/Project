% An original text file.
originalText = fileread('text_file.txt');

% Convert text to binary.
Data = textToBinary(originalText);
% Convert binary to text.

reconstructedText = binaryToText(Data);
% Save file decoding.
outputFilename = 'decoding_text_file.txt';
% Open file.
fid = fopen(outputFilename, 'w');
if fid == -1
    error('Cannot open file for writing.');
end
fprintf(fid, '%s', reconstructedText); 
fclose(fid); 

% Function convert text to binary.
function binaryData = textToBinary(text)
    % Convert text to uint8.
    byteData = uint8(text);
    % Convert uint8 to binary.
    % Binry array.    
    binaryData = false(1, numel(byteData) * 8); 
    for i = 1:length(byteData)
        % Convert each uint8 to binary 8 bits.
        bits = dec2bin(byteData(i), 8) - '0';  
        % Collect in binary array.        
        binaryData((i-1)*8+1:i*8) = logical(bits);  
    end
end

% Function convert binary to text.
function text = binaryToText(binaryData)
    % Chect binary text equals 8 bits. 
    if mod(length(binaryData), 8) ~= 0
        error('Binary data length must be a multiple of 8.');
    end
    % Convert binary to uint8.
    % uint8 array.
    byteData = uint8(zeros(1, length(binaryData)/8)); 
    for i = 1:length(byteData)
        byteData(i) = bin2dec(char(binaryData((i-1)*8+1:i*8) + '0'));  
    end
    text = char(byteData);
end
