clc;clear;
im_noflash = imread("potsdetail_01_noflash.jpg");
im_flash = imread("potsdetail_00_flash.jpg");
sigma_d = 3;
sigma_r = 5;
thr_shadow = 0.03;
fprintf("Abase Bilateral \n ");
Abase = bilateral_Abase(im_noflash,sigma_d,sigma_r);
figure(1);
subplot(1,2,1); imshow(im_noflash);
subplot(1,2,2);imshow(Abase) ; title("Abase ImNF bilateral");
%%%
fprintf("\n Anr JointBilateral \n ");
Anr = joint_bilateral_Anr(im_noflash,im_flash,sigma_d,sigma_r);
figure(2);
subplot(1,3,1); imshow(im_noflash);
subplot(1,3,2); imshow(im_flash);
subplot(1,3,3);imshow(Abase) ; title("Anr JBilateral");
%%
fprintf("\n Calculating Fdetail \n ");
Fdetail = fdetail_transfer(im_flash ,sigma_d,sigma_r);
figure(3);imshow(Fdetail) ;title("details to be transfered from flash");
%%%
fprintf("\n Shadow Mask \n ");
M = xshadow_flash_mask(im_noflash,im_flash,thr_shadow);
figure(4);imshow(M); title("detected Flash Shadows and Specularities");

%%
fprintf("\n Denoised image claculation \n ");
Afinal = (1 - M).*(Anr.*Fdetail) + M.*Abase;
figure(5);imshow(Afinal); title("A_{Final}");


function maskff = xshadow_flash_mask(im_nf,im_f,thr_shadow)
sigma_blurr = 3 ;
linA = rgb2gray(im_nf);
linF = rgb2gray(im_f);
%linF = 0.2989*im_f(:,:,1) + 0.5870*im_f(:,:,2) + 0.1140*im_f(:,:,3);
%linA = 0.2989*im_nf(:,:,1) + 0.5870*im_nf(:,:,2) + 0.1140*im_nf(:,:,3);
Mask_shadow = (linF-linA)<=thr_shadow ; %for greater value than thr 1 otherwise 0 %boolean value
Mask_spec = linF >= 0.95 .* (max(max(linF)) - min(min(linF))); %boolean value
Mask_union = (Mask_shadow|Mask_spec);
Mask_merge = double(Mask_union);
%out = Mask_merge;
out = imgaussfilt(Mask_merge,sigma_blurr) ;
%imshow(out); title("Mask Flash Shadows and Specularities");
maskff = out ;
end
