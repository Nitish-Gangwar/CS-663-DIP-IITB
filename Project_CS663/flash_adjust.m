%im_noflash = imread("carpet_01_noflash.jpg");
%im_flash = imread("carpet_00_flash.jpg");
%k = flash_adjust(im_noflash,im_flash,1);
%
function fadj = flash_adjust(im_nf,im_f,alpha)
adj_nf = rgb2ycbcr(im_nf);
adj_f = rgb2ycbcr(im_f);
out = (1-alpha)*adj_nf+alpha*adj_f ;
out(out > 255) = 255 ;
out(out < 0)   = 0 ;
imshow(ycbcr2rgb(out)); title("flash adjusted image")
fadj = ycbcr2rgb(out);
end
