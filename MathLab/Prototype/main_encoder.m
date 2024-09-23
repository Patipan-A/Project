clc
close all
clear all

% load a image data
% originalImage = imread('WatSothornR.tif');
% originalImage = rgb2gray(imread('peppers.tiff'));
% originalImage = 0.98039*rgb2gray(imread('QR Code V40.png'));
 originalImage = rgb2gray(imread('lenanew.tiff'));
% originalImage = rgb2gray(imread('baboon512.tif'));
% originalImage = rgb2gray(imread('jetnew.tiff'));
% originalImage = rgb2gray(imread('barbara512.tif'));
% originalImage = rgb2gray(imread('MRI.jpg'));
% originalImage = rgb2gray(imread('ultrasound.jpg'));
% originalImage = imread('brain.tif');

% show the image
figure(1)
imshow(originalImage)

% changes data to be double
originalImage = double(originalImage);

% collect information in cross cell {c,r,d,var,u',u,u}
cross_data = crossset(originalImage);

% figure(2)
% plot(cross_data(:,3)),axis([0 length(cross_data(:,3)) -80 80]) 
% 
% maximum of watermaking side (10^3 bits)
max_kb=26;

% The set of a threshold finetuning
maxT=24;
Tn=[1;1]*(-1:-1:-maxT);
Tp=[1;1]*(1:maxT-1);

% This is a variable to collect the PSNR for all thresthold and payload.
TpTnpsnr=zeros(numel(Tn),3);
TpTnpsnr(:,1:2)=[[0;Tp(:);maxT] Tn(:)];

% watermerk=[10e3*(1:max_kb-1) 10e3*max_kb-1800];
% watermark = im2bw(imresize(imread('doraemon.bmp'),1),0.8);
watermark = im2bw(imresize(imread('lenanew.tiff'),0.8),0.8);
% watermark = im2bw(imresize(imread('happybiosis.bmp'),0.5),0.8);
% watermark = im2bw(imresize(imread('logo.bmp'),0.5),0.8);
% watermark = im2bw(imresize(imread('happy.bmp'),0.5),0.8);
% watermark = im2bw(imresize(imread('GN_brcode.jpg'),1),0.8);
% watermark = im2bw(imresize(imread('brcode_c.bmp'),1),0.8);
% watermark = im2bw(imresize(imread('eeg.jpg'),0.5),0.8);
% watermark = im2bw(imresize(imread('GN_brcode.jpg'),0.81),0.8);

figure(5)
imshow(watermark)


watermark = watermark(:)';
Pload_cross = watermark(1:length(watermark)/2);
Pload_dot = watermark(length(watermark)/2+1:end);



% kb=3;

for ii=1:size(TpTnpsnr,1)
%     kb=kb-2; % step back by 3
%     ypsnr=NaN(1,max_kb); xbps=NaN(1,max_kb);
    Tp=TpTnpsnr(ii,1);
    Tn=TpTnpsnr(ii,2);

%     while  kb<=max_kb
        % Payload for cross and dot set.
%         Pload=randint(1,round(watermerk(kb)/2),[0 1]);
        
        % The function is used to modify and embed a payload into cross set
        % If PLcheckcross = 1, it means set E is enough to put payload.
        % If PLcheckcross = 0, it means set E is not enough to put payload.
        
        [embeded_cross_image,PLcheckcross]=embeded_modification2(cross_data,Pload_cross,Tp,Tn,originalImage);
        
        
        % collect information in dot cell {c,r,d,var,u',u,u}
        dot_data = dotset(embeded_cross_image); 
                     
        % The function is used to modify and embed a payload into dot set
        % If PLcheckdot = 1, it means set E is enough to put payload.
        % If PLcheckdot = 0, it means set E is not enough to put payload.       
        [embeded_dot_image,PLcheckdot]=embeded_modification2(dot_data,Pload_dot,Tp,Tn,embeded_cross_image);
      
        if PLcheckcross*PLcheckdot==1
            Mean2err=sum(sum((embeded_dot_image-originalImage).^2))/(numel(originalImage));
            sdf=255^2./(Mean2err);
            PSNR = 10*log10(sdf); 
            TpTnpsnr(ii,3)= PSNR;
            
            ypsnr=PSNR;
            xbps=length(watermark)/numel(originalImage);
            figure(2)
            % This is colour map to show in the graph.
            mapp=colormap(lines(size(TpTnpsnr,1)));
            plot(xbps,ypsnr,'.-','Color',mapp(ii,:)),axis([0 1 25 60]),hold on,grid on
            title(['Tp = ',num2str(Tp),'           Tn =  ',num2str(Tn)])
        end
        if  sum(TpTnpsnr(:,3)>0)>2
            break;
        end
            
        

%      end
end
[oypsnr Id]=max(TpTnpsnr(:,3));
% cross_data = crossset(originalImage);
[embeded_cross_image,PLcheckcross]=embeded_modification2(cross_data,Pload_cross,TpTnpsnr(Id,1),TpTnpsnr(Id,2),originalImage);
% collect information in dot cell {c,r,d,var,u',u,u}
dot_data = dotset(embeded_cross_image); 
% The function is used to modify and embed a payload into dot set
% If PLcheckdot = 1, it means set E is enough to put payload.
% If PLcheckdot = 0, it means set E is not enough to put payload.       
[embeded_dot_image,PLcheckdot]=embeded_modification2(dot_data,Pload_dot,TpTnpsnr(Id,1),TpTnpsnr(Id,2),embeded_cross_image);
figure(3)
imshow(uint8(embeded_dot_image))

% oypsnr=max(TpTnpsnr(:,3:end));
% oxbps=watermark/(numel(originalImage));
% figure(3)
% plot(oxbps,oypsnr,'b.-'),axis([0 1 30 60]),hold on,grid on
% title('Lena')

imwrite(uint8(embeded_dot_image),'lena512_encoder.bmp')    


% embeded_dot_image = double(embeded_dot_image);

% collect information in dot cell {c,r,D,var,u',U,U}
% dot_data_decode = dotset(embeded_dot_image);
% [image_dot_decoding,Pload_dot]=decoding(dot_data_decode,embeded_dot_image);
% 
% cross_data_decode = crossset(image_dot_decoding);
% [image_cross_decoding,Pload_cross]=decoding(cross_data_decode,image_dot_decoding);
% 
% figure(4)
% imshow(uint8(image_cross_decoding))
% 
% watermark =[Pload_cross;Pload_dot];
% watermark = reshape(watermark,sqrt(length(watermark)),sqrt(length(watermark)));
% figure(5)
% imshow(watermark)
% 
% sum(sum(image_cross_decoding~=originalImage))



