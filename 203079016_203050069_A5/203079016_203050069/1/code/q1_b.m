clc;
clear;
im1=imread('../data/barbara256.png');

im2=imread('../data/stream.png');
%imshow(im2);
im2_patch1= im1(1:256,1:256);

im2_patch2= im2(1:256,1:256);

%imshow(im2_patch);
reconstructed_image1 = myPCADenoising2(im2_patch1);

reconstructed_image2 = myPCADenoising2(im2_patch2);

imwrite(uint8(reconstructed_image1), 'barbara_q1_b_reconstruction.jpg');
imwrite(uint8(reconstructed_image2), 'stream_q1_b_reconstruction.jpg');



