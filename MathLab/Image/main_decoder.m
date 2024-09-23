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
watermark = [Pload_cross; Pload_dot];
watermark = reshape(watermark, sqrt(length(watermark)), sqrt(length(watermark)));
figure(1)
imshow(watermark)

decode = cat(3, R, G, B);
decode = uint8(decode);
figure(2)
imshow(decode)
title('Decodering')
imwrite(decode, 'lena512_decoded.bmp');

