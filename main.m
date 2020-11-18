clear all 
clc
close all 

% read pictures
Image1 = imread('picgauche.jpg');  
Image2 = imread('picdroite.jpg'); 

% convert to grayscale
Image1 = rgb2gray(Image1);
Image2 = rgb2gray(Image2);
%% detection des points d'intéret 
Image1Points = detectSURFFeatures(Image1); 
Image2Points = detectSURFFeatures(Image2);

%% affichage des points d'interét
figure;   
imshow(Image1);
title('Interest Points Img1');
hold on;
plot(Image1Points.selectStrongest(50));
stg1=Image1Points.selectStrongest(50);

figure;  
imshow(Image2);
title('Interest Points Img2');
hold on;
plot(Image2Points.selectStrongest(50)); 
stg2=Image2Points.selectStrongest(50);
% extraction des points d'interets 
[Features1, Points1] = extractFeatures(Image1, stg1);
[Features2, Points2] = extractFeatures(Image2, stg2);
% correspondances des points d'interets 
indexPairs = matchFeatures(Features1, Features2);  
matchedPoints1 = Points1(indexPairs(:, 1), :);
matchedPoints2 = Points2(indexPairs(:, 2), :);
figure;
showMatchedFeatures(Image1, Image2, matchedPoints1,matchedPoints2,'montage');

title('MatchedFeatures');

  K=[2.005488077317492e+03, 0 , 0;0,1.998288908331825e+03,0; 7.149445514133121e+02, 1.271312756711674e+03 , 1]
  fundamentalMatrix = eightPoint(matchedPoints1.Location, matchedPoints2.Location);
  fundamentalMatrix

  %essentialMatrix
  E = K' * fundamentalMatrix * K;
  E
  
  %% decompose E
  [U, D, V] = svd(E);
  e = (D(1,1) + D(2,2)) / 2;
  D(1,1) = e;
  D(2,2) = e;
  D(3,3) = 0;
  E = U * D * V';
  [U, ~, V] = svd(E);
  W=[0 -1 0;1 0 0;0 0 1];
  Z = [0 1 0;-1 0 0;0 0 0];
  R1 = U * W * V';
  R2 = U * W' * V';
  if det(R1) < 0
      R1 = -R1;
  end
  if det(R2) < 0
      R2 = -R2;
  end
  Tx = U * Z * U';
  t = -[Tx(3, 2), Tx(1, 3), Tx(2, 1)]
  R=R1'
