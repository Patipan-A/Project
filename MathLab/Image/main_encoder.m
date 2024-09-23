clc;
close all;
clear all;

% Load an original image.
originalImage = imread('lenanew.tiff');
figure(1);
imshow(originalImage);
title('Original Image');
% Sperate an original image to RGB plane.
R = double(originalImage(:,:,1));
G = double(originalImage(:,:,2));
B = double(originalImage(:,:,3));
% Load and resize a watermark.
watermark = im2bw(imresize(imread('lenanew.tiff'),0.8),0.8);
figure(2)
imshow(watermark);
watermark = double(watermark);
watermark = watermark(:)';
Pload_cross = watermark(1:length(watermark)/2);
Pload_dot = watermark(length(watermark)/2+1:end);
% Define parameter.
max_kb = 26;
maxT = 24;
Tn = [1;1]*(-1:-1:-maxT);
Tp = [1;1]*(1:maxT-1);
TpTnpsnr = zeros(numel(Tn),3);
TpTnpsnr(:,1:2) = [[0; Tp(:); maxT] Tn(:)];

% Proccessing a plane.
currentImage = R;
cross_data = crossset(currentImage);

for ii = 1:size(TpTnpsnr,1)
    Tp = TpTnpsnr(ii,1);
    Tn = TpTnpsnr(ii,2);
    [embeded_cross_image, PLcheckcross] = embeded_modification2(cross_data, Pload_cross, Tp, Tn, currentImage);
    
    dot_data = dotset(embeded_cross_image);
    [embeded_dot_image, PLcheckdot] = embeded_modification2(dot_data, Pload_dot, Tp, Tn, embeded_cross_image);
    
    if PLcheckcross * PLcheckdot == 1
        Mean2err = sum(sum((embeded_dot_image - currentImage).^2)) / (numel(currentImage));
        sdf = 255^2 / Mean2err;
        PSNR = 10 * log10(sdf);
        TpTnpsnr(ii,3) = PSNR;
        ypsnr = PSNR;
        xbps = length(watermark) / numel(currentImage);
        figure(3);
        mapp = colormap(lines(size(TpTnpsnr,1)));
        figure(4);
        plot(xbps, ypsnr, '.-', 'Color', mapp(ii,:)), axis([0 1 25 60]), hold on, grid on;
        title(['Tp = ', num2str(Tp), ' Tn = ', num2str(Tn)]);
    end
    
    if sum(TpTnpsnr(:,3) > 0) > 2
        break;
    end
end

% Optimize value.
[oypsnr, Id] = max(TpTnpsnr(:,3));
[embeded_cross_image, PLcheckcross] = embeded_modification2(cross_data, Pload_cross, TpTnpsnr(Id,1), TpTnpsnr(Id,2), currentImage);
dot_data = dotset(embeded_cross_image);
[embeded_dot_image, PLcheckdot] = embeded_modification2(dot_data, Pload_dot, TpTnpsnr(Id,1), TpTnpsnr(Id,2), embeded_cross_image);
R = embeded_dot_image;

embeded = cat(3, R, G, B);
embeded = uint8(embeded);
imwrite(embeded, 'lena512_encoder.bmp');
figure(5);
imshow(embeded);
title('Encryption Image');
