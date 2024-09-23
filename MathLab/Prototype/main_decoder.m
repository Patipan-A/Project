clc
close all
clear all

%  load a image data
% originalImage = rgb2gray(imread('lenanew.tiff'));
originalImage = imread('lena512_encoder.bmp');

%  show the image
figure(1)
imshow(originalImage)

% changes data to be double
originalImage = double(originalImage);

% collect information in dot cell {c,r,D,var,u',U,U}
dot_data = dotset(originalImage);
[image_dot_decoding,Pload_dot]=decoding(dot_data,originalImage);

cross_data = crossset(image_dot_decoding);
[image_cross_decoding,Pload_cross]=decoding(cross_data,image_dot_decoding);

figure(2)
imshow(uint8(image_cross_decoding))

watermark =[Pload_cross;Pload_dot];
watermark = reshape(watermark,sqrt(length(watermark)),sqrt(length(watermark)));
figure(3)
imshow(watermark)  
