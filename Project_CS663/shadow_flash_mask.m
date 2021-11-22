%im_noflash = imread("potsdetail_01_noflash.jpg");
%im_flash = imread("potsdetail_00_flash.jpg");
%linF = rgb2gray(im_flash);
%linA = rgb2gray(im_noflash);
%Mask_shadow = (linF-linA)<= 2 ;
%Mask_spec = linF >= 0.95 .* (max(max(linF)) - min(min(linF)));
%Mask_union = (Mask_shadow|Mask_spec);
%k = shadow_flash_mask(im_noflash,im_flash ,0.03)

function maskff = shadow_flash_mask(im_nf,im_f,thr_shadow)
sigma_blurr = 3 ;
linF = rgb2gray(im_f);
linA = rgb2gray(im_nf);
Mask_shadow = (linF-linA)<=thr_shadow ; %for greater value than thr 1 otherwise 0 %boolean value
Mask_spec = linF >= 0.95 .* (max(max(linF)) - min(min(linF))); %boolean value
Mask_union = (Mask_shadow|Mask_spec);
Mask_merge = double(Mask_union);
%out = Mask_merge;
out = imgaussfilt(Mask_merge,sigma_blurr) ;
%imshow(out); title("Mask Flash Shadows and Specularities");
Maskff = out ;
end
