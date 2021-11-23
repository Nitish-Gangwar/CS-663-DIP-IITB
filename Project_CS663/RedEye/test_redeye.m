
tic;

ambient = im2double(imread('01_01_stranger_no_flash.jpg'));
flash = im2double(imread('01_02_stranger_flash.jpg'));

ambient_convert = rgb2ycbcr(ambient);
flash_convert = rgb2ycbcr(flash);

a_y = ambient_convert(:,:,1);
a_cb = ambient_convert(:,:,2);
a_cr = ambient_convert(:,:,3);
% figure;
% imshow(a_cr);

f_y = flash_convert(:,:,1);
f_cb = flash_convert(:,:,2);
f_cr = flash_convert(:,:,3);
% figure;
% imshow(f_cr);

A = contrast_streching(f_cr - a_cr);

% https://in.mathworks.com/matlabcentral/answers/86410-changing-values-of-pixels-in-an-image-pixel-by-pixel-thresholding
R = A;
[height, width] = size(A);
R(A<=0.05) = 0.0;
R = reshape(R, [height, width]);

minimum = min(R, [], 'all');
maximum = max(R, [], 'all');
fprintf("Minimum: %f\n", minimum);
fprintf("Maximum: %f\n", maximum);

figure;
imshow(R);
impixelinfo;

final_bin = find_seed(R);

figure;
imshow(final_bin);
impixelinfo;

%  https://in.mathworks.com/help/images/morphological-dilation-and-erosion.html
%  https://docs.opencv.org/master/d9/d61/tutorial_py_morphological_ops.html
se = strel('disk',15);
final_bin = imclose(final_bin, se);



figure;
imshow(final_bin);
impixelinfo;

figure;
[C, h] = imcontour(final_bin);

toc;
function final_bin = find_seed(R)
    mean_R = mean(R, 'all');
    std_R = std(R, 0, 'all');

    R_thresh = max([0.6 mean_R+3*std_R]);

    R_bin = imbinarize(R, R_thresh);
    A_Y = imbinarize(R, 0.6);

    final_bin = bitand(R_bin, A_Y);

    minimum = min(final_bin, [], 'all');
    maximum = max(final_bin, [], 'all');
    fprintf("Minimum: %f\n", minimum);
    fprintf("Maximum: %f\n", maximum);
end
function output_image = contrast_streching(image)
    minimum = min(image, [], 'all');
    maximum = max(image, [], 'all');
    output_image = ((image - minimum)/(maximum - minimum));
end