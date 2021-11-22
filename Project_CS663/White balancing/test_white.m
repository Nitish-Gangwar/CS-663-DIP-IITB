clc;clear;close all;
im_f = rescale(imread("potsWB_00_flash.jpg"));

amb = rescale(imread("potsWB_01_noflash.jpg")); %denoised result
%imwrite(amb,"potsWB_01_noflash.tiff");
%amb = rescale(imread("potsWB_01_noflash.tiff"));

linF = rgb2gray(im_f);
linA = rgb2gray(amb);
delta = (linF-linA);
%amb = double(amb); delta = double(delta);
%%
%%%%Ap and Cp are p pixel value  Ap each pixel of ambient image ;
%deltap = zeros(size(im_f));
%deltap(:,:,1) = delta ;deltap(:,:,2) = delta ;deltap(:,:,3) = delta ;
Cp = zeros(size(amb));
Cp(:,:,1) = imdivide(amb(:,:,1),delta);Cp(:,:,2) = imdivide(amb(:,:,2),delta);Cp(:,:,3) = imdivide(amb(:,:,3),delta);
%figure(1);imshow(cp);title(" estimated color");

%%

%t1 for each color r g b
%t1r = 0.02*range(amb(:,:,1),'all');t1g = 0.02*range(amb(:,:,2),'all');t1b = 0.02*range(amb(:,:,3),'all');
%t2 = 0.02*range(delta,'all');
t2 = 0.02*max(max(delta));
tr1 = 0.02*max(max(amb(:,:,1)));tg1 = 0.02*max(max(amb(:,:,2)));tb1 = 0.02*max(max(amb(:,:,3)));

%%
%setting the Cp value to zero at the pixel where |Ap|<t1 or deltap<t2
fprintf("Discard pixel value according to threshold \n start");
for i = 1:size(amb,1)
    for j = 1:size(amb,2)
        if delta(i,j)<t2|| amb(i,j,3)<tb1 || amb(i,j,2)<tg1 || amb(i,j,1)<tr1 
            Cp(i,j,:)=0.0 ;
        end
    end
end
fprintf(".. end");
%imshow(Cp);

%%
Awb = zeros(size(amb));
%white-balance the image by scaling the color channel
% amb color estimate 𝑐 for the scene as the mean of 𝐶𝑝 for the non-discarded pixels
%non discareded pixel ;
cr = mean(nonzeros(Cp(:,:,1)),'all');cg = mean(nonzeros(Cp(:,:,2)),'all');cb = mean(nonzeros(Cp(:,:,3)),'all');
Awb(:,:,1) = imdivide(amb(:,:,1),cr);Awb(:,:,2) = imdivide(amb(:,:,2),cg);Awb(:,:,3) = imdivide(amb(:,:,3),cb);
%s = imabsdiff(amb,Awb);
%imshow(s);
figure(1);
subplot(1,2,1);imshow(amb);title("Ambient original with orange light effect");
subplot(1,2,2);imshow(Awb);title("White Balanced image");