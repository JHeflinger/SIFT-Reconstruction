#KNN Code from https://medium.com/analytics-vidhya/opencv-feature-matching-sift-algorithm-scale-invariant-feature-transform-16672eafb253

import numpy as np
import cv2
import matplotlib.pyplot as plt
import os

# read two input images as grayscale
script_dir = os.path.dirname(__file__) #<-- absolute dir the script is in
rel_path1 = "../Resources/myers1.png"
abs_file_path1 = os.path.join(script_dir, rel_path1)
rel_path2 = "../Resources/myers2.png"
abs_file_path2 = os.path.join(script_dir, rel_path2)
img1 = cv2.imread(abs_file_path1,0)
img2 = cv2.imread(abs_file_path2,0)

# Initiate SIFT detector
sift = cv2.SIFT_create()

#Mask from: https://stackoverflow.com/questions/42346761/opencv-python-feature-detection-how-to-provide-a-mask-sift

# mask1 = np.ones(img1.shape)
# mask2 = np.ones(img2.shape)
# mask1 = mask1.astype(np.uint8)
# mask2 = mask2.astype(np.uint8)
# kp1, des1 = sift.detectAndCompute(img1, mask = mask1)
# kp2, des2 = sift.detectAndCompute(img2, mask = mask2)
# detect and compute the keypoints and descriptors with SIFT
kp1, des1 = sift.detectAndCompute(img1,None)
kp2, des2 = sift.detectAndCompute(img2,None)

# create BFMatcher object
bf = cv2.BFMatcher()

# Match descriptors.
# matches = bf.match(des1,des2)

# knn version

matches = bf.knnMatch(des1, des2,k=2)

good = []

for m,n in matches:
    if m.distance < 0.75*n.distance:
       good.append([m])

       

# sort the matches based on distance
#matches = sorted(matches, key=lambda val: val.distance)


# Draw first 50 matches.
out = cv2.drawMatchesKnn(img1, kp1, img2, kp2, good, None, flags=2)
#out = cv2.drawMatches(img1, kp1, img2, kp2, matches[:50], None, flags=2)
plt.imshow(out), plt.show()
# http://www.bim-times.com/opencv/3.3.0/d1/de0/tutorial_py_feature_homography.html
if len(good)>10:
    src_pts = np.float32([ kp1[m.queryIdx].pt for m in good ]).reshape(-1,1,2)
    dst_pts = np.float32([ kp2[m.trainIdx].pt for m in good ]).reshape(-1,1,2)
    M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC,5.0)
    matchesMask = mask.ravel().tolist()
    h,w,d = img1.shape
    pts = np.float32([ [0,0],[0,h-1],[w-1,h-1],[w-1,0] ]).reshape(-1,1,2)
    dst = cv2.perspectiveTransform(pts,M)
    img2 = cv2.polylines(img2,[np.int32(dst)],True,255,3, cv2.LINE_AA)
else:
    print( "Not enough matches are found - {}/{}".format(len(good), 10) )
    matchesMask = None