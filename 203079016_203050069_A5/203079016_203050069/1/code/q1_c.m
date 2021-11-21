clear;
clc;
im_orig1 = double(imread('../data/barbara256.png'));
im_orig2 = double(imread('../data/stream.png'));


im1=im_orig1(1:256,1:256);
im2=im_orig2(1:256,1:256);

bilateral_res1 = bilateral_filter(im1);
bilateral_res2 = bilateral_filter(im2);

imwrite(bilateral_res1, 'barbara_q1_c_bilateral_reconstruction.jpg');
imwrite(bilateral_res2, 'stream_q1_c_bilateral_reconstruction.jpg');

