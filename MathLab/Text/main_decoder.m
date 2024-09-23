clc;
close all;
clear all;
% load a image data
originalImage = imread('lena512_encoder.bmp');
% Sperate an original image to RGB plane.
R = double(originalImage(:,:,1));
G = double(originalImage(:,:,2));
B = double(originalImage(:,:,3));
% changes data to be double
currentImage = R;

dot_data = dotset(currentImage);

% collect information in dot cell {c,r,D,var,u',U,U}
[image_dot_decoding, Pload_dot] = decoding(dot_data, currentImage);

cross_data = crossset(image_dot_decoding);
[image_cross_decoding, Pload_cross] = decoding(cross_data, image_dot_decoding);

R = image_cross_decoding;
watermark = [Pload_cross(:); Pload_dot(:)]';

reconstructedText = binaryToText(watermark);

% Save text in file.
outputFilename = 'reconstructed_text_file.txt';
% Open file for collect text decoding.
fid = fopen(outputFilename, 'w'); 
if fid == -1
    error('Cannot open file for writing.');
end
% Write text in new file.
fprintf(fid, '%s', reconstructedText); 
fclose(fid); 



% แสดงข้อความที่ได้
disp('Recovered Text:');
decode = cat(3, R, G, B);
decode = uint8(decode);
figure(2)
imshow(decode)
title('Decodering')
imwrite(decode, 'lena512_decoded.bmp');



% ฟังก์ชันสำหรับแปลงไบนารีกลับเป็นข้อความ
function text = binaryToText(binaryData)
    % ตรวจสอบให้แน่ใจว่าขนาดของ binaryData เป็นจำนวนเต็ม 8
    if mod(length(binaryData), 8) ~= 0
        error('Binary data length must be a multiple of 8.');
    end
    
    % แปลงไบนารีเป็นไบต์
    byteData = uint8(zeros(1, length(binaryData)/8)); % เตรียม array สำหรับไบต์
    for i = 1:length(byteData)
        byteData(i) = bin2dec(char(binaryData((i-1)*8+1:i*8) + '0'));  % แปลงกลับเป็นไบต์
    end

    % แปลงไบต์กลับเป็นข้อความ
    text = char(byteData);
end


