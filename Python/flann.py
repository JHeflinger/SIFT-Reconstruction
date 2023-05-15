import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt
import os
MIN_MATCH_COUNT = 20
script_dir = os.path.dirname(__file__) #<-- absolute dir the script is in
rel_path1 = "../Resources/myers1.png"
# rel_path1 = "../Resources/root_quadrangle01.ppm"
abs_file_path1 = os.path.join(script_dir, rel_path1)
rel_path2 = "../Resources/myers2.png"
# rel_path2 = "../Resources/root_quadrangle02.ppm"
abs_file_path2 = os.path.join(script_dir, rel_path2)
img1 = cv.imread(abs_file_path1,0)
img2 = cv.imread(abs_file_path2,0)
# Initiate SIFT detector
sift = cv.SIFT_create()
# find the keypoints and descriptors with SIFT
kp1, des1 = sift.detectAndCompute(img1,None)
kp2, des2 = sift.detectAndCompute(img2,None)
FLANN_INDEX_KDTREE = 1
index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
search_params = dict(checks = 50)
flann = cv.FlannBasedMatcher(index_params, search_params)
matches = flann.knnMatch(des1,des2,k=2)
# store all the good matches as per Lowe's ratio test.
good = []
for m,n in matches:
    if m.distance < 0.75*n.distance:
        good.append(m)

if len(good)>MIN_MATCH_COUNT:
    src_pts = np.float32([ kp1[m.queryIdx].pt for m in good ]).reshape(-1,1,2)
    dst_pts = np.float32([ kp2[m.trainIdx].pt for m in good ]).reshape(-1,1,2)
    M, mask = cv.findHomography(src_pts, dst_pts, cv.RANSAC,20.0)
    #print(M)
    matchesMask = mask.ravel().tolist()
    h,w = img1.shape
    pts = np.float32([ [0,0],[0,h-1],[w-1,h-1],[w-1,0] ]).reshape(-1,1,2)
    dst = cv.perspectiveTransform(pts,M)
    img2 = cv.polylines(img2,[np.int32(dst)],True,255,3, cv.LINE_AA)
else:
    print( "Not enough matches are found - {}/{}".format(len(good), MIN_MATCH_COUNT) )
    matchesMask = None

list_kp1 = []
list_kp2 = []

# For each match...
for i in range(len(good)):
    if(matchesMask[i] != 1):
        continue
    mat = good[i]
    # Get the matching keypoints for each of the images
    img1_idx = mat.queryIdx
    img2_idx = mat.trainIdx

    # x - columns
    # y - rows
    # Get the coordinates
    (x1, y1) = kp1[img1_idx].pt
    (x2, y2) = kp2[img2_idx].pt

    # Append to each list
    list_kp1.append((x1, y1))
    list_kp2.append((x2, y2))
print("[",end="")
for i in range(2):
    for j in range(len(list_kp1)):
        if(j == len(list_kp1) - 1):
            if(i == 1):
                print(str(round(list_kp1[j][i],1)) + "]")
            else:
                print(str(round(list_kp1[j][i],1)) + ";")
        else:
            print(str(round(list_kp1[j][i],1)) + " ",end="")
print("[",end="")
for i in range(2):
    for j in range(len(list_kp2)):
        if(j == len(list_kp2) - 1):
            if(i == 1):
                print(str(round(list_kp2[j][i],1)) + "]")
            else:
                print(str(round(list_kp2[j][i],1)) + ";")
        else:
            print(str(round(list_kp2[j][i],1)) + " ",end="")
                
draw_params = dict(matchColor = (0,255,0), # draw matches in green color
                   singlePointColor = None,
                   matchesMask = matchesMask, # draw only inliers
                   flags = 2)
img3 = cv.drawMatches(img1,kp1,img2,kp2,good,None,**draw_params)
plt.imshow(img3, 'gray'),plt.show()