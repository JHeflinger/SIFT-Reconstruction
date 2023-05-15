% My solutions for Fn, F, E, Ra, Rb, T, P1a, P1b, P1c, P1d, Xa, Xb,
% Xc, and Xd are stored in shed_results.mat.

% read a pair of images
%shed1corr = [158.51153564453125 202.6476287841797 238.5785369873047 242.64569091796875 242.64569091796875 329.6810607910156 335.68414306640625 345.5121765136719 346.0570068359375 381.2843933105469 387.9850158691406 391.8325500488281 394.2660827636719 432.7882385253906;
%285.4622802734375 156.0848846435547 266.08990478515625 262.755859375 262.755859375 241.12562561035156 232.65345764160156 203.5968475341797 202.90794372558594 235.21102905273438 193.46766662597656 162.8241729736328 170.14544677734375 262.57861328125;
%1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%shed2corr = [81.32493591308594 169.5692596435547 170.9026336669922 174.87315368652344 174.87315368652344 254.82403564453125 258.2394714355469 263.82122802734375 251.34422302246094 284.3818664550781 288.4932861328125 291.92626953125 293.9723205566406 357.3499755859375;
%273.1035461425781 154.21505737304688 261.8113098144531 259.58685302734375 259.58685302734375 242.30487060546875 233.8695068359375 204.5051727294922 203.5911865234375 238.89077758789062 193.58480834960938 171.00320434570312 168.16015625 273.2414245605469;
%1 1 1 1 1 1 1 1 1 1 1 1 1 1];
i1 = imread('myers1.ppm');
i2 = imread('myers2.ppm');
%i1 = imread('shed1.png');
%i2 = imread('shed2.png');

% load the corresponding points
%load('shed_correspondences');

% use the cpselect tool to check and adjust the correspondences
%[ipinput, ipbase] = cpselect(i1, i2, input_points, base_points, 'Wait', true);
ipinput = ip1(1:2,:)';
ipbase = ip2(1:2,:)';
% convert the 2-vectors to 3-vectors (i.e. points in P2)
%ip1 = [ipinput'; ones(1, size(input_points,1))];
%ip2 = [base_points'; ones(1, size(base_points,1))];
ip1 = [178.8334503173828 180.83128356933594 192.8053741455078 193.64308166503906 196.99647521972656 197.44454956054688 198.63345336914062 203.61752319335938 209.83392333984375 211.1698455810547 231.85679626464844 255.23121643066406 256.84210205078125 258.4913635253906 262.8692932128906 266.8345031738281 269.7663269042969 274.9075927734375 277.2796325683594 277.5701904296875 285.3266296386719 704.9591064453125 717.1170654296875 730.1334228515625 730.6701049804688 742.0963134765625 803.7133178710938 850.6522216796875;
686.8486938476562 686.6817016601562 73.20867919921875 687.60400390625 166.48654174804688 161.6317138671875 157.23829650878906 62.16267395019531 77.22354888916016 181.71417236328125 104.95598602294922 676.0814819335938 533.8837890625 678.3534545898438 481.94061279296875 446.15020751953125 330.4459228515625 390.96429443359375 344.9586486816406 515.8226928710938 490.3077392578125 407.63104248046875 417.64556884765625 406.8657531738281 393.3730773925781 413.2897033691406 418.3438720703125 416.0961608886719;
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
ip2 = [171.23052978515625 173.79652404785156 167.19859313964844 187.7768096923828 171.8981170654297 171.98495483398438 172.56787109375 174.05612182617188 183.76002502441406 189.24819946289062 206.5900421142578 261.1661682128906 255.79281616210938 264.399169921875 263.7507019042969 266.0861511230469 265.68035888671875 271.4024658203125 272.95556640625 275.9735412597656 283.9092712402344 714.1388549804688 733.565185546875 746.46337890625 749.6283569335938 754.2725219726562 802.3573608398438 839.7796020507812;
572.7888793945312 571.5586547851562 87.78453063964844 573.088134765625 164.05076599121094 160.480224609375 156.55319213867188 78.29019927978516 90.16129302978516 174.655517578125 112.53572845458984 563.6748046875 458.9776611328125 565.658203125 409.7314147949219 379.8442687988281 285.4270935058594 335.68035888671875 295.8979187011719 436.0898742675781 414.397705078125 322.03741455078125 331.4305725097656 320.597900390625 306.4362487792969 326.4327697753906 329.82342529296875 327.1728210449219;
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%showPoints(i1, i2, ipinput', ipbase');
% *** create a matlab function that will normalize the data ***

% calculate the transformation that will normalize the data
T1n = normalizePoints(ip1);
T2n = normalizePoints(ip2);

% apply the normalization to the image points
ipn1 = T1n*ip1;
ipn2 = T2n*ip2;

%mean(ipn1'), var(ipn1', 1)
%mean(ipn2'), var(ipn2', 1)
%y = size(ipinput,1)
mat = zeros(size(ipinput,1),9);
for i = 1:size(ipinput,1)
    secondx = ipn1(1,i);
    secondy = ipn1(2,i);
    firstx = ipn2(1,i);
    firsty = ipn2(2,i);
    mat(i,:) =  [secondx*firstx secondx*firsty secondx secondy*firstx secondy*firsty secondy firstx firsty 1];
end
[fu, fd, fv] = svd(mat);
fflat = fv(:,9);
Fnorm = [fflat(1) fflat(2) fflat(3); fflat(4) fflat(5) fflat(6); fflat(7) fflat(8) fflat(9)];
distances = zeros(size(ipinput,1),1);
for i = 1:size(ipinput,1)
    distances(i) = [ipn1(1,i) ipn1(2,i) 1] * Fnorm * [ipn2(1,i); ipn2(2,i); 1];
end
distances;
[fnu, fnd, fnv] = svd(Fnorm);
fnd(3,3) = 0;
newFnorm = fnu * fnd * fnv';
distancesNew = zeros(size(ipinput,1),1);
for i = 1:size(ipinput,1)
    distancesNew(i) = [ipn1(1,i) ipn1(2,i) 1] * newFnorm * [ipn2(1,i); ipn2(2,i); 1];
end
distancesNew;

F = T1n' * newFnorm * T2n;

distancesFinal = zeros(size(ipinput,1),1);
for i = 1:size(ipinput,1)
    distancesFinal(i) = [ip1(1,i) ip1(2,i) 1] * F * [ip2(1,i); ip2(2,i); 1];
end
distancesFinal
%for i = 1:2
    %fig = figure(2*i - 1);
    %clf;
    %imshow(i1);
    %hold on;
    %line1 = (ip1(:,i)' * F)'
    %h2 = plot(ip2(1,i), ip2(2,i), 'ro');
    %h = drawLine(line1, [0 size(i1,2) 0 size(i1,1)]);
    %set(h, 'MarkerSize', 5);
    %set(h, 'MarkerFaceColor', [0 1 1]);
    %set(h2, 'MarkerSize', 5);
    %set(h2, 'MarkerFaceColor', [1 0 0]);
    %saveas(fig, "firstImagePoint" + i, "jpg");

    %fig = figure(2*i);
    %clf;
    %imshow(i2);
    %hold on;
    %line2 = F * ip2(:,i)
    %h2 = plot(ip1(1,i), ip1(2,i), 'ro');
    %h = drawLine(line2, [0 size(i2,2) 0 size(i2,1)]);
    %set(h, 'MarkerSize', 5);
    %set(h, 'MarkerFaceColor', [0 1 1]);
    %set(h2, 'MarkerSize', 5);
    %set(h2, 'MarkerFaceColor', [1 0 0]);
    %saveas(fig, "secondImagePoint" + i, "jpg");
%end

K = [1584 0 593; 0 1584 380; 0 0 1];
K1 = K;
K2 = K;
%load('K1_K2');
% calculate E using F and K1, K2
Eprime = K1' * F * K2;
[epu, epd, epv] = svd(Eprime);
epd(3,3) = 0;
epd(1,1) = (epd(1,1) + epd(2,2)) / 2;
epd(2,2) = epd(1,1);
E = epu * epd * epv';
if(E(3,3) < 0)
    E = -E;
end
[eu, ed, ev] = svd(E);
W = [0 -1 0; 1 0 0; 0 0 1];
R1 = eu * W * ev';
R2 = eu * W' * ev';
T1 = eu(:,3);
T2 = -eu(:,3);
P1 = K2 * [eye(3) zeros(3,1)];
P2 = P1;
P3 = P1;
P4 = P1;
P1prime = K1 * [R1 T1]
P2prime = K1 * [R1 T2]
P3prime = K1 * [R2 T1]
P4prime = K1 * [R2 T2]
if(P1prime(3,3) < 0)
    P1prime = -P1prime;
end
if(P2prime(3,3) < 0)
    P2prime = -P2prime;
end
if(P3prime(3,3) < 0)
    P3prime = -P3prime;
end
if(P4prime(3,3) < 0)
    P4prime = -P4prime;
end
if(R1(3,3) < 0)
    R1 = -R1;
end
if(R2(3,3) < 0)
    R2 = -R2;
end
solutions = zeros(4,size(ipinput,1));
for i=1:size(ipinput,1)
    mat3d = [ip2(1,i) * P1(3,:) - P1(1,:); ip2(2,i) * P1(3,:) - P1(2,:); ip1(1,i) * P1prime(3,:) - P1prime(1,:); ip1(2,i) * P1prime(3,:) - P1prime(2,:)];
    %temp = null(mat3d)
    [mu, md, mv] = svd(mat3d);
    temp = mv(:,4);
    newTemp = temp / temp(4);
    solutions(:,i) = newTemp;
end
%plotPoints(solutions)
solutions
[R1 T1] * solutions




solutions2 = zeros(4,size(ipinput,1));
for i=1:size(ipinput,1)
    mat3d = [ip2(1,i) * P2(3,:) - P2(1,:); ip2(2,i) * P2(3,:) - P2(2,:); ip1(1,i) * P2prime(3,:) - P2prime(1,:); ip1(2,i) * P2prime(3,:) - P2prime(2,:)];
    %temp = null(mat3d)
    [mu, md, mv] = svd(mat3d);
    temp = mv(:,4);
    newTemp = temp / temp(4);
    solutions2(:,i) = newTemp;
end
%plotPoints(solutions2)
%for i=1:size(solutions2,2)
    %solutions2(:,i) = solutions2(:,i) / solutions2(4,i);
%end
%plotPoints(solutions2)
solutions2
solutions2Transformed = [R1 T2] * solutions2


solutions3 = zeros(4,size(ipinput,1));
for i=1:size(ipinput,1)
    mat3d = [ip2(1,i) * P3(3,:) - P3(1,:); ip2(2,i) * P3(3,:) - P3(2,:); ip1(1,i) * P3prime(3,:) - P3prime(1,:); ip1(2,i) * P3prime(3,:) - P3prime(2,:)];
    %temp = null(mat3d)
    [mu, md, mv] = svd(mat3d);
    temp = mv(:,4);
    newTemp = temp / temp(4);
    solutions3(:,i) = newTemp;
end
%plotPoints(solutions3)
%for i=1:size(solutions3,2)
    %solutions3(:,i) = solutions3(:,i) / solutions3(4,i);
%end
%plotPoints(solutions3)
solutions3
[R2 T1] * solutions3



solutions4 = zeros(4,size(ipinput,1));
for i=1:size(ipinput,1)
    mat3d = [ip2(1,i) * P4(3,:) - P4(1,:); ip2(2,i) * P4(3,:) - P4(2,:); ip1(1,i) * P4prime(3,:) - P4prime(1,:); ip1(2,i) * P4prime(3,:) - P4prime(2,:)];
    %temp = null(mat3d)
    [mu, md, mv] = svd(mat3d);
    temp = mv(:,4);
    newTemp = temp / temp(4);
    solutions4(:,i) = newTemp;
end
%for i=1:size(solutions4,2)
    %solutions4(:,i) = solutions4(:,i) / solutions4(4,i);
%end
%plotPoints(solutions4)
solutions4
[R2 T2] * solutions4


X = solutions2;
Pfinal = P2;
Pfinalprime = P2prime;
plotPoints(X)

polygons = {[52 39 41 40] [39 19 42 41] [19 38 44 43] [38 17 45 44] [53 54 55 56] [48 49 50 51] [33 34 35 36] [35 37 36] [39 53 38 19]}
npolygons = size(polygons, 2)
makeWireframe("wireframe.vrml", X, polygons, [0 0 1 3.14], 1)
world = vrworld('wireframe.vrml');
open(world);
view(world);
sets = extractTexture(i1, i2, X, eye(3), T1, K, polygons, Pfinal, Pfinalprime, ip2)
textureFileNames = {"Polygon1.png", "Polygon2.png", "Polygon3.png", "Polygon4.png", "Polygon5.png", "Polygon6.png", "Polygon7.png", "Polygon8.png", "Polygon9.png"};
makeTexturedModel("textured.vrml", X, polygons, textureFileNames, sets, [0 0 1 3.14], 1)
world = vrworld('textured.vrml');
open(world);
view(world);
