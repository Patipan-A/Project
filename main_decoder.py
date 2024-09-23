import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
from dotset import dotset

# Import an image.
original_image = Image.open('lenanew.tiff')
image_array = np.array(original_image)

# Divide RGB plane.
R = image_array[:, :, 0]  
G = image_array[:, :, 1]  
B = image_array[:, :, 2]  

currentImage = R
dot_data = dotset(currentImage)
    
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

