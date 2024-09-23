import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
from crossset import crossset
from dotset import dotset
from embeded_modification2 import embeded
# Import an image.
original_image = Image.open('lenanew.tiff')
original_image = np.double(original_image)
image_array = np.array(original_image)
# Divide RGB plane.
R = image_array[:, :, 0]  
G = image_array[:, :, 1]  
B = image_array[:, :, 2]  
currentImage = R
cross_data = crossset(currentImage)
# Convert image to grayscale.
watermark = Image.open('w.bmp').convert("L")
threshold = 0.8 * 255  
watermark = watermark.point(lambda p: 1.0 if p > threshold else 0.0)
watermark = np.array(watermark)
# Convert datatype to double.
watermark = watermark.astype(np.float64)  
# A column matrix.
watermark = watermark.flatten()
# Separate half watermark.
half_length = len(watermark) // 2
first_half = []
second_half = []
for i in range(len(watermark)):
    if i < half_length:
        first_half.append(watermark[i])
    else:
        second_half.append(watermark[i])
# Convert to array.
Pload_cross = np.array(first_half)
Pload_dot = np.array(second_half)
# Set.
max_kb = 26
maxT = 24
Tn = np.repeat(-np.arange(1, maxT+1), 2).reshape(-1, 1)
Tp = np.repeat(np.arange(1, maxT), 2).reshape(-1, 1)
TpTnpsnr = np.zeros((len(Tn), 3))
TpTnpsnr[:, 0] = np.concatenate((np.array([0]), Tp.flatten(), np.array([maxT])))
TpTnpsnr[:, 1] = Tn.flatten()

# Opimize value. 
oypsnr = np.max(TpTnpsnr[:, 2])
Id = np.argmax(TpTnpsnr[:, 2])  
embeded_cross_image, PLcheckcross = embeded(cross_data, Pload_cross, TpTnpsnr[Id, 0], TpTnpsnr[Id, 1], currentImage)
dot_data = dotset(embeded_cross_image)
embeded_dot_image, PLcheckdot = embeded(dot_data, Pload_dot, TpTnpsnr[Id, 0], TpTnpsnr[Id, 1], embeded_cross_image)
R = embeded_dot_image

embeded = np.stack((R, G, B), axis=-1)
embeded = (embeded * 255).astype(np.uint8)
image = Image.fromarray(embeded)
image.save('corrected_rgb_image.png')
image.show()

# emb = np.concatenate((R[:, :, np.newaxis], G[:, :, np.newaxis], B[:, :, np.newaxis]), axis=-1)
# emb = (emb * 255).astype(np.uint8)
# print(emb)

# image = Image.fromarray(emb)
# image.save('output_image.png')

# image.show()
# image = Image.fromarray(combined_image)
# image.save('encoder.tiff')
# image.show()