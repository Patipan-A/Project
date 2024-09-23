clc;
clear all;

% อ่านภาพ
image1 = imread('lenanew.tiff'); % เปลี่ยนเป็นชื่อไฟล์ของคุณ
image2 = imread('lena512_encoder.bmp'); % เปลี่ยนเป็นชื่อไฟล์ของคุณ

% ตรวจสอบขนาดของภาพ
if ~isequal(size(image1), size(image2))
    error('ขนาดของภาพไม่ตรงกัน');
end

% แปลงภาพเป็น double เพื่อการคำนวณที่แม่นยำ
image1 = double(image1);
image2 = double(image2);

% แยกแต่ละเพลนสี
image1R = image1(:,:,1); % Red channel of image1
image1G = image1(:,:,2); % Green channel of image1
image1B = image1(:,:,3); % Blue channel of image1

image2R = image2(:,:,1); % Red channel of image2
image2G = image2(:,:,2); % Green channel of image2
image2B = image2(:,:,3); % Blue channel of image2

% คำนวณความแตกต่างของพิกเซลในแต่ละเพลนสี
diffR = abs(image1R - image2R);
diffG = abs(image1G - image2G);
diffB = abs(image1B - image2B);

% แสดงผลลัพธ์
subplot(3, 3, 1);
imshow(uint8(image1R));
title('Image 1 Red Channel');

subplot(3, 3, 2);
imshow(uint8(image2R));
title('Image 2 Red Channel');

subplot(3, 3, 3);
imshow(uint8(diffR));
title('Difference Red Channel');

subplot(3, 3, 4);
imshow(uint8(image1G));
title('Image 1 Green Channel');

subplot(3, 3, 5);
imshow(uint8(image2G));
title('Image 2 Green Channel');

subplot(3, 3, 6);
imshow(uint8(diffG));
title('Difference Green Channel');

subplot(3, 3, 7);
imshow(uint8(image1B));
title('Image 1 Blue Channel');

subplot(3, 3, 8);
imshow(uint8(image2B));
title('Image 2 Blue Channel');

subplot(3, 3, 9);
imshow(uint8(diffB));
title('Difference Blue Channel');

% คำนวณ Mean Squared Error (MSE) และ Peak Signal-to-Noise Ratio (PSNR) สำหรับแต่ละเพลนสี
mseR = mean((image1R(:) - image2R(:)).^2);
mseG = mean((image1G(:) - image2G(:)).^2);
mseB = mean((image1B(:) - image2B(:)).^2);

% คำนวณ Peak Signal-to-Noise Ratio (PSNR)
maxPixelValue = 255; % สำหรับภาพแบบ uint8
psnrR = 10 * log10((maxPixelValue^2) / mseR);
psnrG = 10 * log10((maxPixelValue^2) / mseG);
psnrB = 10 * log10((maxPixelValue^2) / mseB);

% แสดงผลลัพธ์ MSE และ PSNR
fprintf('Mean Squared Error (MSE) for Red Channel: %.2f\n', mseR);
fprintf('Peak Signal-to-Noise Ratio (PSNR) for Red Channel: %.2f dB\n', psnrR);

fprintf('Mean Squared Error (MSE) for Green Channel: %.2f\n', mseG);
fprintf('Peak Signal-to-Noise Ratio (PSNR) for Green Channel: %.2f dB\n', psnrG);

fprintf('Mean Squared Error (MSE) for Blue Channel: %.2f\n', mseB);
fprintf('Peak Signal-to-Noise Ratio (PSNR) for Blue Channel: %.2f dB\n', psnrB);
