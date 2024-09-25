import numpy as np
import cv2 
from PIL import Image
import matplotlib.pyplot as plt
from crossset import crossset
from dotset import dotset
from embeded_modification2 import embeded
np.set_printoptions(threshold=np.inf)
# Import an image.
original_image = Image.open('lenanew.tiff')
image_array = np.array(original_image)
# Divide RGB plane.
R = image_array[:, :, 0]
G = image_array[:, :, 1]  
B = image_array[:, :, 2]  
R = R.astype(float)
G = G.astype(float)
B = B.astype(float)
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
# Complie RGB plane.
R = np.clip(R, 0, 255)
G = np.clip(G, 0, 255)
B = np.clip(B, 0, 255)
np.savetxt('image_array.txt', G.reshape(-1, G.shape[-1]), fmt='%d')
img_reconstructed = np.stack([B, G, R], axis=-1).astype(np.uint8)
cv2.imwrite('reconstructed_image.png', img_reconstructed)
