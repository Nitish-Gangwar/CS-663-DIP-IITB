clc;clear;close all;
im_f = double(imread("01_02_stranger_flash.jpg"));
amb = double(imread("01_01_stranger_no_flash.jpg"));

%%Convert image to ycbcr
Fycbcr = rgb2ycbcr(im_f); 
Aycbcr=rgb2ycbcr(amb);


%%select the chrominance channel
Fcr = Fycbcr(:,:,3);
Acr = Aycbcr(:,:,3);

%Redness measure
R = Fcr - Acr ;
tauEye = 0.05;
tauDark = 0.6;
%imshow(R);
Red=R;
Red(R<=tauEye)=0.0;

%%%%%%% seed implementation to check the region having redness
mean_R = mean(Red, 'all');
std_R = std(Red, 0, 'all');

R_thresh = max([0.6 mean_R+3*std_R]);

%%%binarise the image using thresh
R_bin = imbinarize(Red, R_thresh);

A_Y = imbinarize(Red, 0.6);

final_bin = R_bin.* A_Y;


%%% using morphological filter to fill out small sized patches and holes
se = strel('disk',15);
final_bin = imclose(final_bin, se);



eye(:,:,1) = ~final_bin.*im_f(:,:,1);
eye(:,:,2) = ~final_bin.*im_f(:,:,2);
eye(:,:,3) = ~final_bin.*im_f(:,:,3);


figure;
subplot(1,2,1),imshow(uint8(im_f));
subplot(1,2,2),imshow(uint8(eye));
impixelinfo;