#KNN Code from https://medium.com/analytics-vidhya/opencv-feature-matching-sift-algorithm-scale-invariant-feature-transform-16672eafb253

import numpy as np
import cv2
import matplotlib.pyplot as plt
import os

# read two input images as grayscale
script_dir = os.path.dirname(__file__) #<-- absolute dir the script is in
rel_path1 = "../Resources/shed1.png"
abs_file_path1 = os.path.join(script_dir, rel_path1)
rel_path2 = "../Resources/shed2.png"
abs_file_path2 = os.path.join(script_dir, rel_path2)
img1 = cv2.imread(abs_file_path1,1)
img2 = cv2.imread(abs_file_path2,1)

# Initiate SIFT detector
sift = cv2.SIFT_create()

# detect and compute the keypoints and descriptors with SIFT
kp1, des1 = sift.detectAndCompute(img1,None)
kp2, des2 = sift.detectAndCompute(img2,None)

# create BFMatcher object
bf = cv2.BFMatcher()

# Match descriptors.
#matches = bf.match(des1,des2)
matches = bf.knnMatch(des1, des2,k=2)

good = []

for m,n in matches:
    if m.distance < 0.75*n.distance:
       good.append([m])

# sort the matches based on distance
#matches = sorted(matches, key=lambda val: val.distance)


# Draw first 50 matches.
out = cv2.drawMatchesKnn(img1, kp1, img2, kp2, good[:50], None, flags=2)
plt.imshow(out), plt.show()