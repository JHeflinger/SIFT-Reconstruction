% Calculate the plane formed by the 3D vertices of the polygon using
% X'*pi = 0.  Let A be a matrix built using several points.


% *** Fill in your code *** A =
function tchset = extractTexture(i1, i2, X, R, T, K, polygons, P, Pprime, ip2);
tchset = {}
planes = zeros(4,size(polygons,2));
size(polygons{1},2)
size(polygons,2)

for i=1:size(polygons,2)
    mat = zeros(size(polygons{i},2),4);
    for j=1:size(polygons{i},2) 
        mat(j,:) = X(:,polygons{i}(j));
    end
    [U D V] = svd(mat);
    mat
    plane = V(:,size(V,2));
    planes(:,i) = plane(:);
    %planes(:,i) = plane(1:3) / plane(4)
end
planes


% (Optional) Use the image that is closest to being fronto-parallel
% Use the magnitude of the dot product between plane's normal and the
% camera's optical axis to decide.  The largest magnitude (reguardless
% of sign) is closest to fronto-parallel.
%choices = zeros(1,size(planes,2));
%for i=1:size(planes,2)
    %abs(planes(:,i)' * P(3,:)') < abs(planes(:,i)' * Pprime(3,:)')
    %if(abs(planes(:,i)' * P(3,:)') < abs(planes(:,i)' * Pprime(3,:)'))
        %choices(1,i) = 0;
    %else
        %choices(1,i) = 1;
    %end
%end
%choices

  
% (Probably optional) The polygon should be facing the camera

% *** Fill in your code ***


% Calculate a rotation matrix which will align the polygon normal with
% the optical axis of the camera.  We choose the new x axis so that it
% is perpendicular to the new z and old y axes.  The new y axis is
% chosen to be perpendicular to the new x and z axes.
rots2 = [];
for i=1:size(planes,2)
    normal = planes(1:3,i);
    z = normal/norm(normal);
    x = cross(R(2,:),z);
    y = cross(x,z);

    rots2 = cat(3,rots2, [x;y;z'])
end
for i=1:size(polygons,2)

    H = K * rots2(:,:,i) * inv(R) * inv(K)
    %if(H(3,3) < 0)
        %H = -H;
    %end
    mat = zeros(size(polygons{i},2),4);
    tchtemp =  zeros(3,size(polygons{i},2));
    for j=1:size(polygons{i},2) 
       tchtemp(:,j) = H * ip2(:,polygons{i}(j));
    end
    tchtemp
    tch = zeros(2,size(polygons{i},2));
    for j=1:size(polygons{i},2) 
       tch(1,j) = tchtemp(1,j) / tchtemp(3,j)
       tch(2,j) = tchtemp(2,j) / tchtemp(3,j)
    end
    tcmin = min(tch')
    tcmax = max(tch')
    

    T = maketform('projective', H');
    image = i2;
    texture = imtransform(image, T, 'XData', [tcmin(1,1) tcmax(1,1)], 'YData', [tcmin(1,2) tcmax(1,2)]);
    [height width depth] = size(texture);
    tch
    tch = tch - tcmin'
    tch(1,:) = tch(1,:) / width
    tch(2,:) = tch(2,:) / height
    tch(2,:) = 1 - tch(2,:)
    str = sprintf('%s%d.png', "Polygon", i);
    imwrite(texture, str);
    tchset{i} = tch;
end




% Construct homography that will rectify image.  Be sure to take into
% account the rotation of the camera (R) and the camera calibration
% (K) in a manner similar to that of problem set 3.

% *** Fill in your code *** H =


% Calculate the new texture coordinates by applying H to the image
% coordinates (in the appropriate image) of the vertices of the
% polygon


% Find the minimum and maximum coordinates of the polygon we're after



% Transform just the region of the image we're after


% Get the size of the resulting image


% Adjust the texture coordinates so they range from 0 to 1 with the
% origin in the bottom left of the image.




% Convert the texture coordinates back to non-homgeneous coordinates

% *** Fill in your code *** tc =
